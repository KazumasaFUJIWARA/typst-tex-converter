= Introduction
<introduction>
In this note, we consider the behavior of solutions to the Cauchy
problem for the semilinear damped wave equation
$ cases(delim: "{", partial_t^2 u + partial_t u - Delta u = \| u \|^p \, & t > 0 \, x in bb(R)^n \,, u \( 0 \) = u_0 \, partial_t u \( 0 \) = u_1 \, & x in bb(R)^n .) $<eq:DW>
The aim of this manuscript is to establish the global existence of
solutions under the initial conditions
$  & (u_0 \, u_1) = (epsilon_0 phi \, epsilon_1 phi) \,\
 & 0 < epsilon_0 < \| epsilon_1 \| = - epsilon_1 . $<eq:initial_condition>
with $n = 1$, $(epsilon_0 \, epsilon_1) in bb(R)^2$ small, and $phi$
being a regular non-negative function.

The Cauchy problem #link(<eq:DW>)[\[eq:DW\]] has been extensively
studied (see @M76, @TY01, @N03, @MN03, @HKN04, @INZ06, @DA15, @DLR15
@IIOW19, @FIW19, @LT19, @IS19, @CR21, @KK22, and references therein). A
key step for analyzing the nonlinear problem #link(<eq:DW>)[\[eq:DW\]]
is to first understand the corresponding linear (free) problem:
$ {partial_t^2 u + partial_t u - Delta u = 0 \,\
u \( 0 \) = u_0 \, partial_t u \( 0 \) = u_1 . $<eq:linear_damped_wave>

An explicit representation of solutions to
#link(<eq:linear_damped_wave>)[\[eq:linear\_damped\_wave\]] is derived
through the substitution $u \( t \, x \) = e^(- t \/ 2) w \( t \, x \)$,
which transforms
#link(<eq:linear_damped_wave>)[\[eq:linear\_damped\_wave\]] into the
wave-type equation
$ partial_t^2 w - Delta w = 1 / 4 w \, $<eq:transformed_wave_equation>
which highlights the wave structure; for details, see Chapter VI,
Section 6 in @CH89. In particular,
#link(<eq:transformed_wave_equation>)[\[eq:transformed\_wave\_equation\]]
yields the following comparison principle for #link(<eq:DW>)[\[eq:DW\]]
in one and two dimensional case: if $overline(u_0) gt.eq underline(u_0)$
and
$overline(u_1) + overline(u_0) \/ 2 gt.eq underline(u_1) + underline(u_0) \/ 2$,
then the solutions $overline(u)$ of #link(<eq:DW>)[\[eq:DW\]] with
$overline(u_0) \, overline(u_1)$ and $underline(u)$ with
$underline(u_0) \, underline(u_1)$ satisfy
$overline(u) \( t \, x \) gt.eq underline(u) \( t \, x \)$ for all
$t gt.eq 0$ and $x$. This comparison principle will be a key tool in
what follows. Hereafter, we denote by $S \( t \) f$ the solution to
#link(<eq:linear_damped_wave>)[\[eq:linear\_damped\_wave\]]
corresponding to the data $\( u_0 \, u_1 \) = \( 0 \, f \)$.

Owing to the damping term $partial_t u$, the free solution to
#link(<eq:DW>)[\[eq:DW\]] is asymptotically equivalent to the solution
of the free heat equation: $ {partial_t v - Delta v = 0 \,\
v \( 0 \) = u_0 + u_1 . $<eq:free_heat> For simplicity, we denote by
$e^(t Delta) f$ the solution to #link(<eq:free_heat>)[\[eq:free\_heat\]]
corresponding to the data $v \( 0 \) = f$. Marcati and Nishihara @MN03
and Nishihara @N03 established the asymptotic equivalence in the one-
and three-dimensional cases, respectively. Namely, for a sufficiently
regular function $f$, the following asymptotic relation holds:
$ S \( t \) f tilde.op e^(t Delta) f + e^(- t \/ 2) W \( t \) f . $<eq:asymptotic_equivalence>
We refer to @IIOW19 for more general results. We note that, even before
the explicit proofs by Marcati and Nishihara, this idea had been used in
the perturbative analysis of solutions to #link(<eq:DW>)[\[eq:DW\]];;
see, for example, @LZ95.

Returning to the Cauchy problem #link(<eq:DW>)[\[eq:DW\]];, the local
existence of solutions to #link(<eq:DW>)[\[eq:DW\]] is known under
standard regularity assumptions. For example, a classical result can be
found in @s90. Moreover, the discussion in @MN03 implies that
$S \( t \)$ satisfies the same $L^p$--$L^q$ type estimates as
$e^(t Delta)$. Therefore, the following local existence result holds:

#block[
#strong[Lemma 1] (Local existence). #emph[Assume that
$\( u_0 \, u_1 \) in W^(1 \, oo) sect W^(1 \, 1) times L^oo sect L^1$
and $p > 1$ and $n = 1$. There exists $T_1 = T_1 \( u_0 \, u_1 \)$ such
that #link(<eq:DW>)[\[eq:DW\]] possesses a unique mild solution
$u in C (lr([0 \, T_1)) ; W^(1 \, oo) sect W^(1 \, 1))$ satisfying the
estimate
$ sup_(0 lt.eq t lt.eq T_1) parallel u \( t \) parallel_(L^oo) lt.tilde \( parallel u_0 parallel_(L^oo) + parallel u_1 parallel_(L^oo) \) . $<eq2>]

] <lemma:local_existence>
Here $W^(1 \, q)$ for $1 lt.eq q lt.eq oo$ denotes the usual Sobolev
space, a collection of measurable functions $f$ such that both $f$ and
its weak derivative $f'$ belong to $L^q$. We also note that
$p = 1 + 2 \/ n$ is the so-called Fujita critical exponent, which gives
the threshold for blow-up of positive solutions to
#link(<eq:DW>)[\[eq:DW\]] and for the existence of global solutions to
the Fujita-type heat equation:
$ partial_t v - Delta v = \| v \|^p . $<eq:fujita_equation> For details,
see @F66@H73@KST77. We also remark that when $n in bb(N)$,
$p > 1 + 2 \/ n$, and the initial data are sufficiently small, then
solutions to #link(<eq:DW>)[\[eq:DW\]] exist globally in time. Our
subsequent analysis is based on Lemma @lemma:local_existence.

