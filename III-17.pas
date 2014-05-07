// Вариант 17 Jerome Boateng

program IV_17;

type
  polynom = ^list;
  list = record
    sgn: integer;
    cft: integer;
    deg: integer;
    next: polynom;
  end;

var
  a, b, c: polynom;

//---------------------------/Вспомогательные процедуры/------------------------
function isDigit(x: char): boolean;
begin
  isDigit := x in ['0'..'9'];
end;

function isSign(x: char): boolean;
begin
  isSign := x in ['+', '-'];
end;

function isDeg(x: char): boolean;
begin
  isDeg := x = '^';
end;

function SearchDegree(x: polynom; var w: polynom; k: integer): boolean;
begin
  SearchDegree := false;
  repeat
    if x^.deg = k then
    begin
      SearchDegree := true;
      break
    end else
      x := x^.next;
  until x^.next = nil
end;
//------------------------------------------------------------------------------

//----------------------------/Ввод многочлена/---------------------------------
procedure ReadPolynom(var x: polynom);
var
  tmp: polynom;
  sgn_tmp: integer;
  cft_tmp, deg_tmp, cft_acc, deg_acc: integer;
  deg_flag: boolean;
  y: char;
begin
  sgn_tmp := 1;
  repeat
    read(y);
    
    //Обработка знака
    if isSign(y) then
    begin
      if x = nil then
      begin
        new(tmp);
        x := tmp;
        x^.next := nil;
        if cft_acc = 0 then x^.cft := 1
        else x^.cft := cft_acc;
        x^.deg := deg_acc;
        x^.sgn := sgn_tmp;
      end else
      begin
        tmp := x;
        while tmp^.next <> nil do
          tmp := tmp^.next;
        new(tmp^.next);
        tmp := tmp^.next;
        tmp^.next := nil;
        if cft_acc = 0 then tmp^.cft := 1
        else tmp^.cft := cft_acc;
        tmp^.deg := deg_acc;
        tmp^.sgn := sgn_tmp;
      end;
      
      cft_tmp := 0;
      cft_acc := 0;
      deg_tmp := 0;
      deg_acc := 0;
      deg_flag := false;
      
      if y = '-' then sgn_tmp := -1;
      
    end;
    //---------------
    
    if y = 'x' then deg_acc := 1;
    
    if isDeg(y) then
    begin
      deg_flag := true;
      deg_acc := 0;
    end;  
    
    //Обработка цифр
    if isDigit(y) then
    begin
      if deg_flag then
      begin
        deg_tmp := ord(y) - ord('0');
        deg_acc := deg_acc * 10 + deg_tmp;
      end else
      begin
        cft_tmp := ord(y) - ord('0');
        cft_acc := cft_acc * 10 + cft_tmp;
      end;
    end;
    //--------------
  until y = ' ';
  
  if x = nil then
  begin
    new(tmp);
    x := tmp;
    x^.next := nil;
    if cft_acc = 0 then x^.cft := 1
    else x^.cft := cft_acc;
    x^.deg := deg_acc;
    x^.sgn := sgn_tmp;
    
  end else
  begin
    tmp := x;
    while tmp^.next <> nil do
      tmp := tmp^.next;
    new(tmp^.next);
    tmp := tmp^.next;
    tmp^.next := nil;
    if cft_acc = 0 then tmp^.cft := 1
    else tmp^.cft := cft_acc;
    tmp^.deg := deg_acc;
    tmp^.sgn := sgn_tmp;
  end;
  
end;
//------------------------------------------------------------------------------

//--------------------------/Вывод многочлена/----------------------------------
procedure PrintPolynom(x: polynom);
var
  tmp: polynom;
begin
  tmp := x;
  if tmp^.sgn = -1 then write('-');
  if tmp^.cft <> 1 then write(tmp^.cft);
  if tmp^.deg = 1 then write('x') 
  else if tmp^.deg <> 0 then write('x^', tmp^.deg); 
  tmp := tmp^.next;
  while tmp <> nil do
  begin
    case tmp^.sgn of
      -1: write('-');
      1: write('+');
    end;
    if tmp^.cft <> 1 then write(tmp^.cft);
    if tmp^.deg = 1 then write('x') 
    else if tmp^.deg <> 0 then write('x^', tmp^.deg);
    tmp := tmp^.next;
  end;
end;
//------------------------------------------------------------------------------

//--------------------------/Произведение многочленов/--------------------------
procedure MultiplyPolynom(x, y: polynom; var z: polynom);
var
  tmp1, tmp2, tmp3: polynom;
begin
  tmp1 := x;
  while tmp1 <> nil do
  begin
    tmp2 := y;
    while tmp2 <> nil do
    begin
      if z = nil then
      begin
        new(tmp3);
        z := tmp3;
        z^.next := nil;
        z^.cft := tmp1^.cft * tmp2^.cft;
        z^.deg := tmp1^.deg + tmp2^.deg;
        z^.sgn := tmp1^.sgn * tmp2^.sgn;
      end else
      begin
        tmp3 := z;
        while tmp3^.next <> nil do
          tmp3 := tmp3^.next;
        new(tmp3^.next);
        tmp3 := tmp3^.next;
        tmp3^.next := nil;
        tmp3^.cft := tmp1^.cft * tmp2^.cft;
        tmp3^.deg := tmp1^.deg + tmp2^.deg;
        tmp3^.sgn := tmp1^.sgn * tmp2^.sgn;
      end;
      tmp2 := tmp2^.next;
    end;
    tmp1 := tmp1^.next;
  end;
end;
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//-----------------------------------/MAIN/-------------------------------------
//------------------------------------------------------------------------------

begin
  ReadPolynom(a);
  ReadPolynom(b);
  MultiplyPolynom(a, b, c);
  PrintPolynom(c);
  writeln;
end.
