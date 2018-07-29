// @(#)$Id: JMLBag.java-generic,v 1.70 2006/12/02 23:38:15 leavens Exp $

// Copyright (C) 2005 Iowa State University
//
// This file is part of the runtime library of the Java Modeling Language.
//
// This library is free software; you can redistribute it and/or
// modify it under the terms of the GNU Lesser General Public License
// as published by the Free Software Foundation; either version 2.1,
// of the License, or (at your option) any later version.
//
// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with JML; see the file LesserGPL.txt.  If not, write to the Free
// Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
// 02110-1301  USA.


package org.jmlspecs.unfinished;

import org.jmlspecs.lang.JMLIterator;

/** Bags (i.e., multisets) of objects.  This type uses
 * "==" to compare elements, and does not clone elements that
 * are passed into and returned from the bag's methods.
 *
 * @version $Revision: 1.70 $
 * @author Gary T. Leavens, with help from Albert Baker, Clyde Ruby,
 * and others.
 * @see JMLCollection
 * @see JMLType
 * @see JMLValueSet
 * @see JMLObjectSetEnumerator
 * 
 * @see JMLObjectSet
 * @see JMLValueSet
 */
//+OPENJML@ immutable
// FIXME: adapt this file to non-null-by-default and remove the following modifier.
/*@ nullable_by_default @*/ 
public /*@ pure @*/ class JMLObjectBag
    implements JMLCollection
{

    /** The list representing the contents of this bag.  Each element
     * of this list is of type JMLObjectBagEntry.
     */
    protected final JMLObjectBagEntryNode the_list;
    //@                  in objectState;
    //@                  maps the_list.elementState \into elementState;

    /** The size of this bag.
     */
    protected /*@ spec_public @*/ final int size;
    //@                                      in objectState;

    //@ protected invariant the_list == null <==> size == 0;
    //@ public    invariant size >= 0;
    /*@ protected invariant the_list != null ==>
      @   (\forall int i; 0 <= i && i < the_list.int_size();
      @			      the_list.itemAt(i) instanceof JMLObjectBagEntry);
      @*/

    //*********************** equational theory ***********************

    //@ public invariant (\forall Object e1; ; count(e1) >= 0);

    /*@ public invariant (\forall JMLObjectBag s2; s2 != null;
      @                    (\forall Object e1, e2; ;
      @                       equational_theory(this, s2, e1, e2) ));
      @*/

    /** An equational specification of the properties of bags.
     */
    /*@ public normal_behavior
       @ {|
       @     // The following are defined by using has and induction.
       @
       @       ensures \result <==>
       @           (new JMLObjectBag()).count(e1) == 0;
       @     also
       @       requires e1 != null;
       @       ensures \result <==>
       @          s.insert(e1).count(e2) 
       @          	== (e1 == e2
       @                      ? (s.count(e2) + 1) : s.count(e2));
       @     also
       @       ensures \result <==>
       @           s.insert(null).count(e2) 
       @          	== (e2 == null ? (s.count(e2) + 1) : s.count(e2));
       @     also
       @       ensures \result <==>
       @           (new JMLObjectBag()).int_size() == 0;
       @     also
       @       ensures \result <==>
       @           s.insert(e1).int_size() == (s.int_size() + 1);
       @     also
       @       ensures \result <==>
       @           s.isSubbag(s2)
       @              == (\forall Object o; ; s.count(o) <= s2.count(o));
       @     also
       @       ensures \result <==>
       @           s.equals(s2) == ( s.isSubbag(s2) && s2.isSubbag(s));
       @     also
       @       ensures \result <==>
       @           (new JMLObjectBag()).remove(e1).equals(new JMLObjectBag());
       @     also
       @       ensures \result <==>
       @           s.insert(null).remove(e2)
       @                     .equals
       @                     (e2 == null ? s : s.remove(e2).insert(null));
       @     also
       @       requires e1 != null;
       @       ensures \result <==>
       @            s.insert(e1).remove(e2)
       @                     .equals
       @                     (e1 == e2
       @                         ? s : s.remove(e2).insert(e1));
       @
       @     // The following are all defined as abbreviations.
       @
       @    also
       @      ensures \result <==>
       @         s.isEmpty() == (s.int_size() == 0);
       @    also
       @      ensures \result <==>
       @           (new JMLObjectBag()).has(e1);
       @    also
       @      ensures \result <==>
       @         (new JMLObjectBag(e1)).equals(new JMLObjectBag().insert(e1));
       @    also
       @      ensures \result <==>
       @         s.isProperSubbag(s2) == ( s.isSubbag(s2) && !s.equals(s2));
       @    also
       @      ensures \result <==>
       @         s.isSuperbag(s2) == s2.isSubbag(s);
       @    also
       @      ensures \result <==>
       @         s.isProperSuperbag(s2) == s2.isProperSubbag(s);
       @ |}
       @
       @ implies_that   // other ways to specify some operations
       @
       @   ensures \result <==> (new JMLObjectBag()).isEmpty();
       @
       @   ensures \result <==> !s.insert(e1).isEmpty();
       @
       @   ensures \result <==>
       @         (new JMLObjectBag(null)).has(e2) == (e2 == null);
       @
       @   ensures \result <==>
       @         (e1 != null
       @          ==> new JMLObjectBag(e1).has(e2)
       @                        == (e1 == e2));
       public pure model boolean equational_theory(JMLObjectBag s,
                                                   JMLObjectBag s2,
                                                   Object e1,
                                                   Object e2);
       @*/ // end of equational_theory

    //@ public invariant elementType <: \type(Object);
    /*@ public invariant
      @           (\forall Object o; o != null && has(o);
      @                                 \typeof(o) <: elementType);
      @*/

    //@ public invariant_redundantly isEmpty() ==> !containsNull;

    //@ public invariant owner == null;

    //************************* Constructors ********************************

    /** Initialize this bag to be empty.
     *  @see #EMPTY
     */
    /*@ public normal_behavior
      @    assignable objectState, elementType, containsNull, owner;
      @    ensures this.isEmpty();
      @    ensures_redundantly (* this is an empty bag *);
      @
      @ implies_that
      @    ensures elementType <: \type(Object) && !containsNull;
      @*/
    public JMLObjectBag() {
        //@ set owner = null;
        the_list = null;
        size = 0;
        //@ set elementType = \type(Object);
        //@ set containsNull = false;
    }  

    /*@ public normal_behavior
      @    assignable objectState, elementType, containsNull, owner;
      @    ensures count(elem) == 1 && int_size() == 1;
      @    ensures_redundantly (* this is a singleton bag containing elem *);
      @
      @ implies_that
      @    ensures containsNull <==> elem == null;
      @    ensures elem != null ==> elementType == \typeof(elem);
      @    ensures elem == null ==> elementType <: \type(Object);
      @*/
    /** Initialize this bag to contain the given element.
     *  @param elem the element that is the sole contents of this bag.
     *  @see #singleton
     */
    public JMLObjectBag (Object elem) {
        //@ set owner = null;
        // cons() clones if necessary
        the_list = JMLObjectBagEntryNode.cons(new JMLObjectBagEntry(elem),
                                              null);
        size = 1;
        //@ set elementType = the_list.entryElementType;
        //@ assume elem != null ==> elementType == \typeof(elem);
        //@ set containsNull = (elem == null);
    }  

    /** Initialize this bag with the given representation.
     */
    /*@  requires ls == null <==> sz == 0;
      @  requires sz >= 0;
      @  assignable objectState, elementType, containsNull, owner;
      @  ensures elementType
      @          == (ls == null ? \type(Object) : ls.entryElementType);
      @  ensures containsNull
      @          == (ls == null ? false : ls.containsNullElements);
      @*/
    protected JMLObjectBag (JMLObjectBagEntryNode ls, int sz) {
        //@ set owner = null;
        the_list = ls;
        size = sz;
        /*@ set elementType
          @     = (ls == null ? \type(Object) : ls.entryElementType);
          @ set containsNull = (ls == null ? false : ls.containsNullElements);
          @*/
    }

    //**************************** Static methods ****************************

    /** The empty JMLObjectBag.
     *  @see #JMLObjectBag()
     */
    public static final /*@ non_null @*/ JMLObjectBag EMPTY
        = new JMLObjectBag();

    /** Return the singleton bag containing the given element.
     *  @see #JMLObjectBag(Object)
     */
    /*@ public normal_behavior
      @    ensures \result != null && \result.equals(new JMLObjectBag(e));
      @*/
    public static /*@ pure @*/ /*@ non_null @*/ JMLObjectBag singleton(
        Object e)
    {
        return new JMLObjectBag(e);
    }

    /** Return the bag containing all the elements in the given array.
     */
    /*@ public normal_behavior
      @    requires a != null;
      @    ensures \result != null && \result.int_size() == a.length
      @         && (* \result contains each element in a *);
      @    ensures_redundantly \result != null && \result.int_size() == a.length
      @         && (\forall int i; 0 <= i && i < a.length; \result.has(a[i]));
      @*/
    public static /*@ pure @*/ /*@ non_null @*/
        JMLObjectBag convertFrom(/*@ non_null @*/Object[] a)
    {
        /*@ non_null @*/ JMLObjectBag ret = EMPTY;
        for (int i = 0; i < a.length; i++) {
            ret = ret.insert(a[i]);
        }
        return ret;
    } //@ nowarn Exception;

    /** Return the bag containing all the object in the
     * given collection.
     *  @throws ClassCastException if some element in c is not an instance of 
     * Object.
     *  @see #containsAll(java.util.Collection)
     */
    /*@   public normal_behavior
      @      requires c != null
      @           && (c.elementType <: \type(Object));
      @      ensures \result != null && \result.int_size() == c.size()
      @           && (* \result contains each element in c *);
      @      ensures_redundantly \result != null && \result.int_size() == c.size()
      @           && (\forall Object x; c.contains(x) <==> \result.has(x));
      @  also
      @    public exceptional_behavior
      @      requires c != null && (\exists Object o; c.contains(o);
      @                                  !(o instanceof Object));
      @      signals_only ClassCastException;
      @*/
    public static /*@ pure @*/ /*@ non_null @*/
        JMLObjectBag convertFrom(/*@ non_null @*/ java.util.Collection c)
        throws ClassCastException
    {
        /*@ non_null @*/ JMLObjectBag ret = EMPTY;
        java.util.Iterator celems = c.iterator();
        while (celems.hasNext()) {
            Object o = celems.next();
            if (o == null) {
                ret = ret.insert(null);
            } else {
                //@ assume o instanceof Object;
                ret = ret.insert(o);
            }
        }
        return ret;
    } //@ nowarn Exception;

    /** Return the bag containing all the object in the
     * given JMLCollection.
     *  @throws ClassCastException if some element in c is not an instance of 
     * Object.
     */
    /*@   public normal_behavior
      @      requires c != null
      @           && (c.elementType <: \type(Object));
      @      ensures \result != null
      @           && (\forall Object x; c.has(x) <==> \result.has(x));
      @      ensures_redundantly \result.int_size() == c.int_size();
      @  also
      @    public exceptional_behavior
      @      requires c != null && (\exists Object o; c.has(o);
      @                                  !(o instanceof Object));
      @      signals_only ClassCastException;
      @*/
    public static /*@ pure @*/ /*@ non_null @*/
        JMLObjectBag convertFrom(/*@ non_null @*/ JMLCollection c)
        throws ClassCastException
    {
        /*@ non_null @*/ JMLObjectBag ret = EMPTY;
        JMLIterator celems = c.iterator();
        while (celems.hasNext()) {
            Object o = celems.next();
            if (o == null) {
                ret = ret.insert(null);
            } else {
                //@ assume o instanceof Object;
                ret = ret.insert(o);
            }
        }
        return ret;
    } //@ nowarn Exception;

    //**************************** Observers **********************************

    /** Tell how many times the given element occurs "=="
     *  to an element in this bag.
     *  @param elem the element sought.
     *  @return the number of times elem occurs in this bag.
     *  @see #has(Object)
     */
    /*@ 
      @    public normal_behavior
      @      ensures \result >= 0
      @           && (* \result is the number of times elem occurs in this *);
      @*/
     //@ implies_that
     //@    ensures \result >= 0;
    public int count(Object elem ) {
        JMLObjectBagEntry matchingEntry = getMatchingEntry(elem);
        if (matchingEntry != null) {
            return matchingEntry.count;
        } else {
            //@ assert !has(elem); 
            // there is no matching item in the list.
            return 0;
        }
    }  

    /** Tell whether the given element occurs "=="
     *  to an element in this bag.
     *  @param elem the element sought.
     *  @see #count(Object)
     */
    /*@ also
      @   public normal_behavior
      @     ensures \result <==> (count(elem) > 0);
      @*/
    public boolean has(Object elem) {
        return the_list != null && the_list.has(new JMLObjectBagEntry(elem));
    }  

    /** Tell whether, for each element in the given collection, there is a
     * "==" element in this bag.
     *  @param c the collection whose elements are sought.
     *  @see #isSuperbag(JMLObjectSet)
     *  @see #convertFrom(java.util.Collection)
     */
    /*@ public normal_behavior
      @    requires c != null;
      @    ensures \result <==> (\forall Object o; c.contains(o); this.has(o));
      @*/
    public boolean containsAll(/*@ non_null @*/ java.util.Collection c) {
        java.util.Iterator celems = c.iterator();
        while (celems.hasNext()) {
            Object o = celems.next();
            if (!has(o)) {
                return false;
            }
        }
        return true;
    }  

    /** Test whether this object's value is equal to the given argument.
     * This comparison uses "==" to compare elements.
     *
     * <p>Note that the <kbd>elementType</kbd>s may be different for
     * otherwise equal bags.
     */
    /*@ also
      @   public normal_behavior
      @     ensures \result <==>
      @              b2 != null && b2 instanceof JMLObjectBag
      @               && (\forall Object e; ;
      @                   this.count(e) == ((JMLObjectBag)b2).count(e));
      @*/
    /*@ implies_that
      @   public normal_behavior
      @     requires b2 != null && b2 instanceof JMLObjectBag;
      @     ensures \result ==>
      @          this.int_size() == ((JMLObjectBag)b2).int_size()
      @          && containsNull == ((JMLObjectBag)b2).containsNull;
      @*/
    public boolean equals(/*@ nullable @*/ Object b2) {
        return b2 != null && b2 instanceof JMLObjectBag
            && (size == ((JMLObjectBag)b2).int_size())
            && isSubbag((JMLObjectBag)b2);
    }  

    /** Return a hash code for this object
     */
    public /*@ pure @*/ int hashCode() {
        return the_list == null ? 0 : the_list.hashCode();
    }

    /** Tell whether this bag has no elements.
     * @see #int_size()
     * @see #has(Object)
     */
    /*@ public normal_behavior
      @   ensures \result == (\forall Object e; ; count(e) == 0);
      @*/
    public boolean isEmpty() {
        return the_list == null;
    }  

    /** Tell the number of elements in this bag.
     */
    /*@ also
      @    public normal_behavior
      @      ensures \result >= 0 && (* \result is the size of this bag *);
      @*/
    public int int_size( ) {
        return size;
    }  

    /** Tells whether every item in this bag is contained in the argument.
     * @see #isProperSubbag(JMLObjectBag)
     * @see #isSuperbag(JMLObjectBag)
     */
    /*@ public normal_behavior
      @    requires b2 != null;
      @    ensures \result <==>
      @      (\forall Object e; ; count(e) <= b2.count(e));
      @*/
    public boolean isSubbag(/*@ non_null @*/ JMLObjectBag b2) {
        if (size > b2.int_size()) {
            return false;
        } else {
            for (JMLListValueNode walker = the_list;
                 walker != null;
                 walker = walker.next) {
                //@ assume walker.val instanceof JMLObjectBagEntry;
                JMLObjectBagEntry entry = (JMLObjectBagEntry) walker.val;
                if (entry.count > b2.count(entry.theElem)) {
                    return false;
                }
            }   
            //@ assert (\forall Object e; ; this.count(e) <= b2.count(e));
            return true;
        }
    }

    /** Tells whether every item in this bag is contained in the
     * argument, but the argument is strictly larger.
     * @see #isSubbag(JMLObjectBag)
     * @see #isProperSuperbag(JMLObjectBag)
     */
    /*@ public normal_behavior
      @    requires b2 != null;
      @    ensures \result <==>
      @       this.isSubbag(b2) && !this.equals(b2);
      @*/
    public boolean isProperSubbag(/*@ non_null @*/ JMLObjectBag b2) {
        return size < b2.int_size() && isSubbag(b2);
    }  

    /** Tells whether every item in the argument is contained in this bag.
     * @see #isProperSuperbag(JMLObjectBag)
     * @see #isSubbag(JMLObjectBag)
     * @see #containsAll(java.util.Collection)
     */
    /*@ public normal_behavior
      @    requires b2 != null;
      @    ensures \result == b2.isSubbag(this);
      @*/
    public boolean isSuperbag(/*@ non_null @*/ JMLObjectBag b2) {
        return b2.isSubbag(this);
    }

    /** Tells whether every item in the argument is contained in this bag
     * argument, but this bag is strictly larger.
     * @see #isSuperbag(JMLObjectBag)
     * @see #isProperSubbag(JMLObjectBag)
     */
    /*@  public normal_behavior
      @    requires b2 != null;
      @    ensures \result == b2.isProperSubbag(this);
      @*/
    public boolean isProperSuperbag(/*@ non_null @*/ JMLObjectBag b2) {
        return b2.isProperSubbag(this);
    }  

    /** Return an arbitrary element of this.
     *  @exception JMLNoSuchElementException if this is empty.
     *  @see #isEmpty()
     *  @see #elements()
     */
    /*@   public normal_behavior
      @     requires !isEmpty();
      @     ensures (\exists Object e; this.has(e);
      @                       \result == e);
      @ also
      @   public exceptional_behavior
      @     requires isEmpty();
      @     signals_only JMLNoSuchElementException;
      @
      @ implies_that
      @    ensures \result != null ==> \typeof(\result) <: elementType;
      @    ensures !containsNull ==> \result != null;
      @    signals_only JMLNoSuchElementException;
      @    signals (JMLNoSuchElementException) size == 0;
      @*/
    public Object choose() throws JMLNoSuchElementException {
        if (the_list != null) {
            //@ assume the_list.val instanceof JMLObjectBagEntry;
            JMLObjectBagEntry entry = (JMLObjectBagEntry) the_list.val;
            Object elt = entry.theElem;
            if (elt == null) {
                //@ assume containsNull;
                return null;
            } else {
                Object o = elt ;
                //@ assume o != null && \typeof(o) <: elementType;
                return (Object) o;
            }
        } else {
            throw new JMLNoSuchElementException("Tried to .choose() "
                                                + "with JMLObjectBag empty");
        }
    }  

    // ******************** building new JMLObjectBags **********************

    /** Return a clone of this object.  This method does not clone the
     * elements of the bag.
     */
    /*@ also
      @   public normal_behavior
      @     ensures \result instanceof JMLObjectBag && this.equals(\result);
      @     ensures_redundantly \result != null;
      @*/
    public /*@ non_null @*/ Object clone() { 
        return this;
    }  

    /** Find a JMLObjectBagEntry that is for the same element, if possible.
     *  @param item the item sought.
     *  @return null if the item is not in the bag.
     */
    /*@  assignable \nothing;
      @   ensures the_list == null ==> \result == null;
      @  ensures_redundantly \result != null ==> the_list != null;
      @   ensures \result != null
      @        ==> 0 <= \result.count && \result.count <= size;
      @*/
    protected JMLObjectBagEntry getMatchingEntry(Object item) {
        JMLObjectBagEntry currEntry = null;
        JMLListValueNode ptr = this.the_list;
        //@ maintaining (* no earlier element matches item *);
        while (ptr != null) {
            //@ assume ptr.val instanceof JMLObjectBagEntry;
            currEntry = (JMLObjectBagEntry) ptr.val;
            if (currEntry.equalElem(item)) {
                //@ assume currEntry.count <= size;
                return currEntry;
            }
            ptr = ptr.next;
        }
        return null;
    }

    /** Return a bag containing the given item and the ones in
     * this bag.
     *  @see #insert(Object, int)
     *  @see #has(Object)
     *  @see #remove(Object)
     */
    /*@ 
      @   public normal_behavior
      @    requires size < Integer.MAX_VALUE;
      @    {|
      @       requires elem != null;
      @       ensures \result != null
      @       && (\forall Object e; ;
      @                ( (e == elem)
      @    	        ==> \result.count(e) == count(e) + 1 )
      @             && ( !(e == elem)
      @    	        ==> \result.count(e) == count(e) ));
      @     also
      @       requires elem == null;
      @       ensures \result != null
      @       && (\forall Object e; ;
      @               ( e == null
      @    	    ==> \result.count(e) == count(e) + 1 )
      @            && (e != null
      @    	    ==> \result.count(e) == count(e) ));
      @    |}
      @*/
    public /*@ non_null @*/ JMLObjectBag insert(/*@ nullable @*/ Object elem)
        throws IllegalStateException
    {
        return insert(elem, 1);
    }

    /** Return a bag containing the given item the given number of
     *  times, in addition to the ones in this bag.
     *  @see #insert(Object)
     *  @see #has(Object)
     *  @see #remove(Object, int)
     */
    /*@ 
      @   public normal_behavior
      @    requires cnt > 0;
      @    requires size <= Integer.MAX_VALUE - cnt;
      @    {|
      @       requires elem != null;
      @       ensures \result != null
      @	      && (\forall Object e; ;
      @                ( (e != null && e == elem)
      @	                  ==> \result.count(e) == count(e) + cnt )
      @             && ( e == null || !(e == elem)
      @	                 ==> \result.count(e) == count(e) ));
      @     also
      @       requires elem == null;
      @       ensures \result != null
      @	      && (\forall Object e; ;
      @	              ( e == null ==> \result.count(e) == count(e) + cnt )
      @	           && ( e != null ==> \result.count(e) == count(e) ));
      @    |}
      @ also
      @  public normal_behavior
      @    requires cnt == 0;
      @    ensures \result != null && \result.equals(this);
      @*/
    //@ also
    //@      signals (IllegalArgumentException) cnt < 0;
    public /*@ non_null @*/ JMLObjectBag insert(/*@ nullable @*/ Object elem, int cnt)
          throws IllegalArgumentException, IllegalStateException
    {
        if (cnt < 0) {
            throw new IllegalArgumentException("insert called with negative count");
        }
        if (cnt == 0) {
            return this;
        }
        if (!(size <= Integer.MAX_VALUE - cnt)) {
            throw new IllegalStateException("Bag too big to insert into");
        }

        //@ assume cnt > 0;
        JMLObjectBagEntry entry = null;
        JMLObjectBagEntryNode new_list = the_list;
        JMLObjectBagEntry matchingEntry = getMatchingEntry(elem);
        if (matchingEntry != null) {
            entry = new JMLObjectBagEntry(matchingEntry.theElem,
                                          matchingEntry.count + cnt);
            JMLListValueNode nl = the_list.removeBE(matchingEntry);
            if (nl == null) {
                new_list = null;
            } else {
                new_list = (JMLObjectBagEntryNode) nl;
            }
        } else {
            //@ assert !has(elem); 
            // there is no matching item in the list.
            entry = new JMLObjectBagEntry(elem, cnt);
        }
        // cons() clones if necessary
        return new JMLObjectBag(JMLObjectBagEntryNode.cons(entry, new_list),
                                size + cnt);
    }

    /** Return a bag containing the items in this bag except for
     * one of the given element.
     * @see #remove(Object, int)
     * @see #insert(Object)
     */
    /*@ public normal_behavior
      @ {|
      @    requires elem != null;
      @    ensures \result != null
      @	   && (\forall Object e; ;
      @             ( (e == elem && has(e))
      @		  ==> \result.count(e) == count(e) - 1 )
      @          && ( !(e == elem)
      @		  ==> \result.count(e) == count(e) ));
      @  also
      @    requires elem == null;
      @    ensures \result != null
      @	   && (\forall Object e; ;
      @	           ( e == null
      @		  ==> \result.count(e) == count(e) - 1 )
      @	        && (e != null
      @		  ==> \result.count(e) == count(e) ));
      @ |}
      @*/
    public /*@ non_null @*/ JMLObjectBag remove(/*@ nullable @*/ Object elem) {
        return remove(elem, 1);
    }

    /** Return a bag containing the items in this bag, except for
     *  the given number of the given element.
     * @see #remove(Object)
     * @see #insert(Object, int)
     */
    /*@ public normal_behavior
      @  requires cnt > 0;
      @  {|
      @     requires elem != null;
      @     ensures \result != null
      @	    && (\forall Object e; ;
      @              ( (e == elem && has(e))
      @		   ==> \result.count(e) == JMLMath.max(0, count(e) - cnt) )
      @           && ( !(e == elem)
      @		   ==> \result.count(e) == count(e) ));
      @   also
      @     requires elem == null;
      @     ensures \result != null
      @	    && (\forall Object e; ;
      @	            ( e == null
      @		   ==> \result.count(e) == JMLMath.max(0, count(e) - cnt) )
      @	         && (e != null
      @		   ==> \result.count(e) == count(e) ));
      @  |}
      @ also
      @  public normal_behavior
      @    requires cnt == 0;
      @    ensures \result != null && \result.equals(this);
      @ implies_that
      @    requires 0 <= cnt;
      @*/
    public /*@ non_null @*/ JMLObjectBag remove(/*@ nullable @*/ Object elem, int cnt)
        throws IllegalArgumentException
    {
        if (cnt < 0) {
            throw new IllegalArgumentException("remove called with negative count");
        }
        if (cnt == 0) {
            return this;
        }

        JMLObjectBagEntry entry = null;
        JMLObjectBagEntryNode new_list = the_list;
        JMLObjectBagEntry matchingEntry = getMatchingEntry(elem);
        if (matchingEntry != null) {
            JMLListValueNode nl = the_list.removeBE(matchingEntry);
            if (nl == null) {
                new_list = null;
            } else {
                new_list = (JMLObjectBagEntryNode) nl;
            }
            //@ assume new_list == null <==> matchingEntry.count == size;
            if ((matchingEntry.count - cnt) > 0) {
                entry = new JMLObjectBagEntry(matchingEntry.theElem,
                                              matchingEntry.count - cnt);
                // cons() clones if necessary
                return new JMLObjectBag(JMLObjectBagEntryNode.cons(entry,
                                                                   new_list),
                                        size-cnt);
            } else {
                return new JMLObjectBag(new_list,
                                        size - matchingEntry.count);
            }
        } else {
            //@ assert !has(elem); 
            // there is no matching item in the list.
            return this;
        }
    }  

    /** Return a bag containing the items in this bag, except for
     *  all items that are "==" to the given item.
     *  @see #remove(Object)
     *  @see #remove(Object, int)
     */
    /*@   public normal_behavior
      @     requires elem != null;
      @     ensures \result != null
      @	    && (\forall Object e; ;
      @              ( (e == elem && has(e))
      @		   ==> \result.count(e) == 0 )
      @           && ( !(e == elem)
      @		   ==> \result.count(e) == count(e) ));
      @ also
      @   public normal_behavior
      @     requires elem == null;
      @     ensures \result != null
      @	    && (\forall Object e; ;
      @	            ( e == null
      @		   ==> \result.count(e) == 0 )
      @	         && (e != null
      @		   ==> \result.count(e) == count(e) ));
      @*/
    public /*@ non_null @*/ JMLObjectBag removeAll(/*@ nullable @*/ Object elem) {
        JMLObjectBagEntry matchingEntry = getMatchingEntry(elem);
        if (matchingEntry != null) {
            //@ assert the_list != null;
            JMLListValueNode nl = the_list.removeBE(matchingEntry);
            JMLObjectBagEntryNode new_list;
            if (nl == null) {
                new_list = null;
            } else {
                new_list = (JMLObjectBagEntryNode) nl;
            }
            //@ assume new_list == null <==> size-matchingEntry.count == 0;
            return new JMLObjectBag(new_list, size - matchingEntry.count);
        } else {
            //@ assert !has(elem); 
            // there is no matching item in the list.
            return this;
        }
    }  

    /** Return a bag containing the items in both this bag and the
     *  given bag.  Note that items occur the minimum number of times they
     *  occur in both bags.
     *  @see #union(JMLObjectBag)
     *  @see #difference(JMLObjectBag)
     */
    /*@ public normal_behavior
      @    requires b2 != null;
      @    ensures \result != null
      @	   && (\forall Object e; ;
      @             \result.count(e) == Math.min(count(e), b2.count(e)));
      @*/
    public /*@ non_null @*/ 
        JMLObjectBag intersection(/*@ non_null @*/ JMLObjectBag b2)
    {
        JMLObjectBagEntryNode newList = null;
        JMLObjectBagEntry newEntry;
        int othCount, newCount;
        int newSize = 0;
        JMLListValueNode thisWalker = the_list;
        while (thisWalker != null) {
            //@ assume thisWalker.val instanceof JMLObjectBagEntry;
            JMLObjectBagEntry currEntry = (JMLObjectBagEntry) thisWalker.val;
            othCount = b2.count(currEntry.theElem);
            newCount = Math.min(othCount, currEntry.count);
            if (newCount >= 1) {
                newEntry = new JMLObjectBagEntry(currEntry.theElem, newCount);
                newList = new JMLObjectBagEntryNode(newEntry, newList);
                newSize += newCount;
            }
            thisWalker = thisWalker.next;
        }   
        return new JMLObjectBag(newList, newSize);
    }  

    /** Return a bag containing the items in either this bag or the
     *  given bag.  Note that items occur the sum of times they
     *  occur in both bags.
     *  @see #intersection(JMLObjectBag)
     *  @see #difference(JMLObjectBag)
     */
    /*@ public normal_behavior
      @    requires size < Integer.MAX_VALUE - b2.size;
      @    requires b2 != null;
      @    ensures \result != null
      @	   && (\forall Object e; ;
      @             \result.count(e) == (count(e) + b2.count(e)));
      @*/
    public /*@ non_null @*/ 
        JMLObjectBag union(/*@ non_null @*/ JMLObjectBag b2)
    {
        JMLObjectBagEntryNode newList = null;
        JMLObjectBagEntry newEntry;
        int othCount, newCount;
        JMLListValueNode thisWalker = the_list;
        while (thisWalker != null) {
            //@ assume thisWalker.val instanceof JMLObjectBagEntry;
            JMLObjectBagEntry currEntry = (JMLObjectBagEntry) thisWalker.val;
            othCount = b2.count(currEntry.theElem);
            newCount = currEntry.count + othCount;
            //@ assume newCount > 0;
            newEntry = new JMLObjectBagEntry(currEntry.theElem, newCount);
            newList = new JMLObjectBagEntryNode(newEntry, newList);
            thisWalker = thisWalker.next;
        }   
        /*@ assert newList != null
          @      ==> (\forall JMLObjectBagEntry e; the_list.has(e);
          @             (\exists JMLObjectBagEntry n; newList.has(n);
          @                 n.theElem == e.theElem ==>
          @                 n.count == e.count + b2.count(e.theElem)));
          @*/
        JMLListValueNode othWalker = b2.the_list;
        while (othWalker != null) {
            //@ assume othWalker.val instanceof JMLObjectBagEntry;
            JMLObjectBagEntry currEntry = (JMLObjectBagEntry) othWalker.val;
            if (the_list == null || !the_list.has(currEntry)) {
                newList = new JMLObjectBagEntryNode(currEntry, newList);
            }
            othWalker = othWalker.next;
        }
        return new JMLObjectBag(newList, size + b2.size);
    }  

    /** Return a bag containing the items in this bag minus the
     *  items in the given bag.  If an item occurs in this bag N times,
     *  and M times in the given bag, then it occurs N-M times in the result.
     *  @see #union(JMLObjectBag)
     *  @see #difference(JMLObjectBag)
     */
    /*@ public normal_behavior
      @   requires b2 != null;
      @   ensures \result != null
      @	  && (\forall Object e; ;
      @            \result.count(e) == JMLMath.max(0, count(e) - b2.count(e)));
      @*/
    public /*@ non_null @*/ JMLObjectBag 
        difference(/*@ non_null @*/ JMLObjectBag b2)
    {
        JMLObjectBagEntryNode newList = null;
        JMLObjectBagEntry newEntry;
        int othCount, newCount;
        int newSize = 0;
        JMLListValueNode thisWalker = the_list;
        while (thisWalker != null) {
            //@ assume thisWalker.val instanceof JMLObjectBagEntry;
            JMLObjectBagEntry currEntry = (JMLObjectBagEntry) thisWalker.val;
            othCount = b2.count(currEntry.theElem);
            newCount = Math.max(0, currEntry.count - othCount);
            if (newCount >= 1) {
                newEntry = new JMLObjectBagEntry(currEntry.theElem, newCount);
                newList = new JMLObjectBagEntryNode(newEntry, newList);
                newSize += newCount;
            }
            thisWalker = thisWalker.next;
        }   
        return new JMLObjectBag(newList, newSize);
    }  


    /** Return a new JMLObjectSequence containing all the elements of this.
     *  @see #toArray()
     *  @see #toSet()
     */
    /*@ public normal_behavior
      @    ensures \result != null
      @         && (\forall Object o;; \result.count(o) == this.count(o));
      @*/
    public /*@ non_null @*/ JMLObjectSequence toSequence() {
        JMLObjectSequence ret = new JMLObjectSequence();
        JMLObjectBagEnumerator elems = elements();
        while (elems.hasMoreElements()) {
            //@ assume elems.moreElements;
            Object o = elems.nextElement();
            Object e = (o == null ? null :  o);
            ret = ret.insertFront(e);
        }
        return ret;
    } //@ nowarn Exception;

    /** Return a new JMLObjectSet containing all the elements of this.
     *  @see #toSequence()
     */
    /*@ public normal_behavior
      @    ensures \result != null
      @         && (\forall Object o;; \result.has(o) == this.has(o));
      @*/
    public /*@ non_null @*/ JMLObjectSet toSet() {
        JMLObjectSet ret = new JMLObjectSet();
        JMLObjectBagEnumerator elems = elements();
        while (elems.hasMoreElements()) {
            //@ assume elems.moreElements;
            Object o = elems.nextElement();
            Object e = (o == null ? null :  o);
            ret = ret.insert(e);
        }
        return ret;
    } //@ nowarn Exception;

    /** Return a new array containing all the elements of this.
     *  @see #toSequence()
     */
    /*@ public normal_behavior
      @    ensures \result != null && \result.length == int_size()
      @         && (\forall Object o;;
      @                   JMLArrayOps.objectIdentityCount(\result, o) == count(o));
      @    ensures_redundantly \result != null && \result.length == int_size()
      @         && (\forall int i; 0 <= i && i < \result.length;
      @               JMLArrayOps.objectIdentityCount(\result, \result[i])
      @                    == count(\result[i]));
      @*/
    public /*@ non_null @*/ Object[] toArray() {
        Object[] ret = new Object[int_size()];
        JMLObjectBagEnumerator elems = elements();
        int i = 0;
        //@ loop_invariant 0 <= i && i <= ret.length;
        while (elems.hasMoreElements()) {
            //@ assume elems.moreElements && i < ret.length;
            Object o = elems.nextElement();
            if (o == null) {
                ret[i] = null;
            } else {
                Object e =  o;
                ret[i] =  e ;
            }
            i++;
        }
        return ret;
    } //@ nowarn Exception;

    // ********************* Tools Methods *********************************
    // The enumerator method and toString are of no value for writing
    // assertions in JML. They are included for the use of developers
    // of CASE tools based on JML, e.g., type checkers, assertion
    // evaluators, prototype generators, test tools, ... . They can
    // also be used in model programs in specifications.

    /** Returns an Enumeration over this bag.
     *  @see #iterator()
     */
    /*@ public normal_behavior
      @   ensures \fresh(\result) && this.equals(\result.uniteratedElems);
      @*/  
    public /*@ non_null @*/ JMLObjectBagEnumerator elements() {
        return new JMLObjectBagEnumerator(this);
    }  

    /** Returns an iterator over this bag.
     *  @see #elements()
     */
    /*@ also
      @    public normal_behavior
      @      ensures \fresh(\result)
      @          && \result.equals(new JMLEnumerationToIterator(elements()));
      @*/  
    public /*@ non_null @*/ JMLIterator iterator() {
        return new JMLEnumerationToIterator(elements());
    }  //@ nowarn Post;

    /** Return a string representation of this object.
     */
    /*@ also
      @   public normal_behavior
      @     ensures (* \result is a string representation of this *);
      @*/
    public /*@ non_null @*/ String toString() {
        String newStr = new String("{");
        JMLListValueNode bagWalker = the_list;

        if (bagWalker != null) {
            newStr = newStr + bagWalker.val;
            bagWalker = bagWalker.next;
        }
        while (bagWalker != null) {
            newStr = newStr + ", " + bagWalker.val;
            bagWalker = bagWalker.next;
        }   
        newStr = newStr + "}";
        return newStr;
    }

}  // end of class JMLObjectBag