Although the solution to
#link(<eq:linear_damped_wave>)[\[eq:linear\_damped\_wave\]] can be
constructed explicitly from
#link(<eq:transformed_wave_equation>)[\[eq:transformed\_wave\_equation\]];,
the asymptotic equivalence
#link(<eq:asymptotic_equivalence>)[\[eq:asymptotic\_equivalence\]] is a
powerful tool for analyzing solutions to #link(<eq:DW>)[\[eq:DW\]];.
Roughly speaking, one may analyze solutions $u$ to
#link(<eq:DW>)[\[eq:DW\]] by treating $u$ as if it were
$e^(t Delta) \( u_0 + u_1 \)$---that is, as if $u$ behaved like the heat
flow generated by the initial mass $u_0 + u_1$. For example, Li and Zhou
@LZ95 showed that when $n = 1 \, 2$ and $1 < p lt.eq 3$, if
$ integral u_0 + u_1 d x > 0 \, $<eq:initial_mean_condition> then,
irrespective of the size of the initial data, the solution $u$ to
#link(<eq:DW>)[\[eq:DW\]] blows up in finite time. Moreover, they
derived sharp estimates for the lifespan in terms of the size of the
initial data. In @LZ95, the authors rigorously estimated the infimum of
the solution $u$ in a parabolic region, as if, roughly speaking, $u$
behaved like $e^(t Delta) \( u_0 + u_1 \)$, and introduced an ODE
governing the infimum of $u$. Later, Zhang @Z01, Ikeda and Wakasugi
@IW15, and Ikeda and Sobajima @IS19 proved finite-time blow-up of the
spatial mean of solutions to #link(<eq:DW>)[\[eq:DW\]] and derived
lifespan estimates in more general spatial settings, still under the
initial condition
#link(<eq:initial_mean_condition>)[\[eq:initial\_mean\_condition\]];.
Their approach is based on the weak formulation of
#link(<eq:DW>)[\[eq:DW\]] and is more closely tied to the scaling
properties of #link(<eq:DW>)[\[eq:DW\]] than to the asymptotic
equivalence
#link(<eq:asymptotic_equivalence>)[\[eq:asymptotic\_equivalence\]];.
Recently, the present authors @FG25a showed the finite-time blow-up of
solutions to #link(<eq:DW>)[\[eq:DW\]] and obtained sharp lifespan
estimates under the mean-zero initial condition
$ integral u_0 + u_1 d x = 0 \, quad u_0 \, u_1 equiv.not 0 . $<eq:initial_mean_condition_ours>
The approach of @FG25a is inspired by that of Li and Zhou @LZ95. We note
that the mean-zero condition
#link(<eq:initial_mean_condition_ours>)[\[eq:initial\_mean\_condition\_ours\]]
cannot be handled by a direct application of a weak formulation
approach. We also refer to @IO16@FIW19@IS19 for related topics.

The arguments above do not yield the sharp initial conditions for
blow-up. In particular, for any $mu_0 \, mu_1 in bb(R)$, by combining
the finite propagation speed with the arguments above, for any
$mu_0 \, mu_1 in bb(R)$, there exist smooth initial data
$\( u_0 \, u_1 \)$ satisfying
$ integral u_0 d x = mu_0 \, quad integral u_1 d x = mu_1 \, $ such that
the corresponding solution blows up in finite time. More precisely, let
$psi$ be a smooth function supported in a compact set and its integral
is $1$. Let $L$ be a large positive number. If
$ u_0 \( x \) & = psi \( x \) + \( mu_0 - 1 \) psi \( x - L \) \,\
u_1 \( x \) & = mu_1 psi \( x - L \) \, $ then one can show
$u \( t \, x \) = u_b \( t \, x \) + u_g \( t \, x - L \)$ till some
time, where $u_b$ is the blow-up solution with initial data
$\( u_0 \, u_1 \) = \( psi \, 0 \)$ and $u_g$ is the solution with
initial data $\( u_0 \, u_1 \) = \( \( mu_0 - 1 \) psi \, mu_1 psi \)$.
Since the argument above implies that $integral u_b + partial_t u_b d x$
blows up in finite time and $integral u_g + partial_t u_g d x$ is
increasing, there exists a time $t_0$ such that
$ integral u \( t_0 \) + partial_t u \( t_0 \) d x = integral u_b \( t_0 \) + partial_t u_b \( t_0 \) d x + integral u_g \( t_0 \) + partial_t u_g \( t_0 \) d x > 0 . $
Therefore, the solution $u$ blows up in finite time by the same argument
from $t = t_0$.

Nevertheless, it is also known that there exist nontrivial global
solutions to #link(<eq:DW>)[\[eq:DW\]];. Li and Zhou @LZ95 also showed
that, when $n = 1 \, 2$ and even when $1 < p lt.eq 3$, global existence
for small initial data holds for #link(<eq:DW>)[\[eq:DW\]] under the
following pointwise condition (for all $x$):
$ u_0 \( x \) = 0 \, quad u_1 \( x \) lt.eq 0 . $<eq:initial_condition_Li_Zhou>
This was further extended to
$ u_0 \( x \) lt.eq 0 \, u_1 \( x \) + 1 / 2 u_0 \( x \) lt.eq 0 . $<eq:initial_condition_Li_Zhou_general>
For details, see @FG25b. The conditions
#link(<eq:initial_condition_Li_Zhou>)[\[eq:initial\_condition\_Li\_Zhou\]]
and
#link(<eq:initial_condition_Li_Zhou_general>)[\[eq:initial\_condition\_Li\_Zhou\_general\]]
are used to implement a comparison argument based on the nonlinear
version of the transformation associated with
#link(<eq:transformed_wave_equation>)[\[eq:transformed\_wave\_equation\]];.
Indeed, under
#link(<eq:initial_condition_Li_Zhou>)[\[eq:initial\_condition\_Li\_Zhou\]]
and
#link(<eq:initial_condition_Li_Zhou_general>)[\[eq:initial\_condition\_Li\_Zhou\_general\]];,
solutions are shown to be negative at any time and point. On the other
hand, in other cases, it is unclear whether there is an initial
condition with which global solutions exist.

