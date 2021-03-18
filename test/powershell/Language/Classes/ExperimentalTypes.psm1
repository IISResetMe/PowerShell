# No members
interface I1 {}

# Simple field
interface I2 { $x; }

# Simple typed field
interface I3 { [int] $x; }

# Multiple fields, one line, last w/o semicolon
interface I4 { $x; $y }

# Multiple fields, multiple lines
interface I5
{
    $x
    $y
}

# Field using type defined in this scope
interface I8a { [I1] $i1; }
interface I8b { [i1] $i1; }

# Field referring to self type
interface I9 { [I9] $i9; }


# Simple method
interface I10 { f(); }

# Simple method with return type
interface I11 { [int] f(); }

# Multiple methods, one line

interface I12 { f() f1() }


# Multiple methods w/ overloads
interface I13
{
    f1()
    f1($a)
}
# Method using return type defined in this scope
interface I14a { [I1] f1() }
interface I14b { [I1] f1() }
