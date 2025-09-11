// vim: set foldmarker=[[[,]]]
// \documentclass[reqno]{amsart}
//// \usepackage{xcolor}
// \usepackage{mathtools,amssymb, xcolor}
\mathtoolsset{showonlyrefs}
//[[[ env setting
\newtheorem{Theorem}{Theorem}[section]
\newtheorem{Definition}[Theorem]{Definition}
\newtheorem{Corollary}[Theorem]{Corollary}
\newtheorem{Lemma}[Theorem]{Lemma}
\newtheorem{Proposition}[Theorem]{Proposition}
\newtheorem{Remark}{Remark}[section]
//\addtolength{\textwidth}{5.cm}
//\addtolength{\textheight}{4cm}
//]]]

// \begin{document}
//[[[ metadata
\title{Global existence for DWQ caused by Sign changing  phenomena}
\author[K.Fujiwara]{Kazumasa Fujiwara }
\address[K. Fujiwara]{
	Faculty of Advanced Science and Technology,
	Ryukoku University,
	1-5 Yokotani,Seta Oe-cho,Otsu,Shiga,
	520-2194, Japan
}

\email{fujiwara.kazumasa@math.ryukoku.ac.jp}

\author[V.Georgiev]{Vladimir Georgiev}
\address[V.Georgiev]{
Department of Mathematics,
University of Pisa,
Largo Bruno Pontecorvo 5,
I - 56127 Pisa, Italy}
\address{
Faculty of Science and Engineering, Waseda University,
3-4-1, Okubo, Shinjuku-ku, Tokyo 169-8555, Japan}
\address{
Institute of Mathematics and Informatics,  Bulgarian Academy of Sciences, Acad. Georgi Bonchev Str., Block 8, Sofia, 1113, Bulgaria
}
\email{georgiev@dm.unipi.it}

\subjclass{35B40,35B33, 35B51}
\keywords{
damped wave equations,
Fujita  critical exponent,
power-type nonlinearity,
decay estimate
}
//]]]

\begin{abstract}
In this manuscript, we study initial data
that guarantee global-in-time solutions to the Cauchy problem
for the semilinear damped wave equation
with a power-type nonlinearity.
Our proof relies on a comparison principle derived from
fundamental properties of wave equations.
In particular, we exhibit initial data
with negative position and positive velocity
that produce global solutions through a sign-changing mechanism,
even though these data do not satisfy
the standard assumptions of the comparison argument.
\end{abstract}

\maketitle

//[[[ = Introduction
= Introduction

//[[[ In this note,
In this note,
we consider the behavior of solutions
to the Cauchy problem for the semilinear damped wave equation
	$<label-eq:DW>
	$
    ∂_t^2 u+∂_t u-\Delta u=|u|^p, & t>0, x ∈ \mathbb R^n, \
    u(0)=u_0, ∂_t u(0)=u_1, & x ∈ \mathbb R^n .
	$
	$
The aim of this manuscript
is to establish the global existence of solutions
under the initial conditions
	$<label-eq:initial_condition>
    & \left(u_0, u_1\right)=\left(\varepsilon_0 \varphi, \varepsilon_1 \varphi\right), \
    & 0 < \varepsilon_0 < |\varepsilon_1| = - \varepsilon_1.
	$
with $n = 1$, $\left(\varepsilon_0, \varepsilon_1\right) ∈ ℝ^2$ small,
and $\varphi$ being a regular non-negative function.
//]]]

//[[[ The Cauchy problem @label-eq:DW has been extensively studied.
The Cauchy problem @label-eq:DW has been extensively studied
(see
	@M76,
	@TY01,
	@N03,
	@MN03,
	@HKN04,
	@INZ06,
	@DA15,
	@DLR15
	@IIOW19,
	@FIW19,
	@LT19,
	@IS19,
	@CR21,
	@KK22,
and references therein).
A key step for analyzing the nonlinear problem @label-eq:DW is to first
understand the corresponding linear (free) problem:
	$
	$
	∂_t^2 u + ∂_t u - \Delta u = 0,\
	u(0) = u_0,
	∂_t u(0) = u_1.
	$
	<label-eq:linear_damped_wave>
	$
//]]]
 
//[[[ An explicit representation of solutions to @label-eq:linear_damped_wave
An explicit representation of solutions to @label-eq:linear_damped_wave
is derived through the substitution $u(t,x)=e^{-t/2}w(t,x)$,
which transforms
@label-eq:linear_damped_wave into the wave-type equation
	$
	∂_t^2 w - \Delta w = 1/4 w,
	<label-eq:transformed_wave_equation>
	$
which highlights the wave structure; for details, see Chapter VI, Section 6 in  @CH89.
In particular, @label-eq:transformed_wave_equation yields the following
comparison principle for @label-eq:DW in one and two dimensional case:
if $\overline{u_0} ≥ \underline{u_0} $
and $\overline{u_1} + \overline{u_0}/2 ≥ \underline{u_1} + \underline{u_0}/2$,
then the solutions $\overline{u}$ of @label-eq:DW
with $\overline{u_0}, \overline{u_1}$
and $\underline{u}$ with $\underline{u_0}, \underline{u_1}$
satisfy $\overline{u}(t,x) ≥ \underline{u}(t,x)$ for all $t ≥ 0$ and $x$.
This comparison principle will be a key tool in what follows.
Hereafter, we denote by $S(t)f$ the solution to @label-eq:linear_damped_wave
corresponding to the data $(u_0,u_1)=(0,f)$.
//]]]

//[[[ Owing to the damping term $∂_t u$,
Owing to the damping term $∂_t u$,
the free solution to @label-eq:DW is
asymptotically equivalent to the solution of the free heat equation:
	$
	$
	∂_t v - \Delta v = 0,\
	v(0) = u_0 + u_1.
	$
	<label-eq:free_heat>
	$