The expectation of global existence for #link(<eq:DW>)[\[eq:DW\]];, even
with a positive initial position, may be supported by a result of Pinsky
@P16. In @P16, it is shown that there exist both global and blow-up
solutions of #link(<eq:fujita_equation>)[\[eq:fujita\_equation\]] for
certain sign-changing initial data. The proof relies on a comparison
argument that is not directly applicable to #link(<eq:DW>)[\[eq:DW\]]
without imposing the initial condition
#link(<eq:initial_condition_Li_Zhou_general>)[\[eq:initial\_condition\_Li\_Zhou\_general\]];.
On the other hand, since global solutions to #link(<eq:DW>)[\[eq:DW\]]
are known to behave similarly to global solutions of
#link(<eq:fujita_equation>)[\[eq:fujita\_equation\]] under certain
initial conditions, the gap in the assumptions required by the
comparison argument appears to be merely technical.

The aim of this manuscript is to generalize a sufficient condition for
global existence of solutions to #link(<eq:DW>)[\[eq:DW\]];. For
simplicity, we restrict our attention to the one-dimensional case. In
particular, we show that the blow-up conditions based on the spatial
integrals of the initial data, namely
#link(<eq:initial_mean_condition>)[\[eq:initial\_mean\_condition\]] and
#link(<eq:initial_mean_condition_ours>)[\[eq:initial\_mean\_condition\_ours\]];,
cannot be relaxed without taking into account the shape of the initial
data, provided that the spatial integral of the initial position is
positive. More precisely, we ask the following question: Does there
exist a constant $c_0 > 0$ such that, for
$ 0 < epsilon_0 < c_0 \| epsilon_1 \| lt.double 1 \, $ there exists a
smooth, positive function $phi$ such that the solution with initial data
$\( u_0 \, u_1 \) = \( epsilon_0 phi \, epsilon_1 phi \)$ exists
globally in time? To the best of the authors' knowledge, global
existence for #link(<eq:DW>)[\[eq:DW\]] has only been established via
comparison arguments. Accordingly, we employ the following simple
sufficient condition for global existence: there exist a constant
$c_0 > 0$ and a smooth, positive function $phi$ such that, for
$ epsilon_0 < c_0 \| epsilon_1 \| lt.double 1 \, $ the solution $u$ with
initial data $\( u_0 \, u_1 \) = \( epsilon_0 phi \, epsilon_1 phi \)$
satisfies
$ u \( t \, x \) lt.eq 0 \, med med partial_t u \( t \, x \) + 1 / 2 u \( t \, x \) lt.eq 0 $<eq:aim>
for all $x$ at some time $t$. Once #link(<eq:aim>)[\[eq:aim\]] is
verified, Theorem 1.2 in @FG25a yields global existence. Decay in this
case is studied in @FG25b.

The following is the main statement of this manuscript, answering the
question above:

#block[
#strong[Theorem 2];. #emph[Let
$ 0 < epsilon_0 < - epsilon_1 lt.double 1 . $<eq:condition_ratio> Then
there exists a sufficiently small number $rho$ and a positive function
$phi in W^(2 \, 1) sect W^(2 \, oo)$ satisfying the following pointwise
control
$ \| phi' \( x \) \| + \| phi^('') \( x \) \| lt.eq rho phi \( x \) \, med med forall x gt.eq 0 $<eq:shape_assumption>
and the mild solution $u in C \( \[ 0 \, T_0 \) times bb(R) \)$ to
#link(<eq:DW>)[\[eq:DW\]] with initial data
$\( u_0 \, u_1 \) = \( epsilon_0 phi \, epsilon_1 phi \)$ exists and
satisfies the pointwise estimates #link(<eq:aim>)[\[eq:aim\]] at time
$ t \( epsilon_0 \/ \| epsilon_1 \| \) + delta in \( 0 \, 2 \) \, $
where $delta > 0$ is sufficiently small and
$t = t \( epsilon_0 \/ \| epsilon_1 \| \)$ is the unique positive
solution of
$ frac(epsilon_0, \| epsilon_1 \|) = frac(4 t, \( 4 - t \) \( 2 + t \)) . $<eq.deft>]

] <theorem:main>
We give some remarks on Theorem @theorem:main. First, the condition
#link(<eq:condition_ratio>)[\[eq:condition\_ratio\]] is optimal. Indeed,
for $epsilon_0 + epsilon_1 gt.eq 0$, we can apply Theorem 1.1 in @FG25a
and deduce blow-up. Second, for any positive $rho$, there exists a
function $phi in W^(2 \, 1) sect W^(2 \, oo)$ satisfying
#link(<eq:shape_assumption>)[\[eq:shape\_assumption\]];. Indeed, let $N$
be an integer, $a > 1$, and $ phi \( x \) = \( N^2 + x^2 \)^(- a \/ 2) $
then $phi in W^(2 \, 1) sect W^(2 \, oo)$ and
$ \| phi' \( x \) \| & lt.eq a / N phi \( x \) \,\
\| phi^('') \( x \) \| & lt.eq frac(a \( a + 1 \), N^2) phi \( x \) \, $
so $rho = a \/ N + a \( a + 1 \) \/ N^2 arrow.r 0$ as $N arrow.r oo .$
Third, the condition
#link(<eq:shape_assumption>)[\[eq:shape\_assumption\]] plays an
important role in obtaining the pointwise estimate
#link(<eq:aim>)[\[eq:aim\]];. In particular,
#link(<eq:shape_assumption>)[\[eq:shape\_assumption\]] implies that
solutions $u$ are estimated by $phi$ pointwisely up to a certain time,
and this pointwise control implies the conclusion. Finally, the function
$ a \( t \) = frac(4 t, \( 4 - t \) \( 2 + t \)) $ is strictly
increasing for $t in \( 0 \, 2 \)$, with $a \( 0 \) = 0$ and
$a \( 2 \) = 1$. Therefore, the unique positive solution
$t in \( 0 \, 2 \)$ of #link(<eq.deft>)[\[eq.deft\]] is well-defined.
The smallness of $delta$ is determined by
$ delta < b \( t \) - a \( t \) \, $ where
$ b \( t \) = frac(8 t, \( 2 + t \)^2) . $ The proof that
$b \( t \) > a \( t \)$ for $t in \( 0 \, 2 \)$ is elementary and can be
found at the end of the proof of Theorem @theorem:main.

