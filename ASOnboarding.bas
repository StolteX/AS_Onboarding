B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=7
@EndOfDesignText@
'Author: Alexander Stolte
'Version: V1.12

#IF Documentation

Updates:
V1.1
-Add getNextButton
-Add getBackButton
-Add getSkipButton
-Add getFinishButton
-Add SwipeGesture swipe right to left to get next, or swipe left to right to get back
-Add SwipeGesture Enable Property
-Add Fix DesignerPropertys Description Texts

v1.2
-Add AddView
-Add B4J Click Events

v1.3
-Add Tags for every Page

v1.4
-Add HeaderSize

v1.5
-Indicator BugFix

v1.6
-AddView BugFix

v1.7
-Add BackgroundImage
-Add TagOfPage Set or Get the Tag on a Index

v1.8
-Add Partingline + Visible + Color + BorderWidth Property
-Add Indicator Active Color and Inactive Color Property
-BugFixes
-Add b4xlib

V1.9
-Fix Crash on Crashlytics "width and height must be > 0"

V1.10
-Add getHeaderLabel Property
-Add getDescriptionLabel Property
V1.11
-Removed a unusded Variable
-Add AutomaticCalculateDescriptionTextHeight Property, set it to true and the description text height adapts automatically to the text
V1.12
-B4I BugFixes

#End If

#DesignerProperty: Key: NextButton, DisplayName: Next Button Text, FieldType: String, DefaultValue: Next , Description: Text on Next Button
#DesignerProperty: Key: BackButton, DisplayName: Back Button Text, FieldType: String, DefaultValue: Back , Description: Text on Back Button
#DesignerProperty: Key: ShowSkipButton, DisplayName: Show Skip Button, FieldType: Boolean, DefaultValue: True, Description: Enable Skip Button , Description: Enable Skip Button
#DesignerProperty: Key: SkipButton, DisplayName: Skip Button Text, FieldType: String, DefaultValue: Skip , Description: Text on Skip Button
#DesignerProperty: Key: ShowFinishButtonText, DisplayName: Show Finish Button Text, FieldType: Boolean, DefaultValue: True, Description: Enable Finish Button
#DesignerProperty: Key: FinishButtonText, DisplayName: Finish Button Text, FieldType: String, DefaultValue: Get Started , Description: Text on Finish Button
#DesignerProperty: Key: SwipeGestureEnable, DisplayName: Enable SwipeGesture, FieldType: Boolean, DefaultValue: True, Description: Swipe right to left to get next or swipe left to right to get back
#DesignerProperty: Key: HeaderSize, DisplayName: Header Size in Percent, FieldType: Int, DefaultValue: 50,  MinRange: 25, MaxRange: 75, Description: Set the height percentage of the upper Header View 
#DesignerProperty: Key: PartinglineVisible, DisplayName: Partingline Visible, FieldType: Boolean, DefaultValue: False, Description: Shows a partingline.
#DesignerProperty: Key: PartinglineColor, DisplayName: Partingline Color, FieldType: Color, DefaultValue: 0xFFFFFFFF, Description: The Color of Partingline
#DesignerProperty: Key: PartinglineBorderWidth, DisplayName: Partingline Border Width, FieldType: Float, DefaultValue: 2, MinRange: 0, MaxRange: 100, Description: The Border Width of the Partingline.
#DesignerProperty: Key: IndicatorActiveColor, DisplayName: Indicator Active Color, FieldType: Color, DefaultValue: 0xFFFFFFFF, Description: The Color of the Indicators they are active
#DesignerProperty: Key: IndicatorInactiveColor, DisplayName: Indicator Inactive Color, FieldType: Color, DefaultValue: 0x98FFFFFF, Description: The Color of the Indicators they are inactive

#Event: PageChange(Page as int)
#Event: NextButtonClick
#Event: BackButtonClick
#Event: SkipButtonClick
#Event: GetStartedButtonClick