For simplicity, we denote by $e^{t \Delta} f$
the solution to @label-eq:free_heat corresponding to the data $v(0)=f$.
Marcati and Nishihara @MN03 and Nishihara @N03
established the asymptotic equivalence
in the one- and three-dimensional cases, respectively.
Namely, for a sufficiently regular function $f$,
the following asymptotic relation holds:
	$
	S(t) f
	\sim e^{t \Delta} f + e^{-t/2} W(t) f.
	<label-eq:asymptotic_equivalence>
	$
We refer to @IIOW19 for more general results.
We note that, even before the explicit proofs by Marcati and Nishihara,
this idea had been used in the perturbative analysis of solutions to @label-eq:DW;
see, for example, @LZ95.
//]]]

//[[[ Returning to the Cauchy problem @label-eq:DW,
Returning to the Cauchy problem @label-eq:DW,
the local existence of solutions to @label-eq:DW
is known under standard regularity assumptions.
For example, a classical result can be found in @s90.
Moreover, the discussion in @MN03 implies that
$S(t)$ satisfies the same $L^p$–$L^q$ type estimates
as $e^{t \Delta}$.
Therefore, the following local existence result holds:
#lemma[[Local existence]<label-lemma:local_existence>
Assume that
$(u_0,u_1) ∈ W^{1,∞} ∩ W^{1,1} \times L^∞ ∩ L^1$ and $p > 1$ and $n =1$.
There exists
$T_1=T_1(u_0,u_1)$
such that @label-eq:DW possesses a unique mild solution
$u ∈ C\left(\left[0, T_1\right) ;W^{1,∞} ∩ W^{1,1}\right)$
satisfying the estimate
	$<label-eq2>
	\sup _{0 ≤ t ≤ T_1} \|u(t) \|_{ L^{∞}}
	\lesssim ( \|u_0 \|_{L^∞} + \|u_1 \|_{L^∞}).
	$
]
\noindent
Here
$W^{1,q}$ for $1 ≤ q ≤ ∞$ denotes the usual Sobolev space,
a collection of measurable functions $f$
such that both $f$ and its weak derivative $f^\prime$
belong to $L^q$.
We also note that $p=1+2/n$ is the so-called Fujita critical exponent,
which gives the threshold for blow-up of positive solutions to @label-eq:DW
and for the existence of global solutions to the Fujita-type heat equation:
	$
	∂_t v - \Delta v = |v|^p.
	<label-eq:fujita_equation>
	$
For details, see @F66,H73,KST77.
We also remark that when $n ∈ \mathbb N$, $p > 1+2/n$,
and the initial data are sufficiently small,
then solutions to @label-eq:DW exist globally in time.
Our subsequent analysis is based on Lemma @label-lemma:local_existence.
//]]]

//[[[ Although the solution to @label-eq:linear_damped_wave
Although the solution to @label-eq:linear_damped_wave
can be constructed explicitly from @label-eq:transformed_wave_equation,
the asymptotic equivalence @label-eq:asymptotic_equivalence
is a powerful tool for analyzing solutions to @label-eq:DW.
Roughly speaking, one may analyze solutions $u$ to @label-eq:DW
by treating $u$ as if it were $e^{t \Delta}(u_0 + u_1)$—that is,
as if $u$ behaved like the heat flow generated by the initial mass $u_0+u_1$.
For example, Li and Zhou @LZ95 showed that
when $n = 1, 2$ and $1 < p ≤ 3$,
if
	$
	∫ u_0 + u_1 dx > 0,
	<label-eq:initial_mean_condition>
	$
then, irrespective of the size of the initial data,
the solution $u$ to @label-eq:DW blows up in finite time.
Moreover, they derived sharp estimates for the lifespan in terms of the size of the initial data.
In @LZ95, the authors rigorously estimated the infimum of the solution $u$ in a parabolic region,
as if, roughly speaking, $u$ behaved like $e^{t \Delta} (u_0 + u_1)$,
and introduced an ODE governing the infimum of $u$.
Later,
Zhang @Z01,
Ikeda and Wakasugi @IW15,
and Ikeda and Sobajima @IS19
proved finite-time blow-up of
the spatial mean of solutions to @label-eq:DW
and derived lifespan estimates
in more general spatial settings,
still under the initial condition @label-eq:initial_mean_condition.
Their approach is based on the weak formulation of @label-eq:DW
and is more closely tied to the scaling properties of @label-eq:DW
than to the asymptotic equivalence @label-eq:asymptotic_equivalence.
Recently, the present authors @FG25a
showed the finite-time blow-up of solutions to @label-eq:DW
and obtained sharp lifespan estimates
under the mean-zero initial condition
	$
	∫ u_0 + u_1 dx = 0,
	\quad
	u_0, u_1 \not\equiv 0.
	<label-eq:initial_mean_condition_ours>
	$
The approach of @FG25a is inspired by that of Li and Zhou @LZ95.
We note that
the mean-zero condition @label-eq:initial_mean_condition_ours
cannot be handled by a direct application of a weak formulation approach.
We also refer to @IO16, FIW19, IS19 for related topics.
//]]]

//[[[ The arguments above do not yield
The arguments above do not yield
the sharp initial conditions for blow-up.
In particular, for any $\mu_0, \mu_1 ∈ ℝ$,
by combining the finite propagation speed
with the arguments above,
for any $\mu_0, \mu_1 ∈ ℝ$,
there exist smooth initial data $(u_0, u_1)$
satisfying
	\[
	∫ u_0 dx = \mu_0,
	\quad
	∫ u_1 dx = \mu_1,
	\]
such that the corresponding solution blows up in finite time.
More precisely,
let $\psi$ be a smooth function supported in a compact set
and its integral is $1$.
Let $L$ be a large positive number.
If
	\begin{align*}
	u_0(x) &= \psi(x) + (\mu_0-1) \psi(x-L), \
	u_1(x) &= \mu_1 \psi(x-L),
	\end{align*}
