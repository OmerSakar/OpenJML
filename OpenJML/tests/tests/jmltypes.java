package tests;


/** These tests do typechecking on all the aspects of JML types.
 * <BR> \TYPE - the type of types in JML, somewhat like, but not equivalent to Class<?>
 * <BR> \type - (type \TYPE) type literal in JML, similar to T.class
 * <BR> \typeof - (type \TYPE) dynamic type in JML, similar to getClass()
 * <BR> \elemtype - element type of array type
 * <BR> <: - is subtype of - similar to isAssignableFrom
 * @author David R. Cok
 *
 */
public class jmltypes extends TCBase {


    @Override
    public void setUp() throws Exception {
//        noCollectDiagnostics = true;
//        jmldebug = true;
        super.setUp();
    }
    
    public void testUninitGhost() {
        helpTCF("A.java",
                "import java.util.Vector; public class A { \n" +
                " void m() {\n" +
                "  Class<?> c = Object.class; Object o = c; \n" +
                "  //@ ghost \\TYPE t;\n" +
                "  //@ ghost \\TYPE tt = \\type(Object);\n" +
                "  //@ set tt = \\type(int);\n" +
                "  //@ set tt = \\type(Vector<Integer>);\n" +
                "  //@ ghost \\TYPE ttt = \\typeof(o);\n" +
                "  //@ ghost boolean b = \\type(Object) == tt;\n" +
                "  //@ set b = \\typeof(o) == tt;\n" +
                "  //@ set b = (\\TYPE)c == t; \n" + // Casts allowed
                "  //@ set t = \\elemtype(t); \n" + // Allow elemtype on TYPE, returning TYPE
                "  //@ set c = \\elemtype(c); \n" + // Allow elemtype on Class, returning Class
                "  //@ set b = tt <: ttt;\n" +
                " }\n" +
                "}\n"
                ,"/A.java:11: variable t might not have been initialized",27
                );
    }

    public void testOK1() {
        helpTCF("A.java",
                "public class A { \n" +
                " void m() {\n" +
                "  Class<?> c = Object.class; Object o = c; \n" +
                "  //@ ghost boolean b = \\typeof(o).erasure() == Object.class;\n" +
                "  //@ set b = \\typeof(o).numargs() == 0;\n" +
                "  //@ set b = \\typeof(o).arg(0) != \\typeof(o);\n" +
                "  //@ set b = \\typeof(o).isArray();\n" +
                "  boolean jb = c.isArray();\n" +
                " }\n" +
                "}\n"
                );
    }

    public void testOK2() {
        helpTCF("A.java",
                "public class A { \n" +
                " void m() {\n" +
                "  Class<?> c = Object.class; Object o = c; \n" +
                "  //@ ghost \\TYPE t;\n" +
                "  //@ ghost boolean b = \\type(Object).numargs() == 0;\n" +
                "  //@ set b = \\elemtype(t).numargs() == 0;\n" +
                " }\n" +
                "}\n"
                );
    }

    public void testOK3() {
        helpTCF("A.java",
                "class B<T> {}\n" +
                "public class A<T>  { \n" +
                " void m() {\n" +
                "  Class<?> c = Object.class; Object o = c; \n" +
                "  //@ ghost \\TYPE w = \\type(B<Integer>);\n" +
                "  //@ ghost \\TYPE t = \\type(B<T>);\n" +
                "  //@ ghost \\TYPE v = \\type(T);\n" +
                " }\n" +
                "}\n"
                );
    }

    public void testBad() {
        helpTCF("A.java",
                "public class A { \n" +
                " void m() {\n" +
                "  Class<?> c = Object.class; Object o = c; \n" +
                "  //@ ghost \\TYPE t = Object.class;\n" + // NO mixing
                "  //@ ghost Class<?> cc = t;\n" + // NO mixing
                "  //@ ghost boolean b = \\type(Object) == Object.class;\n" + // No mixing
                "  //@ ghost Object oo = \\type(Object);\n" +  // types are Objects??? TODO
                "  //@ set b = t <: Object.class;\n" +  // No mixing
                "  //@ set b = Object.class <: t;\n" +  // No mixing 
                "  //@ set b = c instanceof \\type(Object);\n" +  // No mixing
                "  //@ set b = t instanceof Object;\n" +  // types are Objects??? TODO
                "  //@ set t = (\\TYPE)0;\n" + // No casts of ints
                "  //@ set t = (\\TYPE)o;\n" + // No casts of Object
                "}}\n"
                ,"/A.java:4: incompatible types\n  required: org.jmlspecs.utils.IJMLTYPE\n  found:    java.lang.Class<java.lang.Object>",29
                ,"/A.java:5: incompatible types\n  required: java.lang.Class<?>\n  found:    org.jmlspecs.utils.IJMLTYPE",27
                ,"/A.java:6: incomparable types: org.jmlspecs.utils.IJMLTYPE and java.lang.Class<java.lang.Object>",39
                ,"/A.java:8: The arguments to <: must both be \\TYPE or both be Class",26
                ,"/A.java:9: The arguments to <: must both be \\TYPE or both be Class",31
                ,"/A.java:10: unexpected type\n  required: class\n  found:    value",28
                ,"/A.java:12: A cast to \\TYPE may be applied only to expressions of type Class, not int",22
                ,"/A.java:13: A cast to \\TYPE may be applied only to expressions of type Class, not java.lang.Object",22

        );
                
    }
    
//    public void testBadJava() {
//        helpTCF("A.java",
//                "public class A<T extends java.io.File> { \n" +
//                " void m() {\n" +
//                "  Class<?> c = T.class; \n" +
//                "  Class<?> c = A<T>.class; \n" +
//                "}}\n"
//
//        );
//    }
    
}
