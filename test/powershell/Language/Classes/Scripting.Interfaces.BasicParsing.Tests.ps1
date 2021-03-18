
BeforeAll {
    $interfacesSupported = [ExperimentalFeature]::IsEnabled('PSTypeInterfaceSupport')
    $PSDefaultParameterValues['Describe:Skip'] = -not $interfacesSupported
}
Describe 'Positive Parse Properties Tests' -Tags "CI" {
    It 'PositiveParseTests' {
        # Just a bunch of random basic things here
        # This test doesn't need to check anything, if there are
        # any parse errors, the entire suite will fail because the
        # script will fail to parse.
        { Import-Module "$PSScriptRoot\ExperimentalTypes.psm1" -ErrorAction Stop } |Should -Not -Throw
    }
}

Describe 'Negative Parsing Tests' -Tags "CI" {
    ShouldBeParseError 'interface' MissingNameAfterKeyword 9
    ShouldBeParseError 'interface IFoo' MissingTypeBody 14
    ShouldBeParseError 'interface IFoo {' MissingEndCurlyBrace 16
    ShouldBeParseError 'interface IFoo { [int] }' IncompleteMemberDefinition 22
    ShouldBeParseError 'interface IFoo { $private: }' InvalidVariableReference 17
    ShouldBeParseError 'interface IFoo { [int]$global: }' InvalidVariableReference 22
    ShouldBeParseError 'interface IFoo {} interface IFoo {}' MemberAlreadyDefined 18
    ShouldBeParseError 'interface IFoo { $x; $x; }' MemberAlreadyDefined 21 -SkipAndCheckRuntimeError
    ShouldBeParseError 'interface IFoo { [int][string]$x; }' TooManyTypes 22
    ShouldBeParseError 'interface IFoo { static $x; }' AbstractTypesCantHaveStaticOrHiddenMembers 17
    ShouldBeParseError 'interface IFoo { [zz]$x; }' TypeNotFound 18
    ShouldBeParseError 'interface IFoo { [zz]f() }' TypeNotFound 18
    ShouldBeParseError 'interface IFoo { f([zz]$x) }' TypeNotFound 20

    ShouldBeParseError 'interface I {} interface I {}' MemberAlreadyDefined 15
    ShouldBeParseError 'interface I { f(); f() }' MemberAlreadyDefined 16 -SkipAndCheckRuntimeError
    ShouldBeParseError 'interface I { F(); F($o); [int] F($o) }' MemberAlreadyDefined 24 -SkipAndCheckRuntimeError
    ShouldBeParseError 'interface I { f(); f($a); f(); }' MemberAlreadyDefined 24 -SkipAndCheckRuntimeError
    ShouldBeParseError 'interface I { f([int]$a); f([int]$b); }' MemberAlreadyDefined 23 -SkipAndCheckRuntimeError
    ShouldBeParseError 'interface I { $x; [int]$x; }' MemberAlreadyDefined 14 -SkipAndCheckRuntimeError
    ShouldBeParseError 'interface I { static C($x) }' AbstractTypesCantHaveStaticOrHiddenMembers 24 -SkipAndCheckRuntimeError
    ShouldBeParseError 'interface I { static C([int]$x = 100) }' AbstractTypesCantHaveStaticOrHiddenMembers 24 -SkipAndCheckRuntimeError

    ShouldBeParseError 'interface I : B' MissingTypeBody 15

    ShouldBeParseError 'interface IFoo { q(); w()' MissingEndCurlyBrace 16
}

Describe 'Positive SelfClass Type As Parameter Test' -Tags "CI" {
        $scriptText = @'
interface IPoint
{
    [int] $x;
    [int] $y;
    Add([IPoint]$val)
}

$type = [IPoint]
$type.GetMember('Add').GetParameters()[0].ParameterType -eq $type
'@
        It  "[IPoint]::Add accepts a parameter of its own type" {
            Invoke-Expression $scriptText |Should -BeTrue
        }
}
