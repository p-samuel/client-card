unit u_main;

interface
 // ['{AE6FA75E-F79A-4E40-9767-37AA6F109569}']
uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Objects, FMX.Ani, FMX.Effects, FMX.StdCtrls, Fmx.Bind.GenData,
  Data.Bind.GenData, System.Rtti, FMX.Grid.Style, FMX.Controls.Presentation,
  FMX.ScrollBox, FMX.Grid, Data.Bind.Components, Data.Bind.ObjectScope,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.Grid;

type
  TForm1 = class(TForm)
    Layout1: TLayout;
    Rectangle1: TRectangle;
    Circle1: TCircle;
    Rectangle2: TRectangle;
    FloatAnimationDeg: TFloatAnimation;
    FloatAnimationY: TFloatAnimation;
    ShadowEffect1: TShadowEffect;
    Splitter1: TSplitter;
    PrototypeBindSource1: TPrototypeBindSource;
    Grid1: TGrid;
    BindingsList1: TBindingsList;
    LinkGridToDataSourcePrototypeBindSource1: TLinkGridToDataSource;
    Text1: TText;
    Text2: TText;
    Image1: TImage;
    Image2: TImage;
    Text3: TText;
    Text4: TText;
    LinkPropertyToFieldText: TLinkPropertyToField;
    LinkPropertyToFieldText2: TLinkPropertyToField;
    LinkPropertyToFieldBitmap: TLinkPropertyToField;
    Circle2: TCircle;
    Rectangle3: TRectangle;
    Text5: TText;
    Circle3: TCircle;
    Rectangle4: TRectangle;
    Text6: TText;
    StyleBook1: TStyleBook;
    procedure FormCreate(Sender: TObject);
    procedure Layout1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Single);
    procedure Layout1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure Layout1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure FloatAnimationDegFinish(Sender: TObject);
    procedure Layout1Resized(Sender: TObject);
    procedure FloatAnimationDegProcess(Sender: TObject);
    procedure Grid1CellClick(const Column: TColumn; const Row: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
    Win:Single;
    PointDelta:TPointF;
    procedure InitCards;
    procedure UpdateStatus(const aCi:TCircle;const aTe:TText;const aDeg:Single = 0);
    function DegPointY:Single;
    procedure NextCard;
    procedure EditCard;
    procedure NextUpdate;
  end;

  const InfDeg: Array[-1..1] of String = ('Ahh!',Space,'Yep!' );

var
  Form1: TForm1;



implementation

Uses
 Math;

{$R *.fmx}

function TForm1.DegPointY: Single;
begin
 Result := ((Rectangle1.Height * 0.5) -  (Circle1.Height * 0.5) + 950);
end;

procedure TForm1.EditCard;
var A:integer;
begin
   if Abs(Circle1.RotationAngle) > 15
   then begin
          {           Direction            }
          { Up(+) Down(-) Right(+) Left(-) }
          A := Sign(Circle1.RotationAngle);
          A := Sign(DegPointY) * A;
          PrototypeBindSource1.DataGenerator.FindField('Field1').SetTValue(A);


        end;
end;

procedure TForm1.FloatAnimationDegFinish(Sender: TObject);
begin
 if (Abs(Circle1.RotationAngle) > 15)
 or (FloatAnimationY.AnimationType = TAnimationType.&In)
 then NextCard;

 FloatAnimationDeg.AnimationType := TAnimationType.Out;
 FloatAnimationDeg.Interpolation := TInterpolationType.Back;
 FloatAnimationDeg.StopValue := 0;
 FloatAnimationY.AnimationType := TAnimationType.Out;
 FloatAnimationY.Interpolation := TInterpolationType.Back;
 FloatAnimationY.StopValue := DegPointY;
 UpdateStatus(Circle3,Text6);
 InitCards;
 Layout1.Repaint;
end;

procedure TForm1.FloatAnimationDegProcess(Sender: TObject);
begin
 ShadowEffect1.UpdateParentEffects;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 InitCards;
 Layout1.AutoCapture := True;
 UpdateStatus(Circle3,Text6);
 NextUpdate;
end;


procedure TForm1.Grid1CellClick(const Column: TColumn; const Row: Integer);
begin
 UpdateStatus(Circle3,Text6);
 NextUpdate;
end;

procedure TForm1.InitCards;
begin
 Rectangle2.Width := Rectangle1.Width;
 Rectangle2.Height := Rectangle1.Height;
 Circle1.RotationAngle := 0;
 Circle1.Position.X := (Rectangle1.Width * 0.5) - (Circle1.Width * 0.5) ;
 Circle1.Position.Y := DegPointY;
 FloatAnimationY.StopValue := DegPointY;
 Rectangle2.Position.X := -(Rectangle1.Width - Circle1.Width) * 0.5;
 Rectangle2.Position.Y := -DegPointY;

end;

procedure TForm1.Layout1MouseDown(Sender: TObject; Button: TMouseButton;
Shift: TShiftState; X, Y: Single);
 var A,B,C,D:TPointF;
begin
  if ssLeft in Shift then
  begin
    A := TPointF.Create(X,Y);
    B := Circle1.AbsoluteRect.CenterPoint;
    C := Rectangle1.AbsoluteRect.CenterPoint;
    D := B - A;
    D := D.Normalize * (B - C).Length;
    Win := RadToDeg(ArcTan2(D.Y, D.X));
    PointDelta := Circle1.Position.Point - A;

  end;
end;
procedure TForm1.Layout1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Single);
 var A,B,C,D,E:TPointF;
     W:Single;
