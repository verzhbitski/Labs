// Вариант 17

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

procedure AddHead(var k: polynom; pcft, pdeg, psgn: integer);
var
  ptmp: polynom;
begin
  new(ptmp);
  
  k := ptmp;
  k^.next := nil;
  if pcft = 0 then k^.cft := psgn
  else k^.cft := psgn * pcft;
  k^.deg := pdeg;
end;

procedure AddTail(var k: polynom; pcft, pdeg, psgn: integer);
var
  ptmp: polynom;
begin
  ptmp := k;
  while ptmp^.next <> nil do
    ptmp := ptmp^.next;
  new(ptmp^.next);
  ptmp := ptmp^.next;
  ptmp^.next := nil;
  if pcft = 0 then ptmp^.cft := psgn
    else ptmp^.cft := psgn * pcft;
  ptmp^.deg := pdeg;
end;

procedure AddMid(var k: polynom; pcft, pdeg: integer);
var
  ptmp: polynom;
begin
  new(ptmp);
  ptmp^.next := k^.next;
  k^.next := ptmp;
  ptmp^.cft := pcft;
  ptmp^.deg := pdeg;
end;


//------------------------------------------------------------------------------

//----------------------------/Ввод многочлена/---------------------------------
procedure ReadPolynom(var x: polynom);
var
  deg_flag, zf: boolean;
  tmp, cft_acc, deg_acc, sgn: integer;
  y: char;
begin

  zf := true;
  sgn := 1;
  read(y);
  if y = 'x' then deg_acc := 1;
  if isDigit(y) then cft_acc := ord(y) - ord('0');
  if y = '0' then zf := false;
  
  if zf then
    repeat
    
      repeat
        if y = '-' then sgn := -1;
        read(y);
        if y = 'x' then deg_acc := 1;
        
        if isDeg(y) then
        begin
          deg_flag := true;
          deg_acc := 0;
        end;
        
        //Обработка цифр
        if isDigit(y) then
        begin
          tmp := ord(y) - ord('0');
          if deg_flag then
            deg_acc := deg_acc * 10 + tmp
            else
            cft_acc := cft_acc * 10 + tmp;
        end;
        
      until isSign(y) or (y = ' ');
    
      if x = nil then AddHead(x, cft_acc, deg_acc, sgn)
      else
        AddTail(x, cft_acc, deg_acc, sgn);
        
      tmp := 0;
      cft_acc := 0;
      deg_acc := 0;
      sgn := 1;
      deg_flag := false;
    
    until y = ' ' 
  else
  begin
    new(x);
    x^.cft := 0;
    x^.deg := 0;
    read(y);
    end;  
end;
//------------------------------------------------------------------------------

//--------------------------/Вывод многочлена/----------------------------------
procedure PrintPolynom(x: polynom);
var
  tmp: polynom;
begin
  tmp := x;
  if tmp^.cft = -1 then write('-') else
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
          AddHead(z, tmp1^.cft * tmp2^.cft, tmp1^.deg + tmp2^.deg, 1)
        else
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
              while ((tmp3^.next^.deg > tmp1^.deg + tmp2^.deg)) do
              begin
                if tmp3^.next^.next = nil then
                begin
                  tmp3 := tmp3^.next;
                  break;
                end;
                tmp3 := tmp3^.next;
              end;
            AddMid(tmp3, tmp1^.cft * tmp2^.cft, tmp1^.deg + tmp2^.deg);
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
  multiplypolynom(a, b, c);
  printpolynom(c);
end.