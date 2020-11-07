# clients-card
Demonstration using firemonkey library

This project is a lesson by QuarkCube Youtube Channel.

![](client-card.gif)

Nice dragging effect using firemonkey library.😬 
The code is verbose, but using the right calculations one can make whatever he desires with animations in simple pure pascal:

```
procedure TForm1.Layout1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
var A,B,C,D,E:TPointF; W:Single;
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
    //Caption := FloatToStr(W - Win);
    UpdateStatus(Circle3,Text6,Circle1.RotationAngle);

  end;
end;
```