We note that it is still unclear whether there exists a global solution
to #link(<eq:DW>)[\[eq:DW\]] in the case where
$\( u_0 \, u_1 \) = \( epsilon_0 phi \, epsilon_1 phi \)$ with smooth
positive $phi$ and $epsilon_0$ and $epsilon_1$ are sufficiently small
and satisfy
$ epsilon_0 < 0 \, quad epsilon_1 > 0 \, quad epsilon_0 + epsilon_1 < 0 \, quad upright("and") med epsilon_1 + epsilon_0 \/ 2 > 0 . $

In the next section, we collect some preliminary estimates. Theorem
@theorem:main is shown in the last section.

= Preliminary
<preliminary>
We, at first, show the estimate for the solution to the Cauchy problem
for a nonhomogeneous wave equation.

#block[
#strong[Lemma 3];. #emph[Let $g in W^(1 \, oo)$ and
$f \, w in L^oo \( 0 \, 2 ; L^oo \)$. Then there exists a unique $L^oo$
valued mild solution $v$ to the following Cauchy problem:
$ {partial_t^2 v + partial_t v - partial_x^2 v = f w + g partial_x w \,\
v \( 0 \, x \) = epsilon_0 \,\
partial_t v \( 0 \, x \) = epsilon_1 . $ Moreover, $v$ enjoys the
following estimate:
$ parallel v \( t \) parallel_(L^oo) & lt.eq epsilon_0 e^(- t) + \( epsilon_0 + epsilon_1 \) \( 1 - e^(- t) \)\
 & + C t #scale(x: 240%, y: 240%)[\(] parallel f parallel_(L^oo \( 0 \, t ; L^oo \)) + parallel g parallel_(W^(1 \, oo)) #scale(x: 240%, y: 240%)[\)] parallel w parallel_(L^oo \( 0 \, t ; L^oo \)) . $<1dmax>]

] <lemma:estimate_of_transformed_wave>
#block[
#emph[Proof.] We recall that a standard Duhamel formula implies that
$ v \( t \, x \) & = epsilon_0 e^(- t) + \( epsilon_0 + epsilon_1 \) \( 1 - e^(- t) \)\
 & + integral_0^t S \( t - tau \) f \( tau \) w \( tau \) \( x \) d tau + integral_0^t S \( t - tau \) g partial_x w \( tau \, x \) d tau \, $
where
$ S \( t \) h \( x \) = 1 / 2 e^(- t \/ 2) integral_(- t)^t I_0 #scale(x: 240%, y: 240%)[\(] sqrt(t^2 - y^2) / 2 #scale(x: 240%, y: 240%)[\)] h \( x + y \) d y . $
We note that by denoting $omega = sqrt(t^2 - y^2)$ we have
$ e^(- t \/ 2) I_0 #scale(x: 240%, y: 240%)[\(] omega / 2 #scale(x: 240%, y: 240%)[\)] lt.eq angle.l omega angle.r^(- 1 \/ 2) e^(\( omega - t \/ 2 \)) lt.eq C angle.l t angle.r^(- 1 \/ 2) e^(- y^2 \/ 8 t) . $
Therfore, a straightforward calculation shows that
$ parallel S \( t - tau \) f \( tau \) w \( tau \) parallel_(L^oo) lt.eq C parallel f \( tau \) parallel_(L^oo) parallel w \( tau \) parallel_(L^oo) . $
We note that by writing $sigma = t - tau$ we have
$ e^(sigma \/ 2) S \( sigma \) g partial_x w \( tau \) \( x \) & = integral_(- sigma)^sigma I_0 #scale(x: 240%, y: 240%)[\(] sqrt(sigma^2 - y^2) / 2 #scale(x: 240%, y: 240%)[\)] g \( x + y \) partial_x w \( tau \, x + y \) d y\
 & = g \( x + sigma \) w \( tau \, x + sigma \) - g \( x - sigma \) w \( tau \, x - sigma \)\
 & - integral_(- sigma)^sigma I_0 #scale(x: 240%, y: 240%)[\(] sqrt(sigma^2 - y^2) / 2 #scale(x: 240%, y: 240%)[\)] dot(g) \( x + y \) w \( tau \, x + y \) d y\
 & + integral_(- sigma)^sigma I_1 #scale(x: 240%, y: 240%)[\(] sqrt(sigma^2 - y^2) / 2 #scale(x: 240%, y: 240%)[\)] y / sqrt(sigma^2 - y^2) g \( x + y \) w \( tau \, x + y \) d y . $
We note that by writing $omega = sqrt(sigma^2 - y^2)$, we have
$ #scale(x: 240%, y: 240%)[\|] e^(- sigma \/ 2) y / omega I_1 \( omega \/ 2 \) #scale(x: 240%, y: 240%)[\|] lt.eq C frac(y, angle.l omega angle.r^(3 \/ 2)) e^(\( omega - sigma \) \/ 2) lt.eq C angle.l sigma angle.r^(- 1 \/ 2) e^(- y^2 \/ 8 sigma) . $
Thereore, we have
$ parallel S \( t - tau \) g \( tau \) partial_x w \( tau \) parallel_(L^oo) lt.eq C parallel g parallel_(W^(1 \, oo)) parallel w \( tau \) parallel_(L^oo) $
and this implies #link(<1dmax>)[\[1dmax\]];.~◻

]
By using Lemma @lemma:estimate_of_transformed_wave, we mesure the
difference between $u \( t \)$ and initial position $phi$ under a
certain condition by using their ratio.