then one can show $u(t,x) = u_b(t,x) + u_g(t,x-L)$ till some time,
where $u_b$ is the blow-up solution with initial data $(u_0, u_1) = (\psi,0)$
and $u_g$ is the solution with initial data $(u_0, u_1) = ((\mu_0-1)\psi, \mu_1 \psi)$.
Since the argument above implies that
$∫ u_b + ∂_t u_b dx$ blows up in finite time
and $∫ u_g + ∂_t u_g dx$ is increasing,
there exists a time $t_0$ such that
	\[
	∫ u(t_0) + ∂_t u(t_0) dx
	= ∫ u_b(t_0) + ∂_t u_b(t_0) dx + ∫ u_g(t_0) + ∂_t u_g(t_0) dx
	> 0.
	\]
Therefore, the solution $u$ blows up in finite time
by the same argument from $t=t_0$.
//]]]

//[[[ Nevertheless,
Nevertheless,
it is also known that
there exist nontrivial global solutions to @label-eq:DW.
Li and Zhou @LZ95 also showed that,
when $n = 1, 2$ and even when $1 < p ≤ 3$,
global existence for small initial data holds for @label-eq:DW
under the following pointwise condition (for all $x$):
	$
	u_0(x) = 0,
	\quad
	u_1(x) ≤ 0.
	<label-eq:initial_condition_Li_Zhou>
	$
This was further extended to
	$
	u_0(x) ≤ 0,
	u_1(x) + \frac 1 2 u_0(x) ≤ 0.
	<label-eq:initial_condition_Li_Zhou_general>
	$
For details, see @FG25b.
The conditions @label-eq:initial_condition_Li_Zhou
and @label-eq:initial_condition_Li_Zhou_general
are used to implement a comparison argument
based on the nonlinear version of
the transformation associated with @label-eq:transformed_wave_equation.
Indeed, under @label-eq:initial_condition_Li_Zhou
and @label-eq:initial_condition_Li_Zhou_general,
solutions are shown to be negative at any time and point.
On the other hand, in other cases,
it is unclear whether
there is an initial condition
with which global solutions exist.
//]]]

//[[[ The expectation of global existence for @label-eq:DW,
The expectation of global existence for @label-eq:DW,
even with a positive initial position,
may be supported by a result of Pinsky @P16.
In @P16, it is shown that
there exist both global and blow-up solutions of @label-eq:fujita_equation
for certain sign-changing initial data.
The proof relies on a comparison argument
that is not directly applicable to @label-eq:DW
without imposing the initial condition @label-eq:initial_condition_Li_Zhou_general.
On the other hand,
since global solutions to @label-eq:DW
are known to behave similarly to global solutions of @label-eq:fujita_equation
under certain initial conditions,
the gap in the assumptions required by the comparison argument
appears to be merely technical.
//]]]

//[[[ The aim of this manuscript
The aim of this manuscript
is to generalize a sufficient condition
for global existence of solutions to @label-eq:DW.
For simplicity, we restrict our attention to the one-dimensional case.
In particular,
we show that the blow-up conditions based on the spatial integrals of the initial data,
namely @label-eq:initial_mean_condition and @label-eq:initial_mean_condition_ours,
cannot be relaxed without taking into account the shape of the initial data,
provided that the spatial integral of the initial position is positive.
More precisely, we ask the following question:
Does there exist a constant $c_0 > 0$ such that, for
	\[
	0 < \varepsilon_0 < c_0 |\varepsilon_1| \ll 1,
	\]
there exists a smooth, positive function $\varphi$ such that
the solution with initial data
$(u_0,u_1) = (\varepsilon_0 \varphi, \varepsilon_1 \varphi)$
exists globally in time?
To the best of the authors' knowledge,
global existence for @label-eq:DW
has only been established via comparison arguments.
Accordingly, we employ the following simple sufficient condition for global existence:
there exist a constant $c_0 > 0$ and a smooth, positive function $\varphi$ such that, for
	\[
	\varepsilon_0 < c_0 |\varepsilon_1| \ll 1,
	\]
the solution $u$ with initial data
$(u_0,u_1) = (\varepsilon_0 \varphi, \varepsilon_1 \varphi)$
satisfies
	$
	u(t,x) ≤ 0,\ \ ∂_t u(t,x) + 1/2u(t,x) ≤ 0
	<label-eq:aim>
	$
for all $x$ at some time $t$.
Once @label-eq:aim is verified,
Theorem 1.2 in @FG25a yields global existence.
Decay in this case is studied in @FG25b.

The following is the main statement of this manuscript,
answering the question above:
#theorem[<label-theorem:main>
Let
	$
	0 < \varepsilon_0 < -\varepsilon_1 \ll 1.
	<label-eq:condition_ratio>
	$
Then there exists a sufficiently small number $\rho$ and
a positive function $\varphi ∈ W^{2,1} ∩ W^{2,∞}$
satisfying the following pointwise control
	$<label-eq:shape_assumption> \tag{H1}
	|\varphi^\prime(x)| + |\varphi^{\prime\prime} (x)| ≤ \rho  \varphi(x) , \ \ \forall x ≥ 0
	$
and the mild solution $u ∈ C([0,T_0) \times ℝ)$ to @label-eq:DW
with initial data $(u_0,u_1) = (\varepsilon_0 \varphi, \varepsilon_1 \varphi)$
exists and satisfies the pointwise estimates @label-eq:aim
at time
	\[
	t(\varepsilon_0/|\varepsilon_1|)+\delta ∈ (0,2),
	\]
where $\delta>0$ is sufficiently small
and $t=t(\varepsilon_0/|\varepsilon_1|)$ is the unique positive solution 
of 
	$<label-eq.deft>
	\varepsilon_0/|\varepsilon_1| =  4t/(4-t)(2+t).
	$
]

