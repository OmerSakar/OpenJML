public class Test {
    
    public void m() {
        
        double d = 2.0;
        double dd = 3.0;
        assert d + dd == 5.0;
        assert d - dd == -1.0;
        assert d * dd == 6.0;
        assert dd / d == 1.5;
        assert dd % d == 1.0;
        assert (-dd) % d == -1.0;
        assert dd % (-d) == 1.0;
        assert (-dd) % (-d) == -1.0;
    }
    
//    public void mm() {
//        
//        double d = 2;
//        double dd = 3;
//        assert d + dd == 5;
//        assert d - dd == -1;
//        assert d * dd == 6;
//        assert dd / d == 1.5;
//    }
}