program semestr1;

const
  eps = 0.001;

const
  INF = 1.0e9;

type
  TF = function(x: real): real;

var
  r1, r2, r3: real;

//FUNCTION 1
function f1(x: real): real;
begin
  f1 := exp(x) + 2;
end;

function f1p(x: real): real;
begin
  f1p := exp(x);
end;

//FUNCTION 2
function f2(x: real): real;
begin
  if x <> 0 then
    f2 := -1 / x
  else
    f2 := INF;
end;

function f2p(x: real): real;
begin
  if x <> 0 then
    f2p := 1 / sqr(x)
  else
    f2p := INF;
end;

//FUNCTION 3
function f3(x: real): real;
begin
  f3 := -2 / 3 * (x + 1);
end;

function f3p(x: real): real;
begin
  f3p := -2 / 3;
end;

function Ur(f, g: tf; x: real): real;
begin
  Ur := f(x) - g(x);
end;

//ROOT
procedure root(f, fp, g, gp: tf; a, b, epsilon: real; var x: real);
begin
  if (Ur(f, g, a) - Ur(f, g, b) < 0) and (Ur(f, g, (a + b) / 2) < ((Ur(f, g, a) + Ur(f, g, b)) / 2)) or
		   (Ur(f, g, a) - Ur(f, g, b) > 0) and (Ur(f, g, (a + b) / 2) > ((Ur(f, g, a) + Ur(f, g, b)) / 2)) then
    repeat
      a := (a * Ur(f, g, b) - b * Ur(f, g, a)) / (Ur(f, g, b) - Ur(f, g, a));
      b := b - Ur(f, g, b) / Ur(fp, gp, b);
    until abs(b - a) <= epsilon
  else
    repeat
      b := (a * Ur(f, g, b) - b * Ur(f, g, a)) / (Ur(f, g, b) - Ur(f, g, a));
      a := a - Ur(f, g, a) / Ur(fp, gp, a);
    until abs(b - a) <= epsilon;
  x := (b + a) / 2;
end;

//INTEGRAL
function integral(f: TF; x1, x2: real; epsilon: real): real;
var
  n0, n, i: integer;
  s1, s2, h1, h2, len: real;
begin
  n0 := 10;
  n := 20;
  len := abs(x1 - x2);
  repeat
    h1 := len / n0;
    h2 := len / n;
    s1:=0; s2:=0;
    if x1 < x2 then 
    begin
      for i := 1 to n0 do
        s1 := s1 + f((x1+(i-1)*h1+(x1 + i * h1))/2) * h1;
      for i := 1 to n do
        s2 := s2 + f((x1+(i-1)*h2+(x1 + i * h2))/2) * h2;
    end
    else begin
      for i := 1 to n0 do
        s1 := s1 + f((x2+(i-1)*h1+(x2 + i * h1))/2) * h1;
      for i := 1 to n do
        s2 := s2 + f((x2+(i-1)*h2+(x2 + i * h2))/2) * h2;
    end;
    n0 := n;
    n := 2 * n;
  until (abs(1 / 3 * (s1 - s2)) < epsilon);
  integral := s2;
end;

begin
  root(f2, f2p, f1, f1p, -1, -0.3, eps, r1);
  writeln('First root - ', r1);
  root(f2, f2p, f3, f3p, -2, -1, eps, r2);
  writeln('Second root - ', r2);
  root(f1, f1p, f3, f3p, -5, -3, eps, r3);
  writeln('Third root - ', r3);
  writeln('S = ', integral(f1, r3, r1, eps) - integral(f3, r3, r2, eps) - integral(f2, r2, r1, eps))
end.