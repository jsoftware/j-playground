NB. NuVoc -- generate Vocabulary/ page name from J primitive (as string)

CBYTE=: 0 : 0
=eq
<lt
>gt
_under
+plus
*star
-minus
%percent
^hat
$dollar
~tilde
|bar
.dot
:co
,comma
;semi
#number
!bang
/slash
\bslash
[squarelf
]squarert
{curlylf
}curlyrt
(parenlf
)parenrt
'apostrophe
"quote
`grave
@at
&amp
?query
0zero
1one
2two
3three
4four
5five
6six
7seven
8eight
9nine
)

cbyte=: (3 : 0)"0
if. y e. 'abcdefghijklmnopqrstuvwxyz' do. < y
elseif. y e. 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' do. < 'cap' ,~ tolower y
elseif. y e. CBYTE {~ I. 1 , }: LF=CBYTE do. < }. LF taketo (CBYTE i. y) }. CBYTE
elseif. do. ''
end.
)

cname=: ; @: cbyte

assert 'eq' 		-: cname '='
assert 'eqco' 		-: cname '=:'
assert 'ncapbcapdot' 	-: cname 'NB.'
