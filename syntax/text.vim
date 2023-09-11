setlocal conceallevel=2

syntax keyword TextTodo TODO NOTE IMPORTANT ASSIGNMENT

syntax match Normal "\v\\\{sub\}\{0\}" conceal cchar=₀
syntax match Normal "\v\\\{sub\}\{1\}" conceal cchar=₁
syntax match Normal "\v\\\{sub\}\{2\}" conceal cchar=₂
syntax match Normal "\v\\\{sub\}\{3\}" conceal cchar=₃
syntax match Normal "\v\\\{sub\}\{4\}" conceal cchar=₄
syntax match Normal "\v\\\{sub\}\{5\}" conceal cchar=₅
syntax match Normal "\v\\\{sub\}\{6\}" conceal cchar=₆
syntax match Normal "\v\\\{sub\}\{7\}" conceal cchar=₇
syntax match Normal "\v\\\{sub\}\{8\}" conceal cchar=₈
syntax match Normal "\v\\\{sub\}\{9\}" conceal cchar=₉

syntax match Normal "\v\\\{sup\}\{0\}" conceal cchar=⁰
syntax match Normal "\v\\\{sup\}\{1\}" conceal cchar=¹
syntax match Normal "\v\\\{sup\}\{2\}" conceal cchar=²
syntax match Normal "\v\\\{sup\}\{3\}" conceal cchar=³
syntax match Normal "\v\\\{sup\}\{4\}" conceal cchar=⁴
syntax match Normal "\v\\\{sup\}\{5\}" conceal cchar=⁵
syntax match Normal "\v\\\{sup\}\{6\}" conceal cchar=⁶
syntax match Normal "\v\\\{sup\}\{7\}" conceal cchar=⁷
syntax match Normal "\v\\\{sup\}\{8\}" conceal cchar=⁸
syntax match Normal "\v\\\{sup\}\{9\}" conceal cchar=⁹
syntax match Normal "\v\\\{sup\}\{\-\}" conceal cchar=⁻
syntax match Normal "\v\\\{sup\}\{\+\}" conceal cchar=⁺
syntax match Normal "\v\\\{sup\}\{\(\}" conceal cchar=⁽
syntax match Normal "\v\\\{sup\}\{\)\}" conceal cchar=⁾

syntax match Normal "\v\\\{Z\}" conceal cchar=ℤ
syntax match Normal "\v\\\{R\}" conceal cchar=ℝ
syntax match Normal "\v\\\{C\}" conceal cchar=ℂ
syntax match Normal "\v\\\{F\}" conceal cchar=𝔽
syntax match Normal "\v\\\{Q\}" conceal cchar=ℚ

syntax match Normal "\v\\\{approx\}" conceal cchar=≈
syntax match Normal "\v\\\{inf\}" conceal cchar=∞
syntax match Normal "\v\\\{root\}" conceal cchar=√
syntax match Normal "\v\\\{proportional\}" conceal cchar=∝
syntax match Normal "\v\\\{angle\}" conceal cchar=∡
syntax match Normal "\v\\\{integral\}" conceal cchar=∫
syntax match Normal "\v\\\{mp\}" conceal cchar=∓
syntax match Normal "\v\\\{pm\}" conceal cchar=±

syntax match Normal "\v\\\{element\}" conceal cchar=∈
syntax match Normal "\v\\\{intersect\}" conceal cchar=∩
syntax match Normal "\v\\\{union\}" conceal cchar=∪
syntax match Normal "\v\\\{subset\}" conceal cchar=⊆
syntax match Normal "\v\\\{supset\}" conceal cchar=⊇
syntax match Normal "\v\\\{psupset\}" conceal cchar=⊃
syntax match Normal "\v\\\{psubset\}" conceal cchar=⊂

syntax match Normal "\v\\\{a\}" conceal cchar=𝑎
syntax match Normal "\v\\\{b\}" conceal cchar=𝑏
syntax match Normal "\v\\\{c\}" conceal cchar=𝑐
syntax match Normal "\v\\\{d\}" conceal cchar=𝑑
syntax match Normal "\v\\\{e\}" conceal cchar=𝑒
syntax match Normal "\v\\\{f\}" conceal cchar=𝑓
syntax match Normal "\v\\\{g\}" conceal cchar=𝑔
syntax match Normal "\v\\\{i\}" conceal cchar=𝑖
syntax match Normal "\v\\\{j\}" conceal cchar=𝑗
syntax match Normal "\v\\\{k\}" conceal cchar=𝑘
syntax match Normal "\v\\\{l\}" conceal cchar=𝑙
syntax match Normal "\v\\\{m\}" conceal cchar=𝑚
syntax match Normal "\v\\\{n\}" conceal cchar=𝑛
syntax match Normal "\v\\\{o\}" conceal cchar=𝑜
syntax match Normal "\v\\\{p\}" conceal cchar=𝑝
syntax match Normal "\v\\\{q\}" conceal cchar=𝑞
syntax match Normal "\v\\\{r\}" conceal cchar=𝑟
syntax match Normal "\v\\\{s\}" conceal cchar=𝑠
syntax match Normal "\v\\\{t\}" conceal cchar=𝑡
syntax match Normal "\v\\\{u\}" conceal cchar=𝑢
syntax match Normal "\v\\\{v\}" conceal cchar=𝑣
syntax match Normal "\v\\\{w\}" conceal cchar=𝑤
syntax match Normal "\v\\\{x\}" conceal cchar=𝑥
syntax match Normal "\v\\\{y\}" conceal cchar=𝑦
syntax match Normal "\v\\\{z\}" conceal cchar=𝑧

