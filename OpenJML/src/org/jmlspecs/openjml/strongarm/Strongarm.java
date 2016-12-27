package org.jmlspecs.openjml.strongarm;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;
import java.util.Map;
import java.util.Set;

import org.jmlspecs.openjml.JmlOption;
import org.jmlspecs.openjml.JmlPretty;
import org.jmlspecs.openjml.JmlSpecs;
import org.jmlspecs.openjml.JmlSpecs.MethodSpecs;
import org.jmlspecs.openjml.JmlToken;
import org.jmlspecs.openjml.JmlTree;
import org.jmlspecs.openjml.JmlTree.JmlClassDecl;
import org.jmlspecs.openjml.JmlTree.JmlMethodClause;
import org.jmlspecs.openjml.JmlTree.JmlMethodClauseExpr;
import org.jmlspecs.openjml.JmlTree.JmlMethodDecl;
import org.jmlspecs.openjml.JmlTree.JmlMethodSpecs;
import org.jmlspecs.openjml.JmlTree.JmlSpecificationCase;
import org.jmlspecs.openjml.JmlTree.JmlStatementExpr;
import org.jmlspecs.openjml.JmlTree.JmlVariableDecl;
import org.jmlspecs.openjml.JmlTreeUtils;
import org.jmlspecs.openjml.Strings;
import org.jmlspecs.openjml.Utils;
import org.jmlspecs.openjml.esc.BasicBlocker2;
import org.jmlspecs.openjml.esc.BasicBlocker2.VarMap;
import org.jmlspecs.openjml.esc.BasicProgram;
import org.jmlspecs.openjml.esc.BasicProgram.BasicBlock;
import org.jmlspecs.openjml.strongarm.gui.BasicBlockExecutionDebugger;
import org.jmlspecs.openjml.strongarm.gui.BasicBlockExecutionDebuggerConfigurationUtil;
import org.jmlspecs.openjml.strongarm.transforms.AttributeMethod;
import org.jmlspecs.openjml.strongarm.transforms.CleanupPrestateAssignable;
import org.jmlspecs.openjml.strongarm.transforms.CleanupVariableNames;
import org.jmlspecs.openjml.strongarm.transforms.PropagateResults;
import org.jmlspecs.openjml.strongarm.transforms.PruneUselessClauses;
import org.jmlspecs.openjml.strongarm.transforms.Purifier;
import org.jmlspecs.openjml.strongarm.transforms.RemoveContradictions;
import org.jmlspecs.openjml.strongarm.transforms.RemoveDeadAssignments;
import org.jmlspecs.openjml.strongarm.transforms.RemoveDuplicateAssignments;
import org.jmlspecs.openjml.strongarm.transforms.RemoveDuplicatePreconditions;
import org.jmlspecs.openjml.strongarm.transforms.RemoveDuplicatePreconditionsSMT;
import org.jmlspecs.openjml.strongarm.transforms.RemoveImpossibleSpecificationCases;
import org.jmlspecs.openjml.strongarm.transforms.RemoveLocals;
import org.jmlspecs.openjml.strongarm.transforms.RemoveTautologies;
import org.jmlspecs.openjml.strongarm.transforms.RemoveUselessPostconditions;
import org.jmlspecs.openjml.strongarm.transforms.SimplicyViaInternalSubstitutions;
import org.jmlspecs.openjml.strongarm.transforms.SubstituteTree;
import org.jmlspecs.openjml.strongarm.transforms.SubstituteTree2;
import org.jmlspecs.openjml.strongarm.transforms.TreeContains;
import org.jmlspecs.openjml.strongarm.tree.Prop;
import org.jmlspecs.openjml.utils.ui.ASTViewer;
import org.jmlspecs.openjml.esc.Label;