/** Internal class used in the implementation of JMLObjectBag.
 *
 *  @author Gary T. Leavens
 *  @see JMLObjectBag
 *  @see JMLObjectBagEntryNode
 */
// FIXME: adapt this file to non-null-by-default and remove the following modifier.
/*@ nullable_by_default @*/ 
/*@ pure spec_public @*/ class JMLObjectBagEntry implements JMLType {

    /** The element in this bag entry.
     */
    public final Object theElem;

    /** The number of times the element occurs.
     */
    public final int count;

    //@ public invariant count > 0;

    /** The type of the element in this entry.  This is Object if
     *  the element is null.
     */
    //@ ghost public \TYPE elementType;

    //@ public invariant elementType <: \type(Object);

    /*@ public
      @   invariant (theElem == null ==> elementType == \type(Object))
      @          && (theElem != null ==> elementType == \typeof(theElem));
      @*/

    //@ public invariant owner == null;

    /** Initialize this object to be a singleton entry.
     */
    /*@ public normal_behavior
      @   assignable theElem, count, elementType, owner;
      @   ensures theElem == e && count == 1;
      @*/
    public JMLObjectBagEntry(Object e) {
        //@ set owner = null;
        theElem = e;
        count = 1;
        /*@ set elementType
          @     = (theElem == null ? \type(Object) : \typeof(theElem));
          @*/
    }

    /** Initialize this object to be for the given element with the
     *  given number of repetitions.
     */
    /*@ public normal_behavior
      @    requires cnt > 0;
      @   assignable theElem, count, elementType, owner;
      @    ensures count == cnt && (e == null ==> theElem == null);
      @   ensures (e != null ==> e == theElem);
      @*/
    public JMLObjectBagEntry(Object e, int cnt) {
        //@ set owner = null;
        theElem = e;
        count = cnt;
        /*@ set elementType
          @     = (theElem == null ? \type(Object) : \typeof(theElem));
          @*/
    }

    /** Make a clone of the given entry.
     */
    public /*@ non_null @*/ Object clone() {
        //@ assume owner == null;
        return this;
    }   

    /** Are these elements equal? */
    /*@ public normal_behavior
      @    ensures \result <==>
      @         (othElem == null && theElem == null)
      @      || (othElem != null && othElem == theElem);
      @*/
    public boolean equalElem(Object othElem) {
        return (othElem == null && theElem == null)
            || (othElem != null && othElem == theElem);
    }   

    /** Test whether this object's value is equal to the given argument.
     */
    public boolean equals(/*@ nullable @*/ Object obj) {
        if (obj != null && obj instanceof JMLObjectBagEntry) {
            JMLObjectBagEntry oth = (JMLObjectBagEntry)obj;
            return equalElem(oth.theElem);
        } else {
            return(false);
        }
    }   

    /** Return a hash code for this object.
     */
    public int hashCode() {
        return theElem == null ? 0 : theElem.hashCode();
    }

    /** Return a new bag entry with the same element as this but with
     *  the given number of repetitions added to the element's current
     *  count.
     */
    /*@ public normal_behavior
      @   requires numInserted > 0;
      @   ensures \result != null && \result.count == count + numInserted;
      @   ensures \result != null && \result.theElem == theElem;
      @*/
    public JMLObjectBagEntry insert(int numInserted) {
        return new JMLObjectBagEntry(theElem, count + numInserted);
    }  

    /** Return a string representation of this object.
     */
    public /*@ non_null @*/ String toString() {
        if (count == 1) {
            return theElem + "";
        } else {
            return count + " copies of " + theElem;
        }
    }   

}