Sub Class_Globals
	Private mEventName As String 'ignore
	Private mCallBack As Object 'ignore
	Private mBase As B4XView 'ignore
	Private xui As XUI 'ignore
	
	Private xpnl_headerarea,xpnl_bottomarea,xlbl_header_text,xlbl_description_text,xlbl_skipbtn,xlbl_nextbtn,xlbl_backbtn,xlbl_getstartedbtn,xpnl_circlebackground,ximg_backgroundimage,xpnl_partingline As B4XView
	Private currentpage As Int = 0
	Type Pages (BackgroundColor As Int,HeaderLayout As B4XView,HeadingText As String,DescriptionText As String,Tag As Object)
	Private pagelist As List
	Private IndicatorsCVS As B4XCanvas
	
	'Properties
	Private NextButtonText,BackButtonText,SkipButtonText,FinishButtonText As String
	Private ShowSkipButton,ShowFinishButton,SwipeGestureEnable As Boolean 'ignore
	Private MousePressedX,HeaderSize,PartinglineBorderWidth As Float 'ignore
	Private PartinglineVisible As Boolean
	Private PartinglineColor,IndicatorActiveColor,IndicatorInactiveColor As Int
	
	Private AutomaticCalculateDescriptionTextHeight As Boolean = False
	
End Sub

Private Sub ini_props(Props As Map)
	
	NextButtonText = Props.Get("NextButton")
	BackButtonText = Props.Get("BackButton")
	SkipButtonText = Props.Get("SkipButton")
	FinishButtonText = Props.Get("FinishButtonText")
	ShowSkipButton = Props.Get("ShowSkipButton")
	ShowFinishButton = Props.Get("ShowFinishButtonText")
	SwipeGestureEnable = Props.Get("SwipeGestureEnable")
	HeaderSize = Props.Get("HeaderSize")  /100
	PartinglineVisible = Props.Get("PartinglineVisible")
	PartinglineColor = xui.PaintOrColorToColor(Props.Get("PartinglineColor"))
	PartinglineBorderWidth = Props.Get("PartinglineBorderWidth")
	IndicatorActiveColor = xui.PaintOrColorToColor(Props.Get("IndicatorActiveColor"))
	IndicatorInactiveColor = xui.PaintOrColorToColor(Props.Get("IndicatorInactiveColor"))
	
End Sub

Public Sub Initialize (Callback As Object, EventName As String)
	mEventName = EventName
	mCallBack = Callback
	pagelist.Initialize
End Sub

'Adds the view per code to the given parent
Public Sub AddView(vParent As B4XView,vNextButton As String, vBackButton As String,vShowSkipButton As Boolean,vSkipButton As String,vShowFinishButtonText As Boolean,vFinishButtonText As String,vSwipeGestureEnable As Boolean,vHeaderSize As Float,vPartinglineVisible As Boolean, vPartinglineColor As Int, vPartinglineBorderWidth As Float,vIndicatorActiveColor As Int,vIndicatorInactiveColor As Int)
	
	Dim tmp_parent As B4XView = xui.CreatePanel("")
	vParent.AddView(tmp_parent,0,0,vParent.Width,vParent.Height)
	Dim Props As Map
	Props.Initialize
	
	Props.Put("NextButton",vNextButton)
	Props.Put("BackButton",vBackButton)
	Props.Put("ShowSkipButton",vShowSkipButton)
	Props.Put("SkipButton",vSkipButton)
	Props.Put("ShowFinishButtonText",vShowFinishButtonText)
	Props.Put("FinishButtonText",vFinishButtonText)
	Props.Put("SwipeGestureEnable",vSwipeGestureEnable)
	Props.Put("HeaderSize",vHeaderSize)
	Props.Put("PartinglineVisible",vPartinglineVisible)
	Props.Put("PartinglineColor",vPartinglineColor)
	Props.Put("PartinglineBorderWidth",vPartinglineBorderWidth)
	Props.Put("IndicatorActiveColor",vIndicatorActiveColor)
	Props.Put("IndicatorInactiveColor",vIndicatorInactiveColor)
	
	Dim tmp_lbl As B4XView = CreateLabel("",False)
	DesignerCreateView(tmp_parent,tmp_lbl,Props)
	
End Sub

'Base type must be Object
Public Sub DesignerCreateView (Base As Object, Lbl As Label, Props As Map)
	mBase = Base
  	ini_props(Props)
  
  #If B4A
  
  Base_Resize(mBase.Width,mBase.Height)
  
#End If
	
End Sub

Private Sub Base_Resize (Width As Double, Height As Double)
  
	If xpnl_headerarea.IsInitialized = False Then
		
		ini_views
		
	End If
	
