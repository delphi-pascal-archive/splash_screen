unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    ImageMain: TImage;
    ImageMask: TImage;
    Label1: TLabel;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses Unit2;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
 FormSplash.Show;
 FormSplash.BuildCopy24to32(ImageMain.Picture.Bitmap,ImageMask.Picture.Bitmap, FormSplash.bt);
 FormSplash.RenderForm;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 ImageMain.Picture.Bitmap.PixelFormat:=pf24bit;
 ImageMask.Picture.Bitmap.PixelFormat:=pf24bit;
end;

end.