We give some remarks on Theorem @label-theorem:main.
First,
the condition @label-eq:condition_ratio is optimal.
Indeed, for $\varepsilon_0 + \varepsilon_1 ≥ 0$,
we can apply Theorem 1.1 in @FG25a and deduce blow-up.
Second,
for any positive $\rho$,
there exists a function $\varphi ∈ W^{2,1} ∩ W^{2,∞}$
satisfying @label-eq:shape_assumption.
Indeed, let $N$ be an integer, $a >1$, and
	\[
	\varphi(x) = (N^2+x^2)^{-a/2}
	\]
then $\varphi ∈ W^{2,1} ∩ W^{2,∞}$ and
	\begin{align*}
	|\varphi^\prime(x)| &≤ a/N \varphi(x),\
	|\varphi^{\prime\prime}(x)| &≤ a(a+1)/N^2 \varphi(x),
	\end{align*}
so $\rho = a/N + a(a+1)/N^2 \to 0$ as $N \to ∞.$
Third,
the condition @label-eq:shape_assumption plays an important role
in obtaining the pointwise estimate @label-eq:aim.
In particular, @label-eq:shape_assumption implies that
solutions $u$ are estimated by $\varphi$ pointwisely up to a certain time,
and this pointwise control implies the conclusion.
Finally,
the function
	\[
	a(t) = 4t/(4-t)(2+t)
	\]
is strictly increasing for $t ∈ (0,2)$, with $a(0)=0$ and $a(2)=1$.
Therefore, the unique positive solution $t ∈ (0,2)$ of @label-eq.deft is well-defined.
The smallness of $\delta$ is determined by
	\[
	\delta < b(t)-a(t),
	\]
where
	\[
	b(t) = 8t/(2+t)^2.
	\]
The proof that $b(t)>a(t)$ for $t ∈ (0,2)$ is elementary
and can be found at the end of the proof of Theorem @label-theorem:main.

We note that
it is still unclear whether
there exists a global solution to @label-eq:DW
in the case where $(u_0,u_1) = (\varepsilon_0 \varphi, \varepsilon_1 \varphi)$
with smooth positive $\varphi$
and $\varepsilon_0$ and $\varepsilon_1$ are sufficiently small and satisfy
	\[
	\varepsilon_0 < 0,\quad
	\varepsilon_1 > 0,\quad
	\varepsilon_0 + \varepsilon_1 < 0,\quad
	\mbox{and} \
	\varepsilon_1 + \varepsilon_0/2 > 0.
	\]

In the next section, we collect some preliminary estimates.
Theorem @label-theorem:main is shown in the last section.
//]]]

= Preliminary

We, at first, show the estimate
for the solution to the Cauchy problem for a nonhomogeneous wave equation.

#lemma[<label-lemma:estimate_of_transformed_wave>
Let $g ∈ W^{1,∞}$ and $f, w ∈ L^∞(0,2;L^∞)$.
Then there exists a unique $L^∞$ valued mild solution $v$
to the following Cauchy problem:
	\[
	$
	∂_t^2 v + ∂_t v - ∂_x^2 v  = f w+g ∂_x w,\
	v(0,x)= \varepsilon_0,\
	∂_t v(0,x)= \varepsilon_1.
	$
	\]
Moreover, $v$ enjoys the following estimate:
	$
	\|v(t)\|_{L^∞}
	& ≤ \varepsilon_0 e^{-t} + (\varepsilon_0 + \varepsilon_1) (1-e^{-t})\
	& + C t \bigg(
		\|f\|_{L^∞(0,t; L^∞)} + \| g \|_{W^{1,∞}}
	\bigg) \|w\|_{L^∞(0,t; L^∞)}.
	<label-1dmax>
	$
]

\begin{proof}
We recall that a standard Duhamel formula implies that
	\begin{align*}
	v(t,x)
	&= \varepsilon_0 e^{-t}
	+ ( \varepsilon_0 + \varepsilon_1 )(1-e^{-t})\
	&+ ∫_0^t S(t-\tau) f(\tau) w(\tau)(x) d\tau
	+ ∫_0^t S(t-\tau) g ∂_x w(\tau,x) d\tau,
	\end{align*}
where
	\[
	S(t) h(x)
	= 1/2 e^{-t/2} ∫_{-t}^{t} I_0 \bigg( \frac{sqrt(t^2-y^2)}{2} \bigg) h(x+y) d y.
	\]
We note that by denoting $\omega = sqrt(t^2-y^2)$ we have
	\[
	e^{-t/2} I_0 \bigg( \omega/2 \bigg)
	≤ \langle \omega \rangle^{-1/2} e^{(\omega - t/2)}
	≤ C \langle t \rangle^{-1/2} e^{-y^2/8t}.
	\]
Therfore, a straightforward calculation shows that
	\[
	\| S(t-\tau) f(\tau) w(\tau) \|_{L^∞}
	≤ C \| f(\tau) \|_{L^∞} \| w(\tau) \|_{L^∞}.
	\]
We note that by writing $\sigma = t-\tau$ we have
	\begin{align*}
	e^{\sigma/2} S(\sigma) g ∂_x w(\tau)(x)
	&= ∫_{-\sigma}^{\sigma} I_0 \bigg( \frac{sqrt(\sigma^2-y^2)}{2} \bigg) g(x+y) ∂_x w(\tau, x+y) dy\
	&= g(x+\sigma) w(\tau,x+\sigma) - g(x-\sigma) w(\tau,x-\sigma)\
	&- ∫_{-\sigma}^{\sigma} I_0 \bigg( \frac{sqrt(\sigma^2-y^2)}{2} \bigg) \dot g(x+y) w(\tau,x+y) dy\
	&+ ∫_{-\sigma}^{\sigma} I_1 \bigg( \frac{sqrt(\sigma^2-y^2)}{2} \bigg) y/sqrt(\sigma^2-y^2) g(x+y) w(\tau,x+y) dy.
	\end{align*}