If currentpage = pagelist.Size -1 Then	xlbl_getstartedbtn.Visible = ShowFinishButton
If currentpage < pagelist.Size -1 Then	xlbl_skipbtn.Visible = ShowSkipButton
	
	ximg_backgroundimage.SetLayoutAnimated(0,0,0,mBase.Width,mBase.Height)
	
	xpnl_headerarea.SetLayoutAnimated(0,0,0,mBase.Width,mBase.Height * HeaderSize)
	xpnl_bottomarea.SetLayoutAnimated(0,0,mBase.Height * HeaderSize,mBase.Width,mBase.Height * (1 - HeaderSize))
  
	xlbl_header_text.SetLayoutAnimated(0,5dip,(15 * xpnl_bottomarea.Height)/100,mBase.Width - 10dip,(15 * xpnl_bottomarea.Height)/100)
	
	xlbl_description_text.SetLayoutAnimated(0,5dip,(30 * xpnl_bottomarea.Height)/100,mBase.Width - 10dip,(35 * xpnl_bottomarea.Height)/100)'xlbl_header_text.Top + xlbl_header_text.Height
	
	xpnl_circlebackground.SetLayoutAnimated(0,0,0,xpnl_bottomarea.Width,(12.5 * xpnl_bottomarea.Height)/100)
  
	xpnl_partingline.Visible = PartinglineVisible
	xpnl_partingline.SetLayoutAnimated(0,0,0,mBase.Width,PartinglineBorderWidth)
  
	xlbl_backbtn.SetLayoutAnimated(0,0dip,(66.6 * xpnl_bottomarea.Height)/100,100dip,(16.6 * xpnl_bottomarea.Height)/100)
	xlbl_nextbtn.SetLayoutAnimated(0,xpnl_bottomarea.Width - 100dip,(66.6 * xpnl_bottomarea.Height)/100,100dip,(16.6 * xpnl_bottomarea.Height)/100)
  
	xlbl_skipbtn.SetLayoutAnimated(0,40dip,(83.2 * xpnl_bottomarea.Height)/100,xpnl_bottomarea.Width - 60dip,(11.06 * xpnl_bottomarea.Height)/100)
  
	xlbl_getstartedbtn.SetLayoutAnimated(0,40dip,(83.2 * xpnl_bottomarea.Height)/100,xpnl_bottomarea.Width - 60dip,(11.06 * xpnl_bottomarea.Height)/100) 
  
	xpnl_circlebackground.Width = Max(2dip, xpnl_circlebackground.Width)
	xpnl_circlebackground.Height = Max(2dip, xpnl_circlebackground.Height)
  
	IndicatorsCVS.Resize(xpnl_circlebackground.Width, xpnl_circlebackground.Height)
	DrawIndicators(xpnl_circlebackground.Height)
	
End Sub

