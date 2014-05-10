// Вариант 17 Jerome Boateng

program III_17;
type
  polynom = ^list;
  list = record
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
  while x <> nil do
  begin
    if x^.deg = k then
    begin
      w := x;
      SearchDegree := true;
      break
    end else
      x := x^.next;
  end;
end;
//------------------------------------------------------------------------------

//----------------------------/Ввод многочлена/---------------------------------
procedure ReadPolynom(var x: polynom);
var
  tmp: polynom;
  deg_flag, zf, flag: boolean;
  cft_tmp, cft_acc, deg_tmp, deg_acc, sgn: integer;
  y: char;
begin
  sgn := 1;
  zf := false;
  repeat
  read(y);
  
  if not flag then
    if y='0' then zf := true;
    
  flag := not flag;
   
  
  //Обработка знака
    if isSign(y) then
    begin
      if x = nil then
      begin
        new(tmp);
        x := tmp;
        x^.next := nil;
        if cft_acc = 0 then x^.cft := 1
        else x^.cft := sgn * cft_acc;
        x^.deg := deg_acc;
      end else
      begin
        tmp := x;
        while tmp^.next <> nil do
          tmp := tmp^.next;
        new(tmp^.next);
        tmp := tmp^.next;
        tmp^.next := nil;
        if cft_acc = 0 then tmp^.cft := 1
        else tmp^.cft := sgn * cft_acc;
        tmp^.deg := deg_acc;
      end;
      
      cft_tmp := 0;
      cft_acc := 0;
      deg_tmp := 0;
      deg_acc := 0;
      deg_flag := false;
      
      if y = '-' then sgn := -1 else sgn := 1;
      
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
    else x^.cft := sgn * cft_acc;
    x^.deg := deg_acc;
    
  end else
  begin
    tmp := x;
    while tmp^.next <> nil do
      tmp := tmp^.next;
    new(tmp^.next);
    tmp := tmp^.next;
    tmp^.next := nil;
    if cft_acc = 0 then tmp^.cft := 1
    else tmp^.cft := sgn * cft_acc;
    tmp^.deg := deg_acc;
  end;
  
  if zf then x^.cft := 0;
  
end;
//------------------------------------------------------------------------------

//--------------------------/Вывод многочлена/----------------------------------
procedure PrintPolynom(x: polynom);
var
  tmp: polynom;
begin
  tmp := x;
  if tmp^.cft <> 1 then write(tmp^.cft);
  if tmp^.deg = 1 then write('x') 
  else if tmp^.deg <> 0 then write('x^', tmp^.deg); 
  tmp := tmp^.next;
  while tmp <> nil do
  begin
  if tmp^.cft <> 0 then
  begin
    if tmp^.cft > 0 then write('+');
    if tmp^.cft <> 1 then write(tmp^.cft);
    if (tmp^.cft = 1) and (tmp^.deg = 0) then write(1);
    if tmp^.deg = 1 then write('x') 
    else if tmp^.deg <> 0 then write('x^', tmp^.deg);
  end;
    tmp := tmp^.next;
  end;
end;
//------------------------------------------------------------------------------

//--------------------------/Произведение многочленов/--------------------------
procedure MultiplyPolynom(x, y: polynom; var z: polynom);
var
  tmp1, tmp2, tmp3, tmp: polynom;
begin

  if (x^.cft = 0) or (y^.cft = 0) then
  begin
    new(z);
    z^.cft := 0
  end else
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
      end else
      begin
        tmp3 := z;
        while tmp3^.next <> nil do
          tmp3 := tmp3^.next;
          
        if searchDegree(z, tmp, (tmp1^.deg + tmp2^.deg)) then
        begin
          tmp^.cft := tmp^.cft + (tmp1^.cft * tmp2^.cft);
        end else
        begin
        tmp3 := z;
        if tmp3^.next <> nil then
        while ((tmp3^.deg > tmp1^.deg + tmp2^.deg)) do
        begin
          if tmp3^.next^.next = nil then
          begin
            tmp3 := tmp3^.next;
            break;
          end;
          tmp3 := tmp3^.next;
        end;
          new(tmp);
          tmp^.next := tmp3^.next;
          tmp3^.next := tmp;
          tmp^.cft := tmp1^.cft * tmp2^.cft;
          tmp^.deg := tmp1^.deg + tmp2^.deg;
          end;
      end;
      tmp2 := tmp2^.next;
    end;
    tmp1 := tmp1^.next;
  end;
  end;
end;
//------------------------------------------------------------------------------


//------------------------------/MAIN/------------------------------------------ 
begin
  readpolynom(a);
  readpolynom(b);
  multiplypolynom(a,b,c);
  printpolynom(c);
end. 