We note that by writing $\omega = sqrt(\sigma^2-y^2)$,
we have
	\[
	\bigg| e^{-\sigma/2} y/\omega I_1(\omega/2) \bigg|
	≤ C y/\langle \omega \rangle^{3/2} e^{(\omega - \sigma)/2}
	≤ C \langle \sigma \rangle^{-1/2} e^{-y^2/8\sigma}.
	\]
Thereore, we have
	\[
	\| S(t-\tau) g(\tau) ∂_x w(\tau) \|_{L^∞}
	≤ C \| g \|_{W^{1,∞}} \| w(\tau) \|_{L^∞}
	\]
and this implies @label-1dmax.
\end{proof}

By using Lemma @label-lemma:estimate_of_transformed_wave,
we mesure the difference between $u(t)$ and initial position $\varphi$
under a certain condition by using their ratio.

#lemma[[Refined local estimates]
<label-lemma:estaimte_of_u_devided>
Let $\varepsilon_0$ and $\varepsilon_1$ are real constans sufficiently close to $0$
satisfying $0 < \varepsilon_0 < - \varepsilon_1$.
Let $t ∈ (0,T_0)$ and $\rho >0$ satisfy
	$
	C ( |\varepsilon_1|^{p-1} + \rho ) t < 1
	<label-eq:condition_for_u_devided>
	$
with a positive constant $C$.
Assume that $\varphi ∈ W^{2,1} ∩ W^{2,∞}$
satisfy @label-eq:shape_assumption.
If the mild solution $u$ of Lemma @label-lemma:local_existence
with initial data $(u_0,u_1) = (\varepsilon_0,\varepsilon_1)$
satsify 
	\[
	\| |u|^{p-2}u\|_{L^∞(0,T_0; L^∞)}
	+ \bigg\|\ddot \varphi/\varphi \bigg\|_{L^∞}
	+ \bigg\|\dot \varphi^2/\varphi^2 \bigg\|_{L^∞}
	≤ C ( \varepsilon_1^{p-1} + \rho ).
	\]
Then $u$ enjoys the following estimate for $t ∈ (0,T_0)$:
	$<label-eq2mm>
	\left\| u(t)/\varphi \right\|_{ L^{∞}}
	≤ \frac{|\varepsilon_0 e^{-t} + (\varepsilon_1 + \varepsilon_0)(1-e^{-t})|}{1-C ( |\varepsilon_1|^{p-1} + \rho ) t}.
	$
]

\begin{proof}
We make the substitution
	\[
	v(t,x) = u(t,x)/\varphi(x),
	\]
so we have
	\begin{align*}
    ∂_t^2 v + ∂_t v - ∂_x^2 v
	 = |u|^p/\varphi
	 + 2 \dot \varphi ∂_x u/\varphi^2
	 + \ddot \varphi/\varphi^2 u
	 - 2 \dot \varphi^2/\varphi^3 u
	\end{align*}
Since
	\[
	∂_x u = v \dot \varphi  + \varphi ∂_x v
	\]
we arrive at
	\[
	∂_t^2 v + ∂_t v - ∂_x^2 v \
	= \bigg( |u|^{p-2} u + \ddot \varphi/\varphi \bigg) v
	+ 2 \dot \varphi/\varphi ∂_x v
	\]
Therefore, the Cauchy problem can be rewritten as
	\begin{align*}
	$
	∂_t^2 v + ∂_t v - ∂_x^2 v  = f v+g∂_xv, \
	v(0,x)=\varepsilon_0 , & x ∈ \mathbb R, \
	∂_t v(0,x) =\varepsilon_1 , & x ∈ \mathbb R.
	$
	\end{align*}
with 
	\[
	f = |u|^{p-2}u  + \ddot \varphi/\varphi,
	\quad
	g =  2  \dot \varphi/\varphi.
	\]
Noting
	\[
	\dot g = 2 \ddot \varphi/\varphi - 2 \dot \varphi^2/\varphi^2
	\]	
and applying Lemma @label-lemma:local_existence
and the assumption @label-eq:shape_assumption,
\[
\|f\|_{L^∞(0,T_0; L^∞)}
≤ C_1 ( |\varepsilon_1|^{p-1} + \rho )
\]
and $\|g\|_{W^{1,∞}} ≤ C_1 \rho$
with some positive constants $C_1$.
\end{proof}

Next estimate plays an important role
to estimate the solution on the basis of initial data.

#lemma[[Hermite–Hadamard]<label-l3>
Let $\phi$ be $C^1(\mathbb R; [0,∞))$,
such that there is a positive constant $\rho$ so that
$<label-eq.bb1>
 &  |\dot \phi(x)| ≤ \rho  \phi(x) , \ \ \forall x ≥ 0.
$
Then we have
$<label-eq.HH1>
      &  \phi(\alpha) + \phi(\beta)/2 ≤  1/\beta - \alpha ∫_{\alpha}^{\beta} \phi(\sigma) d \sigma + \rho/2 ∫_{\alpha}^\beta \phi(\sigma) d \sigma
$
and
$<label-eq.HH1mm>
      &  \phi(\alpha) + \phi(\beta)/2 ≥  1/\beta - \alpha ∫_{\alpha}^{\beta} \phi(\sigma) d \sigma -\rho/2 ∫_{\alpha}^\beta \phi(\sigma) d \sigma
$
for $0  ≤  \alpha < \beta < ∞.$
]

\begin{proof}
We use the following identity, obtained in @DA98
(see Lemma 2.1 in @DA98)
	\[
	 \phi(\alpha) + \phi(\beta)/2 - 1/\beta - \alpha ∫_{\alpha}^{\beta} \phi(\sigma) d \sigma
	= \beta -  \alpha/2 ∫_0^1 (1-2t) \dot \phi(t \alpha + (1-t)\beta) dt.
	\]