Private Sub ini_views
	
	xpnl_headerarea = xui.CreatePanel("xpnl_headerarea")
	xpnl_bottomarea = xui.CreatePanel("xpnl_bottomarea")
	xlbl_header_text = CreateLabel("",False)
	xlbl_description_text = CreateLabel("",True)
	xlbl_backbtn = CreateLabel("xlbl_backbtn",False)
	xlbl_nextbtn = CreateLabel("xlbl_nextbtn",False)
	xlbl_skipbtn = CreateLabel("xlbl_skipbtn",False)
	xpnl_partingline = xui.CreatePanel("")
	xlbl_getstartedbtn = CreateLabel("xlbl_getstartedbtn",False)
	xpnl_circlebackground = xui.CreatePanel("")
	ximg_backgroundimage = CreateImageView("")
	mBase.AddView(ximg_backgroundimage,0,0,0,0)
	mBase.AddView(xpnl_headerarea,0,0,0,0)
	mBase.AddView(xpnl_bottomarea,0,0,0,0)
	xpnl_bottomarea.AddView(xlbl_header_text,0,0,0,0)
	xpnl_bottomarea.AddView(xlbl_description_text,0,0,0,0)
	xpnl_bottomarea.AddView(xlbl_backbtn,0,0,0,0)
	xpnl_bottomarea.AddView(xlbl_nextbtn,0,0,0,0)
	xpnl_bottomarea.AddView(xlbl_skipbtn,0,0,0,0)
	xpnl_bottomarea.AddView(xlbl_getstartedbtn,0,0,0,0)
	xpnl_bottomarea.AddView(xpnl_circlebackground,0,0,1dip,1dip)
	xpnl_bottomarea.AddView(xpnl_partingline,0,0,0,0)
	IndicatorsCVS.Initialize(xpnl_circlebackground)
	xlbl_header_text.TextColor = xui.Color_White
	xlbl_header_text.SetTextAlignment("CENTER","CENTER")
	xlbl_header_text.Font = xui.CreateDefaultBoldFont(20)
	xlbl_description_text.TextColor = xui.Color_White
	xlbl_description_text.SetTextAlignment("TOP","CENTER")
	#IF B4J
	Dim jo As JavaObject = xlbl_description_text
	jo.RunMethod("setTextAlignment", Array("CENTER"))
	#End IF
	xlbl_description_text.Font = xui.CreateDefaultFont(15)
  
	ViewDefaultValues(xlbl_backbtn,xui.CreateDefaultBoldFont(15),BackButtonText,True)
	ViewDefaultValues(xlbl_nextbtn,xui.CreateDefaultBoldFont(15),NextButtonText,True)
	ViewDefaultValues(xlbl_skipbtn,xui.CreateDefaultFont(15),SkipButtonText,False)
	ViewDefaultValues(xlbl_getstartedbtn,xui.CreateDefaultBoldFont(15),FinishButtonText,False)
	xpnl_partingline.Color = PartinglineColor
	
End Sub

'Just for safe codelines :P
Private Sub ViewDefaultValues(View As B4XView,xfont As B4XFont,str_text As String,Visible As Boolean)
	
	View.TextColor = xui.Color_White
	View.SetTextAlignment("CENTER","CENTER")
	View.Font = xfont
	View.Text = str_text
	View.Visible = Visible
	
End Sub

#Region UserProperties

Public Sub AddPage(HeadingText As String,Description As String,BackgroundColor As Int,HeaderLayout As B4XView,Tag As Object)
	
	Dim tmp_page As Pages
	tmp_page.Initialize
	tmp_page.HeadingText = HeadingText
	tmp_page.DescriptionText = Description
	tmp_page.BackgroundColor = BackgroundColor
	tmp_page.HeaderLayout = HeaderLayout
	tmp_page.Tag = Tag
	
	If pagelist.Size = 0 Then
		xlbl_header_text.Text = tmp_page.HeadingText
		xlbl_description_text.Text = tmp_page.DescriptionText
		xpnl_bottomarea.Color = tmp_page.BackgroundColor
		xpnl_headerarea.RemoveAllViews
		xpnl_headerarea.AddView(tmp_page.HeaderLayout,0,0,xpnl_headerarea.Width,xpnl_headerarea.Height)
		xlbl_backbtn.Visible = False
	End If
	
	pagelist.Add(tmp_page)
	DrawIndicators(xpnl_circlebackground.Height)
	If currentpage < pagelist.Size -1 Then	xlbl_skipbtn.Visible = ShowSkipButton
End Sub

Public Sub setBackgroundImage(Image As B4XBitmap)
	
	ximg_backgroundimage.SetBitmap(Image)
	
End Sub

Public Sub getBackgroundImage As B4XBitmap
	
	Dim iv As ImageView = ximg_backgroundimage
	#If B4J
	Return iv.GetImage
	#Else
	Return iv.Bitmap
	#End If
	
End Sub

Public Sub setIndicatorActiveColor(Color As Int)
	
	IndicatorActiveColor = Color
	DrawIndicators(xpnl_circlebackground.Height)
	
End Sub

Public Sub getIndicatorActiveColor As Int
	
	Return IndicatorActiveColor
	
End Sub

Public Sub setIndicatorInactiveColor(Color As Int)
	
	IndicatorInactiveColor = Color
	DrawIndicators(xpnl_circlebackground.Height)
	
End Sub

Public Sub getIndicatorInactiveColor As Int
	
	Return IndicatorInactiveColor
	
End Sub

Public Sub setPartinglineBorderWidth(BorderWidth As Float)
	
	PartinglineBorderWidth = BorderWidth
	xpnl_partingline.Height = PartinglineBorderWidth
	
End Sub

