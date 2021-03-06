// Spec# Program Verifier Version 0.80, Copyright (c) 2003-2006, Microsoft.
// Command Line Options: -nologo /prover:blank /print:boogie_tmp.@TIME@.bpl /proverLog:boogie_tmp.@TIME@.simplify /infer:eh loopinv0.dll

type real;

type elements;

type struct;

type exposeVersionType;

var $Heap: [ref,<x>name]x where IsHeap($Heap);

function IsHeap(h: [ref,<x>name]x) returns (bool);

const $allocated: <bool>name;

const $elements: <elements>name;

const $inv: <name>name;

const $localinv: <name>name;

const $exposeVersion: <exposeVersionType>name;

axiom DeclType($exposeVersion) == System.Object;

const $sharingMode: name;

const $SharingMode_Unshared: name;

const $SharingMode_LockProtected: name;

const $ownerRef: <ref>name;

const $ownerFrame: <name>name;

const $PeerGroupPlaceholder: name;

function ClassRepr(class: name) returns (ref);

axiom (forall c0: name, c1: name :: { ClassRepr(c0), ClassRepr(c1) } c0 != c1 ==> ClassRepr(c0) != ClassRepr(c1));

axiom (forall T: name :: !($typeof(ClassRepr(T)) <: System.Object));

axiom (forall T: name :: ClassRepr(T) != null);

axiom (forall T: name, h: [ref,<x>name]x :: { h[ClassRepr(T), $ownerFrame] } IsHeap(h) ==> h[ClassRepr(T), $ownerFrame] == $PeerGroupPlaceholder);

function IsDirectlyModifiableField(f: name) returns (bool);

axiom !IsDirectlyModifiableField($allocated);

axiom IsDirectlyModifiableField($elements);

axiom !IsDirectlyModifiableField($inv);

axiom !IsDirectlyModifiableField($localinv);

axiom !IsDirectlyModifiableField($ownerRef);

axiom !IsDirectlyModifiableField($ownerFrame);

axiom !IsDirectlyModifiableField($exposeVersion);

function IsStaticField(f: name) returns (bool);

axiom !IsStaticField($allocated);

axiom !IsStaticField($elements);

axiom !IsStaticField($inv);

axiom !IsStaticField($localinv);

axiom !IsStaticField($exposeVersion);

function ValueArrayGet(elements, int) returns (any);

function ValueArraySet(elements, int, any) returns (elements);

function RefArrayGet(elements, int) returns (ref);

function RefArraySet(elements, int, ref) returns (elements);

axiom (forall A: elements, i: int, x: any :: ValueArrayGet(ValueArraySet(A, i, x), i) == x);

axiom (forall A: elements, i: int, j: int, x: any :: i != j ==> ValueArrayGet(ValueArraySet(A, i, x), j) == ValueArrayGet(A, j));

axiom (forall A: elements, i: int, x: ref :: RefArrayGet(RefArraySet(A, i, x), i) == x);

axiom (forall A: elements, i: int, j: int, x: ref :: i != j ==> RefArrayGet(RefArraySet(A, i, x), j) == RefArrayGet(A, j));

function ArrayIndex(arr: ref, dim: int, indexAtDim: int, remainingIndexContribution: int) returns (int);

axiom (forall a: ref, d: int, x: int, y: int, x': int, y': int :: { ArrayIndex(a, d, x, y), ArrayIndex(a, d, x', y') } ArrayIndex(a, d, x, y) == ArrayIndex(a, d, x', y') ==> x == x' && y == y');

axiom (forall a: ref, T: name, i: int, r: int, heap: [ref,<x>name]x :: { $typeof(a) <: RefArray(T, r), RefArrayGet(heap[a, $elements], i) } IsHeap(heap) && $typeof(a) <: RefArray(T, r) ==> $Is(RefArrayGet(heap[a, $elements], i), T));

axiom (forall a: ref, T: name, i: int, r: int, heap: [ref,<x>name]x :: { $typeof(a) <: NonNullRefArray(T, r), RefArrayGet(heap[a, $elements], i) } IsHeap(heap) && $typeof(a) <: NonNullRefArray(T, r) ==> $IsNotNull(RefArrayGet(heap[a, $elements], i), T));

function $Rank(ref) returns (int);

axiom (forall a: ref :: 1 <= $Rank(a));

axiom (forall a: ref, T: name, r: int :: { $typeof(a) <: RefArray(T, r) } a != null && $typeof(a) <: RefArray(T, r) ==> $Rank(a) == r);

axiom (forall a: ref, T: name, r: int :: { $typeof(a) <: NonNullRefArray(T, r) } a != null && $typeof(a) <: NonNullRefArray(T, r) ==> $Rank(a) == r);

axiom (forall a: ref, T: name, r: int :: { $typeof(a) <: ValueArray(T, r) } a != null && $typeof(a) <: ValueArray(T, r) ==> $Rank(a) == r);

function $Length(ref) returns (int);

axiom (forall a: ref :: { $Length(a) } 0 <= $Length(a));

function $DimLength(ref, int) returns (int);

axiom (forall a: ref, i: int :: 0 <= $DimLength(a, i));

axiom (forall a: ref :: { $DimLength(a, 0) } $Rank(a) == 1 ==> $DimLength(a, 0) == $Length(a));

function $LBound(ref, int) returns (int);

function $UBound(ref, int) returns (int);

axiom (forall a: ref, i: int :: { $LBound(a, i) } $LBound(a, i) == 0);

axiom (forall a: ref, i: int :: { $UBound(a, i) } $UBound(a, i) == $DimLength(a, i) - 1);

const $ArrayCategoryValue: name;

const $ArrayCategoryRef: name;

const $ArrayCategoryNonNullRef: name;

function $ArrayCategory(arrayType: name) returns (arrayCategory: name);

axiom (forall T: name, ET: name, r: int :: { T <: ValueArray(ET, r) } T <: ValueArray(ET, r) ==> $ArrayCategory(T) == $ArrayCategoryValue);

axiom (forall T: name, ET: name, r: int :: { T <: RefArray(ET, r) } T <: RefArray(ET, r) ==> $ArrayCategory(T) == $ArrayCategoryRef);

axiom (forall T: name, ET: name, r: int :: { T <: NonNullRefArray(ET, r) } T <: NonNullRefArray(ET, r) ==> $ArrayCategory(T) == $ArrayCategoryNonNullRef);

const System.Array: name;

axiom System.Array <: System.Object;

function $ElementType(name) returns (name);

function ValueArray(elementType: name, rank: int) returns (name);

axiom (forall T: name, r: int :: { ValueArray(T, r) } ValueArray(T, r) <: System.Array);

function RefArray(elementType: name, rank: int) returns (name);

axiom (forall T: name, r: int :: { RefArray(T, r) } RefArray(T, r) <: System.Array);

function NonNullRefArray(elementType: name, rank: int) returns (name);

axiom (forall T: name, r: int :: { NonNullRefArray(T, r) } NonNullRefArray(T, r) <: System.Array);

axiom (forall T: name, U: name, r: int :: U <: T ==> RefArray(U, r) <: RefArray(T, r));

axiom (forall T: name, U: name, r: int :: U <: T ==> NonNullRefArray(U, r) <: NonNullRefArray(T, r));

axiom (forall A: name, r: int :: $ElementType(ValueArray(A, r)) == A);

axiom (forall A: name, r: int :: $ElementType(RefArray(A, r)) == A);

axiom (forall A: name, r: int :: $ElementType(NonNullRefArray(A, r)) == A);

axiom (forall A: name, r: int, T: name :: { T <: RefArray(A, r) } T <: RefArray(A, r) ==> T == RefArray($ElementType(T), r) && $ElementType(T) <: A);

axiom (forall A: name, r: int, T: name :: { T <: NonNullRefArray(A, r) } T <: NonNullRefArray(A, r) ==> T == NonNullRefArray($ElementType(T), r) && $ElementType(T) <: A);

axiom (forall A: name, r: int, T: name :: { T <: ValueArray(A, r) } T <: ValueArray(A, r) ==> T == ValueArray(A, r));

axiom (forall A: name, r: int, T: name :: RefArray(A, r) <: T ==> System.Array <: T || (T == RefArray($ElementType(T), r) && A <: $ElementType(T)));

axiom (forall A: name, r: int, T: name :: NonNullRefArray(A, r) <: T ==> System.Array <: T || (T == NonNullRefArray($ElementType(T), r) && A <: $ElementType(T)));

axiom (forall A: name, r: int, T: name :: ValueArray(A, r) <: T ==> System.Array <: T || T == ValueArray(A, r));

function $ArrayPtr(elementType: name) returns (name);

function $StructGet(struct, name) returns (any);

function $StructSet(struct, name, any) returns (struct);

axiom (forall s: struct, f: name, x: any :: $StructGet($StructSet(s, f, x), f) == x);

axiom (forall s: struct, f: name, f': name, x: any :: f != f' ==> $StructGet($StructSet(s, f, x), f') == $StructGet(s, f'));

function ZeroInit(s: struct, typ: name) returns (bool);

function $typeof(ref) returns (name);

function $BaseClass(sub: name) returns (base: name);