Then we can write
	\begin{align*}
	 \phi(\alpha) + \phi(\beta)/2 - 1/\beta - \alpha ∫_{\alpha}^{\beta} \phi(\sigma) d \sigma
	& = \beta - \alpha/2 ∫_0^1 (1-2t) \dot \phi(t \alpha + (1-t)\beta) dt \
	& ≤ \beta - \alpha/2 ∫_{0}^1  | \dot \phi(t \alpha + (1-t)\beta)| dt \
	&  = 1/2∫_{\alpha}^{\beta} |\dot \phi(\sigma)| d \sigma.
	\end{align*}
Assuming @label-eq.bb1, we get
@label-eq.HH1.

It is easy to extend this estimate also to the cases $\alpha < 0 < \beta$ and $\alpha < \beta <0$
using the additional assumption that $\phi$ is an even function.
In fact, when $\alpha < 0 < \beta$ we define the interval $J⊂ [0,∞)$ with ends $-\alpha$ and $\beta$ and then we can apply @label-eq.HH1 so we have
	$<label-eq.HH1m>
	 \phi(\alpha) + \phi(\beta)/2
	=  \phi(-\alpha) + \phi(\beta)/2
	≤  1/|J| ∫_{J} \phi(\sigma) d \sigma
	+ \rho/2 ∫_{J } \phi(\sigma) d \sigma.
	$
This completes the proof.
\end{proof}

We finalize this section
by collecting some estimates of calculs to control nonlinaerity.
Consider the function
	$<label-eq.dC>
	C(t,r,\rho,\varepsilon_1)
	= \sup_{\tau ∈ [0,t]} G(\tau,r,\rho,\varepsilon_1),
	$
where
	\[
	G(\tau,r,\rho,\varepsilon_1)
	=  |r - \tau(1 - r)|/1-C ( |\varepsilon_1|^{p-1 + \rho ) \tau}
	\]
under the assumption @label-eq:condition_for_u_devided is satisfied.
Here $\rho$ is a positive number and $\varepsilon_1$ is a negative number
which are close to $0$.

#lemma[<label-l.61>
We have the relation
$
\begin{aligned}
& C(t,r,\rho,c_0) =  \max \left(r , t(1-r/2)-r /(1-t^2/4) \right)+ O(\rho+|c_0-1/4|).
\end{aligned}
$   
]

\begin{proof}
    The function $G(\tau,r,\rho,c_0)$ is at least $C^1$ with respect  to $\rho, c_0$ in a small neighbourhood of $(0,1/4)$ so it is sufficient to consider the case $\rho=0$ and $c_0=1/4.$
Then we have the relation
$
  G(\tau,r,0,1/4) = \left\{ \begin{aligned}
    & \tau(1-r/2)-r/1- \tau^2/4)  \ \mbox{if $\tau>2r/(2-r)$},\
    &  r-\tau(1-r/2)/(1-\tau^2/4) \ \mbox{if $0 ≤ \tau<2r/(2-r)$}.
  \end{aligned}\right.  
$
In the interval $[0,2r/(2-r)]$ it is decreasing since 
we have
$
    ∂_t G(\tau,r,0,1/4) = 2\tau^2(r-2) + 4\tau r +4(r-2) /(4-\tau^2)^2 < 0 
$
for $\tau ∈ [0,2r/(2-r))$ and $r ∈ [0,1).$ For $\tau > 2r/2-r$ it is increasing so
$
\begin{aligned}
    & C(t,r,\rho,c_0) =  \sup_{\tau ∈ [0,t]}  G(\tau,r,\rho,c_0) \
    &  = \sup_{\tau ∈ [0,t]} G(\tau,r,0,1/4)+ O(\rho+|c_0-1/4|)\
    & = \max \left(r , t(1-r/2)-r /(1-t^2/4) \right)+ O(\rho+|c_0-1/4|).
\end{aligned}
$



for $0≤ r < 1$.
\end{proof}

#corollary[<label-c62>
We have the relation
	$
	C(t,r,0,1/4) =
	$
	t(1-r/2)-r /(1-t^2/4)
	& \mbox{if} \quad r < r_t,\
	r
	& \mbox{if} \quad r ≥ r_t,
	$
	$
where
	\[
	r_t
	= 4t/8+2t-t^2
	= 4t/(4-t)(2+t).
	\]
]

//[[[ = Comparison principle
= Proof of Theorem @label-theorem:main
//[[[ Proposition Comparison Principle
$w = e^{t/2} u$ is a solution to the Cauchy problem
	$<label-CPa1>
	$
	∂_t^2 w - \Delta w = \left(1/4 + u|u|^{p-2} \right) w,
	& t ∈ (0,T_0), \ x ∈ \mathbb R,\
	w(0)=\varepsilon_0 \varphi(x),
	& x ∈ \mathbb R,\
	∂_t w(0) =\varepsilon_1\varphi(x)+\varepsilon_0/2\varphi(x),
	& x ∈ \mathbb R.
	$
	$
	
The D'Alembert formula implies
\begin{align*}
    &w(t) = \varepsilon_0 d/dt W(t) (\varphi)(x) + \left(\varepsilon_1 + \varepsilon_0/2 \right) W(t)(\varphi)(x)\
    &+ ∫_0^t W(t-\tau)\left( \left(1/4+u(\tau)|u(\tau)|^{p-2}\right) w(\tau) \right) (x) d\tau,
\end{align*}
where
	\[
	W(t)(f)(x) = 1/2 ∫_{x-t}^{x+t} f(\tau) d\tau,
	\]