#block[
#strong[Lemma 4] (Refined local estimates). #emph[Let $epsilon_0$ and
$epsilon_1$ are real constans sufficiently close to $0$ satisfying
$0 < epsilon_0 < - epsilon_1$. Let $t in \( 0 \, T_0 \)$ and $rho > 0$
satisfy
$ C \( \| epsilon_1 \|^(p - 1) + rho \) t < 1 $<eq:condition_for_u_devided>
with a positive constant $C$. Assume that
$phi in W^(2 \, 1) sect W^(2 \, oo)$ satisfy
#link(<eq:shape_assumption>)[\[eq:shape\_assumption\]];. If the mild
solution $u$ of Lemma @lemma:local_existence with initial data
$\( u_0 \, u_1 \) = \( epsilon_0 \, epsilon_1 \)$ satsify
$ parallel \| u \|^(p - 2) u parallel_(L^oo \( 0 \, T_0 ; L^oo \)) + #scale(x: 240%, y: 240%)[parallel] dot.double(phi) / phi #scale(x: 240%, y: 240%)[parallel]_(L^oo) + #scale(x: 240%, y: 240%)[parallel] dot(phi)^2 / phi^2 #scale(x: 240%, y: 240%)[parallel]_(L^oo) lt.eq C \( epsilon_1^(p - 1) + rho \) . $
Then $u$ enjoys the following estimate for $t in \( 0 \, T_0 \)$:
$ ∥frac(u \( t \), phi)∥_(L^oo) lt.eq frac(\| epsilon_0 e^(- t) + \( epsilon_1 + epsilon_0 \) \( 1 - e^(- t) \) \|, 1 - C \( \| epsilon_1 \|^(p - 1) + rho \) t) . $<eq2mm>]

] <lemma:estaimte_of_u_devided>
#block[
#emph[Proof.] We make the substitution
$ v \( t \, x \) = frac(u \( t \, x \), phi \( x \)) \, $ so we have
$ partial_t^2 v + partial_t v - partial_x^2 v = frac(\| u \|^p, phi) + 2 frac(dot(phi) partial_x u, phi^2) + dot.double(phi) / phi^2 u - 2 dot(phi)^2 / phi^3 u $
Since $ partial_x u = v dot(phi) + phi partial_x v $ we arrive at
\$\$\\partial\_t^2 v + \\partial\_t v - \\partial\_x^2 v \\\\
    = \\bigg( |u|^{p-2} u + \\frac{\\ddot \\varphi}{\\varphi} \\bigg) v
    + 2 \\frac{\\dot \\varphi}{\\varphi} \\partial\_x v\$\$ Therefore,
the Cauchy problem can be rewritten as
$ {partial_t^2 v + partial_t v - partial_x^2 v = f v + g partial_x v \,\
v \( 0 \, x \) = epsilon_0 \, & x in bb(R) \,\
partial_t v \( 0 \, x \) = epsilon_1 \, & x in bb(R) . $ with
$ f = \| u \|^(p - 2) u + dot.double(phi) / phi \, quad g = 2 dot(phi) / phi . $
Noting $ dot(g) = 2 dot.double(phi) / phi - 2 dot(phi)^2 / phi^2 $ and
applying Lemma @lemma:local_existence and the assumption
#link(<eq:shape_assumption>)[\[eq:shape\_assumption\]];,
$ parallel f parallel_(L^oo \( 0 \, T_0 ; L^oo \)) lt.eq C_1 \( \| epsilon_1 \|^(p - 1) + rho \) $
and $parallel g parallel_(W^(1 \, oo)) lt.eq C_1 rho$ with some positive
constants $C_1$.~◻

]
Next estimate plays an important role to estimate the solution on the
basis of initial data.

#block[
#strong[Lemma 5] (Hermite--Hadamard). #emph[Let $phi.alt$ be
$C^1 \( bb(R) ; \[ 0 \, oo \) \)$, such that there is a positive
constant $rho$ so that
$  & \| dot(phi.alt) \( x \) \| lt.eq rho phi.alt \( x \) \, med med forall x gt.eq 0 . $<eq.bb1>
Then we have
$  & frac(phi.alt \( alpha \) + phi.alt \( beta \), 2) lt.eq frac(1, beta - alpha) integral_alpha^beta phi.alt \( sigma \) d sigma + rho / 2 integral_alpha^beta phi.alt \( sigma \) d sigma $<eq.HH1>
and
$  & frac(phi.alt \( alpha \) + phi.alt \( beta \), 2) gt.eq frac(1, beta - alpha) integral_alpha^beta phi.alt \( sigma \) d sigma - rho / 2 integral_alpha^beta phi.alt \( sigma \) d sigma $<eq.HH1mm>
for $0 lt.eq alpha < beta < oo .$]

] <l3>
#block[
#emph[Proof.] We use the following identity, obtained in @DA98 (see
Lemma 2.1 in @DA98)
$ frac(phi.alt \( alpha \) + phi.alt \( beta \), 2) - frac(1, beta - alpha) integral_alpha^beta phi.alt \( sigma \) d sigma = frac(beta - alpha, 2) integral_0^1 \( 1 - 2 t \) dot(phi.alt) \( t alpha + \( 1 - t \) beta \) d t . $
Then we can write
$ frac(phi.alt \( alpha \) + phi.alt \( beta \), 2) - frac(1, beta - alpha) integral_alpha^beta phi.alt \( sigma \) d sigma & = frac(beta - alpha, 2) integral_0^1 \( 1 - 2 t \) dot(phi.alt) \( t alpha + \( 1 - t \) beta \) d t\
 & lt.eq frac(beta - alpha, 2) integral_0^1 \| dot(phi.alt) \( t alpha + \( 1 - t \) beta \) \| d t\
 & = 1 / 2 integral_alpha^beta \| dot(phi.alt) \( sigma \) \| d sigma . $
Assuming #link(<eq.bb1>)[\[eq.bb1\]];, we get
#link(<eq.HH1>)[\[eq.HH1\]];.