import com.sun.tools.javac.code.Attribute;
import com.sun.tools.javac.code.Flags;
import com.sun.tools.javac.code.Symbol;
import com.sun.tools.javac.code.Symbol.VarSymbol;
import com.sun.tools.javac.tree.JCTree;
import com.sun.tools.javac.tree.JCTree.JCAnnotation;
import com.sun.tools.javac.tree.JCTree.JCBinary;
import com.sun.tools.javac.tree.JCTree.JCBlock;
import com.sun.tools.javac.tree.JCTree.JCExpression;
import com.sun.tools.javac.tree.JCTree.JCIdent;
import com.sun.tools.javac.tree.JCTree.JCStatement;
import com.sun.tools.javac.tree.JCTree.JCUnary;
import com.sun.tools.javac.util.Context;
import com.sun.tools.javac.util.Log;
import com.sun.tools.javac.util.Pair;

public class Strongarm  
 {

    final protected Context                context;

    private final static String            separator = "---------------------";

    final protected Log                    log;

    final protected Utils                  utils;

    final protected JmlInferPostConditions infer;

    final protected JmlTreeUtils           treeutils;
    
    final protected JmlTree.Maker M;
    public static String Current;
    
    final protected static com.sun.tools.javac.util.List JDKList = com.sun.tools.javac.util.List.of(null);
    
    public static JmlTree.Maker MM;
    public static Context _context;
    public Strongarm(JmlInferPostConditions infer) {
        this.infer = infer;
        this.context = infer.context;
        _context = infer.context;
        this.log = Log.instance(context);
        this.utils = Utils.instance(context);
        this.treeutils = JmlTreeUtils.instance(context);
        this.M = JmlTree.Maker.instance(context);
        MM = this.M;
        //
        // Cache copies of the various tree transformation utilities.
        //
        {
            SubstituteTree.cache(context);
            SubstituteTree2.cache(context);
            
            RemoveTautologies.cache(context);
            RemoveContradictions.cache(context);            
            CleanupVariableNames.cache(context);
            RemoveDuplicatePreconditions.cache(context);
            RemoveDuplicatePreconditionsSMT.cache(context);
            SimplicyViaInternalSubstitutions.cache(context);
            RemoveLocals.cache(context);
            RemoveDeadAssignments.cache(context);
            RemoveDuplicateAssignments.cache(context);
            RemoveImpossibleSpecificationCases.cache(context);
            CleanupPrestateAssignable.cache(context);
            RemoveUselessPostconditions.cache(context);
            Purifier.cache(context);
            PruneUselessClauses.cache(context);


        }
    }
    
    public void infer(JmlMethodDecl methodDecl) {

        // first, we translate the method to the basic block format
        boolean printContracts = infer.printContracts;
        boolean verbose        = infer.verbose;

        JmlClassDecl currentClassDecl = utils.getOwner(methodDecl);

        JmlMethodSpecs denestedSpecs = methodDecl.sym == null ? null
                : JmlSpecs.instance(context).getDenestedSpecs(methodDecl.sym);

        // newblock is the translated version of the method body
        JmlMethodDecl translatedMethod = infer.assertionAdder.methodBiMap
                .getf(methodDecl);

        if (translatedMethod == null) {
            log.warning("jml.internal", "No translated method for "
                    + utils.qualifiedMethodSig(methodDecl.sym));
            return;
        }

        JCBlock newblock = translatedMethod.getBody();

        if (newblock == null) {
            log.error("esc.no.typechecking", methodDecl.name.toString()); //$NON-NLS-1$
            return;
        }

        if (verbose) {
            log.noticeWriter.println(Strings.empty);
            log.noticeWriter.println(separator);
            log.noticeWriter.println(Strings.empty);
            log.noticeWriter.println("TRANSFORMATION OF " //$NON-NLS-1$
                    + utils.qualifiedMethodSig(methodDecl.sym));
            log.noticeWriter.println(JmlPretty.write(newblock));
        }
        
        Current = utils.qualifiedMethodSig(methodDecl.sym);
        
        BasicBlocker2 basicBlocker;

        BasicProgram program;

        basicBlocker = new BasicBlocker2(context);
        program = basicBlocker.convertMethodBody(
                newblock, 
                methodDecl,
                denestedSpecs, 
                currentClassDecl, 
                infer.assertionAdder);
        
        if (verbose) {
            log.noticeWriter.println(Strings.empty);
            log.noticeWriter.println(separator);
            log.noticeWriter.println(Strings.empty);
            log.noticeWriter.println("BasicBlock2 FORM of "
                    + utils.qualifiedMethodSig(methodDecl.sym));
            log.noticeWriter.println(program.toString());
        }        

        String savedProgram = program.toString(); // need to freeze a pre-substitution state.
        
        //
        // perform symbolic execution on the method
        //
        BlockReader reader = infer(methodDecl, program, basicBlocker);

        //
        // 
        //
        if(reader==null){
            return; // no spec;
        }
        
        
        //
        // we found a postcondition, so let's start cleaning it up
        //
        com.sun.tools.javac.util.List<JmlMethodClause> contract = reader.postcondition.getClauses(null, treeutils, M); 
        com.sun.tools.javac.util.List<JmlMethodClause> oldMethodClause = null;
        MethodSpecs oldMethodSpecsCombined  = methodDecl.methodSpecsCombined;

        
        // save the old (handwritten) specification case we were given
        if(methodDecl.cases!=null){
            oldMethodClause = methodDecl.cases.cases.head.clauses;
        }

        
        //
        // replace entire set of contracts on method with what we computed during symbolic execution 
        //
        JmlMethodClause precondition = M.JmlMethodClauseExpr
                (
                        JmlToken.REQUIRES,
                        reader.precondition.p
                );
            
        
        //
        // put it all together as a specification case we can pass to our cleanup pipeline
        //
        JmlSpecificationCase cases = M.JmlSpecificationCase(null, false, null, null, JDKList.of(precondition).appendList(contract));

        methodDecl.cases = M.JmlMethodSpecs(JDKList.of(cases));
        methodDecl.cases.decl = methodDecl;
        methodDecl.methodSpecsCombined = new MethodSpecs(null, methodDecl.cases);
        
    	methodDecl.cases.cases.head.modifiers = treeutils.factory.Modifiers(Flags.PUBLIC);
    	methodDecl.cases.cases.head.token = JmlToken.NORMAL_BEHAVIOR;
        

    	if (verbose) {
            log.noticeWriter.println(Strings.empty);
            log.noticeWriter.println("--------------------------------------"); 
            log.noticeWriter.println(Strings.empty);
            log.noticeWriter.println("BEGIN CONTRACT CLEANUP of " + utils.qualifiedMethodSig(methodDecl.sym)); //$NON-NLS-1$
            log.noticeWriter.println(JmlPretty.write(methodDecl.cases));
        }
        
    	String oldContract = methodDecl.toString();
    	
    	
    	//ASTViewer.addView("PRE JavaCompiler.desugar", methodDecl, ASTViewer.ViewType.DIALOG);
        ///
        /// Perform cleanup
        ///
        {
            cleanupContract(methodDecl, methodDecl.cases, reader, precondition);
        }
        ///
        ///
        ///
        
        //
        // restore the old, handwritten specification (if we had one to being with)
        //
        try {
            if(oldMethodClause!=null){
                methodDecl.cases.cases.head.clauses = oldMethodClause.appendList(methodDecl.cases.cases.head.clauses);
            }
        }catch(Exception e){
            if(oldMethodClause!=null){
                methodDecl.cases.cases.head.clauses = oldMethodClause;
            }
            
        }
        //
        // Debugging of inference (Before Delivering PC)
        //
        if(BasicBlockExecutionDebuggerConfigurationUtil.debugBasicBlockExecution()){
            reader.showCFG();
            BasicBlockExecutionDebugger.trace(newblock, savedProgram, program.blocks(), reader.getTrace(), methodDecl.cases, oldContract, reader.getDebugMappings(), reader.getLexicalMappings());
        }

        
        
        if (printContracts) {
            if(contract!=null){
                log.noticeWriter.println("--------------------------------------"); 
                log.noticeWriter.println("INFERRED POSTCONDITION OF " + utils.qualifiedMethodSig(methodDecl.sym)); 
                log.noticeWriter.println(JmlPretty.write(methodDecl.cases));
            }else{
                log.noticeWriter.println("--------------------------------------"); 
                log.noticeWriter.println("FAILED TO INFER THE POSTCONDITION OF " + utils.qualifiedMethodSig(methodDecl.sym)); 
            }
        }  
               
        
        if (verbose) {
            log.noticeWriter.println(Strings.empty);
            log.noticeWriter.println("--------------------------------------"); //$NON-NLS-1$
            log.noticeWriter.println(Strings.empty);
            log.noticeWriter.println("FINISHED INFERENCE OF " + utils.qualifiedMethodSig(methodDecl.sym)); //$NON-NLS-1$
            log.noticeWriter.println(JmlPretty.write(methodDecl));
        }
        
    }
    /**
     * Entry point into the inference 
     * 
     * @param program
     * @return
     */
    public BlockReader infer(JmlMethodDecl methodDecl, BasicProgram program, BasicBlocker2 basicBlocker){
        boolean verbose        = infer.verbose; 

        //
        // First, check if there is an existing postcondition 
        //
       if(TreeContains.analyze(context, methodDecl.cases).atLeastOneEnsuresClause()){
            
            
            
            if (verbose) {
                log.noticeWriter.println(Strings.empty);
                log.noticeWriter.println(separator);
                log.noticeWriter.println(Strings.empty);
                log.noticeWriter.println("[STRONGARM] Skipping inference for  "
                        + utils.qualifiedMethodSig(methodDecl.sym) + " because postconditions are already present.");
            }
            
            return null;
        }
        
        
        BlockReader reader = new BlockReader(context, program.blocks(), basicBlocker);
        
       


        
        // basic idea here is to boil it all down to a proposition. 
        // we take and solve / simplify that proposition and then translate it back into a 
        // post condition, which we then will add to the methodspecs. 
        
        // during the first pass we do no simplification
        
        if (verbose) {
            log.noticeWriter.println(Strings.empty);
            log.noticeWriter.println(separator);
            log.noticeWriter.println(Strings.empty);
            log.noticeWriter.println("BasicBlock2 FORM of "
                    + utils.qualifiedMethodSig(methodDecl.sym));
            log.noticeWriter.println(program.toString());
        }
               
        Prop<JCExpression> props = reader.sp();
        
        if (verbose) {
            log.noticeWriter.println("Inference finished...");
            
            log.noticeWriter.println(BlockReader._substitutionCache.toString());
        }
        
        
        //
        // for some reason, we failed to infer a postcondition
        //
        if(reader.postcondition==null){
            
            if (verbose) {
                log.noticeWriter.println(Strings.empty);
                log.noticeWriter.println("--------------------------------------"); //$NON-NLS-1$
                log.noticeWriter.println(Strings.empty);
                log.noticeWriter.println("DID NOT INFER POSTCONDITION " + utils.qualifiedMethodSig(methodDecl.sym) + "... (SKIPPING)"); //$NON-NLS-1$
                log.noticeWriter.println("(hint: enable -infer-default-preconditions to assume a precondition)");
            }
            
                            
            return null; // no spec 
        }
        
        
        
        //this.treeutils.
        
        
        
        
        if (verbose && props!=null) {
            log.noticeWriter.println(Strings.empty);
            log.noticeWriter.println("--------------------------------------"); 
            log.noticeWriter.println(Strings.empty);
            log.noticeWriter.println("FINISHED (STAGE 1) INFERENCE OF " + utils.qualifiedMethodSig(methodDecl.sym)); 
            log.noticeWriter.println(JmlPretty.write(methodDecl));
            log.noticeWriter.println("POSTCONDITION: " + JmlPretty.write(props.toTree(treeutils)));
        }

        
        
        

        return reader;
    }
    
        

    public void cleanupContract(JmlMethodDecl methodDecl, JCTree contract, BlockReader reader, JmlMethodClause precondition){
        
        boolean verbose        = infer.verbose;
        Timing t;
        
        
        
        
        t = Timing.start();
        RemoveDuplicatePreconditionsSMT.simplify(contract, methodDecl);
       
        
        if (verbose) {
            log.noticeWriter.println(BlockReader._substitutionCache.toString());
        }
        
        
       if (verbose) {
            log.noticeWriter.println(Strings.empty);
            log.noticeWriter.println("--------------------------------------"); 
            log.noticeWriter.println(Strings.empty);
            log.noticeWriter.println("AFTER REMOVING DUPLICATE PRECONDITIONS (VIA SMT) " + utils.qualifiedMethodSig(methodDecl.sym) + t.tell()); 
            log.noticeWriter.println(JmlPretty.write(contract));
        }
        
        t = Timing.start();         
        RemoveImpossibleSpecificationCases.simplify(contract, methodDecl);
        
        if (verbose) {
            log.noticeWriter.println(Strings.empty);
            log.noticeWriter.println("--------------------------------------"); 
            log.noticeWriter.println(Strings.empty);
            log.noticeWriter.println("AFTER REMOVING IMPOSSIBLE SPECIFICATION CASES (VIA SMT) " + utils.qualifiedMethodSig(methodDecl.sym) + t.tell()); 
            log.noticeWriter.println(JmlPretty.write(contract));
        }
        
        //
        // Perform substitutions on the underlying formula. 
        //
        {
            // This is done FIRST LEXICALLY because we don't know
            // the underlying expressions for the temporary variables.
            // The substitution we do later then resolves the variables 
            // in the equations we substitute here.
            t = Timing.start();
            
            reader.postcondition.replace(null, true);
            
            // will trigger OLD way
            //reader.postcondition.replace(reader.getSubstitutionMappings(), true);

            
        }
        //t.tellFile(utils.qualifiedMethodSig(methodDecl.sym), "/tmp/new.csv");
        
        {
            // alternate approach -- here we iterate over the ENTIRE contract
            
//            for(BasicBlock exitBlock : reader.getExitBlocks()){
//                log.noticeWriter.println("[STRONGARM] found exit block: "+ exitBlock.id().toString());
//
//            }
//            
        }
        
        if (verbose) {
            log.noticeWriter.println(Strings.empty);
            log.noticeWriter.println("--------------------------------------"); 
            log.noticeWriter.println(Strings.empty);
            log.noticeWriter.println("AFTER PERFORMING LEXICAL SUBSTITUTIONS " + utils.qualifiedMethodSig(methodDecl.sym) + t.tell()); 
            log.noticeWriter.println(JmlPretty.write(contract));
        }   
        
        
        com.sun.tools.javac.util.List<JmlMethodClause> newContract = reader.postcondition.getClauses(null, treeutils, M);
        
        
        JmlSpecificationCase cases = M.JmlSpecificationCase(null, false, null, null, JDKList.of(precondition).appendList(newContract));

        methodDecl.cases = M.JmlMethodSpecs(JDKList.of(cases));
        methodDecl.cases.decl = methodDecl;
        methodDecl.methodSpecsCombined = new MethodSpecs(null, methodDecl.cases);
        
        methodDecl.cases.cases.head.modifiers = treeutils.factory.Modifiers(Flags.PUBLIC);
        methodDecl.cases.cases.head.token = JmlToken.NORMAL_BEHAVIOR;
        
        if (verbose) {
            log.noticeWriter.println(Strings.empty);
            log.noticeWriter.println("--------------------------------------"); 
            log.noticeWriter.println(Strings.empty);
            log.noticeWriter.println("AFTER PERFORMING LEXICAL SUBSTITUTIONS II" + utils.qualifiedMethodSig(methodDecl.sym) + t.tell()); 
            log.noticeWriter.println(JmlPretty.write(cases));
        }

        
        // SWAP
        contract = cases;
        

        //
        //
        // The rest of these transforms require that the substitutions have been done
        //
        //
        
        //
        // Perform logical simplification
        //
        t = Timing.start();
        
        RemoveTautologies.simplify(contract);

        if (verbose) {
            log.noticeWriter.println(Strings.empty);
            log.noticeWriter.println("--------------------------------------"); 
            log.noticeWriter.println(Strings.empty);
            log.noticeWriter.println("AFTER REMOVING TAUTOLOGIES OF " + utils.qualifiedMethodSig(methodDecl.sym) + t.tell()); 
            log.noticeWriter.println(JmlPretty.write(contract));
        }
        
        t = Timing.start();
        
        RemoveContradictions.simplify(contract);

        if (verbose) {
            log.noticeWriter.println(Strings.empty);
            log.noticeWriter.println("--------------------------------------"); 
            log.noticeWriter.println(Strings.empty);
            log.noticeWriter.println("AFTER REMOVING CONTRADICTIONS OF " + utils.qualifiedMethodSig(methodDecl.sym) + t.tell()); 
            log.noticeWriter.println(JmlPretty.write(contract));
        }

        //
        // These last two tend to tear up contracts a bit so we do an intermediate cleanup here
        // to simplify the next few 
        //
        t = Timing.start();
        
        PruneUselessClauses.simplify(contract);
        
        if (verbose) {
            log.noticeWriter.println(Strings.empty);
            log.noticeWriter.println("--------------------------------------"); 
            log.noticeWriter.println(Strings.empty);
            log.noticeWriter.println("AFTER PRUNING USELESS CLAUSES OF " + utils.qualifiedMethodSig(methodDecl.sym) + t.tell()); 
            log.noticeWriter.println(JmlPretty.write(contract));
        }

        
        
       
        //
        // Remove dead assignments 
        //
        t = Timing.start();
        
       RemoveDeadAssignments.simplify(reader.getBlockerMappings(), contract);
        
        if (verbose) {
            log.noticeWriter.println(Strings.empty);
            log.noticeWriter.println("--------------------------------------"); 
            log.noticeWriter.println(Strings.empty);
            log.noticeWriter.println("AFTER REMOVING DEAD ASSIGNMENTS OF " + utils.qualifiedMethodSig(methodDecl.sym) + t.tell()); 
            log.noticeWriter.println(JmlPretty.write(contract));
        }
       
        
        
        //
        // Perform substitutions on the underlying formula, but now base it on 
        // the map of program variables generated during transformation to 
        // basic block format. 
        //
        {
            t = Timing.start();
            
            reader.postcondition.replace(reader.getBlockerMappings(), false);
        }
        
        
        if (verbose) {
            
            log.noticeWriter.println(Strings.empty);
            log.noticeWriter.println("--------------------------------------"); 
            log.noticeWriter.println(Strings.empty);
            log.noticeWriter.println("AFTER PERFORMING PREMAP BLOCK SUBSTITUTIONS " + utils.qualifiedMethodSig(methodDecl.sym) + t.tell()); 
            log.noticeWriter.println(JmlPretty.write(contract));
        }

        
        
        //
        // Remove local variables
        //
        t = Timing.start();
                
       RemoveLocals.simplify(methodDecl, contract);
        
        if (verbose) {
            log.noticeWriter.println(Strings.empty);
            log.noticeWriter.println("--------------------------------------"); 
            log.noticeWriter.println(Strings.empty);
            log.noticeWriter.println("AFTER REMOVING LOCALS OF " + utils.qualifiedMethodSig(methodDecl.sym) + t.tell()); 
            log.noticeWriter.println(JmlPretty.write(contract));
        }
        
        
        //
        // This is a very specific optimization that comes into play when we 
        // try to extract a little more information out of loops. 
        //
        t = Timing.start();
        
        SimplicyViaInternalSubstitutions.simplify(methodDecl, contract);
        
        if (verbose) {
            log.noticeWriter.println(Strings.empty);
            log.noticeWriter.println("--------------------------------------"); 
            log.noticeWriter.println(Strings.empty);
            log.noticeWriter.println("AFTER DOING BACKWARDS PROPAGATION OF " + utils.qualifiedMethodSig(methodDecl.sym) + t.tell()); 
            log.noticeWriter.println(JmlPretty.write(contract));
        }
        
        
        
       

        
        //
        // Simplify labels -- TODO: Remove
        //
        t = Timing.start();
        
       CleanupVariableNames.simplify(contract);
        
        if (verbose) {
            log.noticeWriter.println(Strings.empty);
            log.noticeWriter.println("--------------------------------------"); 
            log.noticeWriter.println(Strings.empty);
            log.noticeWriter.println("AFTER SIMPLIFYING LABELS OF " + utils.qualifiedMethodSig(methodDecl.sym) + t.tell()); 
            log.noticeWriter.println(JmlPretty.write(contract));
        }
        
        
        //
        // Remove Duplicate Preconditions
        //
        t = Timing.start();
        
        RemoveDuplicatePreconditions.simplify(contract);
        
        if (verbose) {
            log.noticeWriter.println(Strings.empty);
            log.noticeWriter.println("--------------------------------------"); 
            log.noticeWriter.println(Strings.empty);
            log.noticeWriter.println("AFTER REMOVING DUPLICATE PRECONDITIONS (LEXICAL) OF " + utils.qualifiedMethodSig(methodDecl.sym) + t.tell()); 
            log.noticeWriter.println(JmlPretty.write(contract));
        }
        
        
        //
        // Remove duplicate assignments 
        //
        t = Timing.start();
        
       RemoveDuplicateAssignments.simplify(contract);
        
        if (verbose) {
            log.noticeWriter.println(Strings.empty);
            log.noticeWriter.println("--------------------------------------"); 
            log.noticeWriter.println(Strings.empty);
            log.noticeWriter.println("AFTER REMOVING DUPLICATE ASSIGNMENTS OF " + utils.qualifiedMethodSig(methodDecl.sym) + t.tell()); 
            log.noticeWriter.println(JmlPretty.write(contract));
        }
       
        
        
        //
        // Fix up results... 
        //
       {
           t = Timing.start();
           
           reader.postcondition.replace(PropagateResults.simplify(context, contract));
       }
        
        if (verbose) {
            log.noticeWriter.println(Strings.empty);
            log.noticeWriter.println("--------------------------------------"); 
            log.noticeWriter.println(Strings.empty);
            log.noticeWriter.println("AFTER FIXING RESULTS " + utils.qualifiedMethodSig(methodDecl.sym) + t.tell()); 
            log.noticeWriter.println(JmlPretty.write(contract));
        }
        
        
        
        
        //
        // Clean up assignables
        //
        t = Timing.start();
        
        CleanupPrestateAssignable.simplify(contract);
        
        if (verbose) {
            log.noticeWriter.println(Strings.empty);
            log.noticeWriter.println("--------------------------------------"); 
            log.noticeWriter.println(Strings.empty);
            log.noticeWriter.println("AFTER CLEANING PRESTATE ASSIGNABLES " + utils.qualifiedMethodSig(methodDecl.sym) + t.tell()); 
            log.noticeWriter.println(JmlPretty.write(contract));
        }
        
        //
        // Everything past this point should be to make things pretty
        //        

        
        //
        // Clean up clauses lacking useful postconditions
        //
        t = Timing.start();
        
        RemoveUselessPostconditions.simplify(contract);
        
        if (verbose) {
            log.noticeWriter.println(Strings.empty);
            log.noticeWriter.println("--------------------------------------"); 
            log.noticeWriter.println(Strings.empty);
            log.noticeWriter.println("AFTER REMOVING USELESS POSTCONDITIONS " + utils.qualifiedMethodSig(methodDecl.sym) + t.tell()); 
            log.noticeWriter.println(JmlPretty.write(contract));
        }
        
        
       // we do this one last time to clean up
        t = Timing.start();
        
       PruneUselessClauses.simplify(contract);
        
        if (verbose) {
            log.noticeWriter.println(Strings.empty);
            log.noticeWriter.println("--------------------------------------"); 
            log.noticeWriter.println(Strings.empty);
            log.noticeWriter.println("AFTER PRUNING USELESS CLAUSES OF " + utils.qualifiedMethodSig(methodDecl.sym) + t.tell()); 
            log.noticeWriter.println(JmlPretty.write(contract));
        }

        //
        // PURITY
        //
        t = Timing.start();
        
        Purifier.simplify(contract, methodDecl);
        
        if (verbose) {
            log.noticeWriter.println(Strings.empty);
            log.noticeWriter.println("--------------------------------------"); 
            log.noticeWriter.println(Strings.empty);
            log.noticeWriter.println("AFTER ADDING PURITY " + utils.qualifiedMethodSig(methodDecl.sym) + t.tell()); 
            log.noticeWriter.println(JmlPretty.write(contract));
        }
        
        
        
    }
}