so
	\begin{align*}
	&∂_t w(t,x) =  \varepsilon_0 \left(d/dt\right)^2 W(t) (\varphi)(x) + \left(\varepsilon_1 + \varepsilon_0/2 \right) d/dt W(t)(\varphi)(x)\
	&+ ∫_0^t d/dt W(t-\tau)\left( \left(1/4+u(\tau)|u(\tau)|^{p-2}\right) w(\tau) \right) (x) d\tau
	\end{align*}

Set 
	\[
	r = \varepsilon_0/|\varepsilon_1|
	\]
and $r∈ [0,1)$ follows from the assumption @label-eq:condition_ratio.

The idea of the proof is to define the set
$<label-eq.dA>
\mathcal{A}
= \{r ∈ [0,1); \exists (t,\varepsilon_0, \varepsilon_1, \varphi), \  w(t,x) ≤ 0,\  ∂_t w(t,x) ≤ 0 \ \mbox{for a.e.} \ \  x ∈ ℝ \}
$
and show that $\mathcal{A}$ covers the whole interval $[0,1),$ i.e.
$<label-Asup>
    \begin{aligned}
        \mathcal{A} ⊃ [0,1).
    \end{aligned}
$

We start with a sufficient condition that guaranties $∂_t w(t,x) ≤ 0$ for almost every $x ∈ ℝ.$
#lemma[
<label-lemma:condition_for_negative_speed>
Let the assumption of Lemma @label-lemma:estaimte_of_u_devided
be satisfied.
Let $\rho$ be the parameter from assumption @label-eq:shape_assumption
and $c_0$ be a number close to $1/4.$
If $C(t,r,\rho,c_0)$ defined by @label-eq.dC satisfies the estimate
	$<label-eq.a1>
	c_0/2 C(t,r,\rho,c_0)
	≤ \bigg(1 - r \bigg( \rho + 1/2 \bigg) \bigg) \bigg( 1/2t - \frac \rho 2 \bigg)
	$
then $∂_t w(t,x) ≤ 0$ for a.e. $x ∈ ℝ.$
]

\begin{proof}
The D'Alembert formula gives
$
    \begin{aligned}
   &∂_t w(t,x)\
	&= \varepsilon_0 \varphi^\prime(x+t)- \varphi^\prime(x-t)/2 
	+ \left(\varepsilon_1 + \varepsilon_0/2 \right) \varphi(x+t) + \varphi(x-t)/2 \
    & + ∫_0^t d/dt W(t-\tau)\left( \left(1/4+u(\tau)|u(\tau)|^{p-2}\right) w(\tau) \right) (x) d\tau.
    \end{aligned}
$

 
Then using @label-eq2mm in  Lemma @label-lemma:estimate_of_transformed_wave,
we obtain 
	\begin{align*}
	&∫_0^t d/dt W(t-\tau)\left( \left(1/4+u(\tau)|u(\tau)|^{p-2}\right) w(\tau) \right) (x) d\tau \
	& ≤ c_0 ∫_0^t d/dt W(t-\tau) ( w(\tau) ) (x) d\tau \
	&=  c_0/2∫_0^t \left(  w(\tau, x+t-\tau) +  w(\tau, x-t+\tau) \right) d\tau \
	& ≤ c_0/2\max_{0≤ \tau ≤ t}  |\varepsilon_0 + \tau(\varepsilon_1 + \varepsilon_0/2)|/(1-c_0 \tau^2-2c_0\rho \tau^2 - 2 \rho \tau)
	∫_0^t \left(  \varphi(x+t-\tau) +  \varphi( x-t+\tau) \right) d\tau\
	& ≤ c_0/2| \varepsilon_1 | C(t,r) ∫_{-t}^t  \varphi(x+\sigma) d\sigma.
	\end{align*}

Using  @label-eq:shape_assumption, we obtain
	\begin{align*}
	&∂_t w(t,x)\
	&≤ \varepsilon_0 \varphi^\prime(x+t)- \varphi^\prime(x-t)/2 
	+ \left(\varepsilon_1 + \varepsilon_0/2 \right) \varphi(x+t) + \varphi(x-t)/2 \
	& + c_0/2 |\varepsilon_1| C(t,r) ∫_{-t}^t  \varphi(x+\sigma) d\tau\
	& ≤ \left(\varepsilon_0 \rho + \varepsilon_1 + \varepsilon_0/2\right)\varphi(x+t) + \varphi(x-t)/2
	+ c_0/2| \varepsilon_1 | C(t,r)
	∫_{-t}^t  \varphi(x+\sigma) d\sigma.
	\end{align*}

Lemma @label-l3 implies
	$<label-eq.HH1m1>
	\varphi(x+t) + \varphi(x-t)/2
	≥  \left( 1/2t - \frac \rho 2 \right)
	∫_{-t}^t  \varphi(x+\sigma) d\tau. 
	$

Then we estimate
	$
	<label-HH2>
	∂_t w(t,x)
	&≤ |\varepsilon_1| A(t,r) ∫_{-t}^t  \varphi(x+\sigma) d\tau,
	$
where 
	\[
	A(t,r) =
	- \bigg(1 - r \bigg( \rho + 1/2 \bigg) \bigg) \bigg( 1/2t - \frac \rho 2 \bigg)
	+ c_0/2 C(t,r, \rho,c_0).
	\]
Therefore, the condition @label-eq.a1 implies $A(t,r) ≤ 0$
and hence $∂_t w(t,x) ≤ 0$ a.e.
This completes the proof.
\end{proof}


#lemma[
<label-lemma:condition_for_negative_position>
Let the assumption of Lemma @label-lemma:estaimte_of_u_devided
be satisfied.
If the inequality
	$<label-eq.a2>
   c_0/2t  C(t,r,\rho,c_0)
	≤ 1 - \bigg( \rho+1/2 + 1/2t\bigg) r
	$