It is easy to extend this estimate also to the cases $alpha < 0 < beta$
and $alpha < beta < 0$ using the additional assumption that $phi.alt$ is
an even function. In fact, when $alpha < 0 < beta$ we define the
interval $J subset \[ 0 \, oo \)$ with ends $- alpha$ and $beta$ and
then we can apply #link(<eq.HH1>)[\[eq.HH1\]] so we have
$ frac(phi.alt \( alpha \) + phi.alt \( beta \), 2) = frac(phi.alt \( - alpha \) + phi.alt \( beta \), 2) lt.eq frac(1, \| J \|) integral_J phi.alt \( sigma \) d sigma + rho / 2 integral_J phi.alt \( sigma \) d sigma . $<eq.HH1m>
This completes the proof.~◻

]
We finalize this section by collecting some estimates of calculs to
control nonlinaerity. Consider the function
$ C \( t \, r \, rho \, epsilon_1 \) = sup_(tau in \[ 0 \, t \]) G \( tau \, r \, rho \, epsilon_1 \) \, $<eq.dC>
where
$ G \( tau \, r \, rho \, epsilon_1 \) = frac(\| r - tau \( 1 - r \) \|, 1 - C \( \| epsilon_1 \|^(p - 1) + rho \) tau) $
under the assumption
#link(<eq:condition_for_u_devided>)[\[eq:condition\_for\_u\_devided\]]
is satisfied. Here $rho$ is a positive number and $epsilon_1$ is a
negative number which are close to $0$.

#block[
#strong[Lemma 6];. #emph[We have the relation
$  & C \( t \, r \, rho \, c_0 \) = max (r \, frac(t \( 1 - r \/ 2 \) - r, \( 1 - t^2 \/ 4 \))) + O \( rho + \| c_0 - 1 \/ 4 \| \) . $]

] <l.61>
#block[
#emph[Proof.] The function $G \( tau \, r \, rho \, c_0 \)$ is at least
$C^1$ with respect to $rho \, c_0$ in a small neighbourhood of
$\( 0 \, 1 \/ 4 \)$ so it is sufficient to consider the case $rho = 0$
and $c_0 = 1 \/ 4 .$ Then we have the relation
$ G \( tau \, r \, 0 \, 1 \/ 4 \) = { & frac(tau \( 1 - r \/ 2 \) - r, 1 - tau^2 \/ 4 \)) med upright("if ") tau > 2 r \/ \( 2 - r \) \,\
 & frac(r - tau \( 1 - r \/ 2 \), \( 1 - tau^2 \/ 4 \)) med upright("if ") 0 lt.eq tau < 2 r \/ \( 2 - r \) . $
In the interval $\[ 0 \, 2 r \/ \( 2 - r \) \]$ it is decreasing since
we have
$ partial_t G \( tau \, r \, 0 \, 1 \/ 4 \) = 2 frac(tau^2 \( r - 2 \) + 4 tau r + 4 \( r - 2 \), \( 4 - tau^2 \)^2) < 0 $
for $tau in \[ 0 \, 2 r \/ \( 2 - r \) \)$ and $r in \[ 0 \, 1 \) .$ For
$tau > 2 r \/ 2 - r$ it is increasing so
$  & C \( t \, r \, rho \, c_0 \) = sup_(tau in \[ 0 \, t \]) G \( tau \, r \, rho \, c_0 \)\
 & = sup_(tau in \[ 0 \, t \]) G \( tau \, r \, 0 \, 1 \/ 4 \) + O \( rho + \| c_0 - 1 \/ 4 \| \)\
 & = max (r \, frac(t \( 1 - r \/ 2 \) - r, \( 1 - t^2 \/ 4 \))) + O \( rho + \| c_0 - 1 \/ 4 \| \) . $

for $0 lt.eq r < 1$.~◻

]
#block[
#strong[Corollary 7];. #emph[We have the relation
$ C \( t \, r \, 0 \, 1 \/ 4 \) = cases(delim: "{", frac(t \( 1 - r \/ 2 \) - r, \( 1 - t^2 \/ 4 \)) & upright("if") quad r < r_t \,, r & upright("if") quad r gt.eq r_t \,) $
where
$ r_t = frac(4 t, 8 + 2 t - t^2) = frac(4 t, \( 4 - t \) \( 2 + t \)) . $]

] <c62>
= Proof of Theorem @theorem:main
<proof-of-theorem-theoremmain>
$w = e^(t \/ 2) u$ is a solution to the Cauchy problem
$ cases(delim: "{", partial_t^2 w - Delta w = (1 / 4 + u \| u \|^(p - 2)) w \, & t in \( 0 \, T_0 \) \, med x in bb(R) \,, w \( 0 \) = epsilon_0 phi \( x \) \, & x in bb(R) \,, partial_t w \( 0 \) = epsilon_1 phi \( x \) + epsilon_0 / 2 phi \( x \) \, & x in bb(R) .) $<CPa1>

The D'Alembert formula implies
$  & w \( t \) = epsilon_0 frac(d, d t) W \( t \) \( phi \) \( x \) + (epsilon_1 + epsilon_0 / 2) W \( t \) \( phi \) \( x \)\
 & + integral_0^t W \( t - tau \) ((1 / 4 + u \( tau \) \| u \( tau \) \|^(p - 2)) w \( tau \)) \( x \) d tau \, $
where
$ W \( t \) \( f \) \( x \) = 1 / 2 integral_(x - t)^(x + t) f \( tau \) d tau \, $
so
$  & partial_t w \( t \, x \) = epsilon_0 (frac(d, d t))^2 W \( t \) \( phi \) \( x \) + (epsilon_1 + epsilon_0 / 2) frac(d, d t) W \( t \) \( phi \) \( x \)\
 & + integral_0^t frac(d, d t) W \( t - tau \) ((1 / 4 + u \( tau \) \| u \( tau \) \|^(p - 2)) w \( tau \)) \( x \) d tau $

Set $ r = epsilon_0 \/ \| epsilon_1 \| $ and $r in \[ 0 \, 1 \)$ follows
from the assumption
#link(<eq:condition_ratio>)[\[eq:condition\_ratio\]];.

The idea of the proof is to define the set
$ cal(A) = { r in \[ 0 \, 1 \) ; exists \( t \, epsilon_0 \, epsilon_1 \, phi \) \, med w \( t \, x \) lt.eq 0 \, med partial_t w \( t \, x \) lt.eq 0 med upright("for a.e.") med med x in bb(R) } $<eq.dA>
and show that $cal(A)$ covers the whole interval $\[ 0 \, 1 \) \,$ i.e.
$ cal(A) supset \[ 0 \, 1 \) . $<Asup>

We start with a sufficient condition that guaranties
$partial_t w \( t \, x \) lt.eq 0$ for almost every $x in bb(R) .$