function AsDirectSubClass(sub: name, base: name) returns (sub': name);

function OneClassDown(sub: name, base: name) returns (directSub: name);

axiom (forall A: name, B: name, C: name :: { C <: AsDirectSubClass(B, A) } C <: AsDirectSubClass(B, A) ==> OneClassDown(C, A) == B);

function $IsValueType(name) returns (bool);

axiom (forall T: name :: $IsValueType(T) ==> (forall U: name :: T <: U ==> T == U) && (forall U: name :: U <: T ==> T == U));

const System.Object: name;

function $IsTokenForType(struct, name) returns (bool);

function TypeObject(name) returns (ref);

const System.Type: name;

axiom System.Type <: System.Object;

axiom (forall T: name :: { TypeObject(T) } $IsNotNull(TypeObject(T), System.Type));

function TypeName(ref) returns (name);

axiom (forall T: name :: { TypeObject(T) } TypeName(TypeObject(T)) == T);

function $Is(ref, name) returns (bool);

axiom (forall o: ref, T: name :: { $Is(o, T) } $Is(o, T) <==> o == null || $typeof(o) <: T);

function $IsNotNull(ref, name) returns (bool);

axiom (forall o: ref, T: name :: { $IsNotNull(o, T) } $IsNotNull(o, T) <==> o != null && $Is(o, T));

function $As(ref, name) returns (ref);

axiom (forall o: ref, T: name :: $Is(o, T) ==> $As(o, T) == o);

axiom (forall o: ref, T: name :: !$Is(o, T) ==> $As(o, T) == null);

axiom (forall h: [ref,<x>name]x, o: ref :: { $typeof(o) <: System.Array, h[o, $inv] } IsHeap(h) && o != null && $typeof(o) <: System.Array ==> h[o, $inv] == $typeof(o) && h[o, $localinv] == $typeof(o));

function IsAllocated(h: [ref,<x>name]x, o: any) returns (bool);

axiom (forall h: [ref,<x>name]x, o: ref, f: name :: { IsAllocated(h, h[o, f]) } IsHeap(h) && h[o, $allocated] ==> IsAllocated(h, h[o, f]));

axiom (forall h: [ref,<x>name]x, o: ref, f: <ref>name :: { h[h[o, f], $allocated] } IsHeap(h) && h[o, $allocated] ==> h[h[o, f], $allocated]);

axiom (forall h: [ref,<x>name]x, s: struct, f: name :: { IsAllocated(h, $StructGet(s, f)) } IsAllocated(h, s) ==> IsAllocated(h, $StructGet(s, f)));

axiom (forall h: [ref,<x>name]x, e: elements, i: int :: { IsAllocated(h, RefArrayGet(e, i)) } IsAllocated(h, e) ==> IsAllocated(h, RefArrayGet(e, i)));

axiom (forall h: [ref,<x>name]x, e: elements, i: int :: { IsAllocated(h, ValueArrayGet(e, i)) } IsAllocated(h, e) ==> IsAllocated(h, ValueArrayGet(e, i)));

axiom (forall h: [ref,<x>name]x, o: ref :: { h[o, $allocated] } IsAllocated(h, o) ==> h[o, $allocated]);

axiom (forall h: [ref,<x>name]x, c: name :: { h[ClassRepr(c), $allocated] } IsHeap(h) ==> h[ClassRepr(c), $allocated]);

const $BeingConstructed: ref;

const $NonNullFieldsAreInitialized: <bool>name;

function DeclType(field: name) returns (class: name);

function AsNonNullRefField(field: <ref>name, T: name) returns (f: <ref>name);

function AsRefField(field: <ref>name, T: name) returns (f: <ref>name);

function AsRangeField(field: <int>name, T: name) returns (f: <int>name);

axiom (forall f: <ref>name, T: name :: { AsNonNullRefField(f, T) } AsNonNullRefField(f, T) == f ==> AsRefField(f, T) == f);

axiom (forall h: [ref,<x>name]x, o: ref, f: <ref>name, T: name :: { h[o, AsRefField(f, T)] } IsHeap(h) ==> $Is(h[o, AsRefField(f, T)], T));

axiom (forall h: [ref,<x>name]x, o: ref, f: <ref>name, T: name :: { h[o, AsNonNullRefField(f, T)] } IsHeap(h) && o != null && (o != $BeingConstructed || h[$BeingConstructed, $NonNullFieldsAreInitialized] == true) ==> h[o, AsNonNullRefField(f, T)] != null);

axiom (forall h: [ref,<x>name]x, o: ref, f: <int>name, T: name :: { h[o, AsRangeField(f, T)] } IsHeap(h) ==> InRange(h[o, AsRangeField(f, T)], T));

function $IsMemberlessType(name) returns (bool);

axiom (forall o: ref :: { $IsMemberlessType($typeof(o)) } !$IsMemberlessType($typeof(o)));

function $IsImmutable(T: name) returns (bool);

axiom !$IsImmutable(System.Object);

function $AsImmutable(T: name) returns (theType: name);

function $AsMutable(T: name) returns (theType: name);

axiom (forall T: name, U: name :: { U <: $AsImmutable(T) } U <: $AsImmutable(T) ==> $IsImmutable(U) && $AsImmutable(U) == U);

axiom (forall T: name, U: name :: { U <: $AsMutable(T) } U <: $AsMutable(T) ==> !$IsImmutable(U) && $AsMutable(U) == U);

function AsOwner(string: ref, owner: ref) returns (theString: ref);

axiom (forall o: ref, T: name :: { $typeof(o) <: $AsImmutable(T) } o != null && o != $BeingConstructed && $typeof(o) <: $AsImmutable(T) ==> (forall h: [ref,<x>name]x :: { IsHeap(h) } IsHeap(h) ==> h[o, $inv] == $typeof(o) && h[o, $localinv] == $typeof(o) && h[o, $ownerFrame] == $PeerGroupPlaceholder && AsOwner(o, h[o, $ownerRef]) == o && (forall t: ref :: { AsOwner(o, h[t, $ownerRef]) } AsOwner(o, h[t, $ownerRef]) == o ==> t == o || h[t, $ownerFrame] != $PeerGroupPlaceholder)));

const System.String: name;

function $StringLength(ref) returns (int);

axiom (forall s: ref :: { $StringLength(s) } 0 <= $StringLength(s));

function AsRepField(f: <ref>name, declaringType: name) returns (theField: <ref>name);

axiom (forall h: [ref,<x>name]x, o: ref, f: <ref>name, T: name :: { h[o, AsRepField(f, T)] } IsHeap(h) && h[o, AsRepField(f, T)] != null ==> h[h[o, AsRepField(f, T)], $ownerRef] == o && h[h[o, AsRepField(f, T)], $ownerFrame] == T);

function AsPeerField(f: <ref>name) returns (theField: <ref>name);

axiom (forall h: [ref,<x>name]x, o: ref, f: <ref>name :: { h[o, AsPeerField(f)] } IsHeap(h) && h[o, AsPeerField(f)] != null ==> h[h[o, AsPeerField(f)], $ownerRef] == h[o, $ownerRef] && h[h[o, AsPeerField(f)], $ownerFrame] == h[o, $ownerFrame]);

axiom (forall h: [ref,<x>name]x, o: ref :: { h[h[o, $ownerRef], $inv] <: h[o, $ownerFrame] } IsHeap(h) && h[o, $ownerFrame] != $PeerGroupPlaceholder && h[h[o, $ownerRef], $inv] <: h[o, $ownerFrame] && h[h[o, $ownerRef], $localinv] != $BaseClass(h[o, $ownerFrame]) ==> h[o, $inv] == $typeof(o) && h[o, $localinv] == $typeof(o));

procedure $SetOwner(o: ref, ow: ref, fr: name);
  modifies $Heap;
  ensures (forall p: ref, F: name :: { $Heap[p, F] } (F != $ownerRef && F != $ownerFrame) || old($Heap[p, $ownerRef] != $Heap[o, $ownerRef]) || old($Heap[p, $ownerFrame] != $Heap[o, $ownerFrame]) ==> old($Heap[p, F]) == $Heap[p, F]);
  ensures (forall p: ref :: { $Heap[p, $ownerRef] } { $Heap[p, $ownerFrame] } old($Heap[p, $ownerRef] == $Heap[o, $ownerRef]) && old($Heap[p, $ownerFrame] == $Heap[o, $ownerFrame]) ==> $Heap[p, $ownerRef] == ow && $Heap[p, $ownerFrame] == fr);



procedure $UpdateOwnersForRep(o: ref, T: name, e: ref);
  modifies $Heap;
  ensures (forall p: ref, F: name :: { $Heap[p, F] } (F != $ownerRef && F != $ownerFrame) || old($Heap[p, $ownerRef] != $Heap[e, $ownerRef]) || old($Heap[p, $ownerFrame] != $Heap[e, $ownerFrame]) ==> old($Heap[p, F]) == $Heap[p, F]);
  ensures e == null ==> $Heap == old($Heap);
  ensures e != null ==> (forall p: ref :: { $Heap[p, $ownerRef] } { $Heap[p, $ownerFrame] } old($Heap[p, $ownerRef] == $Heap[e, $ownerRef]) && old($Heap[p, $ownerFrame] == $Heap[e, $ownerFrame]) ==> $Heap[p, $ownerRef] == o && $Heap[p, $ownerFrame] == T);



procedure $UpdateOwnersForPeer(c: ref, d: ref);
  modifies $Heap;
  ensures (forall p: ref, F: name :: { $Heap[p, F] } (F != $ownerRef && F != $ownerFrame) || old(($Heap[p, $ownerRef] != $Heap[c, $ownerRef] || $Heap[p, $ownerFrame] != $Heap[c, $ownerFrame]) && ($Heap[p, $ownerRef] != $Heap[d, $ownerRef] || $Heap[p, $ownerFrame] != $Heap[d, $ownerFrame])) ==> old($Heap[p, F]) == $Heap[p, F]);
  ensures d == null ==> $Heap == old($Heap);
  ensures d != null ==> (forall p: ref :: { $Heap[p, $ownerRef] } { $Heap[p, $ownerFrame] } (old($Heap[p, $ownerRef] == $Heap[c, $ownerRef]) && old($Heap[p, $ownerFrame] == $Heap[c, $ownerFrame])) || (old($Heap[p, $ownerRef] == $Heap[d, $ownerRef]) && old($Heap[p, $ownerFrame] == $Heap[d, $ownerFrame])) ==> (old($Heap)[d, $ownerFrame] == $PeerGroupPlaceholder && $Heap[p, $ownerRef] == old($Heap)[c, $ownerRef] && $Heap[p, $ownerFrame] == old($Heap)[c, $ownerFrame]) || (old($Heap)[d, $ownerFrame] != $PeerGroupPlaceholder && $Heap[p, $ownerRef] == old($Heap)[d, $ownerRef] && $Heap[p, $ownerFrame] == old($Heap)[d, $ownerFrame]));



const $FirstConsistentOwner: <ref>name;

function $AsPureObject(ref) returns (ref);

function ##FieldDependsOnFCO(o: ref, f: name, ev: exposeVersionType) returns (value: any);

axiom (forall o: ref, f: name, h: [ref,<x>name]x :: { h[$AsPureObject(o), f] } IsHeap(h) && o != null && h[o, $allocated] == true && h[o, $ownerFrame] != $PeerGroupPlaceholder && h[h[o, $ownerRef], $inv] <: h[o, $ownerFrame] && h[h[o, $ownerRef], $localinv] != $BaseClass(h[o, $ownerFrame]) ==> h[o, f] == ##FieldDependsOnFCO(o, f, h[h[o, $FirstConsistentOwner], $exposeVersion]));

axiom (forall o: ref, h: [ref,<x>name]x :: { h[o, $FirstConsistentOwner] } IsHeap(h) && o != null && h[o, $allocated] == true && h[o, $ownerFrame] != $PeerGroupPlaceholder && h[h[o, $ownerRef], $inv] <: h[o, $ownerFrame] && h[h[o, $ownerRef], $localinv] != $BaseClass(h[o, $ownerFrame]) ==> h[o, $FirstConsistentOwner] != null && h[h[o, $FirstConsistentOwner], $allocated] == true && (h[h[o, $FirstConsistentOwner], $ownerFrame] == $PeerGroupPlaceholder || !(h[h[h[o, $FirstConsistentOwner], $ownerRef], $inv] <: h[h[o, $FirstConsistentOwner], $ownerFrame]) || h[h[h[o, $FirstConsistentOwner], $ownerRef], $localinv] == $BaseClass(h[h[o, $FirstConsistentOwner], $ownerFrame])));

function Box(any, ref) returns (ref);

function Unbox(ref) returns (any);

axiom (forall x: any, p: ref :: { Unbox(Box(x, p)) } Unbox(Box(x, p)) == x);

function UnboxedType(ref) returns (name);

axiom (forall p: ref :: { $IsValueType(UnboxedType(p)) } $IsValueType(UnboxedType(p)) ==> (forall heap: [ref,<x>name]x, x: any :: { heap[Box(x, p), $inv] } IsHeap(heap) ==> heap[Box(x, p), $inv] == $typeof(Box(x, p)) && heap[Box(x, p), $localinv] == $typeof(Box(x, p))));

axiom (forall x: any, p: ref :: { UnboxedType(Box(x, p)) <: System.Object } UnboxedType(Box(x, p)) <: System.Object && Box(x, p) == p ==> x == p);

function BoxTester(p: ref, typ: name) returns (ref);

axiom (forall p: ref, typ: name :: { BoxTester(p, typ) } UnboxedType(p) == typ <==> BoxTester(p, typ) != null);

const System.SByte: name;

axiom $IsValueType(System.SByte);

const System.Byte: name;

axiom $IsValueType(System.Byte);

const System.Int16: name;

axiom $IsValueType(System.Int16);

const System.UInt16: name;

axiom $IsValueType(System.UInt16);

const System.Int32: name;

axiom $IsValueType(System.Int32);

const System.UInt32: name;

axiom $IsValueType(System.UInt32);

const System.Int64: name;

axiom $IsValueType(System.Int64);

const System.UInt64: name;

axiom $IsValueType(System.UInt64);

const System.Char: name;

axiom $IsValueType(System.Char);

const int#m2147483648: int;

const int#2147483647: int;

const int#4294967295: int;

const int#m9223372036854775808: int;

const int#9223372036854775807: int;

const int#18446744073709551615: int;

axiom int#m9223372036854775808 < int#m2147483648;

axiom int#m2147483648 < 0 - 100000;

axiom 100000 < int#2147483647;

axiom int#2147483647 < int#4294967295;

axiom int#4294967295 < int#9223372036854775807;

axiom int#9223372036854775807 < int#18446744073709551615;

function InRange(i: int, T: name) returns (bool);

axiom (forall i: int :: InRange(i, System.SByte) <==> 0 - 128 <= i && i < 128);

axiom (forall i: int :: InRange(i, System.Byte) <==> 0 <= i && i < 256);

axiom (forall i: int :: InRange(i, System.Int16) <==> 0 - 32768 <= i && i < 32768);

axiom (forall i: int :: InRange(i, System.UInt16) <==> 0 <= i && i < 65536);

axiom (forall i: int :: InRange(i, System.Int32) <==> int#m2147483648 <= i && i <= int#2147483647);

axiom (forall i: int :: InRange(i, System.UInt32) <==> 0 <= i && i <= int#4294967295);

axiom (forall i: int :: InRange(i, System.Int64) <==> int#m9223372036854775808 <= i && i <= int#9223372036854775807);

axiom (forall i: int :: InRange(i, System.UInt64) <==> 0 <= i && i <= int#18446744073709551615);

axiom (forall i: int :: InRange(i, System.Char) <==> 0 <= i && i < 65536);

function $IntToInt(val: int, fromType: name, toType: name) returns (int);

function $IntToReal(int, fromType: name, toType: name) returns (real);

function $RealToInt(real, fromType: name, toType: name) returns (int);

function $RealToReal(val: real, fromType: name, toType: name) returns (real);

function $SizeIs(name, int) returns (bool);

function $IfThenElse(bool, any, any) returns (any);

axiom (forall b: bool, x: any, y: any :: { $IfThenElse(b, x, y) } b ==> $IfThenElse(b, x, y) == x);

axiom (forall b: bool, x: any, y: any :: { $IfThenElse(b, x, y) } !b ==> $IfThenElse(b, x, y) == y);

function #neg(int) returns (int);

function #and(int, int) returns (int);

function #or(int, int) returns (int);

function #xor(int, int) returns (int);

function #shl(int, int) returns (int);

function #shr(int, int) returns (int);

function #rneg(real) returns (real);

function #radd(real, real) returns (real);

function #rsub(real, real) returns (real);

function #rmul(real, real) returns (real);

function #rdiv(real, real) returns (real);

function #rmod(real, real) returns (real);

function #rLess(real, real) returns (bool);

function #rAtmost(real, real) returns (bool);

function #rEq(real, real) returns (bool);

function #rNeq(real, real) returns (bool);

function #rAtleast(real, real) returns (bool);

function #rGreater(real, real) returns (bool);

axiom (forall x: int, y: int :: { x % y } { x / y } x % y == x - x / y * y);

axiom (forall x: int, y: int :: { x % y } 0 <= x && 0 < y ==> 0 <= x % y && x % y < y);

axiom (forall x: int, y: int :: { x % y } 0 <= x && y < 0 ==> 0 <= x % y && x % y < 0 - y);

axiom (forall x: int, y: int :: { x % y } x <= 0 && 0 < y ==> 0 - y < x % y && x % y <= 0);

axiom (forall x: int, y: int :: { x % y } x <= 0 && y < 0 ==> y < x % y && x % y <= 0);

axiom (forall x: int, y: int :: { (x + y) % y } 0 <= x && 0 <= y ==> (x + y) % y == x % y);

axiom (forall x: int, y: int :: { (y + x) % y } 0 <= x && 0 <= y ==> (y + x) % y == x % y);

axiom (forall x: int, y: int :: { (x - y) % y } 0 <= x - y && 0 <= y ==> (x - y) % y == x % y);

axiom (forall a: int, b: int, d: int :: { a % d, b % d } 2 <= d && a % d == b % d && a < b ==> a + d <= b);

axiom (forall x: int, y: int :: { #and(x, y) } 0 <= x || 0 <= y ==> 0 <= #and(x, y));

axiom (forall x: int, y: int :: { #or(x, y) } 0 <= x && 0 <= y ==> 0 <= #or(x, y) && #or(x, y) <= x + y);

axiom (forall i: int :: { #shl(i, 0) } #shl(i, 0) == i);

axiom (forall i: int, j: int :: 0 <= j ==> #shl(i, j + 1) == #shl(i, j) * 2);

axiom (forall i: int :: { #shr(i, 0) } #shr(i, 0) == i);

axiom (forall i: int, j: int :: 0 <= j ==> #shr(i, j + 1) == #shr(i, j) / 2);

function #System.String.IsInterned$System.String$notnull(ref) returns (ref);

function #System.String.Equals$System.String(ref, ref) returns (bool);

function #System.String.Equals$System.String$System.String(ref, ref) returns (bool);

axiom (forall a: ref, b: ref :: { #System.String.Equals$System.String(a, b) } #System.String.Equals$System.String(a, b) == #System.String.Equals$System.String$System.String(a, b));

axiom (forall a: ref, b: ref :: { #System.String.Equals$System.String$System.String(a, b) } #System.String.Equals$System.String$System.String(a, b) == #System.String.Equals$System.String$System.String(b, a));

axiom (forall a: ref, b: ref :: { #System.String.Equals$System.String$System.String(a, b) } a != null && b != null && #System.String.Equals$System.String$System.String(a, b) ==> #System.String.IsInterned$System.String$notnull(a) == #System.String.IsInterned$System.String$notnull(b));

const $UnknownRef: ref;

const LoopInv0.Y: <int>name;

const Node.Next: <ref>name;

const LoopInv0.X: <int>name;

const Node.I: <int>name;

const System.Runtime.InteropServices._Type: name;

const System.Collections.IEnumerable: name;

const System.Runtime.InteropServices._MemberInfo: name;

const System.Reflection.MemberInfo: name;

const System.Reflection.IReflect: name;

const LoopInv0: name;

const System.Reflection.ICustomAttributeProvider: name;

const System.IComparable`1...System.String: name;

const System.IEquatable`1...System.String: name;

const System.IComparable: name;

const System.ICloneable: name;

const Node: name;

const System.IConvertible: name;

const System.Collections.Generic.IEnumerable`1...System.Char: name;

axiom !IsStaticField(Node.Next);

axiom IsDirectlyModifiableField(Node.Next);

axiom DeclType(Node.Next) == Node;

axiom AsRefField(Node.Next, Node) == Node.Next;

axiom !IsStaticField(Node.I);

axiom IsDirectlyModifiableField(Node.I);

axiom DeclType(Node.I) == Node;

axiom AsRangeField(Node.I, System.Int32) == Node.I;

axiom !IsStaticField(LoopInv0.Y);

axiom IsDirectlyModifiableField(LoopInv0.Y);

axiom DeclType(LoopInv0.Y) == LoopInv0;

axiom AsRangeField(LoopInv0.Y, System.Int32) == LoopInv0.Y;

axiom !IsStaticField(LoopInv0.X);

axiom IsDirectlyModifiableField(LoopInv0.X);

axiom DeclType(LoopInv0.X) == LoopInv0;

axiom AsRangeField(LoopInv0.X, System.Int32) == LoopInv0.X;

axiom Node <: Node;

axiom $BaseClass(Node) == System.Object;

axiom Node <: $BaseClass(Node) && AsDirectSubClass(Node, $BaseClass(Node)) == Node;

axiom !$IsImmutable(Node) && $AsMutable(Node) == Node;

procedure Node..ctor(this: ref);
  // nothing is owned by [this,*]
  free requires (forall $o: ref :: $o != this ==> $Heap[$o, $ownerRef] != this);
  // 'this' is alone in its own peer group
  free requires $Heap[this, $ownerRef] == this && $Heap[this, $ownerFrame] == $PeerGroupPlaceholder;
  free requires (forall $o: ref :: $Heap[$o, $ownerRef] == $Heap[this, $ownerRef] && $Heap[$o, $ownerFrame] == $Heap[this, $ownerFrame] ==> $o == this);
  free requires $BeingConstructed == this;
  modifies $Heap;
  ensures ($Heap[this, $ownerFrame] == $PeerGroupPlaceholder || !($Heap[$Heap[this, $ownerRef], $inv] <: $Heap[this, $ownerFrame]) || $Heap[$Heap[this, $ownerRef], $localinv] == $BaseClass($Heap[this, $ownerFrame])) && $Heap[this, $inv] == Node && $Heap[this, $localinv] == $typeof(this);
  ensures $Heap[this, $ownerRef] == old($Heap)[this, $ownerRef] && $Heap[this, $ownerFrame] == old($Heap)[this, $ownerFrame];
  ensures $Heap[this, $sharingMode] == $SharingMode_Unshared;
  // newly allocated objects are fully valid
  free ensures (forall $o: ref :: $o != null && old($Heap)[$o, $allocated] != true && $Heap[$o, $allocated] == true ==> $Heap[$o, $inv] == $typeof($o) && $Heap[$o, $localinv] == $typeof($o));
  // first consistent owner unchanged if its exposeVersion is
  free ensures (forall $o: ref :: { $Heap[$o, $FirstConsistentOwner] } old($Heap)[old($Heap)[$o, $FirstConsistentOwner], $exposeVersion] == $Heap[old($Heap)[$o, $FirstConsistentOwner], $exposeVersion] ==> old($Heap)[$o, $FirstConsistentOwner] == $Heap[$o, $FirstConsistentOwner]);
  // only captured parameters may change their owners
  ensures (forall $o: ref :: $o != null && old($Heap)[$o, $allocated] == true ==> old($Heap)[$o, $ownerRef] == $Heap[$o, $ownerRef] && old($Heap)[$o, $ownerFrame] == $Heap[$o, $ownerFrame]);
  // frame condition
  free ensures (forall $o: ref, $f: name :: { $Heap[$o, $f] } $f != $inv && $f != $localinv && $f != $FirstConsistentOwner && (!IsStaticField($f) || !IsDirectlyModifiableField($f)) && $o != null && old($Heap)[$o, $allocated] == true && (old($Heap)[$o, $ownerFrame] == $PeerGroupPlaceholder || !(old($Heap)[old($Heap)[$o, $ownerRef], $inv] <: old($Heap)[$o, $ownerFrame]) || old($Heap)[old($Heap)[$o, $ownerRef], $localinv] == $BaseClass(old($Heap)[$o, $ownerFrame])) && ($o != this || !(Node <: DeclType($f))) && old(true) ==> old($Heap)[$o, $f] == $Heap[$o, $f]);
  free ensures (forall $o: ref :: $o == this || (old($Heap)[$o, $inv] == $Heap[$o, $inv] && old($Heap)[$o, $localinv] == $Heap[$o, $localinv]) || old($Heap)[$o, $allocated] != true);
  free ensures (forall $o: ref :: old($Heap)[$o, $allocated] == true ==> $Heap[$o, $allocated] == true) && (forall $ot: ref :: old($Heap)[$ot, $allocated] == true && old($Heap)[$ot, $ownerFrame] != $PeerGroupPlaceholder ==> $Heap[$ot, $ownerRef] == old($Heap)[$ot, $ownerRef] && $Heap[$ot, $ownerFrame] == old($Heap)[$ot, $ownerFrame]) && old($Heap)[$BeingConstructed, $NonNullFieldsAreInitialized] == $Heap[$BeingConstructed, $NonNullFieldsAreInitialized];
  free ensures (forall $o: ref :: $o == this || old($Heap[$o, $sharingMode]) == $Heap[$o, $sharingMode]);



implementation Node..ctor(this: ref)
{

  entry:
    assume $IsNotNull(this, Node);
    assume $Heap[this, $allocated] == true;
    assume ($Heap[this, $ownerFrame] == $PeerGroupPlaceholder || !($Heap[$Heap[this, $ownerRef], $inv] <: $Heap[this, $ownerFrame]) || $Heap[$Heap[this, $ownerRef], $localinv] == $BaseClass($Heap[this, $ownerFrame])) && $Heap[this, $inv] == System.Object && $Heap[this, $localinv] == $typeof(this);
    assume $Heap[this, Node.Next] == null;
    assume $Heap[this, Node.I] == 0;
    goto block1207;

  block1207:
    goto block1224;

  block1224:
    // ----- call  ----- loopinv0.ssc(3,14)
    assert this != null;
    call System.Object..ctor(this);
    // ----- return
    assert this != null;
    assert $Heap[this, $inv] == System.Object && $Heap[this, $localinv] == $typeof(this);
    assert (forall $p: ref :: $p != null && $Heap[$p, $allocated] == true && $Heap[$p, $ownerRef] == this && $Heap[$p, $ownerFrame] == Node ==> $Heap[$p, $inv] == $typeof($p) && $Heap[$p, $localinv] == $typeof($p));
    $Heap[this, $inv] := Node;
    assume IsHeap($Heap);
    return;

}



procedure System.Object..ctor(this: ref);
  // nothing is owned by [this,*]
  free requires (forall $o: ref :: $o != this ==> $Heap[$o, $ownerRef] != this);
  // 'this' is alone in its own peer group
  free requires $Heap[this, $ownerRef] == this && $Heap[this, $ownerFrame] == $PeerGroupPlaceholder;
  free requires (forall $o: ref :: $Heap[$o, $ownerRef] == $Heap[this, $ownerRef] && $Heap[$o, $ownerFrame] == $Heap[this, $ownerFrame] ==> $o == this);
  free requires $BeingConstructed == this;
  modifies $Heap;
  ensures ($Heap[this, $ownerFrame] == $PeerGroupPlaceholder || !($Heap[$Heap[this, $ownerRef], $inv] <: $Heap[this, $ownerFrame]) || $Heap[$Heap[this, $ownerRef], $localinv] == $BaseClass($Heap[this, $ownerFrame])) && $Heap[this, $inv] == System.Object && $Heap[this, $localinv] == $typeof(this);
  ensures $Heap[this, $ownerRef] == old($Heap)[this, $ownerRef] && $Heap[this, $ownerFrame] == old($Heap)[this, $ownerFrame];
  ensures $Heap[this, $sharingMode] == $SharingMode_Unshared;
  // newly allocated objects are fully valid
  free ensures (forall $o: ref :: $o != null && old($Heap)[$o, $allocated] != true && $Heap[$o, $allocated] == true ==> $Heap[$o, $inv] == $typeof($o) && $Heap[$o, $localinv] == $typeof($o));
  // first consistent owner unchanged if its exposeVersion is
  free ensures (forall $o: ref :: { $Heap[$o, $FirstConsistentOwner] } old($Heap)[old($Heap)[$o, $FirstConsistentOwner], $exposeVersion] == $Heap[old($Heap)[$o, $FirstConsistentOwner], $exposeVersion] ==> old($Heap)[$o, $FirstConsistentOwner] == $Heap[$o, $FirstConsistentOwner]);
  // only captured parameters may change their owners
  ensures (forall $o: ref :: $o != null && old($Heap)[$o, $allocated] == true ==> old($Heap)[$o, $ownerRef] == $Heap[$o, $ownerRef] && old($Heap)[$o, $ownerFrame] == $Heap[$o, $ownerFrame]);
  // frame condition
  free ensures (forall $o: ref, $f: name :: { $Heap[$o, $f] } $f != $inv && $f != $localinv && $f != $FirstConsistentOwner && (!IsStaticField($f) || !IsDirectlyModifiableField($f)) && $o != null && old($Heap)[$o, $allocated] == true && (old($Heap)[$o, $ownerFrame] == $PeerGroupPlaceholder || !(old($Heap)[old($Heap)[$o, $ownerRef], $inv] <: old($Heap)[$o, $ownerFrame]) || old($Heap)[old($Heap)[$o, $ownerRef], $localinv] == $BaseClass(old($Heap)[$o, $ownerFrame])) && ($o != this || !(System.Object <: DeclType($f))) && old(true) ==> old($Heap)[$o, $f] == $Heap[$o, $f]);
  free ensures (forall $o: ref :: $o == this || (old($Heap)[$o, $inv] == $Heap[$o, $inv] && old($Heap)[$o, $localinv] == $Heap[$o, $localinv]) || old($Heap)[$o, $allocated] != true);
  free ensures (forall $o: ref :: old($Heap)[$o, $allocated] == true ==> $Heap[$o, $allocated] == true) && (forall $ot: ref :: old($Heap)[$ot, $allocated] == true && old($Heap)[$ot, $ownerFrame] != $PeerGroupPlaceholder ==> $Heap[$ot, $ownerRef] == old($Heap)[$ot, $ownerRef] && $Heap[$ot, $ownerFrame] == old($Heap)[$ot, $ownerFrame]) && old($Heap)[$BeingConstructed, $NonNullFieldsAreInitialized] == $Heap[$BeingConstructed, $NonNullFieldsAreInitialized];
  free ensures (forall $o: ref :: $o == this || old($Heap[$o, $sharingMode]) == $Heap[$o, $sharingMode]);



axiom LoopInv0 <: LoopInv0;

axiom $BaseClass(LoopInv0) == System.Object;

axiom LoopInv0 <: $BaseClass(LoopInv0) && AsDirectSubClass(LoopInv0, $BaseClass(LoopInv0)) == LoopInv0;

axiom !$IsImmutable(LoopInv0) && $AsMutable(LoopInv0) == LoopInv0;

axiom (forall $U: name :: { $U <: LoopInv0 } $U <: LoopInv0 ==> $U == LoopInv0);

procedure LoopInv0.N(this: ref);
  requires ($Heap[this, $ownerFrame] == $PeerGroupPlaceholder || !($Heap[$Heap[this, $ownerRef], $inv] <: $Heap[this, $ownerFrame]) || $Heap[$Heap[this, $ownerRef], $localinv] == $BaseClass($Heap[this, $ownerFrame])) && (forall $pc: ref :: $pc != null && $Heap[$pc, $allocated] == true && $Heap[$pc, $ownerRef] == $Heap[this, $ownerRef] && $Heap[$pc, $ownerFrame] == $Heap[this, $ownerFrame] ==> $Heap[$pc, $inv] == $typeof($pc) && $Heap[$pc, $localinv] == $typeof($pc));
  free requires $BeingConstructed == null;
  modifies $Heap;
  // newly allocated objects are fully valid
  free ensures (forall $o: ref :: $o != null && old($Heap)[$o, $allocated] != true && $Heap[$o, $allocated] == true ==> $Heap[$o, $inv] == $typeof($o) && $Heap[$o, $localinv] == $typeof($o));
  // first consistent owner unchanged if its exposeVersion is
  free ensures (forall $o: ref :: { $Heap[$o, $FirstConsistentOwner] } old($Heap)[old($Heap)[$o, $FirstConsistentOwner], $exposeVersion] == $Heap[old($Heap)[$o, $FirstConsistentOwner], $exposeVersion] ==> old($Heap)[$o, $FirstConsistentOwner] == $Heap[$o, $FirstConsistentOwner]);
  // only captured parameters may change their owners
  ensures (forall $o: ref :: $o != null && old($Heap)[$o, $allocated] == true ==> old($Heap)[$o, $ownerRef] == $Heap[$o, $ownerRef] && old($Heap)[$o, $ownerFrame] == $Heap[$o, $ownerFrame]);
  // frame condition
  free ensures (forall $o: ref, $f: name :: { $Heap[$o, $f] } $f != $inv && $f != $localinv && $f != $FirstConsistentOwner && (!IsStaticField($f) || !IsDirectlyModifiableField($f)) && $o != null && old($Heap)[$o, $allocated] == true && (old($Heap)[$o, $ownerFrame] == $PeerGroupPlaceholder || !(old($Heap)[old($Heap)[$o, $ownerRef], $inv] <: old($Heap)[$o, $ownerFrame]) || old($Heap)[old($Heap)[$o, $ownerRef], $localinv] == $BaseClass(old($Heap)[$o, $ownerFrame])) && old($o != this || $f != LoopInv0.Y) && old($o != this || $f != $exposeVersion) ==> old($Heap)[$o, $f] == $Heap[$o, $f]);
  free ensures (forall $o: ref :: (old($Heap)[$o, $inv] == $Heap[$o, $inv] && old($Heap)[$o, $localinv] == $Heap[$o, $localinv]) || old($Heap)[$o, $allocated] != true);
  free ensures (forall $o: ref :: old($Heap)[$o, $allocated] == true ==> $Heap[$o, $allocated] == true) && (forall $ot: ref :: old($Heap)[$ot, $allocated] == true && old($Heap)[$ot, $ownerFrame] != $PeerGroupPlaceholder ==> $Heap[$ot, $ownerRef] == old($Heap)[$ot, $ownerRef] && $Heap[$ot, $ownerFrame] == old($Heap)[$ot, $ownerFrame]) && old($Heap)[$BeingConstructed, $NonNullFieldsAreInitialized] == $Heap[$BeingConstructed, $NonNullFieldsAreInitialized];
  free ensures (forall $o: ref :: old($Heap[$o, $sharingMode]) == $Heap[$o, $sharingMode]);



implementation LoopInv0.N(this: ref)
{
  var local0: ref where $Is(local0, LoopInv0), stack0o: ref, stack1s: struct, stack1o: ref, temp0: exposeVersionType, stack0i: int, temp1: exposeVersionType;

  entry:
    assume $IsNotNull(this, LoopInv0);
    assume $Heap[this, $allocated] == true;
    goto block1734;

  block1734:
    goto block1802;

  block1802:
    // ----- copy  ----- loopinv0.ssc(13,13)
    local0 := this;
    // ----- copy  ----- loopinv0.ssc(13,13)
    stack0o := local0;
    // ----- load token  ----- loopinv0.ssc(13,13)
    havoc stack1s;
    assume $IsTokenForType(stack1s, LoopInv0);
    // ----- statically resolved GetTypeFromHandle call  ----- loopinv0.ssc(13,13)
    stack1o := TypeObject(LoopInv0);
    // ----- local unpack  ----- loopinv0.ssc(13,13)
    assert stack0o != null;
    assert ($Heap[stack0o, $ownerFrame] == $PeerGroupPlaceholder || !($Heap[$Heap[stack0o, $ownerRef], $inv] <: $Heap[stack0o, $ownerFrame]) || $Heap[$Heap[stack0o, $ownerRef], $localinv] == $BaseClass($Heap[stack0o, $ownerFrame])) && $Heap[stack0o, $inv] <: LoopInv0 && $Heap[stack0o, $localinv] == $typeof(stack0o);
    $Heap[stack0o, $localinv] := System.Object;
    havoc temp0;
    $Heap[stack0o, $exposeVersion] := temp0;
    assume IsHeap($Heap);
    goto block1819;

  block1819:
    // ----- load constant 0  ----- loopinv0.ssc(13,21)
    stack0i := 0;
    // ----- store field  ----- loopinv0.ssc(13,21)
    assert this != null;
    havoc temp1;
    $Heap[this, $exposeVersion] := temp1;
    $Heap[this, LoopInv0.Y] := stack0i;
    assume IsHeap($Heap);
    // ----- branch
    goto block1870;

  block1870:
    // ----- copy  ----- loopinv0.ssc(13,33)
    stack0o := local0;
    // ----- load token  ----- loopinv0.ssc(13,33)
    havoc stack1s;
    assume $IsTokenForType(stack1s, LoopInv0);
    // ----- statically resolved GetTypeFromHandle call  ----- loopinv0.ssc(13,33)
    stack1o := TypeObject(LoopInv0);
    // ----- local pack  ----- loopinv0.ssc(13,33)
    assert stack0o != null;
    assert $Heap[stack0o, $localinv] == System.Object;
    assert (forall $p: ref :: $p != null && $Heap[$p, $allocated] == true && $Heap[$p, $ownerRef] == stack0o && $Heap[$p, $ownerFrame] == LoopInv0 ==> $Heap[$p, $inv] == $typeof($p) && $Heap[$p, $localinv] == $typeof($p));
    $Heap[stack0o, $localinv] := $typeof(stack0o);
    assume IsHeap($Heap);
    // ----- nop
    // ----- branch
    goto block1836;

  block1836:
    // ----- return  ----- loopinv0.ssc(14,3)
    return;

}



axiom System.Type <: System.Type;

axiom System.Reflection.MemberInfo <: System.Reflection.MemberInfo;

axiom $BaseClass(System.Reflection.MemberInfo) == System.Object;

axiom System.Reflection.MemberInfo <: $BaseClass(System.Reflection.MemberInfo) && AsDirectSubClass(System.Reflection.MemberInfo, $BaseClass(System.Reflection.MemberInfo)) == System.Reflection.MemberInfo;

axiom $IsImmutable(System.Reflection.MemberInfo) && $AsImmutable(System.Reflection.MemberInfo) == System.Reflection.MemberInfo;

axiom System.Reflection.ICustomAttributeProvider <: System.Object;

axiom $IsMemberlessType(System.Reflection.ICustomAttributeProvider);

axiom System.Reflection.MemberInfo <: System.Reflection.ICustomAttributeProvider;

axiom System.Runtime.InteropServices._MemberInfo <: System.Object;

axiom $IsMemberlessType(System.Runtime.InteropServices._MemberInfo);

axiom System.Reflection.MemberInfo <: System.Runtime.InteropServices._MemberInfo;

axiom $IsMemberlessType(System.Reflection.MemberInfo);

axiom $BaseClass(System.Type) == System.Reflection.MemberInfo;

axiom System.Type <: $BaseClass(System.Type) && AsDirectSubClass(System.Type, $BaseClass(System.Type)) == System.Type;

axiom $IsImmutable(System.Type) && $AsImmutable(System.Type) == System.Type;

axiom System.Runtime.InteropServices._Type <: System.Object;

axiom $IsMemberlessType(System.Runtime.InteropServices._Type);

axiom System.Type <: System.Runtime.InteropServices._Type;

axiom System.Reflection.IReflect <: System.Object;

axiom $IsMemberlessType(System.Reflection.IReflect);

axiom System.Type <: System.Reflection.IReflect;

axiom $IsMemberlessType(System.Type);

procedure LoopInv0.Method0(this: ref);
  requires ($Heap[this, $ownerFrame] == $PeerGroupPlaceholder || !($Heap[$Heap[this, $ownerRef], $inv] <: $Heap[this, $ownerFrame]) || $Heap[$Heap[this, $ownerRef], $localinv] == $BaseClass($Heap[this, $ownerFrame])) && (forall $pc: ref :: $pc != null && $Heap[$pc, $allocated] == true && $Heap[$pc, $ownerRef] == $Heap[this, $ownerRef] && $Heap[$pc, $ownerFrame] == $Heap[this, $ownerFrame] ==> $Heap[$pc, $inv] == $typeof($pc) && $Heap[$pc, $localinv] == $typeof($pc));
  free requires $BeingConstructed == null;
  modifies $Heap;
  // newly allocated objects are fully valid
  free ensures (forall $o: ref :: $o != null && old($Heap)[$o, $allocated] != true && $Heap[$o, $allocated] == true ==> $Heap[$o, $inv] == $typeof($o) && $Heap[$o, $localinv] == $typeof($o));
  // first consistent owner unchanged if its exposeVersion is
  free ensures (forall $o: ref :: { $Heap[$o, $FirstConsistentOwner] } old($Heap)[old($Heap)[$o, $FirstConsistentOwner], $exposeVersion] == $Heap[old($Heap)[$o, $FirstConsistentOwner], $exposeVersion] ==> old($Heap)[$o, $FirstConsistentOwner] == $Heap[$o, $FirstConsistentOwner]);
  // only captured parameters may change their owners
  ensures (forall $o: ref :: $o != null && old($Heap)[$o, $allocated] == true ==> old($Heap)[$o, $ownerRef] == $Heap[$o, $ownerRef] && old($Heap)[$o, $ownerFrame] == $Heap[$o, $ownerFrame]);
  // frame condition
  free ensures (forall $o: ref, $f: name :: { $Heap[$o, $f] } $f != $inv && $f != $localinv && $f != $FirstConsistentOwner && (!IsStaticField($f) || !IsDirectlyModifiableField($f)) && $o != null && old($Heap)[$o, $allocated] == true && (old($Heap)[$o, $ownerFrame] == $PeerGroupPlaceholder || !(old($Heap)[old($Heap)[$o, $ownerRef], $inv] <: old($Heap)[$o, $ownerFrame]) || old($Heap)[old($Heap)[$o, $ownerRef], $localinv] == $BaseClass(old($Heap)[$o, $ownerFrame])) && old($o != this || !(LoopInv0 <: DeclType($f))) && old($o != this || $f != $exposeVersion) ==> old($Heap)[$o, $f] == $Heap[$o, $f]);
  free ensures (forall $o: ref :: (old($Heap)[$o, $inv] == $Heap[$o, $inv] && old($Heap)[$o, $localinv] == $Heap[$o, $localinv]) || old($Heap)[$o, $allocated] != true);
  free ensures (forall $o: ref :: old($Heap)[$o, $allocated] == true ==> $Heap[$o, $allocated] == true) && (forall $ot: ref :: old($Heap)[$ot, $allocated] == true && old($Heap)[$ot, $ownerFrame] != $PeerGroupPlaceholder ==> $Heap[$ot, $ownerRef] == old($Heap)[$ot, $ownerRef] && $Heap[$ot, $ownerFrame] == old($Heap)[$ot, $ownerFrame]) && old($Heap)[$BeingConstructed, $NonNullFieldsAreInitialized] == $Heap[$BeingConstructed, $NonNullFieldsAreInitialized];
  free ensures (forall $o: ref :: old($Heap[$o, $sharingMode]) == $Heap[$o, $sharingMode]);



implementation LoopInv0.Method0(this: ref)
{
  var local0: ref where $Is(local0, LoopInv0), stack0o: ref, stack1s: struct, stack1o: ref, temp0: exposeVersionType, stack0i: int, temp1: exposeVersionType, i: int where InRange(i, System.Int32), stack0b: bool, local3: ref where $Is(local3, LoopInv0), temp2: exposeVersionType, temp3: exposeVersionType, local4: int where InRange(local4, System.Int32), $Heap$block2737$LoopPreheader: [ref,<x>name]x;

  entry:
    assume $IsNotNull(this, LoopInv0);
    assume $Heap[this, $allocated] == true;
    goto block2618;

  block2618:
    goto block2686;

  block2686:
    // ----- copy  ----- loopinv0.ssc(17,13)
    local0 := this;
    // ----- copy  ----- loopinv0.ssc(17,13)
    stack0o := local0;
    // ----- load token  ----- loopinv0.ssc(17,13)
    havoc stack1s;
    assume $IsTokenForType(stack1s, LoopInv0);
    // ----- statically resolved GetTypeFromHandle call  ----- loopinv0.ssc(17,13)
    stack1o := TypeObject(LoopInv0);
    // ----- local unpack  ----- loopinv0.ssc(17,13)
    assert stack0o != null;
    assert ($Heap[stack0o, $ownerFrame] == $PeerGroupPlaceholder || !($Heap[$Heap[stack0o, $ownerRef], $inv] <: $Heap[stack0o, $ownerFrame]) || $Heap[$Heap[stack0o, $ownerRef], $localinv] == $BaseClass($Heap[stack0o, $ownerFrame])) && $Heap[stack0o, $inv] <: LoopInv0 && $Heap[stack0o, $localinv] == $typeof(stack0o);
    $Heap[stack0o, $localinv] := System.Object;
    havoc temp0;
    $Heap[stack0o, $exposeVersion] := temp0;
    assume IsHeap($Heap);
    goto block2703;

  block2703:
    // ----- load constant 5  ----- loopinv0.ssc(17,21)
    stack0i := 5;
    // ----- store field  ----- loopinv0.ssc(17,21)
    assert this != null;
    havoc temp1;
    $Heap[this, $exposeVersion] := temp1;
    $Heap[this, LoopInv0.X] := stack0i;
    assume IsHeap($Heap);
    // ----- branch
    goto block3009;

  block3009:
    // ----- copy  ----- loopinv0.ssc(17,33)
    stack0o := local0;
    // ----- load token  ----- loopinv0.ssc(17,33)
    havoc stack1s;
    assume $IsTokenForType(stack1s, LoopInv0);
    // ----- statically resolved GetTypeFromHandle call  ----- loopinv0.ssc(17,33)
    stack1o := TypeObject(LoopInv0);
    // ----- local pack  ----- loopinv0.ssc(17,33)
    assert stack0o != null;
    assert $Heap[stack0o, $localinv] == System.Object;
    assert (forall $p: ref :: $p != null && $Heap[$p, $allocated] == true && $Heap[$p, $ownerRef] == stack0o && $Heap[$p, $ownerFrame] == LoopInv0 ==> $Heap[$p, $inv] == $typeof($p) && $Heap[$p, $localinv] == $typeof($p));
    $Heap[stack0o, $localinv] := $typeof(stack0o);
    assume IsHeap($Heap);
    // ----- nop
    // ----- branch
    goto block2720;

  block2720:
    // ----- load constant 0  ----- loopinv0.ssc(18,10)
    i := 0;
    goto block2737$LoopPreheader;

  block2737:
    // ----- default loop invariant: allocation and ownership are stable  ----- loopinv0.ssc(19,22)
    assume (forall $o: ref :: $Heap$block2737$LoopPreheader[$o, $allocated] == true ==> $Heap[$o, $allocated] == true) && (forall $ot: ref :: $Heap$block2737$LoopPreheader[$ot, $allocated] == true && $Heap$block2737$LoopPreheader[$ot, $ownerFrame] != $PeerGroupPlaceholder ==> $Heap[$ot, $ownerRef] == $Heap$block2737$LoopPreheader[$ot, $ownerRef] && $Heap[$ot, $ownerFrame] == $Heap$block2737$LoopPreheader[$ot, $ownerFrame]) && $Heap$block2737$LoopPreheader[$BeingConstructed, $NonNullFieldsAreInitialized] == $Heap[$BeingConstructed, $NonNullFieldsAreInitialized];
    // ----- default loop invariant: $inv field  ----- loopinv0.ssc(19,22)
    assume (forall $o: ref :: ($Heap$block2737$LoopPreheader[$o, $inv] == $Heap[$o, $inv] && $Heap$block2737$LoopPreheader[$o, $localinv] == $Heap[$o, $localinv]) || $Heap$block2737$LoopPreheader[$o, $allocated] != true);
    assume (forall $o: ref :: $Heap$block2737$LoopPreheader[$o, $allocated] != true && $Heap[$o, $allocated] == true ==> $Heap[$o, $inv] == $typeof($o) && $Heap[$o, $localinv] == $typeof($o));
    // ----- default loop invariant: $ownerRef and $ownerFrame fields  ----- loopinv0.ssc(19,22)
    assert (forall $o: ref :: $o != null && $Heap$block2737$LoopPreheader[$o, $allocated] == true ==> $Heap$block2737$LoopPreheader[$o, $ownerRef] == $Heap[$o, $ownerRef] && $Heap$block2737$LoopPreheader[$o, $ownerFrame] == $Heap[$o, $ownerFrame]);
    // ----- serialized LoopInvariant  ----- loopinv0.ssc(19,22)
    assert ($Heap[this, $ownerFrame] == $PeerGroupPlaceholder || !($Heap[$Heap[this, $ownerRef], $inv] <: $Heap[this, $ownerFrame]) || $Heap[$Heap[this, $ownerRef], $localinv] == $BaseClass($Heap[this, $ownerFrame])) && $Heap[this, $inv] == LoopInv0 && $Heap[this, $localinv] == $typeof(this);
    goto block2822;

  block2822:
    // ----- nop
    // ----- load constant 10  ----- loopinv0.ssc(18,21)
    stack0i := 10;
    // ----- binary operator  ----- loopinv0.ssc(18,21)
    // ----- branch  ----- loopinv0.ssc(18,21)
    goto true2822to2890, false2822to2839;

  true2822to2890:
    assume i >= stack0i;
    goto block2890;

  false2822to2839:
    assume i < stack0i;
    goto block2839;

  block2890:
    // ----- serialized AssertStatement  ----- loopinv0.ssc(24,5)
    assert $Heap[this, LoopInv0.X] == 5;
    goto block2975;

  block2839:
    // ----- copy  ----- loopinv0.ssc(22,15)
    local3 := this;
    // ----- copy  ----- loopinv0.ssc(22,15)
    stack0o := local3;
    // ----- load token  ----- loopinv0.ssc(22,15)
    havoc stack1s;
    assume $IsTokenForType(stack1s, LoopInv0);
    // ----- statically resolved GetTypeFromHandle call  ----- loopinv0.ssc(22,15)
    stack1o := TypeObject(LoopInv0);
    // ----- local unpack  ----- loopinv0.ssc(22,15)
    assert stack0o != null;
    assert ($Heap[stack0o, $ownerFrame] == $PeerGroupPlaceholder || !($Heap[$Heap[stack0o, $ownerRef], $inv] <: $Heap[stack0o, $ownerFrame]) || $Heap[$Heap[stack0o, $ownerRef], $localinv] == $BaseClass($Heap[stack0o, $ownerFrame])) && $Heap[stack0o, $inv] <: LoopInv0 && $Heap[stack0o, $localinv] == $typeof(stack0o);
    $Heap[stack0o, $localinv] := System.Object;
    havoc temp2;
    $Heap[stack0o, $exposeVersion] := temp2;
    assume IsHeap($Heap);
    goto block2856;

  block2975:
    // ----- nop
    // ----- return  ----- loopinv0.ssc(25,3)
    return;

  block2856:
    // ----- store field  ----- loopinv0.ssc(22,23)
    assert this != null;
    havoc temp3;
    $Heap[this, $exposeVersion] := temp3;
    $Heap[this, LoopInv0.Y] := i;
    assume IsHeap($Heap);
    // ----- branch
    goto block3026;

  block3026:
    // ----- copy  ----- loopinv0.ssc(22,35)
    stack0o := local3;
    // ----- load token  ----- loopinv0.ssc(22,35)
    havoc stack1s;
    assume $IsTokenForType(stack1s, LoopInv0);
    // ----- statically resolved GetTypeFromHandle call  ----- loopinv0.ssc(22,35)
    stack1o := TypeObject(LoopInv0);
    // ----- local pack  ----- loopinv0.ssc(22,35)
    assert stack0o != null;
    assert $Heap[stack0o, $localinv] == System.Object;
    assert (forall $p: ref :: $p != null && $Heap[$p, $allocated] == true && $Heap[$p, $ownerRef] == stack0o && $Heap[$p, $ownerFrame] == LoopInv0 ==> $Heap[$p, $inv] == $typeof($p) && $Heap[$p, $localinv] == $typeof($p));
    $Heap[stack0o, $localinv] := $typeof(stack0o);
    assume IsHeap($Heap);
    // ----- nop
    // ----- branch
    goto block2873;

  block2873:
    // ----- copy  ----- loopinv0.ssc(18,29)
    local4 := i;
    // ----- load constant 1  ----- loopinv0.ssc(18,29)
    stack0i := 1;
    // ----- binary operator  ----- loopinv0.ssc(18,29)
    stack0i := local4 + stack0i;
    // ----- copy  ----- loopinv0.ssc(18,29)
    i := stack0i;
    // ----- copy
    stack0i := local4;
    // ----- branch
    goto block2737;

  block2737$LoopPreheader:
    $Heap$block2737$LoopPreheader := $Heap;
    goto block2737;

}



axiom System.String <: System.String;

axiom $BaseClass(System.String) == System.Object;

axiom System.String <: $BaseClass(System.String) && AsDirectSubClass(System.String, $BaseClass(System.String)) == System.String;

axiom $IsImmutable(System.String) && $AsImmutable(System.String) == System.String;

axiom System.IComparable <: System.Object;

axiom $IsMemberlessType(System.IComparable);

axiom System.String <: System.IComparable;

axiom System.ICloneable <: System.Object;

axiom $IsMemberlessType(System.ICloneable);

axiom System.String <: System.ICloneable;

axiom System.IConvertible <: System.Object;

axiom $IsMemberlessType(System.IConvertible);

axiom System.String <: System.IConvertible;

axiom System.IComparable`1...System.String <: System.Object;

axiom $IsMemberlessType(System.IComparable`1...System.String);

axiom System.String <: System.IComparable`1...System.String;

axiom System.Collections.Generic.IEnumerable`1...System.Char <: System.Object;

axiom System.Collections.IEnumerable <: System.Object;

axiom $IsMemberlessType(System.Collections.IEnumerable);

axiom System.Collections.Generic.IEnumerable`1...System.Char <: System.Collections.IEnumerable;

axiom $IsMemberlessType(System.Collections.Generic.IEnumerable`1...System.Char);

axiom System.String <: System.Collections.Generic.IEnumerable`1...System.Char;

axiom System.String <: System.Collections.IEnumerable;

axiom System.IEquatable`1...System.String <: System.Object;

axiom $IsMemberlessType(System.IEquatable`1...System.String);

axiom System.String <: System.IEquatable`1...System.String;

axiom (forall $U: name :: { $U <: System.String } $U <: System.String ==> $U == System.String);

procedure LoopInv0.Method1(this: ref);
  requires ($Heap[this, $ownerFrame] == $PeerGroupPlaceholder || !($Heap[$Heap[this, $ownerRef], $inv] <: $Heap[this, $ownerFrame]) || $Heap[$Heap[this, $ownerRef], $localinv] == $BaseClass($Heap[this, $ownerFrame])) && (forall $pc: ref :: $pc != null && $Heap[$pc, $allocated] == true && $Heap[$pc, $ownerRef] == $Heap[this, $ownerRef] && $Heap[$pc, $ownerFrame] == $Heap[this, $ownerFrame] ==> $Heap[$pc, $inv] == $typeof($pc) && $Heap[$pc, $localinv] == $typeof($pc));
  free requires $BeingConstructed == null;
  modifies $Heap;
  // newly allocated objects are fully valid
  free ensures (forall $o: ref :: $o != null && old($Heap)[$o, $allocated] != true && $Heap[$o, $allocated] == true ==> $Heap[$o, $inv] == $typeof($o) && $Heap[$o, $localinv] == $typeof($o));
  // first consistent owner unchanged if its exposeVersion is
  free ensures (forall $o: ref :: { $Heap[$o, $FirstConsistentOwner] } old($Heap)[old($Heap)[$o, $FirstConsistentOwner], $exposeVersion] == $Heap[old($Heap)[$o, $FirstConsistentOwner], $exposeVersion] ==> old($Heap)[$o, $FirstConsistentOwner] == $Heap[$o, $FirstConsistentOwner]);
  // only captured parameters may change their owners
  ensures (forall $o: ref :: $o != null && old($Heap)[$o, $allocated] == true ==> old($Heap)[$o, $ownerRef] == $Heap[$o, $ownerRef] && old($Heap)[$o, $ownerFrame] == $Heap[$o, $ownerFrame]);
  // frame condition
  free ensures (forall $o: ref, $f: name :: { $Heap[$o, $f] } $f != $inv && $f != $localinv && $f != $FirstConsistentOwner && (!IsStaticField($f) || !IsDirectlyModifiableField($f)) && $o != null && old($Heap)[$o, $allocated] == true && (old($Heap)[$o, $ownerFrame] == $PeerGroupPlaceholder || !(old($Heap)[old($Heap)[$o, $ownerRef], $inv] <: old($Heap)[$o, $ownerFrame]) || old($Heap)[old($Heap)[$o, $ownerRef], $localinv] == $BaseClass(old($Heap)[$o, $ownerFrame])) && old($o != this || !(LoopInv0 <: DeclType($f))) && old($o != this || $f != $exposeVersion) ==> old($Heap)[$o, $f] == $Heap[$o, $f]);
  free ensures (forall $o: ref :: (old($Heap)[$o, $inv] == $Heap[$o, $inv] && old($Heap)[$o, $localinv] == $Heap[$o, $localinv]) || old($Heap)[$o, $allocated] != true);
  free ensures (forall $o: ref :: old($Heap)[$o, $allocated] == true ==> $Heap[$o, $allocated] == true) && (forall $ot: ref :: old($Heap)[$ot, $allocated] == true && old($Heap)[$ot, $ownerFrame] != $PeerGroupPlaceholder ==> $Heap[$ot, $ownerRef] == old($Heap)[$ot, $ownerRef] && $Heap[$ot, $ownerFrame] == old($Heap)[$ot, $ownerFrame]) && old($Heap)[$BeingConstructed, $NonNullFieldsAreInitialized] == $Heap[$BeingConstructed, $NonNullFieldsAreInitialized];
  free ensures (forall $o: ref :: old($Heap[$o, $sharingMode]) == $Heap[$o, $sharingMode]);



implementation LoopInv0.Method1(this: ref)
{
  var local0: ref where $Is(local0, LoopInv0), stack0o: ref, stack1s: struct, stack1o: ref, temp0: exposeVersionType, stack0i: int, temp1: exposeVersionType, i: int where InRange(i, System.Int32), stack0b: bool, local2: int where InRange(local2, System.Int32), $Heap$block4352$LoopPreheader: [ref,<x>name]x;

  entry:
    assume $IsNotNull(this, LoopInv0);
    assume $Heap[this, $allocated] == true;
    goto block4233;

  block4233:
    goto block4301;

  block4301:
    // ----- copy  ----- loopinv0.ssc(28,13)
    local0 := this;
    // ----- copy  ----- loopinv0.ssc(28,13)
    stack0o := local0;
    // ----- load token  ----- loopinv0.ssc(28,13)
    havoc stack1s;
    assume $IsTokenForType(stack1s, LoopInv0);
    // ----- statically resolved GetTypeFromHandle call  ----- loopinv0.ssc(28,13)
    stack1o := TypeObject(LoopInv0);
    // ----- local unpack  ----- loopinv0.ssc(28,13)
    assert stack0o != null;
    assert ($Heap[stack0o, $ownerFrame] == $PeerGroupPlaceholder || !($Heap[$Heap[stack0o, $ownerRef], $inv] <: $Heap[stack0o, $ownerFrame]) || $Heap[$Heap[stack0o, $ownerRef], $localinv] == $BaseClass($Heap[stack0o, $ownerFrame])) && $Heap[stack0o, $inv] <: LoopInv0 && $Heap[stack0o, $localinv] == $typeof(stack0o);
    $Heap[stack0o, $localinv] := System.Object;
    havoc temp0;
    $Heap[stack0o, $exposeVersion] := temp0;
    assume IsHeap($Heap);
    goto block4318;

  block4318:
    // ----- load constant 5  ----- loopinv0.ssc(28,21)
    stack0i := 5;
    // ----- store field  ----- loopinv0.ssc(28,21)
    assert this != null;
    havoc temp1;
    $Heap[this, $exposeVersion] := temp1;
    $Heap[this, LoopInv0.X] := stack0i;
    assume IsHeap($Heap);
    // ----- branch
    goto block4505;

  block4505:
    // ----- copy  ----- loopinv0.ssc(28,33)
    stack0o := local0;
    // ----- load token  ----- loopinv0.ssc(28,33)
    havoc stack1s;
    assume $IsTokenForType(stack1s, LoopInv0);
    // ----- statically resolved GetTypeFromHandle call  ----- loopinv0.ssc(28,33)
    stack1o := TypeObject(LoopInv0);
    // ----- local pack  ----- loopinv0.ssc(28,33)
    assert stack0o != null;
    assert $Heap[stack0o, $localinv] == System.Object;
    assert (forall $p: ref :: $p != null && $Heap[$p, $allocated] == true && $Heap[$p, $ownerRef] == stack0o && $Heap[$p, $ownerFrame] == LoopInv0 ==> $Heap[$p, $inv] == $typeof($p) && $Heap[$p, $localinv] == $typeof($p));
    $Heap[stack0o, $localinv] := $typeof(stack0o);
    assume IsHeap($Heap);
    // ----- nop
    // ----- branch
    goto block4335;

  block4335:
    // ----- load constant 0  ----- loopinv0.ssc(29,10)
    i := 0;
    goto block4352$LoopPreheader;

  block4352:
    // ----- default loop invariant: allocation and ownership are stable  ----- loopinv0.ssc(29,21)
    assume (forall $o: ref :: $Heap$block4352$LoopPreheader[$o, $allocated] == true ==> $Heap[$o, $allocated] == true) && (forall $ot: ref :: $Heap$block4352$LoopPreheader[$ot, $allocated] == true && $Heap$block4352$LoopPreheader[$ot, $ownerFrame] != $PeerGroupPlaceholder ==> $Heap[$ot, $ownerRef] == $Heap$block4352$LoopPreheader[$ot, $ownerRef] && $Heap[$ot, $ownerFrame] == $Heap$block4352$LoopPreheader[$ot, $ownerFrame]) && $Heap$block4352$LoopPreheader[$BeingConstructed, $NonNullFieldsAreInitialized] == $Heap[$BeingConstructed, $NonNullFieldsAreInitialized];
    // ----- default loop invariant: $inv field  ----- loopinv0.ssc(29,21)
    assume (forall $o: ref :: ($Heap$block4352$LoopPreheader[$o, $inv] == $Heap[$o, $inv] && $Heap$block4352$LoopPreheader[$o, $localinv] == $Heap[$o, $localinv]) || $Heap$block4352$LoopPreheader[$o, $allocated] != true);
    assume (forall $o: ref :: $Heap$block4352$LoopPreheader[$o, $allocated] != true && $Heap[$o, $allocated] == true ==> $Heap[$o, $inv] == $typeof($o) && $Heap[$o, $localinv] == $typeof($o));
    // ----- default loop invariant: $ownerRef and $ownerFrame fields  ----- loopinv0.ssc(29,21)
    assert (forall $o: ref :: $o != null && $Heap$block4352$LoopPreheader[$o, $allocated] == true ==> $Heap$block4352$LoopPreheader[$o, $ownerRef] == $Heap[$o, $ownerRef] && $Heap$block4352$LoopPreheader[$o, $ownerFrame] == $Heap[$o, $ownerFrame]);
    // ----- load constant 10  ----- loopinv0.ssc(29,21)
    stack0i := 10;
    // ----- binary operator  ----- loopinv0.ssc(29,21)
    // ----- branch  ----- loopinv0.ssc(29,21)
    goto true4352to4386, false4352to4369;

  true4352to4386:
    assume i >= stack0i;
    goto block4386;

  false4352to4369:
    assume i < stack0i;
    goto block4369;

  block4386:
    // ----- serialized AssertStatement  ----- loopinv0.ssc(33,5)
    assert $Heap[this, LoopInv0.X] == 5;
    goto block4471;

  block4369:
    // ----- call  ----- loopinv0.ssc(31,7)
    assert this != null;
    call LoopInv0.N(this);
    // ----- copy  ----- loopinv0.ssc(29,29)
    local2 := i;
    // ----- load constant 1  ----- loopinv0.ssc(29,29)
    stack0i := 1;
    // ----- binary operator  ----- loopinv0.ssc(29,29)
    stack0i := local2 + stack0i;
    // ----- copy  ----- loopinv0.ssc(29,29)
    i := stack0i;
    // ----- copy
    stack0i := local2;
    // ----- branch
    goto block4352;

  block4471:
    // ----- nop
    // ----- return  ----- loopinv0.ssc(34,3)
    return;

  block4352$LoopPreheader:
    $Heap$block4352$LoopPreheader := $Heap;
    goto block4352;

}



procedure LoopInv0.Method2$Node$notnull(this: ref, n$in: ref where $IsNotNull(n$in, Node));
  free requires $Heap[n$in, $allocated] == true;
  // user-declared preconditions
  requires ($Heap[this, $ownerFrame] == $PeerGroupPlaceholder || !($Heap[$Heap[this, $ownerRef], $inv] <: $Heap[this, $ownerFrame]) || $Heap[$Heap[this, $ownerRef], $localinv] == $BaseClass($Heap[this, $ownerFrame])) && $Heap[this, $inv] == LoopInv0 && $Heap[this, $localinv] == $typeof(this);
  free requires $BeingConstructed == null;
  modifies $Heap;
  // newly allocated objects are fully valid
  free ensures (forall $o: ref :: $o != null && old($Heap)[$o, $allocated] != true && $Heap[$o, $allocated] == true ==> $Heap[$o, $inv] == $typeof($o) && $Heap[$o, $localinv] == $typeof($o));
  // first consistent owner unchanged if its exposeVersion is
  free ensures (forall $o: ref :: { $Heap[$o, $FirstConsistentOwner] } old($Heap)[old($Heap)[$o, $FirstConsistentOwner], $exposeVersion] == $Heap[old($Heap)[$o, $FirstConsistentOwner], $exposeVersion] ==> old($Heap)[$o, $FirstConsistentOwner] == $Heap[$o, $FirstConsistentOwner]);
  // only captured parameters may change their owners
  ensures (forall $o: ref :: $o != null && old($Heap)[$o, $allocated] == true ==> old($Heap)[$o, $ownerRef] == $Heap[$o, $ownerRef] && old($Heap)[$o, $ownerFrame] == $Heap[$o, $ownerFrame]);
  // frame condition
  free ensures (forall $o: ref, $f: name :: { $Heap[$o, $f] } $f != $inv && $f != $localinv && $f != $FirstConsistentOwner && (!IsStaticField($f) || !IsDirectlyModifiableField($f)) && $o != null && old($Heap)[$o, $allocated] == true && (old($Heap)[$o, $ownerFrame] == $PeerGroupPlaceholder || !(old($Heap)[old($Heap)[$o, $ownerRef], $inv] <: old($Heap)[$o, $ownerFrame]) || old($Heap)[old($Heap)[$o, $ownerRef], $localinv] == $BaseClass(old($Heap)[$o, $ownerFrame])) && old($o != this || !(LoopInv0 <: DeclType($f))) && old($o != this || $f != $exposeVersion) ==> old($Heap)[$o, $f] == $Heap[$o, $f]);
  free ensures (forall $o: ref :: (old($Heap)[$o, $inv] == $Heap[$o, $inv] && old($Heap)[$o, $localinv] == $Heap[$o, $localinv]) || old($Heap)[$o, $allocated] != true);
  free ensures (forall $o: ref :: old($Heap)[$o, $allocated] == true ==> $Heap[$o, $allocated] == true) && (forall $ot: ref :: old($Heap)[$ot, $allocated] == true && old($Heap)[$ot, $ownerFrame] != $PeerGroupPlaceholder ==> $Heap[$ot, $ownerRef] == old($Heap)[$ot, $ownerRef] && $Heap[$ot, $ownerFrame] == old($Heap)[$ot, $ownerFrame]) && old($Heap)[$BeingConstructed, $NonNullFieldsAreInitialized] == $Heap[$BeingConstructed, $NonNullFieldsAreInitialized];
  free ensures (forall $o: ref :: old($Heap[$o, $sharingMode]) == $Heap[$o, $sharingMode]);



implementation LoopInv0.Method2$Node$notnull(this: ref, n$in: ref)
{
  var n: ref where $IsNotNull(n, Node), curr: ref where $Is(curr, Node), local2: ref where $Is(local2, LoopInv0), stack0o: ref, stack1s: struct, stack1o: ref, temp0: exposeVersionType, stack0i: int, temp1: exposeVersionType, i: int where InRange(i, System.Int32), stack0b: bool, local6: ref where $Is(local6, Node), temp2: exposeVersionType, local7: int where InRange(local7, System.Int32), $Heap$block6273$LoopPreheader: [ref,<x>name]x;

  entry:
    assume $IsNotNull(this, LoopInv0);
    assume $Heap[this, $allocated] == true;
    n := n$in;
    goto block6018;

  block6018:
    goto block6222;

  block6222:
    // ----- nop
    // ----- copy  ----- loopinv0.ssc(40,5)
    curr := n;
    // ----- copy  ----- loopinv0.ssc(41,13)
    local2 := this;
    // ----- copy  ----- loopinv0.ssc(41,13)
    stack0o := local2;
    // ----- load token  ----- loopinv0.ssc(41,13)
    havoc stack1s;
    assume $IsTokenForType(stack1s, LoopInv0);
    // ----- statically resolved GetTypeFromHandle call  ----- loopinv0.ssc(41,13)
    stack1o := TypeObject(LoopInv0);
    // ----- local unpack  ----- loopinv0.ssc(41,13)
    assert stack0o != null;
    assert ($Heap[stack0o, $ownerFrame] == $PeerGroupPlaceholder || !($Heap[$Heap[stack0o, $ownerRef], $inv] <: $Heap[stack0o, $ownerFrame]) || $Heap[$Heap[stack0o, $ownerRef], $localinv] == $BaseClass($Heap[stack0o, $ownerFrame])) && $Heap[stack0o, $inv] <: LoopInv0 && $Heap[stack0o, $localinv] == $typeof(stack0o);
    $Heap[stack0o, $localinv] := System.Object;
    havoc temp0;
    $Heap[stack0o, $exposeVersion] := temp0;
    assume IsHeap($Heap);
    goto block6239;

  block6239:
    // ----- load constant 5  ----- loopinv0.ssc(41,21)
    stack0i := 5;
    // ----- store field  ----- loopinv0.ssc(41,21)
    assert this != null;
    havoc temp1;
    $Heap[this, $exposeVersion] := temp1;
    $Heap[this, LoopInv0.X] := stack0i;
    assume IsHeap($Heap);
    // ----- branch
    goto block6630;

  block6630:
    // ----- copy  ----- loopinv0.ssc(41,33)
    stack0o := local2;
    // ----- load token  ----- loopinv0.ssc(41,33)
    havoc stack1s;
    assume $IsTokenForType(stack1s, LoopInv0);
    // ----- statically resolved GetTypeFromHandle call  ----- loopinv0.ssc(41,33)
    stack1o := TypeObject(LoopInv0);
    // ----- local pack  ----- loopinv0.ssc(41,33)
    assert stack0o != null;
    assert $Heap[stack0o, $localinv] == System.Object;
    assert (forall $p: ref :: $p != null && $Heap[$p, $allocated] == true && $Heap[$p, $ownerRef] == stack0o && $Heap[$p, $ownerFrame] == LoopInv0 ==> $Heap[$p, $inv] == $typeof($p) && $Heap[$p, $localinv] == $typeof($p));
    $Heap[stack0o, $localinv] := $typeof(stack0o);
    assume IsHeap($Heap);
    // ----- nop
    // ----- branch
    goto block6256;

  block6256:
    // ----- load constant 0  ----- loopinv0.ssc(42,10)
    i := 0;
    goto block6273$LoopPreheader;

  block6273:
    // ----- default loop invariant: allocation and ownership are stable  ----- loopinv0.ssc(42,21)
    assume (forall $o: ref :: $Heap$block6273$LoopPreheader[$o, $allocated] == true ==> $Heap[$o, $allocated] == true) && (forall $ot: ref :: $Heap$block6273$LoopPreheader[$ot, $allocated] == true && $Heap$block6273$LoopPreheader[$ot, $ownerFrame] != $PeerGroupPlaceholder ==> $Heap[$ot, $ownerRef] == $Heap$block6273$LoopPreheader[$ot, $ownerRef] && $Heap[$ot, $ownerFrame] == $Heap$block6273$LoopPreheader[$ot, $ownerFrame]) && $Heap$block6273$LoopPreheader[$BeingConstructed, $NonNullFieldsAreInitialized] == $Heap[$BeingConstructed, $NonNullFieldsAreInitialized];
    // ----- default loop invariant: $inv field  ----- loopinv0.ssc(42,21)
    assume (forall $o: ref :: ($Heap$block6273$LoopPreheader[$o, $inv] == $Heap[$o, $inv] && $Heap$block6273$LoopPreheader[$o, $localinv] == $Heap[$o, $localinv]) || $Heap$block6273$LoopPreheader[$o, $allocated] != true);
    assume (forall $o: ref :: $Heap$block6273$LoopPreheader[$o, $allocated] != true && $Heap[$o, $allocated] == true ==> $Heap[$o, $inv] == $typeof($o) && $Heap[$o, $localinv] == $typeof($o));
    // ----- default loop invariant: $ownerRef and $ownerFrame fields  ----- loopinv0.ssc(42,21)
    assert (forall $o: ref :: $o != null && $Heap$block6273$LoopPreheader[$o, $allocated] == true ==> $Heap$block6273$LoopPreheader[$o, $ownerRef] == $Heap[$o, $ownerRef] && $Heap$block6273$LoopPreheader[$o, $ownerFrame] == $Heap[$o, $ownerFrame]);
    // ----- load constant 10  ----- loopinv0.ssc(42,21)
    stack0i := 10;
    // ----- binary operator  ----- loopinv0.ssc(42,21)
    // ----- branch  ----- loopinv0.ssc(42,21)
    goto true6273to6511, false6273to6290;

  true6273to6511:
    assume i >= stack0i;
    goto block6511;

  false6273to6290:
    assume i < stack0i;
    goto block6290;

  block6511:
    // ----- serialized AssertStatement  ----- loopinv0.ssc(48,5)
    assert $Heap[this, LoopInv0.X] == 5;
    goto block6596;

  block6290:
    // ----- serialized AssumeStatement  ----- loopinv0.ssc(44,7)
    assume curr != null;
    goto block6375;

  block6596:
    // ----- nop
    // ----- return
    return;

  block6375:
    // ----- nop
    // ----- serialized AssumeStatement  ----- loopinv0.ssc(44,28)
    assume ($Heap[curr, $ownerFrame] == $PeerGroupPlaceholder || !($Heap[$Heap[curr, $ownerRef], $inv] <: $Heap[curr, $ownerFrame]) || $Heap[$Heap[curr, $ownerRef], $localinv] == $BaseClass($Heap[curr, $ownerFrame])) && $Heap[curr, $inv] == Node && $Heap[curr, $localinv] == $typeof(curr);
    goto block6460;

  block6460:
    // ----- nop
    // ----- copy  ----- loopinv0.ssc(45,15)
    local6 := curr;
    // ----- copy  ----- loopinv0.ssc(45,15)
    stack0o := local6;
    // ----- load token  ----- loopinv0.ssc(45,15)
    havoc stack1s;
    assume $IsTokenForType(stack1s, Node);
    // ----- statically resolved GetTypeFromHandle call  ----- loopinv0.ssc(45,15)
    stack1o := TypeObject(Node);
    // ----- local unpack  ----- loopinv0.ssc(45,15)
    assert stack0o != null;
    assert ($Heap[stack0o, $ownerFrame] == $PeerGroupPlaceholder || !($Heap[$Heap[stack0o, $ownerRef], $inv] <: $Heap[stack0o, $ownerFrame]) || $Heap[$Heap[stack0o, $ownerRef], $localinv] == $BaseClass($Heap[stack0o, $ownerFrame])) && $Heap[stack0o, $inv] <: Node && $Heap[stack0o, $localinv] == $typeof(stack0o);
    $Heap[stack0o, $localinv] := System.Object;
    havoc temp2;
    $Heap[stack0o, $exposeVersion] := temp2;
    assume IsHeap($Heap);
    goto block6477;

  block6477:
    // ----- store field  ----- loopinv0.ssc(45,23)
    assert curr != null;
    assert !($Heap[curr, $inv] <: Node) || $Heap[curr, $localinv] == System.Object;
    $Heap[curr, Node.I] := i;
    assume IsHeap($Heap);
    // ----- branch
    goto block6647;

  block6647:
    // ----- copy  ----- loopinv0.ssc(45,35)
    stack0o := local6;
    // ----- load token  ----- loopinv0.ssc(45,35)
    havoc stack1s;
    assume $IsTokenForType(stack1s, Node);
    // ----- statically resolved GetTypeFromHandle call  ----- loopinv0.ssc(45,35)
    stack1o := TypeObject(Node);
    // ----- local pack  ----- loopinv0.ssc(45,35)
    assert stack0o != null;
    assert $Heap[stack0o, $localinv] == System.Object;
    assert (forall $p: ref :: $p != null && $Heap[$p, $allocated] == true && $Heap[$p, $ownerRef] == stack0o && $Heap[$p, $ownerFrame] == Node ==> $Heap[$p, $inv] == $typeof($p) && $Heap[$p, $localinv] == $typeof($p));
    $Heap[stack0o, $localinv] := $typeof(stack0o);
    assume IsHeap($Heap);
    // ----- nop
    // ----- branch
    goto block6494;

  block6494:
    // ----- load field  ----- loopinv0.ssc(46,7)
    assert curr != null;
    curr := $Heap[curr, Node.Next];
    // ----- copy  ----- loopinv0.ssc(42,29)
    local7 := i;
    // ----- load constant 1  ----- loopinv0.ssc(42,29)
    stack0i := 1;
    // ----- binary operator  ----- loopinv0.ssc(42,29)
    stack0i := local7 + stack0i;
    // ----- copy  ----- loopinv0.ssc(42,29)
    i := stack0i;
    // ----- copy
    stack0i := local7;
    // ----- branch
    goto block6273;

  block6273$LoopPreheader:
    $Heap$block6273$LoopPreheader := $Heap;
    goto block6273;

}



procedure LoopInv0..ctor(this: ref);
  // nothing is owned by [this,*]
  free requires (forall $o: ref :: $o != this ==> $Heap[$o, $ownerRef] != this);
  // 'this' is alone in its own peer group
  free requires $Heap[this, $ownerRef] == this && $Heap[this, $ownerFrame] == $PeerGroupPlaceholder;
  free requires (forall $o: ref :: $Heap[$o, $ownerRef] == $Heap[this, $ownerRef] && $Heap[$o, $ownerFrame] == $Heap[this, $ownerFrame] ==> $o == this);
  free requires $BeingConstructed == this;
  modifies $Heap;
  ensures ($Heap[this, $ownerFrame] == $PeerGroupPlaceholder || !($Heap[$Heap[this, $ownerRef], $inv] <: $Heap[this, $ownerFrame]) || $Heap[$Heap[this, $ownerRef], $localinv] == $BaseClass($Heap[this, $ownerFrame])) && $Heap[this, $inv] == LoopInv0 && $Heap[this, $localinv] == $typeof(this);
  ensures $Heap[this, $ownerRef] == old($Heap)[this, $ownerRef] && $Heap[this, $ownerFrame] == old($Heap)[this, $ownerFrame];
  ensures $Heap[this, $sharingMode] == $SharingMode_Unshared;
  // newly allocated objects are fully valid
  free ensures (forall $o: ref :: $o != null && old($Heap)[$o, $allocated] != true && $Heap[$o, $allocated] == true ==> $Heap[$o, $inv] == $typeof($o) && $Heap[$o, $localinv] == $typeof($o));
  // first consistent owner unchanged if its exposeVersion is
  free ensures (forall $o: ref :: { $Heap[$o, $FirstConsistentOwner] } old($Heap)[old($Heap)[$o, $FirstConsistentOwner], $exposeVersion] == $Heap[old($Heap)[$o, $FirstConsistentOwner], $exposeVersion] ==> old($Heap)[$o, $FirstConsistentOwner] == $Heap[$o, $FirstConsistentOwner]);
  // only captured parameters may change their owners
  ensures (forall $o: ref :: $o != null && old($Heap)[$o, $allocated] == true ==> old($Heap)[$o, $ownerRef] == $Heap[$o, $ownerRef] && old($Heap)[$o, $ownerFrame] == $Heap[$o, $ownerFrame]);
  // frame condition
  free ensures (forall $o: ref, $f: name :: { $Heap[$o, $f] } $f != $inv && $f != $localinv && $f != $FirstConsistentOwner && (!IsStaticField($f) || !IsDirectlyModifiableField($f)) && $o != null && old($Heap)[$o, $allocated] == true && (old($Heap)[$o, $ownerFrame] == $PeerGroupPlaceholder || !(old($Heap)[old($Heap)[$o, $ownerRef], $inv] <: old($Heap)[$o, $ownerFrame]) || old($Heap)[old($Heap)[$o, $ownerRef], $localinv] == $BaseClass(old($Heap)[$o, $ownerFrame])) && ($o != this || !(LoopInv0 <: DeclType($f))) && old(true) ==> old($Heap)[$o, $f] == $Heap[$o, $f]);
  free ensures (forall $o: ref :: $o == this || (old($Heap)[$o, $inv] == $Heap[$o, $inv] && old($Heap)[$o, $localinv] == $Heap[$o, $localinv]) || old($Heap)[$o, $allocated] != true);
  free ensures (forall $o: ref :: old($Heap)[$o, $allocated] == true ==> $Heap[$o, $allocated] == true) && (forall $ot: ref :: old($Heap)[$ot, $allocated] == true && old($Heap)[$ot, $ownerFrame] != $PeerGroupPlaceholder ==> $Heap[$ot, $ownerRef] == old($Heap)[$ot, $ownerRef] && $Heap[$ot, $ownerFrame] == old($Heap)[$ot, $ownerFrame]) && old($Heap)[$BeingConstructed, $NonNullFieldsAreInitialized] == $Heap[$BeingConstructed, $NonNullFieldsAreInitialized];
  free ensures (forall $o: ref :: $o == this || old($Heap[$o, $sharingMode]) == $Heap[$o, $sharingMode]);



implementation LoopInv0..ctor(this: ref)
{

  entry:
    assume $IsNotNull(this, LoopInv0);
    assume $Heap[this, $allocated] == true;
    assume ($Heap[this, $ownerFrame] == $PeerGroupPlaceholder || !($Heap[$Heap[this, $ownerRef], $inv] <: $Heap[this, $ownerFrame]) || $Heap[$Heap[this, $ownerRef], $localinv] == $BaseClass($Heap[this, $ownerFrame])) && $Heap[this, $inv] == System.Object && $Heap[this, $localinv] == $typeof(this);
    assume $Heap[this, LoopInv0.X] == 0;
    assume $Heap[this, LoopInv0.Y] == 0;
    goto block7820;

  block7820:
    goto block7837;

  block7837:
    // ----- call  ----- loopinv0.ssc(8,21)
    assert this != null;
    call System.Object..ctor(this);
    // ----- return
    assert this != null;
    assert $Heap[this, $inv] == System.Object && $Heap[this, $localinv] == $typeof(this);
    assert (forall $p: ref :: $p != null && $Heap[$p, $allocated] == true && $Heap[$p, $ownerRef] == this && $Heap[$p, $ownerFrame] == LoopInv0 ==> $Heap[$p, $inv] == $typeof($p) && $Heap[$p, $localinv] == $typeof($p));
    $Heap[this, $inv] := LoopInv0;
    assume IsHeap($Heap);
    return;

}