holds, then
$ w (t,x) ≤ 0$ for a.e. $x ∈ ℝ$.
Here $C(t,r,\rho,c_0)$ is defined in @label-eq.dC.
]
 \begin{proof}
     We have
     \begin{align*}
	&w(t,x)\
	&≤ \varepsilon_0 \varphi(x+t)+ \varphi(x-t)/2 
	+ \left(\varepsilon_1 + \varepsilon_0/2 \right) ∫_{-t}^{t}\varphi(x+\tau)/2 d\tau \
	& + c_0/2|\varepsilon_1| C(t,r) ∫_0^t ∫_{\tau-t}^{t-\tau}\varphi(x+\sigma) d\sigma d\tau\
	&≤
	- |\varepsilon_1|
	\bigg\{
		1
		- \bigg( \rho+1/2 + 1/2t\bigg) r
		- c_0/2 t  C(t,r)
	\bigg\}
	∫_{-t}^t \varphi(x+\sigma) d\sigma.
	\end{align*}
 \end{proof}

In view of the above Lemmas
@label-lemma:estaimte_of_u_devided,
@label-lemma:condition_for_negative_speed,
and @label-lemma:condition_for_negative_position,
$\mathcal{A}$ contains the following set.
	\[
	\mathcal{B}
	= \{r ∈ [0,1); \exists (t,c_0,\rho)\
	\mathrm{satisfying}\
	@label-eq:condition_for_u_devided,\
	@label-eq.a1,\
	\mathrm{and}\ @label-eq.a2\}
	\]
Indeed, if $r ∈ \mathcal{B}$, then
there exits $(\varepsilon_0, \varepsilon_1, \varphi)$
such that $r=\varepsilon_0/|\varepsilon_1|$ and the assumptions
@label-eq:condition_for_u_devided is satisfied.
Therefore, $r ∈ \mathcal{A}$.

The definition @label-eq.dC and Corollary @label-c62 imply
	$
	C(t,r,0,1/4) =
	$
	t(1-r/2)-r /(1-t^2/4)
	& \mbox{if} \ r < 4t/(8+2t-t^2),\
	r
	& \mbox{if} \ r > 4t/(8+2t-t^2).
	$
	$
Therefore, a sufficient condition for $r ∈ \mathcal B$
is that whether $r ∈ [0,1)$ satisfies
that there exists $t ∈ (0,2)$ such that
{\color{blue} A sufficient condition for 
$r∈ B$
is that 
$r ∈ (0,1)$
and there exists $t$
such that 
}



the following two inequalities hold:
	$<label-sys1>
	$
	1/8  \left(t(1-r/2)-r /(1-t^2/4)  \right)
	< \bigg(1 - r/2  \bigg) \bigg( 1/2t \bigg),\
	1/8 t  \left(t(1-r/2)-r /(1-t^2/4)  \right)
	< 1 - \bigg( 1/2 + 1/2t\bigg) r,\
	r
	< 4t/(4-t)(2+t)
	$
	$
and
	$<label-sys2>
	$
	1/8  r
	< \bigg(1 - r/2  \bigg) \bigg( 1/2t \bigg),\
	1/8 t  r
	< 1 - \bigg( 1/2 + 1/2t\bigg) r,\
	r > 4t/(4-t)(2+t).
	$
	$
In particular, if $r ∈ [0,1)$ admits some $t ∈ (0,2)$
such that $(t,r)$ satisfies either @label-sys1 or @label-sys2,
then one can choose $c_0$ sufficiently close to $1/4$
and $\rho>0$ sufficiently small
so that the assumptions @label-eq:condition_for_u_devided, @label-eq.a1 and @label-eq.a2
in Lemmas @label-lemma:condition_for_negative_speed
and @label-lemma:condition_for_negative_position are satisfied.
Consequently,
$\mathcal B$ contains the following set:
	\[
	\mathcal C
	= \{r ∈ [0,1); \exists t, \ (t,r) \ \mbox{is a solution to @label-sys2}\}.
	\]

Finally, we show that $\mathcal C ⊃ [0,1)$.
The system @label-sys2 is equivalent to
	$<label-sys4>
	$
	r <   4/2+t,\
	r < 8t/(2+t)^2,\
	r > 4t/(4-t)(2+t).
	$
	$
 A positive solution $r$ can be found iff
	\[
	4t/(4-t)(2+t) < \min \left(4/2+t, 8t/(2+t)^2  \right) .
	\]
Note that for $t ∈ [0,4)$
	\[
	4t/(4-t)(2+t) < 4/2+t
	\]
is equivalent to $t <2$ and
	\[
	4t/(4-t)(2+t) < 8t/(2+t)^2
	\]
is equivalent to $t <2.$
Therefore the interval
	\begin{align*}
	I(t) &= (a(t),b(t)), \
	a(t) &= 4t/(4-t)(2+t) , \
	b(t) &= \min \left(4/2+t, 8t/(2+t)^2  \right) 
	\end{align*}
is nonempty for any $t ∈ (0,2).$ Note that
	\[
	8t/(2+t)^2 < 4/2+t
	\]
for $t ∈ (0,2).$ Therefore,
	\[
	b(t) = 8t/(2+t)^2.
	\]
The function $a$ is increasing on $[0,4)$, because
	\[
	a(t)
	= 4/4-t\bigg( 1 - 2/t+2 \bigg).
	\]
Moreover, $a(0)=0 $ and $ a(2)=b(2)=1$ imply that 
	\[
	\mathcal{A} ⊃ \mathcal{B} ⊃ \mathcal{C} ⊃ [0,1).
	\]
This completes the proof.
\bibliographystyle{plain}

//\bibliography{L1Dec}
//\bibliography{DIA}

\bibliography{../DIA}
//\bibliography{GlobalSOLNEG/DIA}

//]]]

//\bibliographystyle{plain}
//\bibliography{DAMP}

// \end{document}