/** Internal class used in the implementation of JMLObjectBag.
 *
 *  @author Gary T. Leavens
 *  @see JMLObjectBag
 *  @see JMLObjectBagEntry
 *  @see JMLListValueNode
 */
// FIXME: adapt this file to non-null-by-default and remove the following modifier.
/*@ nullable_by_default @*/ 
/*@ pure spec_public @*/ class JMLObjectBagEntryNode extends JMLListValueNode {

    //@ public invariant elementType == \type(JMLObjectBagEntry) && !containsNull;

    //@ public invariant val != null && val instanceof JMLObjectBagEntry;

    //@ public invariant next != null ==> next instanceof JMLObjectBagEntryNode;

    /** The type of the elements contained in the entries in this list.
     */
    //@ ghost public \TYPE entryElementType;

    //@ public constraint entryElementType == \old(entryElementType);

    //@ public invariant entryElementType <: \type(Object);

    /*@ public invariant
      @      val != null && val instanceof JMLObjectBagEntry
      @      && ((JMLObjectBagEntry)val).elementType <: entryElementType;
      @  public invariant
      @    (next != null
      @       ==> ((JMLObjectBagEntryNode)next).entryElementType
      @             <: entryElementType);
      @  public invariant
      @    containsNullElements ==> entryElementType == \type(Object);
      @*/

    /** Whether this list can contain null elements in its bag entries;
     */
    //@ ghost public boolean containsNullElements;

    //@ public constraint containsNullElements == \old(containsNullElements);

    /*@ protected
      @    invariant containsNullElements <==>
      @                ((JMLObjectBagEntry)val).theElem == null
      @             || (next != null
      @                 && ((JMLObjectBagEntryNode)next).containsNullElements);
      @*/

    /** Initialize this list to have the given bag entry as its first
     * element followed by the given list.
     * This does not do any cloning.
     *
     * @param entry the JMLObjectBagEntry to place at the head of this list.
     * @param nxt the JMLObjectBagEntryNode to make the tail of this list.
     * @see #cons
     */
    /*@  public normal_behavior
      @    requires entry != null;
      @    assignable val, next, elementType, containsNull, owner;
      @    assignable entryElementType, containsNullElements;
      @    ensures val == entry;
      @*/
    /*@    ensures next == nxt;
      @    ensures entryElementType
      @             == (nxt == null ? entry.elementType
      @                 : (nxt.entryElementType <: entry.elementType
      @                    ? entry.elementType
      @                    : ((entry.elementType <: nxt.entryElementType)
      @                       ? nxt.entryElementType
      @                       : \type(Object))));
      @    ensures containsNullElements
      @             == (((JMLObjectBagEntry)val).theElem == null
      @                 || (next != null
      @                     && ((JMLObjectBagEntryNode)next)
      @                         .containsNullElements));
      @*/
    public JMLObjectBagEntryNode(/*@ non_null @*/ JMLObjectBagEntry entry,
                                 JMLObjectBagEntryNode nxt) {
        super(entry, nxt);
        //@ assume elementType == \type(JMLObjectBagEntry) && !containsNull;
        //@ assert owner == null;
        /*@ set entryElementType
          @      = (nxt == null ? entry.elementType
          @           : (nxt.entryElementType <: entry.elementType
          @              ? entry.elementType
          @              // types aren't totally ordered!
          @              : ((entry.elementType <: nxt.entryElementType)
          @                 ? nxt.entryElementType
          @                 : \type(Object))));
          @ set containsNullElements
          @       = (((JMLObjectBagEntry)val).theElem == null
          @          || (next != null
          @              && ((JMLObjectBagEntryNode)next)
          @                  .containsNullElements));
          @*/
    } //@ nowarn Invariant;

    /** Return a JMLObjectBagEntryNode containing the given entry
     *  followed by the given list.
     *
     * This method handles any necessary cloning for value lists
     * and it handles inserting null elements.
     *
     * @param hd the JMLObjectBagEntry to place at the head of the result.
     * @param tl the JMLObjectBagEntryNode to make the tail of the result.
     * @see #JMLObjectBagEntryNode
     */
    /*@  public normal_behavior
      @    requires hd != null;
      @    ensures \result != null
      @         && \result.headEquals(hd) && \result.next == tl;
      @    ensures \result.equals(new JMLObjectBagEntryNode(hd, tl));
      @ implies_that
      @    requires hd != null;
      @    ensures tl == null <==> \result.next == null;
      @    ensures \result != null && \result.val instanceof JMLObjectBagEntry
      @         && \result.entryElementType
      @             == (\result.next == null
      @                 ? ((JMLObjectBagEntry)\result.val).elementType
      @                 : (((JMLObjectBagEntryNode)\result.next)
      @                               .entryElementType
      @                        <: ((JMLObjectBagEntry)\result.val).elementType
      @                    ? ((JMLObjectBagEntry)\result.val).elementType
      @                    : ((((JMLObjectBagEntry)\result.val).elementType
      @                          <: ((JMLObjectBagEntryNode)\result.next)
      @                              .entryElementType)
      @                       ? ((JMLObjectBagEntryNode)\result.next)
      @                              .entryElementType
      @                       : \type(Object))));
      @    ensures \result != null
      @         && \result.containsNullElements
      @             == (((JMLObjectBagEntry)\result.val).theElem == null
      @                 || (\result.next != null
      @                     && ((JMLObjectBagEntryNode)\result.next)
      @                         .containsNullElements));
      @*/
    public static /*@ pure @*/ /*@ non_null @*/
        JMLObjectBagEntryNode cons(/*@ non_null @*/ JMLObjectBagEntry hd,
                                   JMLObjectBagEntryNode tl)
    {
        return new JMLObjectBagEntryNode((JMLObjectBagEntry) hd.clone(),
                                         tl);
    } //@ nowarn Post;

    /** Return a clone of this object.
     */
    /*@ also
      @  public normal_behavior
      @    ensures \result != null
      @    && \result instanceof JMLObjectBagEntryNode
      @    && ((JMLObjectBagEntryNode)\result).equals(this);
      @*/
    public /*@ non_null @*/ Object clone() {
        // Recall that cons() handles cloning.
        return cons(val,
                    (next == null
                     ? null
                     : (JMLObjectBagEntryNode) next.clone()));
    } //@ nowarn Post;

    /** Return a list that is like this list but without the first
     * occurrence of the given bag entry.
     */
    /*@  public normal_behavior
      @    requires !has(entry);
      @    ensures this.equals(\result);
      @ also
      @  public normal_behavior
      @    old int index = indexOf(entry);
      @    requires has(entry);
      @    ensures \result == null <==> \old(int_size() == 1);
      @    ensures \result != null && index == 0
      @        ==> \result.equals(removePrefix(1));
      @    ensures \result != null && index > 0
      @        ==> \result.equals(prefix(index).concat(removePrefix((int)(index+1))));
      @*/
    public JMLObjectBagEntryNode
        removeBE(/*@ non_null @*/ JMLObjectBagEntry entry)
    {
        if (entry == val) {
            if (next == null) {
                return null;
            } else {
                return (JMLObjectBagEntryNode) next;
            }
        } else {
            JMLObjectBagEntryNode rest
                = (next == null ? null
                   : ((JMLObjectBagEntryNode)next).removeBE(entry));
            return new JMLObjectBagEntryNode((JMLObjectBagEntry) val,
                                             rest);
        }
    }

}