syntax match Normal "\v\\\{Sigma\}" conceal cchar=∑

syntax match Normal "\v\\\{le\}" conceal cchar=≤
syntax match Normal "\v\\\{ge\}" conceal cchar=≥
syntax match Normal "\v\\\{pi\}" conceal cchar=𝜋

syntax match Normal "\v\\\{alpha\}" conceal cchar=α
syntax match Normal "\v\\\{beta\}" conceal cchar=β
syntax match Normal "\v\\\{Gamma\}" conceal cchar=Γ
syntax match Normal "\v\\\{gamma\}" conceal cchar=γ
syntax match Normal "\v\\\{Delta\}" conceal cchar=Δ
syntax match Normal "\v\\\{delta\}" conceal cchar=δ
syntax match Normal "\v\\\{epsilon\}" conceal cchar=ε
syntax match Normal "\v\\\{zeta\}" conceal cchar=ζ
syntax match Normal "\v\\\{eta\}" conceal cchar=η
syntax match Normal "\v\\\{Theta\}" conceal cchar=ϴ
syntax match Normal "\v\\\{theta\}" conceal cchar=θ
syntax match Normal "\v\\\{kappa\}" conceal cchar=κ
syntax match Normal "\v\\\{lambda\}" conceal cchar=λ
syntax match Normal "\v\\\{mu\}" conceal cchar=μ
syntax match Normal "\v\\\{nu\}" conceal cchar=ν
syntax match Normal "\v\\\{Xi\}" conceal cchar=Ξ
syntax match Normal "\v\\\{xi\}" conceal cchar=ξ
syntax match Normal "\v\\\{Pi\}" conceal cchar=Π
syntax match Normal "\v\\\{rho\}" conceal cchar=ρ
syntax match Normal "\v\\\{sigma\}" conceal cchar=σ
syntax match Normal "\v\\\{tau\}" conceal cchar=τ
syntax match Normal "\v\\\{upsilon\}" conceal cchar=υ
syntax match Normal "\v\\\{Phi\}" conceal cchar=Φ
syntax match Normal "\v\\\{phi\}" conceal cchar=φ
syntax match Normal "\v\\\{Chi\}" conceal cchar=χ
syntax match Normal "\v\\\{Psi\}" conceal cchar=Ψ
syntax match Normal "\v\\\{psi\}" conceal cchar=ψ
syntax match Normal "\v\\\{Omega\}" conceal cchar=Ω
syntax match Normal "\v\\\{omega\}" conceal cchar=ω
syntax match Normal "\v\\\{Nabla\}" conceal cchar=∇

syntax match TextOperator "\v\*"
syntax match TextOperator "\v/"
syntax match TextOperator "\v\+"
syntax match TextOperator "\v-"
syntax match TextOperator "\v\?"
syntax match TextOperator "\v\="
syntax match TextOperator "\v\^"
syntax match TextOperator "\v\%"

"matches one or more digits if there are no alphabet characters ahead of it
syntax match TextNumber "\v([a-zA-Z])@<!\d+"

"same as above except includes a single '.' for decimals
syntax match TextNumber "\v([a-zA-Z])@<!\d+\.\d+"

"matches a line that starts with '-'
syntax match TextPoint "\v\_^\w@!\s*-\s+.+" contains=ALL

"matches a line that starts with #. "
syntax match TextPoint "\v\_^([a-zA-Z])@!\d*\.\s.+" contains=ALL

"matches a line that starts with any amount of whitespace character
syntax match TextPoint "\v\_^\s+.+" contains=ALL

syntax region TextSpecial matchgroup=Special start="\v\\\{sp\}" end="\v\\\{sp\}" concealends contains=ALL
syntax region TextUnderline matchgroup=Underlined start="\v\\\{un\}" end="\v\\\{un\}" concealends contains=ALL
syntax region TextImportant matchgroup=Keyword start="\v\\\{im\}" end="\v\\\{im\}" concealends contains=ALL
syntax region TextQuote start="\v\"" end="\v\""

highlight link TextTodo Todo
highlight link TextAssignment Function
highlight link TextMonth Number
highlight link TextNumber Number
highlight link TextPoint Include
highlight link TextCapital Keyword
highlight link TextSpecial Special
highlight link TextUnderline Underlined
highlight link TextImportant Keyword
highlight link TextQuote Comment
highlight link TextSingleQuote Comment
highlight link TextOperator Operator