#block[
#strong[Lemma 8];. #emph[Let the assumption of Lemma
@lemma:estaimte_of_u_devided be satisfied. Let $rho$ be the parameter
from assumption #link(<eq:shape_assumption>)[\[eq:shape\_assumption\]]
and $c_0$ be a number close to $1 \/ 4 .$ If
$C \( t \, r \, rho \, c_0 \)$ defined by #link(<eq.dC>)[\[eq.dC\]]
satisfies the estimate
$ c_0 / 2 C \( t \, r \, rho \, c_0 \) lt.eq #scale(x: 240%, y: 240%)[\(] 1 - r #scale(x: 240%, y: 240%)[\(] rho + 1 / 2 #scale(x: 240%, y: 240%)[\)] #scale(x: 240%, y: 240%)[\)] #scale(x: 240%, y: 240%)[\(] frac(1, 2 t) - rho / 2 #scale(x: 240%, y: 240%)[\)] $<eq.a1>
then $partial_t w \( t \, x \) lt.eq 0$ for a.e. $x in bb(R) .$]

] <lemma:condition_for_negative_speed>
#block[
#emph[Proof.] The D'Alembert formula gives
$  & partial_t w \( t \, x \)\
 & = epsilon_0 frac(phi' \( x + t \) - phi' \( x - t \), 2) + (epsilon_1 + epsilon_0 / 2) frac(phi \( x + t \) + phi \( x - t \), 2)\
 & + integral_0^t frac(d, d t) W \( t - tau \) ((1 / 4 + u \( tau \) \| u \( tau \) \|^(p - 2)) w \( tau \)) \( x \) d tau . $

Then using #link(<eq2mm>)[\[eq2mm\]] in Lemma
@lemma:estimate_of_transformed_wave, we obtain
$  & integral_0^t frac(d, d t) W \( t - tau \) ((1 / 4 + u \( tau \) \| u \( tau \) \|^(p - 2)) w \( tau \)) \( x \) d tau\
 & lt.eq c_0 integral_0^t frac(d, d t) W \( t - tau \) \( w \( tau \) \) \( x \) d tau\
 & = c_0 / 2 integral_0^t (w \( tau \, x + t - tau \) + w \( tau \, x - t + tau \)) d tau\
 & lt.eq c_0 / 2 max_(0 lt.eq tau lt.eq t) frac(\| epsilon_0 + tau \( epsilon_1 + epsilon_0 \/ 2 \) \|, \( 1 - c_0 tau^2 - 2 c_0 rho tau^2 - 2 rho tau \)) integral_0^t (phi \( x + t - tau \) + phi \( x - t + tau \)) d tau\
 & lt.eq c_0 / 2 \| epsilon_1 \| C \( t \, r \) integral_(- t)^t phi \( x + sigma \) d sigma . $

Using #link(<eq:shape_assumption>)[\[eq:shape\_assumption\]];, we obtain
$  & partial_t w \( t \, x \)\
 & lt.eq epsilon_0 frac(phi' \( x + t \) - phi' \( x - t \), 2) + (epsilon_1 + epsilon_0 / 2) frac(phi \( x + t \) + phi \( x - t \), 2)\
 & + c_0 / 2 \| epsilon_1 \| C \( t \, r \) integral_(- t)^t phi \( x + sigma \) d tau\
 & lt.eq (epsilon_0 rho + epsilon_1 + epsilon_0 / 2) frac(phi \( x + t \) + phi \( x - t \), 2) + c_0 / 2 \| epsilon_1 \| C \( t \, r \) integral_(- t)^t phi \( x + sigma \) d sigma . $

Lemma @l3 implies
$ frac(phi \( x + t \) + phi \( x - t \), 2) gt.eq (frac(1, 2 t) - rho / 2) integral_(- t)^t phi \( x + sigma \) d tau . $<eq.HH1m1>

Then we estimate
$ partial_t w \( t \, x \) & lt.eq \| epsilon_1 \| A \( t \, r \) integral_(- t)^t phi \( x + sigma \) d tau \, $<HH2>
where
$ A \( t \, r \) = - #scale(x: 240%, y: 240%)[\(] 1 - r #scale(x: 240%, y: 240%)[\(] rho + 1 / 2 #scale(x: 240%, y: 240%)[\)] #scale(x: 240%, y: 240%)[\)] #scale(x: 240%, y: 240%)[\(] frac(1, 2 t) - rho / 2 #scale(x: 240%, y: 240%)[\)] + c_0 / 2 C \( t \, r \, rho \, c_0 \) . $
Therefore, the condition #link(<eq.a1>)[\[eq.a1\]] implies
$A \( t \, r \) lt.eq 0$ and hence $partial_t w \( t \, x \) lt.eq 0$
a.e. This completes the proof.~◻

]
#block[
#strong[Lemma 9];. #emph[Let the assumption of Lemma
@lemma:estaimte_of_u_devided be satisfied. If the inequality
$ c_0 / 2 t C \( t \, r \, rho \, c_0 \) lt.eq 1 - #scale(x: 240%, y: 240%)[\(] frac(rho + 1, 2) + frac(1, 2 t) #scale(x: 240%, y: 240%)[\)] r $<eq.a2>
holds, then $w \( t \, x \) lt.eq 0$ for a.e. $x in bb(R)$. Here
$C \( t \, r \, rho \, c_0 \)$ is defined in #link(<eq.dC>)[\[eq.dC\]];.]

] <lemma:condition_for_negative_position>
#block[
#emph[Proof.] We have $  & w \( t \, x \)\
 & lt.eq epsilon_0 frac(phi \( x + t \) + phi \( x - t \), 2) + (epsilon_1 + epsilon_0 / 2) integral_(- t)^t frac(phi \( x + tau \), 2) d tau\
 & + c_0 / 2 \| epsilon_1 \| C \( t \, r \) integral_0^t integral_(tau - t)^(t - tau) phi \( x + sigma \) d sigma d tau\
 & lt.eq - \| epsilon_1 \| #scale(x: 240%, y: 240%)[{] 1 - #scale(x: 240%, y: 240%)[\(] frac(rho + 1, 2) + frac(1, 2 t) #scale(x: 240%, y: 240%)[\)] r - c_0 / 2 t C \( t \, r \) #scale(x: 240%, y: 240%)[}] integral_(- t)^t phi \( x + sigma \) d sigma . $~◻

]
In view of the above Lemmas @lemma:estaimte_of_u_devided,
@lemma:condition_for_negative_speed, and
@lemma:condition_for_negative_position, $cal(A)$ contains the following
set. \$\$\\mathcal{B}
    = \\{r \\in \[0,1); \\exists (t,c\_0,\\rho)\\
    \\mathrm{satisfying}\\
    \\eqref{eq:condition\_for\_u\_devided},\\
    \\eqref{eq.a1},\\
    \\mathrm{and}\\ \\eqref{eq.a2}\\}\$\$ Indeed, if $r in cal(B)$, then