begin
  if ssLeft in Shift then
  begin
    A := TPointF.Create(X,Y);
    B := Circle1.AbsoluteRect.CenterPoint;
    C := Rectangle1.AbsoluteRect.CenterPoint;
    D := B - A;
    D := D.Normalize * (B - C).Length;
    W := RadToDeg(ArcTan2(D.Y, D.X));
    E := A + PointDelta;
    E.X := (Rectangle1.Width * 0.5) - (Circle1.Width * 0.5);
    Circle1.RotationAngle := W - Win;
    Circle1.Position.Point := E;
  //  Caption := FloatToStr(W - Win);
    UpdateStatus(Circle3,Text6,Circle1.RotationAngle);

  end;
end;

procedure TForm1.Layout1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
var H:Single;
begin

  if Abs(Circle1.RotationAngle) > 15 then
  begin
    FloatAnimationDeg.AnimationType := TAnimationType.&In;
    FloatAnimationDeg.Interpolation := TInterpolationType.Quadratic;
    FloatAnimationDeg.StopValue := Sign(Circle1.RotationAngle)* 60;
  end
  else
  begin
    H := DegPointY;
    if Abs(Circle1.Position.Y - H) > Rectangle1.Height * 0.85 then
    begin
      H := Sign(Circle1.Position.Y - H) * (Rectangle1.Height * 1.5 + H) ;
      FloatAnimationY.AnimationType := TAnimationType.&In;
      FloatAnimationY.Interpolation := TInterpolationType.Quadratic;
    end;

    FloatAnimationY.StopValue := H;
    FloatAnimationY.Start;
  end;


   FloatAnimationDeg.Start;

end;

procedure TForm1.Layout1Resized(Sender: TObject);
begin
 InitCards;
end;

procedure TForm1.NextCard;
begin
 EditCard;
 if PrototypeBindSource1.Eof
 then PrototypeBindSource1.First
 else PrototypeBindSource1.Next ;
 NextUpdate;
end;

procedure TForm1.NextUpdate;
var I:integer;
    B:Boolean;
begin
   B := PrototypeBindSource1.Eof;
   I := PrototypeBindSource1.ItemIndex;
   PrototypeBindSource1.ItemIndex := I + 1;
   if B  then PrototypeBindSource1.First;
   Image1.Bitmap.Assign(TPersistent(PrototypeBindSource1.DataGenerator.GetMember('ContactBitmapL1')));
   Text1.Text := PrototypeBindSource1.DataGenerator.FindField('ContactName1').GetTValue.AsString;
   Text2.Text := PrototypeBindSource1.DataGenerator.FindField('LoremIpsum1').GetTValue.AsString;
   UpdateStatus(Circle2,Text5);
   PrototypeBindSource1.ItemIndex := I;
end;

procedure TForm1.UpdateStatus(const aCi: TCircle; const aTe: TText;
  const aDeg: Single);
  Var A:Integer;
begin

  A :=0;
  if Abs(aDeg) > 1 then
    A := Sign(aDeg)
  else
    A := Sign(PrototypeBindSource1.DataGenerator.FindField('Field1').GetTValue.AsInteger);


  A := Sign(DegPointY)* A;
  aCi.Visible := (A <> 0);
  aCi.RotationAngle := A * 35;
  aTe.Text := InfDeg[A]; //-1(NO) 0(SPACE) 1(YES)

end;

end.