Public Sub getPartinglineBorderWidth As Float
	
	Return PartinglineBorderWidth
	
End Sub

Public Sub setPartingline_Visible(Visible As Boolean)
	
	PartinglineVisible = Visible
	xpnl_partingline.Visible = PartinglineVisible
	
End Sub

Public Sub getPartingline_Visible As Boolean
	
	Return PartinglineVisible
	
End Sub

Public Sub setPartingline_Color(Color As Int)
	
	PartinglineColor = Color
	xpnl_partingline.Color = PartinglineColor
	
End Sub

Public Sub getPartingline_Color As Int
	
	Return PartinglineColor
	
End Sub

'Sets the Tag of a Page with the given Index
Public Sub TagOfPage(Index As Int,Tag As Object)
	
	If Index > pagelist.Size -1 Then 
		
		Log("Index not in Range")
		Return
		
		Else
			
		Dim tmp_page As Pages = pagelist.Get(Index)
		tmp_page.Tag = Tag
			
	End If
	
End Sub

'Gets the Tag of a Page with the given Index
Public Sub getTagOfPage(Index As Int) As Object
	
	If Index > pagelist.Size -1 Then
		
		Log("Index not in Range")
		Return ""
		
	Else
			
		Dim tmp_page As Pages = pagelist.Get(Index)
		Return tmp_page.Tag
			
	End If
	
End Sub

'Gets or Sets the Tag of the current Page
Public Sub getTagOfCurrentPage As Object
	
	Dim tmp_page As Pages = pagelist.Get(currentpage -1)
	Return tmp_page.Tag
	
End Sub

'Gets or Sets the Tag of the current Page
Public Sub setTagOfCurrentPage(Tag As Object)
	
	Dim tmp_page As Pages = pagelist.Get(currentpage)
	tmp_page.Tag = Tag
	
End Sub

Public Sub setHeader_Size(Value As Int)
	
	HeaderSize =  Value /100
	Base_Resize(mBase.Width,mBase.Height)
	
End Sub

Public Sub getHeader_Size As Int
	
'	Dim result As Int = ImageHeightPercentage * 100
	Return HeaderSize * 100
	
End Sub

Public Sub getBaseView As B4XView
	
	Return mBase
	
End Sub

Public Sub getNextButton As B4XView
	
	Return xlbl_nextbtn
	
End Sub

Public Sub getBackButton As B4XView
	
	Return xlbl_backbtn
	
End Sub

Public Sub getSkipButton As B4XView
	
	Return xlbl_skipbtn
	
End Sub

Public Sub getFinishButton As B4XView
	
	Return xlbl_getstartedbtn
	
End Sub

Public Sub getHeaderLabel As B4XView
	
	Return xlbl_header_text
	
End Sub

Public Sub getDescriptionLabel As B4XView
	
	Return xlbl_description_text
	
End Sub

Public Sub setNextBtnText(Text As String)
	
	NextButtonText = Text
	xlbl_nextbtn.Text = NextButtonText
	
End Sub

Public Sub getNextBtnText As String
	
	Return NextButtonText
	
End Sub

Public Sub setBackBtnText(Text As String)
	
	BackButtonText = Text
	xlbl_backbtn.Text = BackButtonText
	
End Sub

Public Sub getBackBtnText As String
	
	Return BackButtonText
	
End Sub

Public Sub setSkipBtnText(Text As String)
	
	SkipButtonText = Text
	xlbl_skipbtn.Text = SkipButtonText
	
End Sub

Public Sub getSkipBtnText As String
	
	Return SkipButtonText
	
End Sub

Public Sub setFinishBtnText(Text As String)
	
	FinishButtonText = Text
	xlbl_getstartedbtn.Text = FinishButtonText
	
End Sub

Public Sub getFinishBtnText As String
	
	Return FinishButtonText
	
End Sub

Public Sub setShowSkipBtn(Visible As Boolean)
	
	ShowSkipButton = Visible
	Base_Resize(mBase.Width,mBase.Height)
	
End Sub

Public Sub getShowSkipBtn As Boolean
	
	Return ShowSkipButton
	
End Sub

Public Sub setShowFinishBtn(Visible As Boolean)
	
	ShowFinishButton = Visible
	Base_Resize(mBase.Width,mBase.Height)
	
End Sub