there exits $\( epsilon_0 \, epsilon_1 \, phi \)$ such that
$r = epsilon_0 \/ \| epsilon_1 \|$ and the assumptions
#link(<eq:condition_for_u_devided>)[\[eq:condition\_for\_u\_devided\]]
is satisfied. Therefore, $r in cal(A)$.

The definition #link(<eq.dC>)[\[eq.dC\]] and Corollary @c62 imply
$ C \( t \, r \, 0 \, 1 \/ 4 \) = cases(delim: "{", frac(t \( 1 - r \/ 2 \) - r, \( 1 - t^2 \/ 4 \)) & upright("if") med r < 4 t \/ \( 8 + 2 t - t^2 \) \,, r & upright("if") med r > 4 t \/ \( 8 + 2 t - t^2 \) .) $
Therefore, a sufficient condition for $r in cal(B)$ is that whether
$r in \[ 0 \, 1 \)$ satisfies that there exists $t in \( 0 \, 2 \)$ such
that A sufficient condition for $r in B$ is that $r in \( 0 \, 1 \)$ and
there exists $t$ such that

the following two inequalities hold:
$ {1 / 8 (frac(t \( 1 - r \/ 2 \) - r, \( 1 - t^2 \/ 4 \))) < #scale(x: 240%, y: 240%)[\(] 1 - r / 2 #scale(x: 240%, y: 240%)[\)] #scale(x: 240%, y: 240%)[\(] frac(1, 2 t) #scale(x: 240%, y: 240%)[\)] \,\
1 / 8 t (frac(t \( 1 - r \/ 2 \) - r, \( 1 - t^2 \/ 4 \))) < 1 - #scale(x: 240%, y: 240%)[\(] 1 / 2 + frac(1, 2 t) #scale(x: 240%, y: 240%)[\)] r \,\
r < frac(4 t, \( 4 - t \) \( 2 + t \)) $<sys1> and
$ {1 / 8 r < #scale(x: 240%, y: 240%)[\(] 1 - r / 2 #scale(x: 240%, y: 240%)[\)] #scale(x: 240%, y: 240%)[\(] frac(1, 2 t) #scale(x: 240%, y: 240%)[\)] \,\
1 / 8 t r < 1 - #scale(x: 240%, y: 240%)[\(] 1 / 2 + frac(1, 2 t) #scale(x: 240%, y: 240%)[\)] r \,\
r > frac(4 t, \( 4 - t \) \( 2 + t \)) . $<sys2> In particular, if
$r in \[ 0 \, 1 \)$ admits some $t in \( 0 \, 2 \)$ such that
$\( t \, r \)$ satisfies either #link(<sys1>)[\[sys1\]] or
#link(<sys2>)[\[sys2\]];, then one can choose $c_0$ sufficiently close
to $1 \/ 4$ and $rho > 0$ sufficiently small so that the assumptions
#link(<eq:condition_for_u_devided>)[\[eq:condition\_for\_u\_devided\]];,
#link(<eq.a1>)[\[eq.a1\]] and #link(<eq.a2>)[\[eq.a2\]] in Lemmas
@lemma:condition_for_negative_speed and
@lemma:condition_for_negative_position are satisfied. Consequently,
$cal(B)$ contains the following set: \$\$\\mathcal C
    = \\{r \\in \[0,1); \\exists t, \\ (t,r) \\ \\mbox{is a solution to \\eqref{sys2}}\\}.\$\$

Finally, we show that $cal(C) supset \[ 0 \, 1 \)$. The system
#link(<sys2>)[\[sys2\]] is equivalent to $ {r < frac(4, 2 + t) \,\
r < frac(8 t, \( 2 + t \)^2) \,\
r > frac(4 t, \( 4 - t \) \( 2 + t \)) . $<sys4> A positive solution $r$
can be found iff
$ frac(4 t, \( 4 - t \) \( 2 + t \)) < min (frac(4, 2 + t) \, frac(8 t, \( 2 + t \)^2)) . $
Note that for $t in \[ 0 \, 4 \)$
$ frac(4 t, \( 4 - t \) \( 2 + t \)) < frac(4, 2 + t) $ is equivalent to
$t < 2$ and
$ frac(4 t, \( 4 - t \) \( 2 + t \)) < frac(8 t, \( 2 + t \)^2) $ is
equivalent to $t < 2 .$ Therefore the interval
$ I \( t \) & = \( a \( t \) \, b \( t \) \) \,\
a \( t \) & = frac(4 t, \( 4 - t \) \( 2 + t \)) \,\
b \( t \) & = min (frac(4, 2 + t) \, frac(8 t, \( 2 + t \)^2)) $ is
nonempty for any $t in \( 0 \, 2 \) .$ Note that
$ frac(8 t, \( 2 + t \)^2) < frac(4, 2 + t) $ for $t in \( 0 \, 2 \) .$
Therefore, $ b \( t \) = frac(8 t, \( 2 + t \)^2) . $ The function $a$
is increasing on $\[ 0 \, 4 \)$, because
$ a \( t \) = frac(4, 4 - t) #scale(x: 240%, y: 240%)[\(] 1 - frac(2, t + 2) #scale(x: 240%, y: 240%)[\)] . $
Moreover, $a \( 0 \) = 0$ and $a \( 2 \) = b \( 2 \) = 1$ imply that
$ cal(A) supset cal(B) supset cal(C) supset \[ 0 \, 1 \) . $ This
completes the proof.
