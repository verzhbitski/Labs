program Sorting;

const
  MAXN = 1000;

type
  PAIR =  record
    first: longint;
    second: longint
  end;
  STAT =  record
    n: longint;
    ms: array[1..5] of PAIR;
    midVal: PAIR
  end;
  TDATE = record
    year: integer;
    month: integer;
    day: integer
  end;
  
  ARR = array [1..MAXN] of TDATE;

var
  swapCount, cmpCount: longint;
  X1: ARR;
  statTable: array[1..4] of STAT;
  tests: array[1..4] of longint;

function compareDates(a, b: TDATE): boolean;
var
  tmp: boolean;
begin
  tmp := false;
  if (a.year = b.year) and (a.month = b.month) then
    tmp := (a.day > b.day)
  else if a.year = b.year then
    tmp := (a.month > b.month)
  else
    tmp := (a.year > b.year);
  inc(cmpCount);
  compareDates := tmp;
end;

procedure generateTest1(var X: ARR; n: longint);
var
  i: longint;
begin
  i := 2;
  x[1].year := 1970 + random(5);
  x[1].month := random(12) + 1;
  x[1].day := random(31) + 1;
  while i <= n do
  begin
    x[i].year := x[i - 1].year + random(5);
    x[i].month := random(12) + 1;
    x[i].day := random(31) + 1;
    if compareDates(x[i - 1], x[i]) then 
      i := i - 1;
    inc(i);
  end;
end;

procedure generateTest2(var x: ARR; n: longint);
var
  i: longint;
begin
  i := 2;
  x[1].year := 1990 + random(10);
  x[1].month := random(12) + 1;
  x[1].day := random(31) + 1;
  while i <= n do
  begin
    x[i].year := X[i - 1].year - random(3);
    x[i].month := random(12) + 1;
    x[i].day := random(31) + 1;
    if not compareDates(x[i - 1], x[i]) then
      i := i - 1;
    inc(i);
  end;
end;

procedure generateTest3(var x: ARR; n: longint);
var
  i: longint;
  a, b: ARR;
begin
  generateTest1(a, (n div 2) + 1);
  generateTest2(b, (n + 2) div 2);
  for i := 1 to (n div 2) + 1 do
  begin
    x[i * 2 - 1] := a[i];
    x[i * 2] := b[i];
  end;
end;

procedure generateTest4(var x: ARR; n: longint);
var
  i: longint;
begin
  for i := 1 to n do
  begin
    x[i].year := 1960 + random(n);
    x[i].month := random(12) + 1;
    x[i].day := random(31) + 1;
  end;
end;

procedure init();
begin
  swapCount := 0;
  cmpCount := 0;
end;

procedure mergeSegment(var X: ARR; l, c, r: longint);
var
  p1, p2, p, i: longint;
  tmp: ARR;
begin
  p1 := l;
  p2 := c + 1;
  p := 1;
  while (p1 <= c) and (p2 <= r) do
  begin
    inc(cmpCount);
    if compareDates(X[p1], X[p2]) then
    begin
      tmp[p] := X[p2];
      inc(p2);
      inc(p);
      inc(swapCount);
    end 
  		else
    begin
      tmp[p] := X[p1];
      inc(p1);
      inc(p);
    end;
  end;
  
  if p1 > c then
    while (p2 <= r) do
    begin
      tmp[p] := X[p2];
      inc(p2);
      inc(p);
    end
  else if p2 > r then
    while (p1 <= c) do
    begin
      tmp[p] := X[p1];
      inc(p1);
      inc(p);
    end;
  dec(p);
  for i := 1 to p do
  begin
    X[l + i - 1] := tmp[i];
  end;

end;

procedure simpleMergeSort(var x: ARR; l, r: longint);
var
  m: longint;
begin
  if l < r then
  begin
    m := (l + r) div 2;
    simpleMergeSort(X, l, m);
    simpleMergeSort(X, m + 1, r);
    mergeSegment(X, l, m, r);
  end;
end;

procedure generateTests(k, n: longint);
begin
  case k of
    1: generateTest1(X1, n);
    2: generateTest2(X1, n);
    3: generateTest3(X1, n);
    4: generateTest4(X1, n);
    5: generateTest4(X1, n);
  end;
end;

procedure printArr(X: ARR; n: longint);
var
  i: longint;
begin
  writeln('----------------------------------------------------------------------');
  for i := 1 to n do
    writeln(X[i].day, '.', X[i].month, '.', X[i].year);
  writeln('----------------------------------------------------------------------')
end;

procedure printTable();
var i, k : longint;
begin
	writeln('                          Сортировка Простым Слиянием                 ');
	writeln('----------------------------------------------------------------------');
	writeln('|  n   |  параметр  |       номер последовательности       | среднее |');
	writeln('|      |            |       1     2     3     4     5      | значение|'); 
	writeln('----------------------------------------------------------------------');
	for i := 1 to 4 do
	begin
		write('| ', tests[i]:3, '  | сравнения  |    ');
		for k := 1 to 5 do
			write(statTable[i].ms[k].first:4, '  ');
		writeln('    |  ', statTable[i].midVal.first:4,'   |');
		
		write('|      | перемещения|    ');
		for k := 1 to 5 do
			write(statTable[i].ms[k].second:4, '  ');
		writeln('    |  ', statTable[i].midVal.second:4,'   |');
		writeln('----------------------------------------------------------------------');
	end;
end;

var
  i, k: longint;
  sum: array[1..2] of longint;

//MAIN
begin
  randomize;
  tests[1] := 10;
  tests[2] := 20;
  tests[3] := 50;
  tests[4] := 100;
  sum[1] := 0; sum[2] := 0;
  for i := 1 to 4 do
  begin
    sum[1] := 0; sum[2] := 0;
    for k := 1 to 5 do
    begin
      init();
      generateTests(k, tests[i]);
      simpleMergeSort(X1, 1, tests[i]);
      statTable[i].n := tests[i];
      statTable[i].ms[k].first := cmpCount;
      sum[1] := sum[1] + cmpCount;
      statTable[i].ms[k].second := swapCount;
      sum[2] := sum[2] + swapCount;
    end;
    statTable[i].midVal.first := round(sum[1] / 5);
    statTable[i].midVal.second := round(sum[2] / 5);
  end;
  printTable();
end.