Public Sub getShowFinishBtn As Boolean
	
	Return ShowFinishButton
	
End Sub


Public Sub setAutomaticCalculateDescriptionTextHeight(enable As Boolean)
	
	AutomaticCalculateDescriptionTextHeight = enable
	TextHeight(enable)
	
	
End Sub

Public Sub getAutomaticCalculateDescriptionTextHeight As Boolean
	
	Return	AutomaticCalculateDescriptionTextHeight
	
End Sub


Private Sub TextHeight(automatic As Boolean)
	
	If automatic = True Then
		
		Dim multipleLines As Boolean = xlbl_description_text.Text.Contains(CRLF)
		Dim size As Float
		For size = 2 To 200
			If CheckSize(size, multipleLines) Then Exit
		Next
		size = size - 0.5
		If CheckSize(size, multipleLines) Then size = size - 0.5
		Sleep(0)
		xlbl_description_text.TextSize = size
		
	Else
			
		xlbl_description_text.Font = xui.CreateDefaultFont(15)
		
	End If
	
End Sub

#End Region

#If B4A or B4I

Private Sub xpnl_headerarea_Touch (Action As Int, X As Float, Y As Float)
	
	If SwipeGestureEnable = True Then SwipeGesture(xpnl_headerarea,Action,X,Y)
	
End Sub

Private Sub xpnl_bottomarea_Touch (Action As Int, X As Float, Y As Float)
	
	If SwipeGestureEnable = True Then SwipeGesture(xpnl_bottomarea,Action,X,Y)
	
End Sub

#End if

Private Sub b4x_backbtnClick
	
	If pagelist.Size > 0 And currentpage > 0 Then
		
		currentpage = currentpage -1
		If currentpage = 0 Then xlbl_backbtn.Visible = False
		xlbl_nextbtn.Visible = True
		BackButtonClickHandler
		PageChangeHandler(currentpage)
		
		Dim tmp_page As Pages = pagelist.Get(currentpage)
		
		xlbl_header_text.Text = tmp_page.HeadingText
		xlbl_description_text.Text = tmp_page.DescriptionText
		xpnl_bottomarea.SetColorAnimated(250,xpnl_bottomarea.Color,tmp_page.BackgroundColor)
		xpnl_headerarea.RemoveAllViews
		xpnl_headerarea.AddView(tmp_page.HeaderLayout,0,0,xpnl_headerarea.Width,xpnl_headerarea.Height)
		DrawIndicators(xpnl_circlebackground.Height)
		
		xlbl_getstartedbtn.Visible = False
		If currentpage < pagelist.Size -1 Then	xlbl_skipbtn.Visible = ShowSkipButton
	End If
	
End Sub

#If B4J

Private Sub xlbl_backbtn_MouseClicked (EventData As MouseEvent)
	
	b4x_backbtnClick
	
End Sub

#Else

Private Sub xlbl_backbtn_Click
	
	b4x_backbtnClick
	
End Sub

#End If

Private Sub b4x_nextbtnClick
	
	If pagelist.Size > 0 And currentpage < pagelist.Size -1 Then
		
		currentpage = currentpage +1
		xlbl_backbtn.Visible = True
		If currentpage = pagelist.Size -1 Then xlbl_nextbtn.Visible = False
		NextButtonClickHandler
		PageChangeHandler(currentpage)
		
		Dim tmp_page As Pages = pagelist.Get(currentpage)
		
		xlbl_header_text.Text = tmp_page.HeadingText
		xlbl_description_text.Text = tmp_page.DescriptionText
		xpnl_bottomarea.SetColorAnimated(250,xpnl_bottomarea.Color,tmp_page.BackgroundColor)
		xpnl_headerarea.RemoveAllViews
		xpnl_headerarea.AddView(tmp_page.HeaderLayout,0,0,xpnl_headerarea.Width,xpnl_headerarea.Height)
		
		DrawIndicators(xpnl_circlebackground.Height)
		
		If currentpage = pagelist.Size -1 Then	xlbl_getstartedbtn.Visible = ShowFinishButton
		If currentpage < pagelist.Size -1 Then	xlbl_skipbtn.Visible = ShowSkipButton Else xlbl_skipbtn.Visible = False
	End If
	
End Sub

#If B4J

