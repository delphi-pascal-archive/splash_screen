unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;

type
  TFormSplash = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
  protected
  procedure WMWINDOWPOSCHANGING(var Msg: TWMWINDOWPOSCHANGING); message WM_WINDOWPOSCHANGING;
  public
    BT:Tbitmap;
    procedure RenderForm;
    procedure BuildCopy24to32(_B_in,_B_mask:TBitmap; var _B_out: TBitmap);
  end;

var
  FormSplash: TFormSplash;

implementation

{$R *.dfm}

procedure TFormSplash.FormCreate(Sender: TObject);
begin
BT:=Tbitmap.Create;
BT.PixelFormat:=pf32bit;
end;

procedure TFormSplash.BuildCopy24to32(_B_in,_B_mask:TBitmap; var _B_out: TBitmap);
const
  MaxPixelCountA = MaxInt div SizeOf(TRGBQuad);
  MaxPixelCount = MaxInt div SizeOf(TRGBTriple);
type
  PRGBArray = ^TRGBArray;
  TRGBArray = array[0..MaxPixelCount-1] of TRGBTriple;
  PRGBAArray = ^TRGBAArray;
  TRGBAArray = array[0..MaxPixelCountA-1] of TRGBQuad;
var x, y: Integer; RowOut: PRGBAArray; RowIn,RowInMask:PRGBArray;
begin
  _B_out.Width:=_B_in.Width;
  _B_out.Height:=_B_in.Height;
  for y:=0 to _B_in.Height-1 do begin
     RowOut:= _B_out.ScanLine[y];
     RowIn:= _B_in.ScanLine[y];
     RowInMask:= _B_mask.ScanLine[y];
    for x:=0 to _B_in.Width-1 do begin
          RowOut[x].rgbReserved:=trunc((RowInMask[x].rgbtBlue+RowInMask[x].rgbtGreen+RowInMask[x].rgbtRed)/3);
          RowOut[x].rgbBlue:=byte(trunc(RowIn[x].rgbtBlue*RowOut[x].rgbReserved/255));
          RowOut[x].rgbGreen:=byte(trunc(RowIn[x].rgbtGreen*RowOut[x].rgbReserved/255));
          RowOut[x].rgbRed:=byte(trunc(RowIn[x].rgbtRed*RowOut[x].rgbReserved/255));
    end;
  end
end;

procedure TFormSplash.RenderForm;
var zsize:TSize; zpoint:TPoint; zbf:TBlendFunction;
    TopLeft: TPoint; DC:HDC;
begin
  SetWindowLong(FormSplash.Handle,GWL_EXSTYLE, GetWindowLong(FormSplash.Handle,GWL_EXSTYLE) or WS_EX_LAYERED);

  width:=BT.Width;
  height:=BT.Height;

  zsize.cx := BT.Width;
  zsize.cy := BT.Height;
  zpoint := Point(0,0);

  with zbf do begin
    BlendOp := AC_SRC_OVER;
    BlendFlags := 0;
    AlphaFormat := AC_SRC_ALPHA;
    SourceConstantAlpha := 255;
  end;
  DC:= GetDC(0);
  TopLeft:=BoundsRect.TopLeft;
  UpdateLayeredWindow(FormSplash.Handle,DC,@TopLeft,@zsize,BT.Canvas.Handle,@zpoint,0,@zbf, ULW_ALPHA);
end;

procedure TFormSplash.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
const SC_DRAGMOVE : Longint = $F012;
begin
 if Button <> mbRight then begin
   ReleaseCapture;
   SendMessage(Handle, WM_SYSCOMMAND, SC_DRAGMOVE, 0);
   end;
end;

procedure TFormSplash.WMWINDOWPOSCHANGING(var Msg: TWMWINDOWPOSCHANGING);
begin
 SetWindowPos(Handle,HWND_TOPmost,Left,Top,Width,Height, SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE );
end;

end.