Private Sub xlbl_nextbtn_MouseClicked (EventData As MouseEvent)
	
	b4x_nextbtnClick
	
End Sub

#Else
Private Sub xlbl_nextbtn_Click
	
	b4x_nextbtnClick
	
End Sub

#End If

#If B4J

Private Sub xlbl_skipbtn_MouseClicked (EventData As MouseEvent)
	
	SkipButtonClickHandler
	
End Sub

#Else

Private Sub xlbl_skipbtn_Click
	
	SkipButtonClickHandler
	
End Sub

#End If

#If B4J

Private Sub xlbl_getstartedbtn_MouseClicked (EventData As MouseEvent)
	
	GetStartedButtonClickHandler
	
End Sub

#Else

Private Sub xlbl_getstartedbtn_Click
	
	GetStartedButtonClickHandler
	
End Sub

#End If



#Region Events

Private Sub PageChangeHandler(Page As Int)
	
	If xui.SubExists(mCallBack, mEventName & "_PageChange",0) Then
		CallSub2(mCallBack, mEventName & "_PageChange",Page)
	End If
	
End Sub

Private Sub NextButtonClickHandler
	
	If xui.SubExists(mCallBack, mEventName & "_NextButtonClick",0) Then
		CallSub(mCallBack, mEventName & "_NextButtonClick")
	End If
	
End Sub

Private Sub BackButtonClickHandler
	
	If xui.SubExists(mCallBack, mEventName & "_BackButtonClick",0) Then
		CallSub(mCallBack, mEventName & "_BackButtonClick")
	End If
	
End Sub

Private Sub SkipButtonClickHandler
	
	If xui.SubExists(mCallBack, mEventName & "_SkipButtonClick",0) Then
		CallSub(mCallBack, mEventName & "_SkipButtonClick")
	End If
	
End Sub

Private Sub GetStartedButtonClickHandler
	
	If xui.SubExists(mCallBack, mEventName & "_GetStartedButtonClick",0) Then
		CallSub(mCallBack, mEventName & "_GetStartedButtonClick")
	End If
	
End Sub

#End Region

#Region Functions

'https://www.b4x.com/android/forum/threads/b4x-xui-imageslider.87128/
Private Sub DrawIndicators(Height As Float)
	'If pagelist.Size < Then Return
	IndicatorsCVS.ClearRect(IndicatorsCVS.TargetRect)
	Dim clr As Int
	For i = 0 To pagelist.Size - 1
		If currentpage = i Then clr = IndicatorActiveColor Else clr =  IndicatorInactiveColor
		IndicatorsCVS.DrawCircle(IndicatorsCVS.TargetRect.CenterX + (-(pagelist.Size - 1) / 2 + i) * 30dip, Height/2, 3dip, clr, True, 0)
	Next
	IndicatorsCVS.Invalidate
End Sub

#If B4A or B4I

'https://www.b4x.com/android/forum/threads/b4x-xui-imageslider.87128/
Private Sub SwipeGesture (xpnl As B4XView,Action As Int, X As Float, Y As Float)'ignore
	
	If Action = xpnl.TOUCH_ACTION_DOWN Then
		MousePressedX = X
	Else If Action = xpnl.TOUCH_ACTION_UP Then
		If X > MousePressedX + 50dip Then
			xlbl_backbtn_Click
		Else if X < MousePressedX - 50dip Then
			
			xlbl_nextbtn_Click
		End If
	End If
	
End Sub

#End if

Private Sub CreateLabel(EventName As String,Multiline As Boolean) As B4XView'ignore
	
	Dim tmp_lbl As Label
	tmp_lbl.Initialize(EventName)
	#IF B4J
	tmp_lbl.WrapText = Multiline
	#Else If B4I
	tmp_lbl.Multiline = Multiline
	#End IF
	Return tmp_lbl
	
End Sub

Private Sub CreateImageView(EventName As String) As B4XView
	
	Dim tmp_imageview As ImageView
	tmp_imageview.Initialize(EventName)
	
	Return tmp_imageview
	
End Sub


'returns true if the size is too large
Private Sub CheckSize(size As Float, multipleLines As Boolean) As Boolean
	xlbl_description_text.TextSize = size
	If multipleLines Then
		#If B4A
		Dim su As StringUtils
		Return su.MeasureMultilineTextHeight(xlbl_description_text,xlbl_description_text.Text) > xlbl_description_text.Height
		
		
		
		#Else if B4I
		Dim tmplbl As Label = xlbl_description_text
		tmplbl.Multiline = True
		xlbl_description_text = tmplbl
		'Return MeasureTextHeight(xlbl_description_text.Text,xlbl_description_text.Font) > xlbl_description_text.Height
		Return getTextHeight(xlbl_description_text.Text,xlbl_description_text.Font,xlbl_description_text.Width) > xlbl_description_text.Height
		#Else B4J
		
		Return MeasureMultilineTextHeight(xlbl_description_text.Font,xlbl_description_text.Width,xlbl_description_text.Text)
		
		#End If
		
	Else
	
		#if b4A
		Dim stuti As StringUtils
		Return MeasureTextWidth(xlbl_description_text.Text,xlbl_description_text.Font) > xlbl_description_text.Width Or stuti.MeasureMultilineTextHeight(xlbl_description_text,xlbl_description_text.Text) > xlbl_description_text.Height
		
		#Else
		
		Return MeasureTextWidth(xlbl_description_text.Text,xlbl_description_text.Font) > xlbl_description_text.Width Or MeasureTextHeight(xlbl_description_text.Text,xlbl_description_text.Font) > xlbl_description_text.Height
			
		#End If
		
	End If
	
End Sub

'https://www.b4x.com/android/forum/threads/b4x-xui-add-measuretextwidth-and-measuretextheight-to-b4xcanvas.91865/#content
Private Sub MeasureTextWidth(Text As String, Font1 As B4XFont) As Int
#If B4A
	Private bmp As Bitmap
	bmp.InitializeMutable(1, 1)'ignore
	Private cvs As Canvas
	cvs.Initialize2(bmp)
	Return cvs.MeasureStringWidth(Text, Font1.ToNativeFont, Font1.Size)
#Else If B4i
    Return Text.MeasureWidth(Font1.ToNativeFont)
#Else If B4J
    Dim jo As JavaObject
    jo.InitializeNewInstance("javafx.scene.text.Text", Array(Text))
    jo.RunMethod("setFont",Array(Font1.ToNativeFont))
    jo.RunMethod("setLineSpacing",Array(0.0))
    jo.RunMethod("setWrappingWidth",Array(0.0))
    Dim Bounds As JavaObject = jo.RunMethod("getLayoutBounds",Null)
    Return Bounds.RunMethod("getWidth",Null)
#End If
End Sub

'https://www.b4x.com/android/forum/threads/b4x-xui-add-measuretextwidth-and-measuretextheight-to-b4xcanvas.91865/#content
Private Sub MeasureTextHeight(Text As String, Font1 As B4XFont) As Int'Ignore
#If B4A     
	Private bmp As Bitmap
	bmp.InitializeMutable(1, 1)'ignore
	Private cvs As Canvas
	cvs.Initialize2(bmp)
	Return cvs.MeasureStringHeight(Text, Font1.ToNativeFont, Font1.Size)
	
#Else If B4i
    Return Text.MeasureHeight(Font1.ToNativeFont)
#Else If B4J
    Dim jo As JavaObject
    jo.InitializeNewInstance("javafx.scene.text.Text", Array(Text))
    jo.RunMethod("setFont",Array(Font1.ToNativeFont))
    jo.RunMethod("setLineSpacing",Array(0.0))
    jo.RunMethod("setWrappingWidth",Array(0.0))
    Dim Bounds As JavaObject = jo.RunMethod("getLayoutBounds",Null)
    Return Bounds.RunMethod("getHeight",Null)
#End If
End Sub


#If B4I
'https://www.b4x.com/android/forum/threads/measuremultilinetextheight-in-ios.65556/#post-531390
Private Sub getTextHeight(Text As String,fo As Font,LbWidth As Float) As Float
  
	Dim tmpString As String = "大"
	Dim str() As String = Regex.Split(Chr(10),Text)
	Dim height As Float
	Dim number As Int
	Dim fontHeight As Float = tmpString.MeasureHeight(fo)
	For Each s As String In str
		number = s.MeasureWidth(fo)/LbWidth + 1
		height = height + number*fontHeight
	Next
	Return height + fontHeight
End Sub

#End if

#End Region
