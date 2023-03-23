package imgui

import "core:c"

CHECKVERSION :: proc() {
	DebugCheckVersionAndDataLayout(IMGUI_VERSION, size_of(IO), size_of(Style), size_of(Vec2), size_of(Vec4), size_of(DrawVert), size_of(DrawIdx))
}


////////////////////////////////////////////////////////////
// DEFINES
////////////////////////////////////////////////////////////

IMGUI_VERSION :: "1.89.5 WIP"


////////////////////////////////////////////////////////////
// ENUMS
////////////////////////////////////////////////////////////

WindowFlags :: bit_set[WindowFlag; c.int]
WindowFlag :: enum c.int {
	NoTitleBar = 0,
	NoResize = 1,
	NoMove = 2,
	NoScrollbar = 3,
	NoScrollWithMouse = 4,
	NoCollapse = 5,
	AlwaysAutoResize = 6,
	NoBackground = 7,
	NoSavedSettings = 8,
	NoMouseInputs = 9,
	MenuBar = 10,
	HorizontalScrollbar = 11,
	NoFocusOnAppearing = 12,
	NoBringToFrontOnFocus = 13,
	AlwaysVerticalScrollbar = 14,
	AlwaysHorizontalScrollbar = 15,
	AlwaysUseWindowPadding = 16,
	NoNavInputs = 18,
	NoNavFocus = 19,
	UnsavedDocument = 20,
	NavFlattened = 23,
	ChildWindow = 24,
	Tooltip = 25,
	Popup = 26,
	Modal = 27,
	ChildMenu = 28,
}

WindowFlags_None :: WindowFlags{}
WindowFlags_NoTitleBar :: WindowFlags{.NoTitleBar}
WindowFlags_NoResize :: WindowFlags{.NoResize}
WindowFlags_NoMove :: WindowFlags{.NoMove}
WindowFlags_NoScrollbar :: WindowFlags{.NoScrollbar}
WindowFlags_NoScrollWithMouse :: WindowFlags{.NoScrollWithMouse}
WindowFlags_NoCollapse :: WindowFlags{.NoCollapse}
WindowFlags_AlwaysAutoResize :: WindowFlags{.AlwaysAutoResize}
WindowFlags_NoBackground :: WindowFlags{.NoBackground}
WindowFlags_NoSavedSettings :: WindowFlags{.NoSavedSettings}
WindowFlags_NoMouseInputs :: WindowFlags{.NoMouseInputs}
WindowFlags_MenuBar :: WindowFlags{.MenuBar}
WindowFlags_HorizontalScrollbar :: WindowFlags{.HorizontalScrollbar}
WindowFlags_NoFocusOnAppearing :: WindowFlags{.NoFocusOnAppearing}
WindowFlags_NoBringToFrontOnFocus :: WindowFlags{.NoBringToFrontOnFocus}
WindowFlags_AlwaysVerticalScrollbar :: WindowFlags{.AlwaysVerticalScrollbar}
WindowFlags_AlwaysHorizontalScrollbar :: WindowFlags{.AlwaysHorizontalScrollbar}
WindowFlags_AlwaysUseWindowPadding :: WindowFlags{.AlwaysUseWindowPadding}
WindowFlags_NoNavInputs :: WindowFlags{.NoNavInputs}
WindowFlags_NoNavFocus :: WindowFlags{.NoNavFocus}
WindowFlags_UnsavedDocument :: WindowFlags{.UnsavedDocument}
WindowFlags_NoNav :: WindowFlags{.NoNavInputs,.NoNavFocus}
WindowFlags_NoDecoration :: WindowFlags{.NoTitleBar,.NoResize,.NoScrollbar,.NoCollapse}
WindowFlags_NoInputs :: WindowFlags{.NoMouseInputs,.NoNavInputs,.NoNavFocus}
WindowFlags_NavFlattened :: WindowFlags{.NavFlattened}
WindowFlags_ChildWindow :: WindowFlags{.ChildWindow}
WindowFlags_Tooltip :: WindowFlags{.Tooltip}
WindowFlags_Popup :: WindowFlags{.Popup}
WindowFlags_Modal :: WindowFlags{.Modal}
WindowFlags_ChildMenu :: WindowFlags{.ChildMenu}

InputTextFlags :: bit_set[InputTextFlag; c.int]
InputTextFlag :: enum c.int {
	CharsDecimal = 0,
	CharsHexadecimal = 1,
	CharsUppercase = 2,
	CharsNoBlank = 3,
	AutoSelectAll = 4,
	EnterReturnsTrue = 5,
	CallbackCompletion = 6,
	CallbackHistory = 7,
	CallbackAlways = 8,
	CallbackCharFilter = 9,
	AllowTabInput = 10,
	CtrlEnterForNewLine = 11,
	NoHorizontalScroll = 12,
	AlwaysOverwrite = 13,
	ReadOnly = 14,
	Password = 15,
	NoUndoRedo = 16,
	CharsScientific = 17,
	CallbackResize = 18,
	CallbackEdit = 19,
	EscapeClearsAll = 20,
}

InputTextFlags_None :: InputTextFlags{}
InputTextFlags_CharsDecimal :: InputTextFlags{.CharsDecimal}
InputTextFlags_CharsHexadecimal :: InputTextFlags{.CharsHexadecimal}
InputTextFlags_CharsUppercase :: InputTextFlags{.CharsUppercase}
InputTextFlags_CharsNoBlank :: InputTextFlags{.CharsNoBlank}
InputTextFlags_AutoSelectAll :: InputTextFlags{.AutoSelectAll}
InputTextFlags_EnterReturnsTrue :: InputTextFlags{.EnterReturnsTrue}
InputTextFlags_CallbackCompletion :: InputTextFlags{.CallbackCompletion}
InputTextFlags_CallbackHistory :: InputTextFlags{.CallbackHistory}
InputTextFlags_CallbackAlways :: InputTextFlags{.CallbackAlways}
InputTextFlags_CallbackCharFilter :: InputTextFlags{.CallbackCharFilter}
InputTextFlags_AllowTabInput :: InputTextFlags{.AllowTabInput}
InputTextFlags_CtrlEnterForNewLine :: InputTextFlags{.CtrlEnterForNewLine}
InputTextFlags_NoHorizontalScroll :: InputTextFlags{.NoHorizontalScroll}
InputTextFlags_AlwaysOverwrite :: InputTextFlags{.AlwaysOverwrite}
InputTextFlags_ReadOnly :: InputTextFlags{.ReadOnly}
InputTextFlags_Password :: InputTextFlags{.Password}
InputTextFlags_NoUndoRedo :: InputTextFlags{.NoUndoRedo}
InputTextFlags_CharsScientific :: InputTextFlags{.CharsScientific}
InputTextFlags_CallbackResize :: InputTextFlags{.CallbackResize}
InputTextFlags_CallbackEdit :: InputTextFlags{.CallbackEdit}
InputTextFlags_EscapeClearsAll :: InputTextFlags{.EscapeClearsAll}

TreeNodeFlags :: bit_set[TreeNodeFlag; c.int]
TreeNodeFlag :: enum c.int {
	Selected = 0,
	Framed = 1,
	AllowItemOverlap = 2,
	NoTreePushOnOpen = 3,
	NoAutoOpenOnLog = 4,
	DefaultOpen = 5,
	OpenOnDoubleClick = 6,
	OpenOnArrow = 7,
	Leaf = 8,
	Bullet = 9,
	FramePadding = 10,
	SpanAvailWidth = 11,
	SpanFullWidth = 12,
	NavLeftJumpsBackHere = 13,
}

TreeNodeFlags_None :: TreeNodeFlags{}
TreeNodeFlags_Selected :: TreeNodeFlags{.Selected}
TreeNodeFlags_Framed :: TreeNodeFlags{.Framed}
TreeNodeFlags_AllowItemOverlap :: TreeNodeFlags{.AllowItemOverlap}
TreeNodeFlags_NoTreePushOnOpen :: TreeNodeFlags{.NoTreePushOnOpen}
TreeNodeFlags_NoAutoOpenOnLog :: TreeNodeFlags{.NoAutoOpenOnLog}
TreeNodeFlags_DefaultOpen :: TreeNodeFlags{.DefaultOpen}
TreeNodeFlags_OpenOnDoubleClick :: TreeNodeFlags{.OpenOnDoubleClick}
TreeNodeFlags_OpenOnArrow :: TreeNodeFlags{.OpenOnArrow}
TreeNodeFlags_Leaf :: TreeNodeFlags{.Leaf}
TreeNodeFlags_Bullet :: TreeNodeFlags{.Bullet}
TreeNodeFlags_FramePadding :: TreeNodeFlags{.FramePadding}
TreeNodeFlags_SpanAvailWidth :: TreeNodeFlags{.SpanAvailWidth}
TreeNodeFlags_SpanFullWidth :: TreeNodeFlags{.SpanFullWidth}
TreeNodeFlags_NavLeftJumpsBackHere :: TreeNodeFlags{.NavLeftJumpsBackHere}
TreeNodeFlags_CollapsingHeader :: TreeNodeFlags{.Framed,.NoTreePushOnOpen,.NoAutoOpenOnLog}

PopupFlags :: distinct c.int
PopupFlags_None :: PopupFlags(0)
PopupFlags_MouseButtonLeft :: PopupFlags(0)
PopupFlags_MouseButtonRight :: PopupFlags(1)
PopupFlags_MouseButtonMiddle :: PopupFlags(2)
PopupFlags_MouseButtonMask_ :: PopupFlags(0x1F)
PopupFlags_MouseButtonDefault_ :: PopupFlags(1)
PopupFlags_NoOpenOverExistingPopup :: PopupFlags(1<<5)
PopupFlags_NoOpenOverItems :: PopupFlags(1<<6)
PopupFlags_AnyPopupId :: PopupFlags(1<<7)
PopupFlags_AnyPopupLevel :: PopupFlags(1<<8)
PopupFlags_AnyPopup :: PopupFlags(PopupFlags_AnyPopupId | PopupFlags_AnyPopupLevel)

SelectableFlags :: bit_set[SelectableFlag; c.int]
SelectableFlag :: enum c.int {
	DontClosePopups = 0,
	SpanAllColumns = 1,
	AllowDoubleClick = 2,
	Disabled = 3,
	AllowItemOverlap = 4,
}

SelectableFlags_None :: SelectableFlags{}
SelectableFlags_DontClosePopups :: SelectableFlags{.DontClosePopups}
SelectableFlags_SpanAllColumns :: SelectableFlags{.SpanAllColumns}
SelectableFlags_AllowDoubleClick :: SelectableFlags{.AllowDoubleClick}
SelectableFlags_Disabled :: SelectableFlags{.Disabled}
SelectableFlags_AllowItemOverlap :: SelectableFlags{.AllowItemOverlap}

ComboFlags :: bit_set[ComboFlag; c.int]
ComboFlag :: enum c.int {
	PopupAlignLeft = 0,
	HeightSmall = 1,
	HeightRegular = 2,
	HeightLarge = 3,
	HeightLargest = 4,
	NoArrowButton = 5,
	NoPreview = 6,
}

ComboFlags_None :: ComboFlags{}
ComboFlags_PopupAlignLeft :: ComboFlags{.PopupAlignLeft}
ComboFlags_HeightSmall :: ComboFlags{.HeightSmall}
ComboFlags_HeightRegular :: ComboFlags{.HeightRegular}
ComboFlags_HeightLarge :: ComboFlags{.HeightLarge}
ComboFlags_HeightLargest :: ComboFlags{.HeightLargest}
ComboFlags_NoArrowButton :: ComboFlags{.NoArrowButton}
ComboFlags_NoPreview :: ComboFlags{.NoPreview}
ComboFlags_HeightMask_ :: ComboFlags{.HeightSmall,.HeightRegular,.HeightLarge,.HeightLargest}

TabBarFlags :: bit_set[TabBarFlag; c.int]
TabBarFlag :: enum c.int {
	Reorderable = 0,
	AutoSelectNewTabs = 1,
	TabListPopupButton = 2,
	NoCloseWithMiddleMouseButton = 3,
	NoTabListScrollingButtons = 4,
	NoTooltip = 5,
	FittingPolicyResizeDown = 6,
	FittingPolicyScroll = 7,
}

TabBarFlags_None :: TabBarFlags{}
TabBarFlags_Reorderable :: TabBarFlags{.Reorderable}
TabBarFlags_AutoSelectNewTabs :: TabBarFlags{.AutoSelectNewTabs}
TabBarFlags_TabListPopupButton :: TabBarFlags{.TabListPopupButton}
TabBarFlags_NoCloseWithMiddleMouseButton :: TabBarFlags{.NoCloseWithMiddleMouseButton}
TabBarFlags_NoTabListScrollingButtons :: TabBarFlags{.NoTabListScrollingButtons}
TabBarFlags_NoTooltip :: TabBarFlags{.NoTooltip}
TabBarFlags_FittingPolicyResizeDown :: TabBarFlags{.FittingPolicyResizeDown}
TabBarFlags_FittingPolicyScroll :: TabBarFlags{.FittingPolicyScroll}
TabBarFlags_FittingPolicyMask_ :: TabBarFlags{.FittingPolicyResizeDown,.FittingPolicyScroll}
TabBarFlags_FittingPolicyDefault_ :: TabBarFlags{.FittingPolicyResizeDown}

TabItemFlags :: bit_set[TabItemFlag; c.int]
TabItemFlag :: enum c.int {
	UnsavedDocument = 0,
	SetSelected = 1,
	NoCloseWithMiddleMouseButton = 2,
	NoPushId = 3,
	NoTooltip = 4,
	NoReorder = 5,
	Leading = 6,
	Trailing = 7,
}

TabItemFlags_None :: TabItemFlags{}
TabItemFlags_UnsavedDocument :: TabItemFlags{.UnsavedDocument}
TabItemFlags_SetSelected :: TabItemFlags{.SetSelected}
TabItemFlags_NoCloseWithMiddleMouseButton :: TabItemFlags{.NoCloseWithMiddleMouseButton}
TabItemFlags_NoPushId :: TabItemFlags{.NoPushId}
TabItemFlags_NoTooltip :: TabItemFlags{.NoTooltip}
TabItemFlags_NoReorder :: TabItemFlags{.NoReorder}
TabItemFlags_Leading :: TabItemFlags{.Leading}
TabItemFlags_Trailing :: TabItemFlags{.Trailing}

TableFlags :: distinct c.int
TableFlags_None :: TableFlags(0)
TableFlags_Resizable :: TableFlags(1<<0)
TableFlags_Reorderable :: TableFlags(1<<1)
TableFlags_Hideable :: TableFlags(1<<2)
TableFlags_Sortable :: TableFlags(1<<3)
TableFlags_NoSavedSettings :: TableFlags(1<<4)
TableFlags_ContextMenuInBody :: TableFlags(1<<5)
TableFlags_RowBg :: TableFlags(1<<6)
TableFlags_BordersInnerH :: TableFlags(1<<7)
TableFlags_BordersOuterH :: TableFlags(1<<8)
TableFlags_BordersInnerV :: TableFlags(1<<9)
TableFlags_BordersOuterV :: TableFlags(1<<10)
TableFlags_BordersH :: TableFlags(TableFlags_BordersInnerH | TableFlags_BordersOuterH)
TableFlags_BordersV :: TableFlags(TableFlags_BordersInnerV | TableFlags_BordersOuterV)
TableFlags_BordersInner :: TableFlags(TableFlags_BordersInnerV | TableFlags_BordersInnerH)
TableFlags_BordersOuter :: TableFlags(TableFlags_BordersOuterV | TableFlags_BordersOuterH)
TableFlags_Borders :: TableFlags(TableFlags_BordersInner | TableFlags_BordersOuter)
TableFlags_NoBordersInBody :: TableFlags(1<<11)
TableFlags_NoBordersInBodyUntilResize :: TableFlags(1<<12)
TableFlags_SizingFixedFit :: TableFlags(1<<13)
TableFlags_SizingFixedSame :: TableFlags(2<<13)
TableFlags_SizingStretchProp :: TableFlags(3<<13)
TableFlags_SizingStretchSame :: TableFlags(4<<13)
TableFlags_NoHostExtendX :: TableFlags(1<<16)
TableFlags_NoHostExtendY :: TableFlags(1<<17)
TableFlags_NoKeepColumnsVisible :: TableFlags(1<<18)
TableFlags_PreciseWidths :: TableFlags(1<<19)
TableFlags_NoClip :: TableFlags(1<<20)
TableFlags_PadOuterX :: TableFlags(1<<21)
TableFlags_NoPadOuterX :: TableFlags(1<<22)
TableFlags_NoPadInnerX :: TableFlags(1<<23)
TableFlags_ScrollX :: TableFlags(1<<24)
TableFlags_ScrollY :: TableFlags(1<<25)
TableFlags_SortMulti :: TableFlags(1<<26)
TableFlags_SortTristate :: TableFlags(1<<27)
TableFlags_SizingMask_ :: TableFlags(TableFlags_SizingFixedFit | TableFlags_SizingFixedSame | TableFlags_SizingStretchProp | TableFlags_SizingStretchSame)

TableColumnFlags :: bit_set[TableColumnFlag; c.int]
TableColumnFlag :: enum c.int {
	Disabled = 0,
	DefaultHide = 1,
	DefaultSort = 2,
	WidthStretch = 3,
	WidthFixed = 4,
	NoResize = 5,
	NoReorder = 6,
	NoHide = 7,
	NoClip = 8,
	NoSort = 9,
	NoSortAscending = 10,
	NoSortDescending = 11,
	NoHeaderLabel = 12,
	NoHeaderWidth = 13,
	PreferSortAscending = 14,
	PreferSortDescending = 15,
	IndentEnable = 16,
	IndentDisable = 17,
	IsEnabled = 24,
	IsVisible = 25,
	IsSorted = 26,
	IsHovered = 27,
	NoDirectResize_ = 30,
}

TableColumnFlags_None :: TableColumnFlags{}
TableColumnFlags_Disabled :: TableColumnFlags{.Disabled}
TableColumnFlags_DefaultHide :: TableColumnFlags{.DefaultHide}
TableColumnFlags_DefaultSort :: TableColumnFlags{.DefaultSort}
TableColumnFlags_WidthStretch :: TableColumnFlags{.WidthStretch}
TableColumnFlags_WidthFixed :: TableColumnFlags{.WidthFixed}
TableColumnFlags_NoResize :: TableColumnFlags{.NoResize}
TableColumnFlags_NoReorder :: TableColumnFlags{.NoReorder}
TableColumnFlags_NoHide :: TableColumnFlags{.NoHide}
TableColumnFlags_NoClip :: TableColumnFlags{.NoClip}
TableColumnFlags_NoSort :: TableColumnFlags{.NoSort}
TableColumnFlags_NoSortAscending :: TableColumnFlags{.NoSortAscending}
TableColumnFlags_NoSortDescending :: TableColumnFlags{.NoSortDescending}
TableColumnFlags_NoHeaderLabel :: TableColumnFlags{.NoHeaderLabel}
TableColumnFlags_NoHeaderWidth :: TableColumnFlags{.NoHeaderWidth}
TableColumnFlags_PreferSortAscending :: TableColumnFlags{.PreferSortAscending}
TableColumnFlags_PreferSortDescending :: TableColumnFlags{.PreferSortDescending}
TableColumnFlags_IndentEnable :: TableColumnFlags{.IndentEnable}
TableColumnFlags_IndentDisable :: TableColumnFlags{.IndentDisable}
TableColumnFlags_IsEnabled :: TableColumnFlags{.IsEnabled}
TableColumnFlags_IsVisible :: TableColumnFlags{.IsVisible}
TableColumnFlags_IsSorted :: TableColumnFlags{.IsSorted}
TableColumnFlags_IsHovered :: TableColumnFlags{.IsHovered}
TableColumnFlags_WidthMask_ :: TableColumnFlags{.WidthStretch,.WidthFixed}
TableColumnFlags_IndentMask_ :: TableColumnFlags{.IndentEnable,.IndentDisable}
TableColumnFlags_StatusMask_ :: TableColumnFlags{.IsEnabled,.IsVisible,.IsSorted,.IsHovered}
TableColumnFlags_NoDirectResize_ :: TableColumnFlags{.NoDirectResize_}

TableRowFlags :: bit_set[TableRowFlag; c.int]
TableRowFlag :: enum c.int {
	Headers = 0,
}

TableRowFlags_None :: TableRowFlags{}
TableRowFlags_Headers :: TableRowFlags{.Headers}

TableBgTarget :: enum c.int {
	None = 0,
	RowBg0 = 1,
	RowBg1 = 2,
	CellBg = 3,
}

FocusedFlags :: bit_set[FocusedFlag; c.int]
FocusedFlag :: enum c.int {
	ChildWindows = 0,
	RootWindow = 1,
	AnyWindow = 2,
	NoPopupHierarchy = 3,
}

FocusedFlags_None :: FocusedFlags{}
FocusedFlags_ChildWindows :: FocusedFlags{.ChildWindows}
FocusedFlags_RootWindow :: FocusedFlags{.RootWindow}
FocusedFlags_AnyWindow :: FocusedFlags{.AnyWindow}
FocusedFlags_NoPopupHierarchy :: FocusedFlags{.NoPopupHierarchy}
FocusedFlags_RootAndChildWindows :: FocusedFlags{.RootWindow,.ChildWindows}

HoveredFlags :: bit_set[HoveredFlag; c.int]
HoveredFlag :: enum c.int {
	ChildWindows = 0,
	RootWindow = 1,
	AnyWindow = 2,
	NoPopupHierarchy = 3,
	AllowWhenBlockedByPopup = 5,
	AllowWhenBlockedByActiveItem = 7,
	AllowWhenOverlapped = 8,
	AllowWhenDisabled = 9,
	NoNavOverride = 10,
	DelayNormal = 11,
	DelayShort = 12,
	NoSharedDelay = 13,
}

HoveredFlags_None :: HoveredFlags{}
HoveredFlags_ChildWindows :: HoveredFlags{.ChildWindows}
HoveredFlags_RootWindow :: HoveredFlags{.RootWindow}
HoveredFlags_AnyWindow :: HoveredFlags{.AnyWindow}
HoveredFlags_NoPopupHierarchy :: HoveredFlags{.NoPopupHierarchy}
HoveredFlags_AllowWhenBlockedByPopup :: HoveredFlags{.AllowWhenBlockedByPopup}
HoveredFlags_AllowWhenBlockedByActiveItem :: HoveredFlags{.AllowWhenBlockedByActiveItem}
HoveredFlags_AllowWhenOverlapped :: HoveredFlags{.AllowWhenOverlapped}
HoveredFlags_AllowWhenDisabled :: HoveredFlags{.AllowWhenDisabled}
HoveredFlags_NoNavOverride :: HoveredFlags{.NoNavOverride}
HoveredFlags_RectOnly :: HoveredFlags{.AllowWhenBlockedByPopup,.AllowWhenBlockedByActiveItem,.AllowWhenOverlapped}
HoveredFlags_RootAndChildWindows :: HoveredFlags{.RootWindow,.ChildWindows}
HoveredFlags_DelayNormal :: HoveredFlags{.DelayNormal}
HoveredFlags_DelayShort :: HoveredFlags{.DelayShort}
HoveredFlags_NoSharedDelay :: HoveredFlags{.NoSharedDelay}

DragDropFlags :: bit_set[DragDropFlag; c.int]
DragDropFlag :: enum c.int {
	SourceNoPreviewTooltip = 0,
	SourceNoDisableHover = 1,
	SourceNoHoldToOpenOthers = 2,
	SourceAllowNullID = 3,
	SourceExtern = 4,
	SourceAutoExpirePayload = 5,
	AcceptBeforeDelivery = 10,
	AcceptNoDrawDefaultRect = 11,
	AcceptNoPreviewTooltip = 12,
}

DragDropFlags_None :: DragDropFlags{}
DragDropFlags_SourceNoPreviewTooltip :: DragDropFlags{.SourceNoPreviewTooltip}
DragDropFlags_SourceNoDisableHover :: DragDropFlags{.SourceNoDisableHover}
DragDropFlags_SourceNoHoldToOpenOthers :: DragDropFlags{.SourceNoHoldToOpenOthers}
DragDropFlags_SourceAllowNullID :: DragDropFlags{.SourceAllowNullID}
DragDropFlags_SourceExtern :: DragDropFlags{.SourceExtern}
DragDropFlags_SourceAutoExpirePayload :: DragDropFlags{.SourceAutoExpirePayload}
DragDropFlags_AcceptBeforeDelivery :: DragDropFlags{.AcceptBeforeDelivery}
DragDropFlags_AcceptNoDrawDefaultRect :: DragDropFlags{.AcceptNoDrawDefaultRect}
DragDropFlags_AcceptNoPreviewTooltip :: DragDropFlags{.AcceptNoPreviewTooltip}
DragDropFlags_AcceptPeekOnly :: DragDropFlags{.AcceptBeforeDelivery,.AcceptNoDrawDefaultRect}

DataType :: enum c.int {
	S8,
	U8,
	S16,
	U16,
	S32,
	U32,
	S64,
	U64,
	Float,
	Double,
	COUNT,
}

Dir :: enum c.int {
	None = -1,
	Left = 0,
	Right = 1,
	Up = 2,
	Down = 3,
	COUNT,
}

SortDirection :: enum c.int {
	None = 0,
	Ascending = 1,
	Descending = 2,
}

Key :: enum c.int {
	None = 0,
	Tab = 512,
	LeftArrow,
	RightArrow,
	UpArrow,
	DownArrow,
	PageUp,
	PageDown,
	Home,
	End,
	Insert,
	Delete,
	Backspace,
	Space,
	Enter,
	Escape,
	LeftCtrl,
	LeftShift,
	LeftAlt,
	LeftSuper,
	RightCtrl,
	RightShift,
	RightAlt,
	RightSuper,
	Menu,
	_0,
	_1,
	_2,
	_3,
	_4,
	_5,
	_6,
	_7,
	_8,
	_9,
	A,
	B,
	C,
	D,
	E,
	F,
	G,
	H,
	I,
	J,
	K,
	L,
	M,
	N,
	O,
	P,
	Q,
	R,
	S,
	T,
	U,
	V,
	W,
	X,
	Y,
	Z,
	F1,
	F2,
	F3,
	F4,
	F5,
	F6,
	F7,
	F8,
	F9,
	F10,
	F11,
	F12,
	Apostrophe,
	Comma,
	Minus,
	Period,
	Slash,
	Semicolon,
	Equal,
	LeftBracket,
	Backslash,
	RightBracket,
	GraveAccent,
	CapsLock,
	ScrollLock,
	NumLock,
	PrintScreen,
	Pause,
	Keypad0,
	Keypad1,
	Keypad2,
	Keypad3,
	Keypad4,
	Keypad5,
	Keypad6,
	Keypad7,
	Keypad8,
	Keypad9,
	KeypadDecimal,
	KeypadDivide,
	KeypadMultiply,
	KeypadSubtract,
	KeypadAdd,
	KeypadEnter,
	KeypadEqual,
	GamepadStart,
	GamepadBack,
	GamepadFaceLeft,
	GamepadFaceRight,
	GamepadFaceUp,
	GamepadFaceDown,
	GamepadDpadLeft,
	GamepadDpadRight,
	GamepadDpadUp,
	GamepadDpadDown,
	GamepadL1,
	GamepadR1,
	GamepadL2,
	GamepadR2,
	GamepadL3,
	GamepadR3,
	GamepadLStickLeft,
	GamepadLStickRight,
	GamepadLStickUp,
	GamepadLStickDown,
	GamepadRStickLeft,
	GamepadRStickRight,
	GamepadRStickUp,
	GamepadRStickDown,
	MouseLeft,
	MouseRight,
	MouseMiddle,
	MouseX1,
	MouseX2,
	MouseWheelX,
	MouseWheelY,
	ReservedForModCtrl,
	ReservedForModShift,
	ReservedForModAlt,
	ReservedForModSuper,
	COUNT,
	ImGuiMod_None = 0,
	ImGuiMod_Ctrl = 1<<12,
	ImGuiMod_Shift = 1<<13,
	ImGuiMod_Alt = 1<<14,
	ImGuiMod_Super = 1<<15,
	ImGuiMod_Shortcut = 1<<11,
	ImGuiMod_Mask_ = 0xF800,
	// Some of the next enum values are self referential, which currently causes issues
	// Search for this in the generator for more info.
	// NamedKey_BEGIN = 512,
	// NamedKey_END = Key.COUNT,
	// NamedKey_COUNT = Key.NamedKey_END-ImGuiKey_NamedKey_BEGIN,
	// KeysData_SIZE = Key.NamedKey_COUNT,
	// KeysData_OFFSET = Key.NamedKey_BEGIN,
	// KeysData_SIZE = Key.COUNT,
	// KeysData_OFFSET = 0,
	// ModCtrl = Key.ImGuiMod_Ctrl,
	// ModShift = Key.ImGuiMod_Shift,
	// ModAlt = Key.ImGuiMod_Alt,
	// ModSuper = Key.ImGuiMod_Super,
	// KeyPadEnter = Key.KeypadEnter,
}

NavInput :: enum c.int {
	Activate,
	Cancel,
	Input,
	Menu,
	DpadLeft,
	DpadRight,
	DpadUp,
	DpadDown,
	LStickLeft,
	LStickRight,
	LStickUp,
	LStickDown,
	FocusPrev,
	FocusNext,
	TweakSlow,
	TweakFast,
	COUNT,
}

ConfigFlags :: bit_set[ConfigFlag; c.int]
ConfigFlag :: enum c.int {
	NavEnableKeyboard = 0,
	NavEnableGamepad = 1,
	NavEnableSetMousePos = 2,
	NavNoCaptureKeyboard = 3,
	NoMouse = 4,
	NoMouseCursorChange = 5,
	IsSRGB = 20,
	IsTouchScreen = 21,
}

ConfigFlags_None :: ConfigFlags{}
ConfigFlags_NavEnableKeyboard :: ConfigFlags{.NavEnableKeyboard}
ConfigFlags_NavEnableGamepad :: ConfigFlags{.NavEnableGamepad}
ConfigFlags_NavEnableSetMousePos :: ConfigFlags{.NavEnableSetMousePos}
ConfigFlags_NavNoCaptureKeyboard :: ConfigFlags{.NavNoCaptureKeyboard}
ConfigFlags_NoMouse :: ConfigFlags{.NoMouse}
ConfigFlags_NoMouseCursorChange :: ConfigFlags{.NoMouseCursorChange}
ConfigFlags_IsSRGB :: ConfigFlags{.IsSRGB}
ConfigFlags_IsTouchScreen :: ConfigFlags{.IsTouchScreen}

BackendFlags :: bit_set[BackendFlag; c.int]
BackendFlag :: enum c.int {
	HasGamepad = 0,
	HasMouseCursors = 1,
	HasSetMousePos = 2,
	RendererHasVtxOffset = 3,
}

BackendFlags_None :: BackendFlags{}
BackendFlags_HasGamepad :: BackendFlags{.HasGamepad}
BackendFlags_HasMouseCursors :: BackendFlags{.HasMouseCursors}
BackendFlags_HasSetMousePos :: BackendFlags{.HasSetMousePos}
BackendFlags_RendererHasVtxOffset :: BackendFlags{.RendererHasVtxOffset}

Col :: enum c.int {
	Text,
	TextDisabled,
	WindowBg,
	ChildBg,
	PopupBg,
	Border,
	BorderShadow,
	FrameBg,
	FrameBgHovered,
	FrameBgActive,
	TitleBg,
	TitleBgActive,
	TitleBgCollapsed,
	MenuBarBg,
	ScrollbarBg,
	ScrollbarGrab,
	ScrollbarGrabHovered,
	ScrollbarGrabActive,
	CheckMark,
	SliderGrab,
	SliderGrabActive,
	Button,
	ButtonHovered,
	ButtonActive,
	Header,
	HeaderHovered,
	HeaderActive,
	Separator,
	SeparatorHovered,
	SeparatorActive,
	ResizeGrip,
	ResizeGripHovered,
	ResizeGripActive,
	Tab,
	TabHovered,
	TabActive,
	TabUnfocused,
	TabUnfocusedActive,
	PlotLines,
	PlotLinesHovered,
	PlotHistogram,
	PlotHistogramHovered,
	TableHeaderBg,
	TableBorderStrong,
	TableBorderLight,
	TableRowBg,
	TableRowBgAlt,
	TextSelectedBg,
	DragDropTarget,
	NavHighlight,
	NavWindowingHighlight,
	NavWindowingDimBg,
	ModalWindowDimBg,
	COUNT,
}

StyleVar :: enum c.int {
	Alpha,
	DisabledAlpha,
	WindowPadding,
	WindowRounding,
	WindowBorderSize,
	WindowMinSize,
	WindowTitleAlign,
	ChildRounding,
	ChildBorderSize,
	PopupRounding,
	PopupBorderSize,
	FramePadding,
	FrameRounding,
	FrameBorderSize,
	ItemSpacing,
	ItemInnerSpacing,
	IndentSpacing,
	CellPadding,
	ScrollbarSize,
	ScrollbarRounding,
	GrabMinSize,
	GrabRounding,
	TabRounding,
	ButtonTextAlign,
	SelectableTextAlign,
	SeparatorTextBorderSize,
	SeparatorTextAlign,
	SeparatorTextPadding,
	COUNT,
}

ButtonFlags :: bit_set[ButtonFlag; c.int]
ButtonFlag :: enum c.int {
	MouseButtonLeft = 0,
	MouseButtonRight = 1,
	MouseButtonMiddle = 2,
}

ButtonFlags_None :: ButtonFlags{}
ButtonFlags_MouseButtonLeft :: ButtonFlags{.MouseButtonLeft}
ButtonFlags_MouseButtonRight :: ButtonFlags{.MouseButtonRight}
ButtonFlags_MouseButtonMiddle :: ButtonFlags{.MouseButtonMiddle}
ButtonFlags_MouseButtonMask_ :: ButtonFlags{.MouseButtonLeft,.MouseButtonRight,.MouseButtonMiddle}
ButtonFlags_MouseButtonDefault_ :: ButtonFlags{.MouseButtonLeft}

ColorEditFlags :: bit_set[ColorEditFlag; c.int]
ColorEditFlag :: enum c.int {
	NoAlpha = 1,
	NoPicker = 2,
	NoOptions = 3,
	NoSmallPreview = 4,
	NoInputs = 5,
	NoTooltip = 6,
	NoLabel = 7,
	NoSidePreview = 8,
	NoDragDrop = 9,
	NoBorder = 10,
	AlphaBar = 16,
	AlphaPreview = 17,
	AlphaPreviewHalf = 18,
	HDR = 19,
	DisplayRGB = 20,
	DisplayHSV = 21,
	DisplayHex = 22,
	Uint8 = 23,
	Float = 24,
	PickerHueBar = 25,
	PickerHueWheel = 26,
	InputRGB = 27,
	InputHSV = 28,
}

ColorEditFlags_None :: ColorEditFlags{}
ColorEditFlags_NoAlpha :: ColorEditFlags{.NoAlpha}
ColorEditFlags_NoPicker :: ColorEditFlags{.NoPicker}
ColorEditFlags_NoOptions :: ColorEditFlags{.NoOptions}
ColorEditFlags_NoSmallPreview :: ColorEditFlags{.NoSmallPreview}
ColorEditFlags_NoInputs :: ColorEditFlags{.NoInputs}
ColorEditFlags_NoTooltip :: ColorEditFlags{.NoTooltip}
ColorEditFlags_NoLabel :: ColorEditFlags{.NoLabel}
ColorEditFlags_NoSidePreview :: ColorEditFlags{.NoSidePreview}
ColorEditFlags_NoDragDrop :: ColorEditFlags{.NoDragDrop}
ColorEditFlags_NoBorder :: ColorEditFlags{.NoBorder}
ColorEditFlags_AlphaBar :: ColorEditFlags{.AlphaBar}
ColorEditFlags_AlphaPreview :: ColorEditFlags{.AlphaPreview}
ColorEditFlags_AlphaPreviewHalf :: ColorEditFlags{.AlphaPreviewHalf}
ColorEditFlags_HDR :: ColorEditFlags{.HDR}
ColorEditFlags_DisplayRGB :: ColorEditFlags{.DisplayRGB}
ColorEditFlags_DisplayHSV :: ColorEditFlags{.DisplayHSV}
ColorEditFlags_DisplayHex :: ColorEditFlags{.DisplayHex}
ColorEditFlags_Uint8 :: ColorEditFlags{.Uint8}
ColorEditFlags_Float :: ColorEditFlags{.Float}
ColorEditFlags_PickerHueBar :: ColorEditFlags{.PickerHueBar}
ColorEditFlags_PickerHueWheel :: ColorEditFlags{.PickerHueWheel}
ColorEditFlags_InputRGB :: ColorEditFlags{.InputRGB}
ColorEditFlags_InputHSV :: ColorEditFlags{.InputHSV}
ColorEditFlags_DefaultOptions_ :: ColorEditFlags{.Uint8,.DisplayRGB,.InputRGB,.PickerHueBar}
ColorEditFlags_DisplayMask_ :: ColorEditFlags{.DisplayRGB,.DisplayHSV,.DisplayHex}
ColorEditFlags_DataTypeMask_ :: ColorEditFlags{.Uint8,.Float}
ColorEditFlags_PickerMask_ :: ColorEditFlags{.PickerHueWheel,.PickerHueBar}
ColorEditFlags_InputMask_ :: ColorEditFlags{.InputRGB,.InputHSV}

SliderFlags :: bit_set[SliderFlag; c.int]
SliderFlag :: enum c.int {
	AlwaysClamp = 4,
	Logarithmic = 5,
	NoRoundToFormat = 6,
	NoInput = 7,
/* this value is quite unfortunate */// 	InvalidMask_ = 30,
}

SliderFlags_None :: SliderFlags{}
SliderFlags_AlwaysClamp :: SliderFlags{.AlwaysClamp}
SliderFlags_Logarithmic :: SliderFlags{.Logarithmic}
SliderFlags_NoRoundToFormat :: SliderFlags{.NoRoundToFormat}
SliderFlags_NoInput :: SliderFlags{.NoInput}
SliderFlags_InvalidMask_ :: c.int(0x7000000F) // Meant to be of type SliderFlags

MouseButton :: enum c.int {
	Left = 0,
	Right = 1,
	Middle = 2,
	COUNT = 5,
}

MouseCursor :: enum c.int {
	None = -1,
	Arrow = 0,
	TextInput,
	ResizeAll,
	ResizeNS,
	ResizeEW,
	ResizeNESW,
	ResizeNWSE,
	Hand,
	NotAllowed,
	COUNT,
}

Cond :: enum c.int {
	None = 0,
	Always = 1<<0,
	Once = 1<<1,
	FirstUseEver = 1<<2,
	Appearing = 1<<3,
}

DrawFlags :: distinct c.int
DrawFlags_None :: DrawFlags(0)
DrawFlags_Closed :: DrawFlags(1<<0)
DrawFlags_RoundCornersTopLeft :: DrawFlags(1<<4)
DrawFlags_RoundCornersTopRight :: DrawFlags(1<<5)
DrawFlags_RoundCornersBottomLeft :: DrawFlags(1<<6)
DrawFlags_RoundCornersBottomRight :: DrawFlags(1<<7)
DrawFlags_RoundCornersNone :: DrawFlags(1<<8)
DrawFlags_RoundCornersTop :: DrawFlags(DrawFlags_RoundCornersTopLeft | DrawFlags_RoundCornersTopRight)
DrawFlags_RoundCornersBottom :: DrawFlags(DrawFlags_RoundCornersBottomLeft | DrawFlags_RoundCornersBottomRight)
DrawFlags_RoundCornersLeft :: DrawFlags(DrawFlags_RoundCornersBottomLeft | DrawFlags_RoundCornersTopLeft)
DrawFlags_RoundCornersRight :: DrawFlags(DrawFlags_RoundCornersBottomRight | DrawFlags_RoundCornersTopRight)
DrawFlags_RoundCornersAll :: DrawFlags(DrawFlags_RoundCornersTopLeft | DrawFlags_RoundCornersTopRight | DrawFlags_RoundCornersBottomLeft | DrawFlags_RoundCornersBottomRight)
DrawFlags_RoundCornersDefault_ :: DrawFlags(DrawFlags_RoundCornersAll)
DrawFlags_RoundCornersMask_ :: DrawFlags(DrawFlags_RoundCornersAll | DrawFlags_RoundCornersNone)

DrawListFlags :: bit_set[DrawListFlag; c.int]
DrawListFlag :: enum c.int {
	AntiAliasedLines = 0,
	AntiAliasedLinesUseTex = 1,
	AntiAliasedFill = 2,
	AllowVtxOffset = 3,
}

DrawListFlags_None :: DrawListFlags{}
DrawListFlags_AntiAliasedLines :: DrawListFlags{.AntiAliasedLines}
DrawListFlags_AntiAliasedLinesUseTex :: DrawListFlags{.AntiAliasedLinesUseTex}
DrawListFlags_AntiAliasedFill :: DrawListFlags{.AntiAliasedFill}
DrawListFlags_AllowVtxOffset :: DrawListFlags{.AllowVtxOffset}

FontAtlasFlags :: bit_set[FontAtlasFlag; c.int]
FontAtlasFlag :: enum c.int {
	NoPowerOfTwoHeight = 0,
	NoMouseCursors = 1,
	NoBakedLines = 2,
}

FontAtlasFlags_None :: FontAtlasFlags{}
FontAtlasFlags_NoPowerOfTwoHeight :: FontAtlasFlags{.NoPowerOfTwoHeight}
FontAtlasFlags_NoMouseCursors :: FontAtlasFlags{.NoMouseCursors}
FontAtlasFlags_NoBakedLines :: FontAtlasFlags{.NoBakedLines}

ViewportFlags :: bit_set[ViewportFlag; c.int]
ViewportFlag :: enum c.int {
	IsPlatformWindow = 0,
	IsPlatformMonitor = 1,
	OwnedByApp = 2,
}

ViewportFlags_None :: ViewportFlags{}
ViewportFlags_IsPlatformWindow :: ViewportFlags{.IsPlatformWindow}
ViewportFlags_IsPlatformMonitor :: ViewportFlags{.IsPlatformMonitor}
ViewportFlags_OwnedByApp :: ViewportFlags{.OwnedByApp}

DrawCornerFlags :: distinct c.int
DrawCornerFlags_None :: DrawCornerFlags(DrawFlags_RoundCornersNone)
DrawCornerFlags_TopLeft :: DrawCornerFlags(DrawFlags_RoundCornersTopLeft)
DrawCornerFlags_TopRight :: DrawCornerFlags(DrawFlags_RoundCornersTopRight)
DrawCornerFlags_BotLeft :: DrawCornerFlags(DrawFlags_RoundCornersBottomLeft)
DrawCornerFlags_BotRight :: DrawCornerFlags(DrawFlags_RoundCornersBottomRight)
DrawCornerFlags_All :: DrawCornerFlags(DrawFlags_RoundCornersAll)
DrawCornerFlags_Top :: DrawCornerFlags(DrawCornerFlags_TopLeft | DrawCornerFlags_TopRight)
DrawCornerFlags_Bot :: DrawCornerFlags(DrawCornerFlags_BotLeft | DrawCornerFlags_BotRight)
DrawCornerFlags_Left :: DrawCornerFlags(DrawCornerFlags_TopLeft | DrawCornerFlags_BotLeft)
DrawCornerFlags_Right :: DrawCornerFlags(DrawCornerFlags_TopRight | DrawCornerFlags_BotRight)


////////////////////////////////////////////////////////////
// STRUCTS
////////////////////////////////////////////////////////////

DrawListSharedData :: struct {
}

FontBuilderIO :: struct {
}

Context :: struct {
}

Vec2 :: [2]f32
Vec4 :: [4]f32
Vector_Wchar :: struct {
	Size: c.int,
	Capacity: c.int,
	Data: ^Wchar,
}

Vector_TextFilter_ImGuiTextRange :: struct {
	Size: c.int,
	Capacity: c.int,
	Data: ^TextFilter_ImGuiTextRange,
}

Vector_char :: struct {
	Size: c.int,
	Capacity: c.int,
	Data: cstring,
}

Vector_DrawCmd :: struct {
	Size: c.int,
	Capacity: c.int,
	Data: ^DrawCmd,
}

Vector_DrawIdx :: struct {
	Size: c.int,
	Capacity: c.int,
	Data: ^DrawIdx,
}

Vector_DrawChannel :: struct {
	Size: c.int,
	Capacity: c.int,
	Data: ^DrawChannel,
}

Vector_DrawVert :: struct {
	Size: c.int,
	Capacity: c.int,
	Data: ^DrawVert,
}

Vector_Vec4 :: struct {
	Size: c.int,
	Capacity: c.int,
	Data: ^Vec4,
}

Vector_TextureID :: struct {
	Size: c.int,
	Capacity: c.int,
	Data: ^TextureID,
}

Vector_Vec2 :: struct {
	Size: c.int,
	Capacity: c.int,
	Data: ^Vec2,
}

Vector_U32 :: struct {
	Size: c.int,
	Capacity: c.int,
	Data: ^U32,
}

Vector_FontPtr :: struct {
	Size: c.int,
	Capacity: c.int,
	Data: ^^Font,
}

Vector_FontAtlasCustomRect :: struct {
	Size: c.int,
	Capacity: c.int,
	Data: ^FontAtlasCustomRect,
}

Vector_FontConfig :: struct {
	Size: c.int,
	Capacity: c.int,
	Data: ^FontConfig,
}

Vector_float :: struct {
	Size: c.int,
	Capacity: c.int,
	Data: ^f32,
}

Vector_FontGlyph :: struct {
	Size: c.int,
	Capacity: c.int,
	Data: ^FontGlyph,
}

Style :: struct {
	Alpha: f32,
	DisabledAlpha: f32,
	WindowPadding: Vec2,
	WindowRounding: f32,
	WindowBorderSize: f32,
	WindowMinSize: Vec2,
	WindowTitleAlign: Vec2,
	WindowMenuButtonPosition: Dir,
	ChildRounding: f32,
	ChildBorderSize: f32,
	PopupRounding: f32,
	PopupBorderSize: f32,
	FramePadding: Vec2,
	FrameRounding: f32,
	FrameBorderSize: f32,
	ItemSpacing: Vec2,
	ItemInnerSpacing: Vec2,
	CellPadding: Vec2,
	TouchExtraPadding: Vec2,
	IndentSpacing: f32,
	ColumnsMinSpacing: f32,
	ScrollbarSize: f32,
	ScrollbarRounding: f32,
	GrabMinSize: f32,
	GrabRounding: f32,
	LogSliderDeadzone: f32,
	TabRounding: f32,
	TabBorderSize: f32,
	TabMinWidthForCloseButton: f32,
	ColorButtonPosition: Dir,
	ButtonTextAlign: Vec2,
	SelectableTextAlign: Vec2,
	SeparatorTextBorderSize: f32,
	SeparatorTextAlign: Vec2,
	SeparatorTextPadding: Vec2,
	DisplayWindowPadding: Vec2,
	DisplaySafeAreaPadding: Vec2,
	MouseCursorScale: f32,
	AntiAliasedLines: bool,
	AntiAliasedLinesUseTex: bool,
	AntiAliasedFill: bool,
	CurveTessellationTol: f32,
	CircleTessellationMaxError: f32,
	Colors: [Col.COUNT]Vec4,
}

KeyData :: struct {
	Down: bool,
	DownDuration: f32,
	DownDurationPrev: f32,
	AnalogValue: f32,
}

IO :: struct {
	ConfigFlags: ConfigFlags,
	BackendFlags: BackendFlags,
	DisplaySize: Vec2,
	DeltaTime: f32,
	IniSavingRate: f32,
	IniFilename: cstring,
	LogFilename: cstring,
	MouseDoubleClickTime: f32,
	MouseDoubleClickMaxDist: f32,
	MouseDragThreshold: f32,
	KeyRepeatDelay: f32,
	KeyRepeatRate: f32,
	HoverDelayNormal: f32,
	HoverDelayShort: f32,
	UserData: rawptr,
	Fonts: ^FontAtlas,
	FontGlobalScale: f32,
	FontAllowUserScaling: bool,
	FontDefault: ^Font,
	DisplayFramebufferScale: Vec2,
	MouseDrawCursor: bool,
	ConfigMacOSXBehaviors: bool,
	ConfigInputTrickleEventQueue: bool,
	ConfigInputTextCursorBlink: bool,
	ConfigInputTextEnterKeepActive: bool,
	ConfigDragClickToInputText: bool,
	ConfigWindowsResizeFromEdges: bool,
	ConfigWindowsMoveFromTitleBarOnly: bool,
	ConfigMemoryCompactTimer: f32,
	ConfigDebugBeginReturnValueOnce: bool,
	ConfigDebugBeginReturnValueLoop: bool,
	BackendPlatformName: cstring,
	BackendRendererName: cstring,
	BackendPlatformUserData: rawptr,
	BackendRendererUserData: rawptr,
	BackendLanguageUserData: rawptr,
	GetClipboardTextFn: proc "c" (user_data: rawptr) -> cstring,
	SetClipboardTextFn: proc "c" (user_data: rawptr, text: cstring),
	ClipboardUserData: rawptr,
	SetPlatformImeDataFn: proc "c" (viewport: ^Viewport, data: ^PlatformImeData),
	ImeWindowHandle: rawptr,
	WantCaptureMouse: bool,
	WantCaptureKeyboard: bool,
	WantTextInput: bool,
	WantSetMousePos: bool,
	WantSaveIniSettings: bool,
	NavActive: bool,
	NavVisible: bool,
	Framerate: f32,
	MetricsRenderVertices: c.int,
	MetricsRenderIndices: c.int,
	MetricsRenderWindows: c.int,
	MetricsActiveWindows: c.int,
	MetricsActiveAllocations: c.int,
	MouseDelta: Vec2,
	KeyMap: [Key.COUNT]c.int,
	KeysDown: [Key.COUNT]bool,
	NavInputs: [NavInput.COUNT]f32,
	Ctx: ^Context,
	MousePos: Vec2,
	MouseDown: [5]bool,
	MouseWheel: f32,
	MouseWheelH: f32,
	KeyCtrl: bool,
	KeyShift: bool,
	KeyAlt: bool,
	KeySuper: bool,
	KeyMods: KeyChord,
	KeysData: [Key.COUNT]KeyData,
	WantCaptureMouseUnlessPopupClose: bool,
	MousePosPrev: Vec2,
	MouseClickedPos: [5]Vec2,
	MouseClickedTime: [5]f64,
	MouseClicked: [5]bool,
	MouseDoubleClicked: [5]bool,
	MouseClickedCount: [5]U16,
	MouseClickedLastCount: [5]U16,
	MouseReleased: [5]bool,
	MouseDownOwned: [5]bool,
	MouseDownOwnedUnlessPopupClose: [5]bool,
	MouseDownDuration: [5]f32,
	MouseDownDurationPrev: [5]f32,
	MouseDragMaxDistanceSqr: [5]f32,
	PenPressure: f32,
	AppFocusLost: bool,
	AppAcceptingEvents: bool,
	BackendUsingLegacyKeyArrays: S8,
	BackendUsingLegacyNavInputArray: bool,
	InputQueueSurrogate: Wchar16,
	InputQueueCharacters: Vector_Wchar,
}

InputTextCallbackData :: struct {
	Ctx: ^Context,
	EventFlag: InputTextFlags,
	Flags: InputTextFlags,
	UserData: rawptr,
	EventChar: Wchar,
	EventKey: Key,
	Buf: cstring,
	BufTextLen: c.int,
	BufSize: c.int,
	BufDirty: bool,
	CursorPos: c.int,
	SelectionStart: c.int,
	SelectionEnd: c.int,
}

SizeCallbackData :: struct {
	UserData: rawptr,
	Pos: Vec2,
	CurrentSize: Vec2,
	DesiredSize: Vec2,
}

Payload :: struct {
	Data: rawptr,
	DataSize: c.int,
	SourceId: ID,
	SourceParentId: ID,
	DataFrameCount: c.int,
	DataType: [33]c.char,
	Preview: bool,
	Delivery: bool,
}

TableColumnSortSpecs :: struct {
	ColumnUserID: ID,
	ColumnIndex: S16,
	SortOrder: S16,
	SortDirection: SortDirection,
}

TableSortSpecs :: struct {
	Specs: ^TableColumnSortSpecs,
	SpecsCount: c.int,
	SpecsDirty: bool,
}

TextFilter_ImGuiTextRange :: struct {
	b: cstring,
	e: cstring,
}

TextFilter :: struct {
	InputBuf: [256]c.char,
	Filters: Vector_TextFilter_ImGuiTextRange,
	CountGrep: c.int,
}

TextBuffer :: struct {
	Buf: Vector_char,
}

ListClipper :: struct {
	Ctx: ^Context,
	DisplayStart: c.int,
	DisplayEnd: c.int,
	ItemsCount: c.int,
	ItemsHeight: f32,
	StartPosY: f32,
	TempData: rawptr,
}

Color :: struct {
	Value: Vec4,
}

DrawCmd :: struct {
	ClipRect: Vec4,
	TextureId: TextureID,
	VtxOffset: c.uint,
	IdxOffset: c.uint,
	ElemCount: c.uint,
	UserCallback: DrawCallback,
	UserCallbackData: rawptr,
}

DrawVert :: struct {
	pos: Vec2,
	uv: Vec2,
	col: U32,
}

DrawCmdHeader :: struct {
	ClipRect: Vec4,
	TextureId: TextureID,
	VtxOffset: c.uint,
}

DrawChannel :: struct {
	_CmdBuffer: Vector_DrawCmd,
	_IdxBuffer: Vector_DrawIdx,
}

DrawListSplitter :: struct {
	_Current: c.int,
	_Count: c.int,
	_Channels: Vector_DrawChannel,
}

DrawList :: struct {
	CmdBuffer: Vector_DrawCmd,
	IdxBuffer: Vector_DrawIdx,
	VtxBuffer: Vector_DrawVert,
	Flags: DrawListFlags,
	_VtxCurrentIdx: c.uint,
	_Data: ^DrawListSharedData,
	_OwnerName: cstring,
	_VtxWritePtr: ^DrawVert,
	_IdxWritePtr: ^DrawIdx,
	_ClipRectStack: Vector_Vec4,
	_TextureIdStack: Vector_TextureID,
	_Path: Vector_Vec2,
	_CmdHeader: DrawCmdHeader,
	_Splitter: DrawListSplitter,
	_FringeScale: f32,
}

DrawData :: struct {
	Valid: bool,
	CmdListsCount: c.int,
	TotalIdxCount: c.int,
	TotalVtxCount: c.int,
	CmdLists: ^^DrawList,
	DisplayPos: Vec2,
	DisplaySize: Vec2,
	FramebufferScale: Vec2,
}

FontConfig :: struct {
	FontData: rawptr,
	FontDataSize: c.int,
	FontDataOwnedByAtlas: bool,
	FontNo: c.int,
	SizePixels: f32,
	OversampleH: c.int,
	OversampleV: c.int,
	PixelSnapH: bool,
	GlyphExtraSpacing: Vec2,
	GlyphOffset: Vec2,
	GlyphRanges: ^Wchar,
	GlyphMinAdvanceX: f32,
	GlyphMaxAdvanceX: f32,
	MergeMode: bool,
	FontBuilderFlags: c.uint,
	RasterizerMultiply: f32,
	EllipsisChar: Wchar,
	Name: [40]c.char,
	DstFont: ^Font,
}

FontGlyph :: struct {
	Colored: c.uint,
	Visible: c.uint,
	Codepoint: c.uint,
	AdvanceX: f32,
	X0, Y0, X1, Y1: f32,
	U0, V0, U1, V1: f32,
}

FontGlyphRangesBuilder :: struct {
	UsedChars: Vector_U32,
}

FontAtlasCustomRect :: struct {
	Width, Height: c.ushort,
	X, Y: c.ushort,
	GlyphID: c.uint,
	GlyphAdvanceX: f32,
	GlyphOffset: Vec2,
	Font: ^Font,
}

FontAtlas :: struct {
	Flags: FontAtlasFlags,
	TexID: TextureID,
	TexDesiredWidth: c.int,
	TexGlyphPadding: c.int,
	Locked: bool,
	UserData: rawptr,
	TexReady: bool,
	TexPixelsUseColors: bool,
	TexPixelsAlpha8: ^c.uchar,
	TexPixelsRGBA32: ^c.uint,
	TexWidth: c.int,
	TexHeight: c.int,
	TexUvScale: Vec2,
	TexUvWhitePixel: Vec2,
	Fonts: Vector_FontPtr,
	CustomRects: Vector_FontAtlasCustomRect,
	ConfigData: Vector_FontConfig,
	TexUvLines: [64]Vec4,
	FontBuilderIO: ^FontBuilderIO,
	FontBuilderFlags: c.uint,
	PackIdMouseCursors: c.int,
	PackIdLines: c.int,
}

Font :: struct {
	IndexAdvanceX: Vector_float,
	FallbackAdvanceX: f32,
	FontSize: f32,
	IndexLookup: Vector_Wchar,
	Glyphs: Vector_FontGlyph,
	FallbackGlyph: ^FontGlyph,
	ContainerAtlas: ^FontAtlas,
	ConfigData: ^FontConfig,
	ConfigDataCount: c.short,
	FallbackChar: Wchar,
	EllipsisChar: Wchar,
	EllipsisCharCount: c.short,
	EllipsisWidth: f32,
	EllipsisCharStep: f32,
	DirtyLookupTables: bool,
	Scale: f32,
	Ascent, Descent: f32,
	MetricsTotalSurface: c.int,
	Used4kPagesMap: [2]U8,
}

Viewport :: struct {
	Flags: ViewportFlags,
	Pos: Vec2,
	Size: Vec2,
	WorkPos: Vec2,
	WorkSize: Vec2,
	PlatformHandleRaw: rawptr,
}

PlatformImeData :: struct {
	WantVisible: bool,
	InputPos: Vec2,
	InputLineHeight: f32,
}


////////////////////////////////////////////////////////////
// FUNCTIONS
////////////////////////////////////////////////////////////

// I'm not an expert on this, so the linux/osx imports may be incorrect!
when      ODIN_OS == .Windows do foreign import lib "imgui.lib"
else when ODIN_OS == .Linux   do foreign import lib "imgui.a"
else when ODIN_OS == .Darwin  do foreign import lib "imgui.a"

foreign lib {
	@(link_name="ImGui_CreateContext") CreateContext :: proc "c" (shared_font_atlas: ^FontAtlas) -> ^Context ---
	@(link_name="ImGui_DestroyContext") DestroyContext :: proc "c" (ctx: ^Context) ---
	@(link_name="ImGui_GetCurrentContext") GetCurrentContext :: proc "c" () -> ^Context ---
	@(link_name="ImGui_SetCurrentContext") SetCurrentContext :: proc "c" (ctx: ^Context) ---
	@(link_name="ImGui_GetIO") GetIO :: proc "c" () -> ^IO ---
	@(link_name="ImGui_GetStyle") GetStyle :: proc "c" () -> ^Style ---
	@(link_name="ImGui_NewFrame") NewFrame :: proc "c" () ---
	@(link_name="ImGui_EndFrame") EndFrame :: proc "c" () ---
	@(link_name="ImGui_Render") Render :: proc "c" () ---
	@(link_name="ImGui_GetDrawData") GetDrawData :: proc "c" () -> ^DrawData ---
	@(link_name="ImGui_ShowDemoWindow") ShowDemoWindow :: proc "c" (p_open: ^bool) ---
	@(link_name="ImGui_ShowMetricsWindow") ShowMetricsWindow :: proc "c" (p_open: ^bool) ---
	@(link_name="ImGui_ShowDebugLogWindow") ShowDebugLogWindow :: proc "c" (p_open: ^bool) ---
	@(link_name="ImGui_ShowStackToolWindow") ShowStackToolWindow :: proc "c" (p_open: ^bool) ---
	@(link_name="ImGui_ShowAboutWindow") ShowAboutWindow :: proc "c" (p_open: ^bool) ---
	@(link_name="ImGui_ShowStyleEditor") ShowStyleEditor :: proc "c" (ref: ^Style) ---
	@(link_name="ImGui_ShowStyleSelector") ShowStyleSelector :: proc "c" (label: cstring) -> bool ---
	@(link_name="ImGui_ShowFontSelector") ShowFontSelector :: proc "c" (label: cstring) ---
	@(link_name="ImGui_ShowUserGuide") ShowUserGuide :: proc "c" () ---
	@(link_name="ImGui_GetVersion") GetVersion :: proc "c" () -> cstring ---
	@(link_name="ImGui_StyleColorsDark") StyleColorsDark :: proc "c" (dst: ^Style) ---
	@(link_name="ImGui_StyleColorsLight") StyleColorsLight :: proc "c" (dst: ^Style) ---
	@(link_name="ImGui_StyleColorsClassic") StyleColorsClassic :: proc "c" (dst: ^Style) ---
	@(link_name="ImGui_Begin") Begin :: proc "c" (name: cstring, p_open: ^bool, flags: WindowFlags) -> bool ---
	@(link_name="ImGui_End") End :: proc "c" () ---
	@(link_name="ImGui_BeginChild") BeginChild :: proc "c" (str_id: cstring, size: Vec2, border: bool, flags: WindowFlags) -> bool ---
	@(link_name="ImGui_BeginChildID") BeginChildID :: proc "c" (id: ID, size: Vec2, border: bool, flags: WindowFlags) -> bool ---
	@(link_name="ImGui_EndChild") EndChild :: proc "c" () ---
	@(link_name="ImGui_IsWindowAppearing") IsWindowAppearing :: proc "c" () -> bool ---
	@(link_name="ImGui_IsWindowCollapsed") IsWindowCollapsed :: proc "c" () -> bool ---
	@(link_name="ImGui_IsWindowFocused") IsWindowFocused :: proc "c" (flags: FocusedFlags) -> bool ---
	@(link_name="ImGui_IsWindowHovered") IsWindowHovered :: proc "c" (flags: HoveredFlags) -> bool ---
	@(link_name="ImGui_GetWindowDrawList") GetWindowDrawList :: proc "c" () -> ^DrawList ---
	@(link_name="ImGui_GetWindowPos") GetWindowPos :: proc "c" () -> Vec2 ---
	@(link_name="ImGui_GetWindowSize") GetWindowSize :: proc "c" () -> Vec2 ---
	@(link_name="ImGui_GetWindowWidth") GetWindowWidth :: proc "c" () -> f32 ---
	@(link_name="ImGui_GetWindowHeight") GetWindowHeight :: proc "c" () -> f32 ---
	@(link_name="ImGui_SetNextWindowPos") SetNextWindowPos :: proc "c" (pos: Vec2, cond: Cond) ---
	@(link_name="ImGui_SetNextWindowPosEx") SetNextWindowPosEx :: proc "c" (pos: Vec2, cond: Cond, pivot: Vec2) ---
	@(link_name="ImGui_SetNextWindowSize") SetNextWindowSize :: proc "c" (size: Vec2, cond: Cond) ---
	@(link_name="ImGui_SetNextWindowSizeConstraints") SetNextWindowSizeConstraints :: proc "c" (size_min: Vec2, size_max: Vec2, custom_callback: SizeCallback, custom_callback_data: rawptr) ---
	@(link_name="ImGui_SetNextWindowContentSize") SetNextWindowContentSize :: proc "c" (size: Vec2) ---
	@(link_name="ImGui_SetNextWindowCollapsed") SetNextWindowCollapsed :: proc "c" (collapsed: bool, cond: Cond) ---
	@(link_name="ImGui_SetNextWindowFocus") SetNextWindowFocus :: proc "c" () ---
	@(link_name="ImGui_SetNextWindowScroll") SetNextWindowScroll :: proc "c" (scroll: Vec2) ---
	@(link_name="ImGui_SetNextWindowBgAlpha") SetNextWindowBgAlpha :: proc "c" (alpha: f32) ---
	@(link_name="ImGui_SetWindowPos") SetWindowPos :: proc "c" (pos: Vec2, cond: Cond) ---
	@(link_name="ImGui_SetWindowSize") SetWindowSize :: proc "c" (size: Vec2, cond: Cond) ---
	@(link_name="ImGui_SetWindowCollapsed") SetWindowCollapsed :: proc "c" (collapsed: bool, cond: Cond) ---
	@(link_name="ImGui_SetWindowFocus") SetWindowFocus :: proc "c" () ---
	@(link_name="ImGui_SetWindowFontScale") SetWindowFontScale :: proc "c" (scale: f32) ---
	@(link_name="ImGui_SetWindowPosStr") SetWindowPosStr :: proc "c" (name: cstring, pos: Vec2, cond: Cond) ---
	@(link_name="ImGui_SetWindowSizeStr") SetWindowSizeStr :: proc "c" (name: cstring, size: Vec2, cond: Cond) ---
	@(link_name="ImGui_SetWindowCollapsedStr") SetWindowCollapsedStr :: proc "c" (name: cstring, collapsed: bool, cond: Cond) ---
	@(link_name="ImGui_SetWindowFocusStr") SetWindowFocusStr :: proc "c" (name: cstring) ---
	@(link_name="ImGui_GetContentRegionAvail") GetContentRegionAvail :: proc "c" () -> Vec2 ---
	@(link_name="ImGui_GetContentRegionMax") GetContentRegionMax :: proc "c" () -> Vec2 ---
	@(link_name="ImGui_GetWindowContentRegionMin") GetWindowContentRegionMin :: proc "c" () -> Vec2 ---
	@(link_name="ImGui_GetWindowContentRegionMax") GetWindowContentRegionMax :: proc "c" () -> Vec2 ---
	@(link_name="ImGui_GetScrollX") GetScrollX :: proc "c" () -> f32 ---
	@(link_name="ImGui_GetScrollY") GetScrollY :: proc "c" () -> f32 ---
	@(link_name="ImGui_SetScrollX") SetScrollX :: proc "c" (scroll_x: f32) ---
	@(link_name="ImGui_SetScrollY") SetScrollY :: proc "c" (scroll_y: f32) ---
	@(link_name="ImGui_GetScrollMaxX") GetScrollMaxX :: proc "c" () -> f32 ---
	@(link_name="ImGui_GetScrollMaxY") GetScrollMaxY :: proc "c" () -> f32 ---
	@(link_name="ImGui_SetScrollHereX") SetScrollHereX :: proc "c" (center_x_ratio: f32) ---
	@(link_name="ImGui_SetScrollHereY") SetScrollHereY :: proc "c" (center_y_ratio: f32) ---
	@(link_name="ImGui_SetScrollFromPosX") SetScrollFromPosX :: proc "c" (local_x: f32, center_x_ratio: f32) ---
	@(link_name="ImGui_SetScrollFromPosY") SetScrollFromPosY :: proc "c" (local_y: f32, center_y_ratio: f32) ---
	@(link_name="ImGui_PushFont") PushFont :: proc "c" (font: ^Font) ---
	@(link_name="ImGui_PopFont") PopFont :: proc "c" () ---
	@(link_name="ImGui_PushStyleColor") PushStyleColor :: proc "c" (idx: Col, col: U32) ---
	@(link_name="ImGui_PushStyleColorImVec4") PushStyleColorImVec4 :: proc "c" (idx: Col, col: Vec4) ---
	@(link_name="ImGui_PopStyleColor") PopStyleColor :: proc "c" () ---
	@(link_name="ImGui_PopStyleColorEx") PopStyleColorEx :: proc "c" (count: c.int) ---
	@(link_name="ImGui_PushStyleVar") PushStyleVar :: proc "c" (idx: StyleVar, val: f32) ---
	@(link_name="ImGui_PushStyleVarImVec2") PushStyleVarImVec2 :: proc "c" (idx: StyleVar, val: Vec2) ---
	@(link_name="ImGui_PopStyleVar") PopStyleVar :: proc "c" () ---
	@(link_name="ImGui_PopStyleVarEx") PopStyleVarEx :: proc "c" (count: c.int) ---
	@(link_name="ImGui_PushTabStop") PushTabStop :: proc "c" (tab_stop: bool) ---
	@(link_name="ImGui_PopTabStop") PopTabStop :: proc "c" () ---
	@(link_name="ImGui_PushButtonRepeat") PushButtonRepeat :: proc "c" (repeat: bool) ---
	@(link_name="ImGui_PopButtonRepeat") PopButtonRepeat :: proc "c" () ---
	@(link_name="ImGui_PushItemWidth") PushItemWidth :: proc "c" (item_width: f32) ---
	@(link_name="ImGui_PopItemWidth") PopItemWidth :: proc "c" () ---
	@(link_name="ImGui_SetNextItemWidth") SetNextItemWidth :: proc "c" (item_width: f32) ---
	@(link_name="ImGui_CalcItemWidth") CalcItemWidth :: proc "c" () -> f32 ---
	@(link_name="ImGui_PushTextWrapPos") PushTextWrapPos :: proc "c" (wrap_local_pos_x: f32) ---
	@(link_name="ImGui_PopTextWrapPos") PopTextWrapPos :: proc "c" () ---
	@(link_name="ImGui_GetFont") GetFont :: proc "c" () -> ^Font ---
	@(link_name="ImGui_GetFontSize") GetFontSize :: proc "c" () -> f32 ---
	@(link_name="ImGui_GetFontTexUvWhitePixel") GetFontTexUvWhitePixel :: proc "c" () -> Vec2 ---
	@(link_name="ImGui_GetColorU32") GetColorU32 :: proc "c" (idx: Col) -> U32 ---
	@(link_name="ImGui_GetColorU32Ex") GetColorU32Ex :: proc "c" (idx: Col, alpha_mul: f32) -> U32 ---
	@(link_name="ImGui_GetColorU32ImVec4") GetColorU32ImVec4 :: proc "c" (col: Vec4) -> U32 ---
	@(link_name="ImGui_GetColorU32ImU32") GetColorU32ImU32 :: proc "c" (col: U32) -> U32 ---
	@(link_name="ImGui_GetStyleColorVec4") GetStyleColorVec4 :: proc "c" (idx: Col) -> ^Vec4 ---
	@(link_name="ImGui_Separator") Separator :: proc "c" () ---
	@(link_name="ImGui_SameLine") SameLine :: proc "c" () ---
	@(link_name="ImGui_SameLineEx") SameLineEx :: proc "c" (offset_from_start_x: f32, spacing: f32) ---
	@(link_name="ImGui_NewLine") NewLine :: proc "c" () ---
	@(link_name="ImGui_Spacing") Spacing :: proc "c" () ---
	@(link_name="ImGui_Dummy") Dummy :: proc "c" (size: Vec2) ---
	@(link_name="ImGui_Indent") Indent :: proc "c" () ---
	@(link_name="ImGui_IndentEx") IndentEx :: proc "c" (indent_w: f32) ---
	@(link_name="ImGui_Unindent") Unindent :: proc "c" () ---
	@(link_name="ImGui_UnindentEx") UnindentEx :: proc "c" (indent_w: f32) ---
	@(link_name="ImGui_BeginGroup") BeginGroup :: proc "c" () ---
	@(link_name="ImGui_EndGroup") EndGroup :: proc "c" () ---
	@(link_name="ImGui_GetCursorPos") GetCursorPos :: proc "c" () -> Vec2 ---
	@(link_name="ImGui_GetCursorPosX") GetCursorPosX :: proc "c" () -> f32 ---
	@(link_name="ImGui_GetCursorPosY") GetCursorPosY :: proc "c" () -> f32 ---
	@(link_name="ImGui_SetCursorPos") SetCursorPos :: proc "c" (local_pos: Vec2) ---
	@(link_name="ImGui_SetCursorPosX") SetCursorPosX :: proc "c" (local_x: f32) ---
	@(link_name="ImGui_SetCursorPosY") SetCursorPosY :: proc "c" (local_y: f32) ---
	@(link_name="ImGui_GetCursorStartPos") GetCursorStartPos :: proc "c" () -> Vec2 ---
	@(link_name="ImGui_GetCursorScreenPos") GetCursorScreenPos :: proc "c" () -> Vec2 ---
	@(link_name="ImGui_SetCursorScreenPos") SetCursorScreenPos :: proc "c" (pos: Vec2) ---
	@(link_name="ImGui_AlignTextToFramePadding") AlignTextToFramePadding :: proc "c" () ---
	@(link_name="ImGui_GetTextLineHeight") GetTextLineHeight :: proc "c" () -> f32 ---
	@(link_name="ImGui_GetTextLineHeightWithSpacing") GetTextLineHeightWithSpacing :: proc "c" () -> f32 ---
	@(link_name="ImGui_GetFrameHeight") GetFrameHeight :: proc "c" () -> f32 ---
	@(link_name="ImGui_GetFrameHeightWithSpacing") GetFrameHeightWithSpacing :: proc "c" () -> f32 ---
	@(link_name="ImGui_PushID") PushID :: proc "c" (str_id: cstring) ---
	@(link_name="ImGui_PushIDStr") PushIDStr :: proc "c" (str_id_begin: cstring, str_id_end: cstring) ---
	@(link_name="ImGui_PushIDPtr") PushIDPtr :: proc "c" (ptr_id: rawptr) ---
	@(link_name="ImGui_PushIDInt") PushIDInt :: proc "c" (int_id: c.int) ---
	@(link_name="ImGui_PopID") PopID :: proc "c" () ---
	@(link_name="ImGui_GetID") GetID :: proc "c" (str_id: cstring) -> ID ---
	@(link_name="ImGui_GetIDStr") GetIDStr :: proc "c" (str_id_begin: cstring, str_id_end: cstring) -> ID ---
	@(link_name="ImGui_GetIDPtr") GetIDPtr :: proc "c" (ptr_id: rawptr) -> ID ---
	@(link_name="ImGui_TextUnformatted") TextUnformatted :: proc "c" (text: cstring) ---
	@(link_name="ImGui_TextUnformattedEx") TextUnformattedEx :: proc "c" (text: cstring, text_end: cstring) ---
	@(link_name="ImGui_Text") Text :: proc "c" (fmt: cstring, #c_vararg args: ..any) ---
	// @(link_name="ImGui_TextV") TextV :: proc "c" (fmt: cstring, args: libc.va_list) ---
	@(link_name="ImGui_TextColored") TextColored :: proc "c" (col: Vec4, fmt: cstring, #c_vararg args: ..any) ---
	// @(link_name="ImGui_TextColoredV") TextColoredV :: proc "c" (col: Vec4, fmt: cstring, args: libc.va_list) ---
	@(link_name="ImGui_TextDisabled") TextDisabled :: proc "c" (fmt: cstring, #c_vararg args: ..any) ---
	// @(link_name="ImGui_TextDisabledV") TextDisabledV :: proc "c" (fmt: cstring, args: libc.va_list) ---
	@(link_name="ImGui_TextWrapped") TextWrapped :: proc "c" (fmt: cstring, #c_vararg args: ..any) ---
	// @(link_name="ImGui_TextWrappedV") TextWrappedV :: proc "c" (fmt: cstring, args: libc.va_list) ---
	@(link_name="ImGui_LabelText") LabelText :: proc "c" (label: cstring, fmt: cstring, #c_vararg args: ..any) ---
	// @(link_name="ImGui_LabelTextV") LabelTextV :: proc "c" (label: cstring, fmt: cstring, args: libc.va_list) ---
	@(link_name="ImGui_BulletText") BulletText :: proc "c" (fmt: cstring, #c_vararg args: ..any) ---
	// @(link_name="ImGui_BulletTextV") BulletTextV :: proc "c" (fmt: cstring, args: libc.va_list) ---
	@(link_name="ImGui_SeparatorText") SeparatorText :: proc "c" (label: cstring) ---
	@(link_name="ImGui_Button") Button :: proc "c" (label: cstring) -> bool ---
	@(link_name="ImGui_ButtonEx") ButtonEx :: proc "c" (label: cstring, size: Vec2) -> bool ---
	@(link_name="ImGui_SmallButton") SmallButton :: proc "c" (label: cstring) -> bool ---
	@(link_name="ImGui_InvisibleButton") InvisibleButton :: proc "c" (str_id: cstring, size: Vec2, flags: ButtonFlags) -> bool ---
	@(link_name="ImGui_ArrowButton") ArrowButton :: proc "c" (str_id: cstring, dir: Dir) -> bool ---
	@(link_name="ImGui_Checkbox") Checkbox :: proc "c" (label: cstring, v: ^bool) -> bool ---
	@(link_name="ImGui_CheckboxFlagsIntPtr") CheckboxFlagsIntPtr :: proc "c" (label: cstring, flags: ^c.int, flags_value: c.int) -> bool ---
	@(link_name="ImGui_CheckboxFlagsUintPtr") CheckboxFlagsUintPtr :: proc "c" (label: cstring, flags: ^c.uint, flags_value: c.uint) -> bool ---
	@(link_name="ImGui_RadioButton") RadioButton :: proc "c" (label: cstring, active: bool) -> bool ---
	@(link_name="ImGui_RadioButtonIntPtr") RadioButtonIntPtr :: proc "c" (label: cstring, v: ^c.int, v_button: c.int) -> bool ---
	@(link_name="ImGui_ProgressBar") ProgressBar :: proc "c" (fraction: f32, size_arg: Vec2, overlay: cstring) ---
	@(link_name="ImGui_Bullet") Bullet :: proc "c" () ---
	@(link_name="ImGui_Image") Image :: proc "c" (user_texture_id: TextureID, size: Vec2) ---
	@(link_name="ImGui_ImageEx") ImageEx :: proc "c" (user_texture_id: TextureID, size: Vec2, uv0: Vec2, uv1: Vec2, tint_col: Vec4, border_col: Vec4) ---
	@(link_name="ImGui_ImageButton") ImageButton :: proc "c" (str_id: cstring, user_texture_id: TextureID, size: Vec2) -> bool ---
	@(link_name="ImGui_ImageButtonEx") ImageButtonEx :: proc "c" (str_id: cstring, user_texture_id: TextureID, size: Vec2, uv0: Vec2, uv1: Vec2, bg_col: Vec4, tint_col: Vec4) -> bool ---
	@(link_name="ImGui_BeginCombo") BeginCombo :: proc "c" (label: cstring, preview_value: cstring, flags: ComboFlags) -> bool ---
	@(link_name="ImGui_EndCombo") EndCombo :: proc "c" () ---
	@(link_name="ImGui_ComboChar") ComboChar :: proc "c" (label: cstring, current_item: ^c.int, items: [^]cstring, items_count: c.int) -> bool ---
	@(link_name="ImGui_ComboCharEx") ComboCharEx :: proc "c" (label: cstring, current_item: ^c.int, items: [^]cstring, items_count: c.int, popup_max_height_in_items: c.int) -> bool ---
	@(link_name="ImGui_Combo") Combo :: proc "c" (label: cstring, current_item: ^c.int, items_separated_by_zeros: cstring) -> bool ---
	@(link_name="ImGui_ComboEx") ComboEx :: proc "c" (label: cstring, current_item: ^c.int, items_separated_by_zeros: cstring, popup_max_height_in_items: c.int) -> bool ---
	@(link_name="ImGui_ComboCallback") ComboCallback :: proc "c" (label: cstring, current_item: ^c.int, items_getter: proc "c" (data: rawptr, idx: c.int, out_text: ^cstring) -> bool, data: rawptr, items_count: c.int) -> bool ---
	@(link_name="ImGui_ComboCallbackEx") ComboCallbackEx :: proc "c" (label: cstring, current_item: ^c.int, items_getter: proc "c" (data: rawptr, idx: c.int, out_text: ^cstring) -> bool, data: rawptr, items_count: c.int, popup_max_height_in_items: c.int) -> bool ---
	@(link_name="ImGui_DragFloat") DragFloat :: proc "c" (label: cstring, v: ^f32) -> bool ---
	@(link_name="ImGui_DragFloatEx") DragFloatEx :: proc "c" (label: cstring, v: ^f32, v_speed: f32, v_min: f32, v_max: f32, format: cstring, flags: SliderFlags) -> bool ---
	@(link_name="ImGui_DragFloat2") DragFloat2 :: proc "c" (label: cstring, v: ^[2]f32) -> bool ---
	@(link_name="ImGui_DragFloat2Ex") DragFloat2Ex :: proc "c" (label: cstring, v: ^[2]f32, v_speed: f32, v_min: f32, v_max: f32, format: cstring, flags: SliderFlags) -> bool ---
	@(link_name="ImGui_DragFloat3") DragFloat3 :: proc "c" (label: cstring, v: ^[3]f32) -> bool ---
	@(link_name="ImGui_DragFloat3Ex") DragFloat3Ex :: proc "c" (label: cstring, v: ^[3]f32, v_speed: f32, v_min: f32, v_max: f32, format: cstring, flags: SliderFlags) -> bool ---
	@(link_name="ImGui_DragFloat4") DragFloat4 :: proc "c" (label: cstring, v: ^[4]f32) -> bool ---
	@(link_name="ImGui_DragFloat4Ex") DragFloat4Ex :: proc "c" (label: cstring, v: ^[4]f32, v_speed: f32, v_min: f32, v_max: f32, format: cstring, flags: SliderFlags) -> bool ---
	@(link_name="ImGui_DragFloatRange2") DragFloatRange2 :: proc "c" (label: cstring, v_current_min: ^f32, v_current_max: ^f32) -> bool ---
	@(link_name="ImGui_DragFloatRange2Ex") DragFloatRange2Ex :: proc "c" (label: cstring, v_current_min: ^f32, v_current_max: ^f32, v_speed: f32, v_min: f32, v_max: f32, format: cstring, format_max: cstring, flags: SliderFlags) -> bool ---
	@(link_name="ImGui_DragInt") DragInt :: proc "c" (label: cstring, v: ^c.int) -> bool ---
	@(link_name="ImGui_DragIntEx") DragIntEx :: proc "c" (label: cstring, v: ^c.int, v_speed: f32, v_min: c.int, v_max: c.int, format: cstring, flags: SliderFlags) -> bool ---
	@(link_name="ImGui_DragInt2") DragInt2 :: proc "c" (label: cstring, v: ^[2]c.int) -> bool ---
	@(link_name="ImGui_DragInt2Ex") DragInt2Ex :: proc "c" (label: cstring, v: ^[2]c.int, v_speed: f32, v_min: c.int, v_max: c.int, format: cstring, flags: SliderFlags) -> bool ---
	@(link_name="ImGui_DragInt3") DragInt3 :: proc "c" (label: cstring, v: ^[3]c.int) -> bool ---
	@(link_name="ImGui_DragInt3Ex") DragInt3Ex :: proc "c" (label: cstring, v: ^[3]c.int, v_speed: f32, v_min: c.int, v_max: c.int, format: cstring, flags: SliderFlags) -> bool ---
	@(link_name="ImGui_DragInt4") DragInt4 :: proc "c" (label: cstring, v: ^[4]c.int) -> bool ---
	@(link_name="ImGui_DragInt4Ex") DragInt4Ex :: proc "c" (label: cstring, v: ^[4]c.int, v_speed: f32, v_min: c.int, v_max: c.int, format: cstring, flags: SliderFlags) -> bool ---
	@(link_name="ImGui_DragIntRange2") DragIntRange2 :: proc "c" (label: cstring, v_current_min: ^c.int, v_current_max: ^c.int) -> bool ---
	@(link_name="ImGui_DragIntRange2Ex") DragIntRange2Ex :: proc "c" (label: cstring, v_current_min: ^c.int, v_current_max: ^c.int, v_speed: f32, v_min: c.int, v_max: c.int, format: cstring, format_max: cstring, flags: SliderFlags) -> bool ---
	@(link_name="ImGui_DragScalar") DragScalar :: proc "c" (label: cstring, data_type: DataType, p_data: rawptr) -> bool ---
	@(link_name="ImGui_DragScalarEx") DragScalarEx :: proc "c" (label: cstring, data_type: DataType, p_data: rawptr, v_speed: f32, p_min: rawptr, p_max: rawptr, format: cstring, flags: SliderFlags) -> bool ---
	@(link_name="ImGui_DragScalarN") DragScalarN :: proc "c" (label: cstring, data_type: DataType, p_data: rawptr, components: c.int) -> bool ---
	@(link_name="ImGui_DragScalarNEx") DragScalarNEx :: proc "c" (label: cstring, data_type: DataType, p_data: rawptr, components: c.int, v_speed: f32, p_min: rawptr, p_max: rawptr, format: cstring, flags: SliderFlags) -> bool ---
	@(link_name="ImGui_SliderFloat") SliderFloat :: proc "c" (label: cstring, v: ^f32, v_min: f32, v_max: f32) -> bool ---
	@(link_name="ImGui_SliderFloatEx") SliderFloatEx :: proc "c" (label: cstring, v: ^f32, v_min: f32, v_max: f32, format: cstring, flags: SliderFlags) -> bool ---
	@(link_name="ImGui_SliderFloat2") SliderFloat2 :: proc "c" (label: cstring, v: ^[2]f32, v_min: f32, v_max: f32) -> bool ---
	@(link_name="ImGui_SliderFloat2Ex") SliderFloat2Ex :: proc "c" (label: cstring, v: ^[2]f32, v_min: f32, v_max: f32, format: cstring, flags: SliderFlags) -> bool ---
	@(link_name="ImGui_SliderFloat3") SliderFloat3 :: proc "c" (label: cstring, v: ^[3]f32, v_min: f32, v_max: f32) -> bool ---
	@(link_name="ImGui_SliderFloat3Ex") SliderFloat3Ex :: proc "c" (label: cstring, v: ^[3]f32, v_min: f32, v_max: f32, format: cstring, flags: SliderFlags) -> bool ---
	@(link_name="ImGui_SliderFloat4") SliderFloat4 :: proc "c" (label: cstring, v: ^[4]f32, v_min: f32, v_max: f32) -> bool ---
	@(link_name="ImGui_SliderFloat4Ex") SliderFloat4Ex :: proc "c" (label: cstring, v: ^[4]f32, v_min: f32, v_max: f32, format: cstring, flags: SliderFlags) -> bool ---
	@(link_name="ImGui_SliderAngle") SliderAngle :: proc "c" (label: cstring, v_rad: ^f32) -> bool ---
	@(link_name="ImGui_SliderAngleEx") SliderAngleEx :: proc "c" (label: cstring, v_rad: ^f32, v_degrees_min: f32, v_degrees_max: f32, format: cstring, flags: SliderFlags) -> bool ---
	@(link_name="ImGui_SliderInt") SliderInt :: proc "c" (label: cstring, v: ^c.int, v_min: c.int, v_max: c.int) -> bool ---
	@(link_name="ImGui_SliderIntEx") SliderIntEx :: proc "c" (label: cstring, v: ^c.int, v_min: c.int, v_max: c.int, format: cstring, flags: SliderFlags) -> bool ---
	@(link_name="ImGui_SliderInt2") SliderInt2 :: proc "c" (label: cstring, v: ^[2]c.int, v_min: c.int, v_max: c.int) -> bool ---
	@(link_name="ImGui_SliderInt2Ex") SliderInt2Ex :: proc "c" (label: cstring, v: ^[2]c.int, v_min: c.int, v_max: c.int, format: cstring, flags: SliderFlags) -> bool ---
	@(link_name="ImGui_SliderInt3") SliderInt3 :: proc "c" (label: cstring, v: ^[3]c.int, v_min: c.int, v_max: c.int) -> bool ---
	@(link_name="ImGui_SliderInt3Ex") SliderInt3Ex :: proc "c" (label: cstring, v: ^[3]c.int, v_min: c.int, v_max: c.int, format: cstring, flags: SliderFlags) -> bool ---
	@(link_name="ImGui_SliderInt4") SliderInt4 :: proc "c" (label: cstring, v: ^[4]c.int, v_min: c.int, v_max: c.int) -> bool ---
	@(link_name="ImGui_SliderInt4Ex") SliderInt4Ex :: proc "c" (label: cstring, v: ^[4]c.int, v_min: c.int, v_max: c.int, format: cstring, flags: SliderFlags) -> bool ---
	@(link_name="ImGui_SliderScalar") SliderScalar :: proc "c" (label: cstring, data_type: DataType, p_data: rawptr, p_min: rawptr, p_max: rawptr) -> bool ---
	@(link_name="ImGui_SliderScalarEx") SliderScalarEx :: proc "c" (label: cstring, data_type: DataType, p_data: rawptr, p_min: rawptr, p_max: rawptr, format: cstring, flags: SliderFlags) -> bool ---
	@(link_name="ImGui_SliderScalarN") SliderScalarN :: proc "c" (label: cstring, data_type: DataType, p_data: rawptr, components: c.int, p_min: rawptr, p_max: rawptr) -> bool ---
	@(link_name="ImGui_SliderScalarNEx") SliderScalarNEx :: proc "c" (label: cstring, data_type: DataType, p_data: rawptr, components: c.int, p_min: rawptr, p_max: rawptr, format: cstring, flags: SliderFlags) -> bool ---
	@(link_name="ImGui_VSliderFloat") VSliderFloat :: proc "c" (label: cstring, size: Vec2, v: ^f32, v_min: f32, v_max: f32) -> bool ---
	@(link_name="ImGui_VSliderFloatEx") VSliderFloatEx :: proc "c" (label: cstring, size: Vec2, v: ^f32, v_min: f32, v_max: f32, format: cstring, flags: SliderFlags) -> bool ---
	@(link_name="ImGui_VSliderInt") VSliderInt :: proc "c" (label: cstring, size: Vec2, v: ^c.int, v_min: c.int, v_max: c.int) -> bool ---
	@(link_name="ImGui_VSliderIntEx") VSliderIntEx :: proc "c" (label: cstring, size: Vec2, v: ^c.int, v_min: c.int, v_max: c.int, format: cstring, flags: SliderFlags) -> bool ---
	@(link_name="ImGui_VSliderScalar") VSliderScalar :: proc "c" (label: cstring, size: Vec2, data_type: DataType, p_data: rawptr, p_min: rawptr, p_max: rawptr) -> bool ---
	@(link_name="ImGui_VSliderScalarEx") VSliderScalarEx :: proc "c" (label: cstring, size: Vec2, data_type: DataType, p_data: rawptr, p_min: rawptr, p_max: rawptr, format: cstring, flags: SliderFlags) -> bool ---
	@(link_name="ImGui_InputText") InputText :: proc "c" (label: cstring, buf: cstring, buf_size: c.size_t, flags: InputTextFlags) -> bool ---
	@(link_name="ImGui_InputTextEx") InputTextEx :: proc "c" (label: cstring, buf: cstring, buf_size: c.size_t, flags: InputTextFlags, callback: InputTextCallback, user_data: rawptr) -> bool ---
	@(link_name="ImGui_InputTextMultiline") InputTextMultiline :: proc "c" (label: cstring, buf: cstring, buf_size: c.size_t) -> bool ---
	@(link_name="ImGui_InputTextMultilineEx") InputTextMultilineEx :: proc "c" (label: cstring, buf: cstring, buf_size: c.size_t, size: Vec2, flags: InputTextFlags, callback: InputTextCallback, user_data: rawptr) -> bool ---
	@(link_name="ImGui_InputTextWithHint") InputTextWithHint :: proc "c" (label: cstring, hint: cstring, buf: cstring, buf_size: c.size_t, flags: InputTextFlags) -> bool ---
	@(link_name="ImGui_InputTextWithHintEx") InputTextWithHintEx :: proc "c" (label: cstring, hint: cstring, buf: cstring, buf_size: c.size_t, flags: InputTextFlags, callback: InputTextCallback, user_data: rawptr) -> bool ---
	@(link_name="ImGui_InputFloat") InputFloat :: proc "c" (label: cstring, v: ^f32) -> bool ---
	@(link_name="ImGui_InputFloatEx") InputFloatEx :: proc "c" (label: cstring, v: ^f32, step: f32, step_fast: f32, format: cstring, flags: InputTextFlags) -> bool ---
	@(link_name="ImGui_InputFloat2") InputFloat2 :: proc "c" (label: cstring, v: ^[2]f32) -> bool ---
	@(link_name="ImGui_InputFloat2Ex") InputFloat2Ex :: proc "c" (label: cstring, v: ^[2]f32, format: cstring, flags: InputTextFlags) -> bool ---
	@(link_name="ImGui_InputFloat3") InputFloat3 :: proc "c" (label: cstring, v: ^[3]f32) -> bool ---
	@(link_name="ImGui_InputFloat3Ex") InputFloat3Ex :: proc "c" (label: cstring, v: ^[3]f32, format: cstring, flags: InputTextFlags) -> bool ---
	@(link_name="ImGui_InputFloat4") InputFloat4 :: proc "c" (label: cstring, v: ^[4]f32) -> bool ---
	@(link_name="ImGui_InputFloat4Ex") InputFloat4Ex :: proc "c" (label: cstring, v: ^[4]f32, format: cstring, flags: InputTextFlags) -> bool ---
	@(link_name="ImGui_InputInt") InputInt :: proc "c" (label: cstring, v: ^c.int) -> bool ---
	@(link_name="ImGui_InputIntEx") InputIntEx :: proc "c" (label: cstring, v: ^c.int, step: c.int, step_fast: c.int, flags: InputTextFlags) -> bool ---
	@(link_name="ImGui_InputInt2") InputInt2 :: proc "c" (label: cstring, v: ^[2]c.int, flags: InputTextFlags) -> bool ---
	@(link_name="ImGui_InputInt3") InputInt3 :: proc "c" (label: cstring, v: ^[3]c.int, flags: InputTextFlags) -> bool ---
	@(link_name="ImGui_InputInt4") InputInt4 :: proc "c" (label: cstring, v: ^[4]c.int, flags: InputTextFlags) -> bool ---
	@(link_name="ImGui_InputDouble") InputDouble :: proc "c" (label: cstring, v: ^f64) -> bool ---
	@(link_name="ImGui_InputDoubleEx") InputDoubleEx :: proc "c" (label: cstring, v: ^f64, step: f64, step_fast: f64, format: cstring, flags: InputTextFlags) -> bool ---
	@(link_name="ImGui_InputScalar") InputScalar :: proc "c" (label: cstring, data_type: DataType, p_data: rawptr) -> bool ---
	@(link_name="ImGui_InputScalarEx") InputScalarEx :: proc "c" (label: cstring, data_type: DataType, p_data: rawptr, p_step: rawptr, p_step_fast: rawptr, format: cstring, flags: InputTextFlags) -> bool ---
	@(link_name="ImGui_InputScalarN") InputScalarN :: proc "c" (label: cstring, data_type: DataType, p_data: rawptr, components: c.int) -> bool ---
	@(link_name="ImGui_InputScalarNEx") InputScalarNEx :: proc "c" (label: cstring, data_type: DataType, p_data: rawptr, components: c.int, p_step: rawptr, p_step_fast: rawptr, format: cstring, flags: InputTextFlags) -> bool ---
	@(link_name="ImGui_ColorEdit3") ColorEdit3 :: proc "c" (label: cstring, col: ^[3]f32, flags: ColorEditFlags) -> bool ---
	@(link_name="ImGui_ColorEdit4") ColorEdit4 :: proc "c" (label: cstring, col: ^[4]f32, flags: ColorEditFlags) -> bool ---
	@(link_name="ImGui_ColorPicker3") ColorPicker3 :: proc "c" (label: cstring, col: ^[3]f32, flags: ColorEditFlags) -> bool ---
	@(link_name="ImGui_ColorPicker4") ColorPicker4 :: proc "c" (label: cstring, col: ^[4]f32, flags: ColorEditFlags, ref_col: ^f32) -> bool ---
	@(link_name="ImGui_ColorButton") ColorButton :: proc "c" (desc_id: cstring, col: Vec4, flags: ColorEditFlags) -> bool ---
	@(link_name="ImGui_ColorButtonEx") ColorButtonEx :: proc "c" (desc_id: cstring, col: Vec4, flags: ColorEditFlags, size: Vec2) -> bool ---
	@(link_name="ImGui_SetColorEditOptions") SetColorEditOptions :: proc "c" (flags: ColorEditFlags) ---
	@(link_name="ImGui_TreeNode") TreeNode :: proc "c" (label: cstring) -> bool ---
	@(link_name="ImGui_TreeNodeStr") TreeNodeStr :: proc "c" (str_id: cstring, fmt: cstring, #c_vararg args: ..any) -> bool ---
	@(link_name="ImGui_TreeNodePtr") TreeNodePtr :: proc "c" (ptr_id: rawptr, fmt: cstring, #c_vararg args: ..any) -> bool ---
	// @(link_name="ImGui_TreeNodeV") TreeNodeV :: proc "c" (str_id: cstring, fmt: cstring, args: libc.va_list) -> bool ---
	// @(link_name="ImGui_TreeNodeVPtr") TreeNodeVPtr :: proc "c" (ptr_id: rawptr, fmt: cstring, args: libc.va_list) -> bool ---
	@(link_name="ImGui_TreeNodeEx") TreeNodeEx :: proc "c" (label: cstring, flags: TreeNodeFlags) -> bool ---
	@(link_name="ImGui_TreeNodeExStr") TreeNodeExStr :: proc "c" (str_id: cstring, flags: TreeNodeFlags, fmt: cstring, #c_vararg args: ..any) -> bool ---
	@(link_name="ImGui_TreeNodeExPtr") TreeNodeExPtr :: proc "c" (ptr_id: rawptr, flags: TreeNodeFlags, fmt: cstring, #c_vararg args: ..any) -> bool ---
	// @(link_name="ImGui_TreeNodeExV") TreeNodeExV :: proc "c" (str_id: cstring, flags: TreeNodeFlags, fmt: cstring, args: libc.va_list) -> bool ---
	// @(link_name="ImGui_TreeNodeExVPtr") TreeNodeExVPtr :: proc "c" (ptr_id: rawptr, flags: TreeNodeFlags, fmt: cstring, args: libc.va_list) -> bool ---
	@(link_name="ImGui_TreePush") TreePush :: proc "c" (str_id: cstring) ---
	@(link_name="ImGui_TreePushPtr") TreePushPtr :: proc "c" (ptr_id: rawptr) ---
	@(link_name="ImGui_TreePop") TreePop :: proc "c" () ---
	@(link_name="ImGui_GetTreeNodeToLabelSpacing") GetTreeNodeToLabelSpacing :: proc "c" () -> f32 ---
	@(link_name="ImGui_CollapsingHeader") CollapsingHeader :: proc "c" (label: cstring, flags: TreeNodeFlags) -> bool ---
	@(link_name="ImGui_CollapsingHeaderBoolPtr") CollapsingHeaderBoolPtr :: proc "c" (label: cstring, p_visible: ^bool, flags: TreeNodeFlags) -> bool ---
	@(link_name="ImGui_SetNextItemOpen") SetNextItemOpen :: proc "c" (is_open: bool, cond: Cond) ---
	@(link_name="ImGui_Selectable") Selectable :: proc "c" (label: cstring) -> bool ---
	@(link_name="ImGui_SelectableEx") SelectableEx :: proc "c" (label: cstring, selected: bool, flags: SelectableFlags, size: Vec2) -> bool ---
	@(link_name="ImGui_SelectableBoolPtr") SelectableBoolPtr :: proc "c" (label: cstring, p_selected: ^bool, flags: SelectableFlags) -> bool ---
	@(link_name="ImGui_SelectableBoolPtrEx") SelectableBoolPtrEx :: proc "c" (label: cstring, p_selected: ^bool, flags: SelectableFlags, size: Vec2) -> bool ---
	@(link_name="ImGui_BeginListBox") BeginListBox :: proc "c" (label: cstring, size: Vec2) -> bool ---
	@(link_name="ImGui_EndListBox") EndListBox :: proc "c" () ---
	@(link_name="ImGui_ListBox") ListBox :: proc "c" (label: cstring, current_item: ^c.int, items: [^]cstring, items_count: c.int, height_in_items: c.int) -> bool ---
	@(link_name="ImGui_ListBoxCallback") ListBoxCallback :: proc "c" (label: cstring, current_item: ^c.int, items_getter: proc "c" (data: rawptr, idx: c.int, out_text: ^cstring) -> bool, data: rawptr, items_count: c.int) -> bool ---
	@(link_name="ImGui_ListBoxCallbackEx") ListBoxCallbackEx :: proc "c" (label: cstring, current_item: ^c.int, items_getter: proc "c" (data: rawptr, idx: c.int, out_text: ^cstring) -> bool, data: rawptr, items_count: c.int, height_in_items: c.int) -> bool ---
	@(link_name="ImGui_PlotLines") PlotLines :: proc "c" (label: cstring, values: ^f32, values_count: c.int) ---
	@(link_name="ImGui_PlotLinesEx") PlotLinesEx :: proc "c" (label: cstring, values: ^f32, values_count: c.int, values_offset: c.int, overlay_text: cstring, scale_min: f32, scale_max: f32, graph_size: Vec2, stride: c.int) ---
	@(link_name="ImGui_PlotLinesCallback") PlotLinesCallback :: proc "c" (label: cstring, values_getter: proc "c" (data: rawptr, idx: c.int) -> f32, data: rawptr, values_count: c.int) ---
	@(link_name="ImGui_PlotLinesCallbackEx") PlotLinesCallbackEx :: proc "c" (label: cstring, values_getter: proc "c" (data: rawptr, idx: c.int) -> f32, data: rawptr, values_count: c.int, values_offset: c.int, overlay_text: cstring, scale_min: f32, scale_max: f32, graph_size: Vec2) ---
	@(link_name="ImGui_PlotHistogram") PlotHistogram :: proc "c" (label: cstring, values: ^f32, values_count: c.int) ---
	@(link_name="ImGui_PlotHistogramEx") PlotHistogramEx :: proc "c" (label: cstring, values: ^f32, values_count: c.int, values_offset: c.int, overlay_text: cstring, scale_min: f32, scale_max: f32, graph_size: Vec2, stride: c.int) ---
	@(link_name="ImGui_PlotHistogramCallback") PlotHistogramCallback :: proc "c" (label: cstring, values_getter: proc "c" (data: rawptr, idx: c.int) -> f32, data: rawptr, values_count: c.int) ---
	@(link_name="ImGui_PlotHistogramCallbackEx") PlotHistogramCallbackEx :: proc "c" (label: cstring, values_getter: proc "c" (data: rawptr, idx: c.int) -> f32, data: rawptr, values_count: c.int, values_offset: c.int, overlay_text: cstring, scale_min: f32, scale_max: f32, graph_size: Vec2) ---
	@(link_name="ImGui_BeginMenuBar") BeginMenuBar :: proc "c" () -> bool ---
	@(link_name="ImGui_EndMenuBar") EndMenuBar :: proc "c" () ---
	@(link_name="ImGui_BeginMainMenuBar") BeginMainMenuBar :: proc "c" () -> bool ---
	@(link_name="ImGui_EndMainMenuBar") EndMainMenuBar :: proc "c" () ---
	@(link_name="ImGui_BeginMenu") BeginMenu :: proc "c" (label: cstring) -> bool ---
	@(link_name="ImGui_BeginMenuEx") BeginMenuEx :: proc "c" (label: cstring, enabled: bool) -> bool ---
	@(link_name="ImGui_EndMenu") EndMenu :: proc "c" () ---
	@(link_name="ImGui_MenuItem") MenuItem :: proc "c" (label: cstring) -> bool ---
	@(link_name="ImGui_MenuItemEx") MenuItemEx :: proc "c" (label: cstring, shortcut: cstring, selected: bool, enabled: bool) -> bool ---
	@(link_name="ImGui_MenuItemBoolPtr") MenuItemBoolPtr :: proc "c" (label: cstring, shortcut: cstring, p_selected: ^bool, enabled: bool) -> bool ---
	@(link_name="ImGui_BeginTooltip") BeginTooltip :: proc "c" () -> bool ---
	@(link_name="ImGui_EndTooltip") EndTooltip :: proc "c" () ---
	@(link_name="ImGui_SetTooltip") SetTooltip :: proc "c" (fmt: cstring, #c_vararg args: ..any) ---
	// @(link_name="ImGui_SetTooltipV") SetTooltipV :: proc "c" (fmt: cstring, args: libc.va_list) ---
	@(link_name="ImGui_BeginPopup") BeginPopup :: proc "c" (str_id: cstring, flags: WindowFlags) -> bool ---
	@(link_name="ImGui_BeginPopupModal") BeginPopupModal :: proc "c" (name: cstring, p_open: ^bool, flags: WindowFlags) -> bool ---
	@(link_name="ImGui_EndPopup") EndPopup :: proc "c" () ---
	@(link_name="ImGui_OpenPopup") OpenPopup :: proc "c" (str_id: cstring, popup_flags: PopupFlags) ---
	@(link_name="ImGui_OpenPopupID") OpenPopupID :: proc "c" (id: ID, popup_flags: PopupFlags) ---
	@(link_name="ImGui_OpenPopupOnItemClick") OpenPopupOnItemClick :: proc "c" (str_id: cstring, popup_flags: PopupFlags) ---
	@(link_name="ImGui_CloseCurrentPopup") CloseCurrentPopup :: proc "c" () ---
	@(link_name="ImGui_BeginPopupContextItem") BeginPopupContextItem :: proc "c" () -> bool ---
	@(link_name="ImGui_BeginPopupContextItemEx") BeginPopupContextItemEx :: proc "c" (str_id: cstring, popup_flags: PopupFlags) -> bool ---
	@(link_name="ImGui_BeginPopupContextWindow") BeginPopupContextWindow :: proc "c" () -> bool ---
	@(link_name="ImGui_BeginPopupContextWindowEx") BeginPopupContextWindowEx :: proc "c" (str_id: cstring, popup_flags: PopupFlags) -> bool ---
	@(link_name="ImGui_BeginPopupContextVoid") BeginPopupContextVoid :: proc "c" () -> bool ---
	@(link_name="ImGui_BeginPopupContextVoidEx") BeginPopupContextVoidEx :: proc "c" (str_id: cstring, popup_flags: PopupFlags) -> bool ---
	@(link_name="ImGui_IsPopupOpen") IsPopupOpen :: proc "c" (str_id: cstring, flags: PopupFlags) -> bool ---
	@(link_name="ImGui_BeginTable") BeginTable :: proc "c" (str_id: cstring, column: c.int, flags: TableFlags) -> bool ---
	@(link_name="ImGui_BeginTableEx") BeginTableEx :: proc "c" (str_id: cstring, column: c.int, flags: TableFlags, outer_size: Vec2, inner_width: f32) -> bool ---
	@(link_name="ImGui_EndTable") EndTable :: proc "c" () ---
	@(link_name="ImGui_TableNextRow") TableNextRow :: proc "c" () ---
	@(link_name="ImGui_TableNextRowEx") TableNextRowEx :: proc "c" (row_flags: TableRowFlags, min_row_height: f32) ---
	@(link_name="ImGui_TableNextColumn") TableNextColumn :: proc "c" () -> bool ---
	@(link_name="ImGui_TableSetColumnIndex") TableSetColumnIndex :: proc "c" (column_n: c.int) -> bool ---
	@(link_name="ImGui_TableSetupColumn") TableSetupColumn :: proc "c" (label: cstring, flags: TableColumnFlags) ---
	@(link_name="ImGui_TableSetupColumnEx") TableSetupColumnEx :: proc "c" (label: cstring, flags: TableColumnFlags, init_width_or_weight: f32, user_id: ID) ---
	@(link_name="ImGui_TableSetupScrollFreeze") TableSetupScrollFreeze :: proc "c" (cols: c.int, rows: c.int) ---
	@(link_name="ImGui_TableHeadersRow") TableHeadersRow :: proc "c" () ---
	@(link_name="ImGui_TableHeader") TableHeader :: proc "c" (label: cstring) ---
	@(link_name="ImGui_TableGetSortSpecs") TableGetSortSpecs :: proc "c" () -> ^TableSortSpecs ---
	@(link_name="ImGui_TableGetColumnCount") TableGetColumnCount :: proc "c" () -> c.int ---
	@(link_name="ImGui_TableGetColumnIndex") TableGetColumnIndex :: proc "c" () -> c.int ---
	@(link_name="ImGui_TableGetRowIndex") TableGetRowIndex :: proc "c" () -> c.int ---
	@(link_name="ImGui_TableGetColumnName") TableGetColumnName :: proc "c" (column_n: c.int) -> cstring ---
	@(link_name="ImGui_TableGetColumnFlags") TableGetColumnFlags :: proc "c" (column_n: c.int) -> TableColumnFlags ---
	@(link_name="ImGui_TableSetColumnEnabled") TableSetColumnEnabled :: proc "c" (column_n: c.int, v: bool) ---
	@(link_name="ImGui_TableSetBgColor") TableSetBgColor :: proc "c" (target: TableBgTarget, color: U32, column_n: c.int) ---
	@(link_name="ImGui_Columns") Columns :: proc "c" () ---
	@(link_name="ImGui_ColumnsEx") ColumnsEx :: proc "c" (count: c.int, id: cstring, border: bool) ---
	@(link_name="ImGui_NextColumn") NextColumn :: proc "c" () ---
	@(link_name="ImGui_GetColumnIndex") GetColumnIndex :: proc "c" () -> c.int ---
	@(link_name="ImGui_GetColumnWidth") GetColumnWidth :: proc "c" (column_index: c.int) -> f32 ---
	@(link_name="ImGui_SetColumnWidth") SetColumnWidth :: proc "c" (column_index: c.int, width: f32) ---
	@(link_name="ImGui_GetColumnOffset") GetColumnOffset :: proc "c" (column_index: c.int) -> f32 ---
	@(link_name="ImGui_SetColumnOffset") SetColumnOffset :: proc "c" (column_index: c.int, offset_x: f32) ---
	@(link_name="ImGui_GetColumnsCount") GetColumnsCount :: proc "c" () -> c.int ---
	@(link_name="ImGui_BeginTabBar") BeginTabBar :: proc "c" (str_id: cstring, flags: TabBarFlags) -> bool ---
	@(link_name="ImGui_EndTabBar") EndTabBar :: proc "c" () ---
	@(link_name="ImGui_BeginTabItem") BeginTabItem :: proc "c" (label: cstring, p_open: ^bool, flags: TabItemFlags) -> bool ---
	@(link_name="ImGui_EndTabItem") EndTabItem :: proc "c" () ---
	@(link_name="ImGui_TabItemButton") TabItemButton :: proc "c" (label: cstring, flags: TabItemFlags) -> bool ---
	@(link_name="ImGui_SetTabItemClosed") SetTabItemClosed :: proc "c" (tab_or_docked_window_label: cstring) ---
	@(link_name="ImGui_LogToTTY") LogToTTY :: proc "c" (auto_open_depth: c.int) ---
	@(link_name="ImGui_LogToFile") LogToFile :: proc "c" (auto_open_depth: c.int, filename: cstring) ---
	@(link_name="ImGui_LogToClipboard") LogToClipboard :: proc "c" (auto_open_depth: c.int) ---
	@(link_name="ImGui_LogFinish") LogFinish :: proc "c" () ---
	@(link_name="ImGui_LogButtons") LogButtons :: proc "c" () ---
	@(link_name="ImGui_LogText") LogText :: proc "c" (fmt: cstring, #c_vararg args: ..any) ---
	// @(link_name="ImGui_LogTextV") LogTextV :: proc "c" (fmt: cstring, args: libc.va_list) ---
	@(link_name="ImGui_BeginDragDropSource") BeginDragDropSource :: proc "c" (flags: DragDropFlags) -> bool ---
	@(link_name="ImGui_SetDragDropPayload") SetDragDropPayload :: proc "c" (type: cstring, data: rawptr, sz: c.size_t, cond: Cond) -> bool ---
	@(link_name="ImGui_EndDragDropSource") EndDragDropSource :: proc "c" () ---
	@(link_name="ImGui_BeginDragDropTarget") BeginDragDropTarget :: proc "c" () -> bool ---
	@(link_name="ImGui_AcceptDragDropPayload") AcceptDragDropPayload :: proc "c" (type: cstring, flags: DragDropFlags) -> ^Payload ---
	@(link_name="ImGui_EndDragDropTarget") EndDragDropTarget :: proc "c" () ---
	@(link_name="ImGui_GetDragDropPayload") GetDragDropPayload :: proc "c" () -> ^Payload ---
	@(link_name="ImGui_BeginDisabled") BeginDisabled :: proc "c" (disabled: bool) ---
	@(link_name="ImGui_EndDisabled") EndDisabled :: proc "c" () ---
	@(link_name="ImGui_PushClipRect") PushClipRect :: proc "c" (clip_rect_min: Vec2, clip_rect_max: Vec2, intersect_with_current_clip_rect: bool) ---
	@(link_name="ImGui_PopClipRect") PopClipRect :: proc "c" () ---
	@(link_name="ImGui_SetItemDefaultFocus") SetItemDefaultFocus :: proc "c" () ---
	@(link_name="ImGui_SetKeyboardFocusHere") SetKeyboardFocusHere :: proc "c" () ---
	@(link_name="ImGui_SetKeyboardFocusHereEx") SetKeyboardFocusHereEx :: proc "c" (offset: c.int) ---
	@(link_name="ImGui_IsItemHovered") IsItemHovered :: proc "c" (flags: HoveredFlags) -> bool ---
	@(link_name="ImGui_IsItemActive") IsItemActive :: proc "c" () -> bool ---
	@(link_name="ImGui_IsItemFocused") IsItemFocused :: proc "c" () -> bool ---
	@(link_name="ImGui_IsItemClicked") IsItemClicked :: proc "c" () -> bool ---
	@(link_name="ImGui_IsItemClickedEx") IsItemClickedEx :: proc "c" (mouse_button: MouseButton) -> bool ---
	@(link_name="ImGui_IsItemVisible") IsItemVisible :: proc "c" () -> bool ---
	@(link_name="ImGui_IsItemEdited") IsItemEdited :: proc "c" () -> bool ---
	@(link_name="ImGui_IsItemActivated") IsItemActivated :: proc "c" () -> bool ---
	@(link_name="ImGui_IsItemDeactivated") IsItemDeactivated :: proc "c" () -> bool ---
	@(link_name="ImGui_IsItemDeactivatedAfterEdit") IsItemDeactivatedAfterEdit :: proc "c" () -> bool ---
	@(link_name="ImGui_IsItemToggledOpen") IsItemToggledOpen :: proc "c" () -> bool ---
	@(link_name="ImGui_IsAnyItemHovered") IsAnyItemHovered :: proc "c" () -> bool ---
	@(link_name="ImGui_IsAnyItemActive") IsAnyItemActive :: proc "c" () -> bool ---
	@(link_name="ImGui_IsAnyItemFocused") IsAnyItemFocused :: proc "c" () -> bool ---
	@(link_name="ImGui_GetItemID") GetItemID :: proc "c" () -> ID ---
	@(link_name="ImGui_GetItemRectMin") GetItemRectMin :: proc "c" () -> Vec2 ---
	@(link_name="ImGui_GetItemRectMax") GetItemRectMax :: proc "c" () -> Vec2 ---
	@(link_name="ImGui_GetItemRectSize") GetItemRectSize :: proc "c" () -> Vec2 ---
	@(link_name="ImGui_SetItemAllowOverlap") SetItemAllowOverlap :: proc "c" () ---
	@(link_name="ImGui_GetMainViewport") GetMainViewport :: proc "c" () -> ^Viewport ---
	@(link_name="ImGui_GetBackgroundDrawList") GetBackgroundDrawList :: proc "c" () -> ^DrawList ---
	@(link_name="ImGui_GetForegroundDrawList") GetForegroundDrawList :: proc "c" () -> ^DrawList ---
	@(link_name="ImGui_IsRectVisibleBySize") IsRectVisibleBySize :: proc "c" (size: Vec2) -> bool ---
	@(link_name="ImGui_IsRectVisible") IsRectVisible :: proc "c" (rect_min: Vec2, rect_max: Vec2) -> bool ---
	@(link_name="ImGui_GetTime") GetTime :: proc "c" () -> f64 ---
	@(link_name="ImGui_GetFrameCount") GetFrameCount :: proc "c" () -> c.int ---
	@(link_name="ImGui_GetDrawListSharedData") GetDrawListSharedData :: proc "c" () -> ^DrawListSharedData ---
	@(link_name="ImGui_GetStyleColorName") GetStyleColorName :: proc "c" (idx: Col) -> cstring ---
	@(link_name="ImGui_BeginChildFrame") BeginChildFrame :: proc "c" (id: ID, size: Vec2, flags: WindowFlags) -> bool ---
	@(link_name="ImGui_EndChildFrame") EndChildFrame :: proc "c" () ---
	@(link_name="ImGui_CalcTextSize") CalcTextSize :: proc "c" (text: cstring) -> Vec2 ---
	@(link_name="ImGui_CalcTextSizeEx") CalcTextSizeEx :: proc "c" (text: cstring, text_end: cstring, hide_text_after_double_hash: bool, wrap_width: f32) -> Vec2 ---
	@(link_name="ImGui_ColorConvertU32ToFloat4") ColorConvertU32ToFloat4 :: proc "c" (_in: U32) -> Vec4 ---
	@(link_name="ImGui_ColorConvertFloat4ToU32") ColorConvertFloat4ToU32 :: proc "c" (_in: Vec4) -> U32 ---
	@(link_name="ImGui_ColorConvertRGBtoHSV") ColorConvertRGBtoHSV :: proc "c" (r: f32, g: f32, b: f32, out_h: ^f32, out_s: ^f32, out_v: ^f32) ---
	@(link_name="ImGui_ColorConvertHSVtoRGB") ColorConvertHSVtoRGB :: proc "c" (h: f32, s: f32, v: f32, out_r: ^f32, out_g: ^f32, out_b: ^f32) ---
	@(link_name="ImGui_IsKeyDown") IsKeyDown :: proc "c" (key: Key) -> bool ---
	@(link_name="ImGui_IsKeyPressed") IsKeyPressed :: proc "c" (key: Key) -> bool ---
	@(link_name="ImGui_IsKeyPressedEx") IsKeyPressedEx :: proc "c" (key: Key, repeat: bool) -> bool ---
	@(link_name="ImGui_IsKeyReleased") IsKeyReleased :: proc "c" (key: Key) -> bool ---
	@(link_name="ImGui_GetKeyPressedAmount") GetKeyPressedAmount :: proc "c" (key: Key, repeat_delay: f32, rate: f32) -> c.int ---
	@(link_name="ImGui_GetKeyName") GetKeyName :: proc "c" (key: Key) -> cstring ---
	@(link_name="ImGui_SetNextFrameWantCaptureKeyboard") SetNextFrameWantCaptureKeyboard :: proc "c" (want_capture_keyboard: bool) ---
	@(link_name="ImGui_IsMouseDown") IsMouseDown :: proc "c" (button: MouseButton) -> bool ---
	@(link_name="ImGui_IsMouseClicked") IsMouseClicked :: proc "c" (button: MouseButton) -> bool ---
	@(link_name="ImGui_IsMouseClickedEx") IsMouseClickedEx :: proc "c" (button: MouseButton, repeat: bool) -> bool ---
	@(link_name="ImGui_IsMouseReleased") IsMouseReleased :: proc "c" (button: MouseButton) -> bool ---
	@(link_name="ImGui_IsMouseDoubleClicked") IsMouseDoubleClicked :: proc "c" (button: MouseButton) -> bool ---
	@(link_name="ImGui_GetMouseClickedCount") GetMouseClickedCount :: proc "c" (button: MouseButton) -> c.int ---
	@(link_name="ImGui_IsMouseHoveringRect") IsMouseHoveringRect :: proc "c" (r_min: Vec2, r_max: Vec2) -> bool ---
	@(link_name="ImGui_IsMouseHoveringRectEx") IsMouseHoveringRectEx :: proc "c" (r_min: Vec2, r_max: Vec2, clip: bool) -> bool ---
	@(link_name="ImGui_IsMousePosValid") IsMousePosValid :: proc "c" (mouse_pos: ^Vec2) -> bool ---
	@(link_name="ImGui_IsAnyMouseDown") IsAnyMouseDown :: proc "c" () -> bool ---
	@(link_name="ImGui_GetMousePos") GetMousePos :: proc "c" () -> Vec2 ---
	@(link_name="ImGui_GetMousePosOnOpeningCurrentPopup") GetMousePosOnOpeningCurrentPopup :: proc "c" () -> Vec2 ---
	@(link_name="ImGui_IsMouseDragging") IsMouseDragging :: proc "c" (button: MouseButton, lock_threshold: f32) -> bool ---
	@(link_name="ImGui_GetMouseDragDelta") GetMouseDragDelta :: proc "c" (button: MouseButton, lock_threshold: f32) -> Vec2 ---
	@(link_name="ImGui_ResetMouseDragDelta") ResetMouseDragDelta :: proc "c" () ---
	@(link_name="ImGui_ResetMouseDragDeltaEx") ResetMouseDragDeltaEx :: proc "c" (button: MouseButton) ---
	@(link_name="ImGui_GetMouseCursor") GetMouseCursor :: proc "c" () -> MouseCursor ---
	@(link_name="ImGui_SetMouseCursor") SetMouseCursor :: proc "c" (cursor_type: MouseCursor) ---
	@(link_name="ImGui_SetNextFrameWantCaptureMouse") SetNextFrameWantCaptureMouse :: proc "c" (want_capture_mouse: bool) ---
	@(link_name="ImGui_GetClipboardText") GetClipboardText :: proc "c" () -> cstring ---
	@(link_name="ImGui_SetClipboardText") SetClipboardText :: proc "c" (text: cstring) ---
	@(link_name="ImGui_LoadIniSettingsFromDisk") LoadIniSettingsFromDisk :: proc "c" (ini_filename: cstring) ---
	@(link_name="ImGui_LoadIniSettingsFromMemory") LoadIniSettingsFromMemory :: proc "c" (ini_data: cstring, ini_size: c.size_t) ---
	@(link_name="ImGui_SaveIniSettingsToDisk") SaveIniSettingsToDisk :: proc "c" (ini_filename: cstring) ---
	@(link_name="ImGui_SaveIniSettingsToMemory") SaveIniSettingsToMemory :: proc "c" (out_ini_size: ^c.size_t) -> cstring ---
	@(link_name="ImGui_DebugTextEncoding") DebugTextEncoding :: proc "c" (text: cstring) ---
	@(link_name="ImGui_DebugCheckVersionAndDataLayout") DebugCheckVersionAndDataLayout :: proc "c" (version_str: cstring, sz_io: c.size_t, sz_style: c.size_t, sz_vec2: c.size_t, sz_vec4: c.size_t, sz_drawvert: c.size_t, sz_drawidx: c.size_t) -> bool ---
	@(link_name="ImGui_SetAllocatorFunctions") SetAllocatorFunctions :: proc "c" (alloc_func: MemAllocFunc, free_func: MemFreeFunc, user_data: rawptr) ---
	@(link_name="ImGui_GetAllocatorFunctions") GetAllocatorFunctions :: proc "c" (p_alloc_func: ^MemAllocFunc, p_free_func: ^MemFreeFunc, p_user_data: ^rawptr) ---
	@(link_name="ImGui_MemAlloc") MemAlloc :: proc "c" (size: c.size_t) -> rawptr ---
	@(link_name="ImGui_MemFree") MemFree :: proc "c" (ptr: rawptr) ---
	@(link_name="ImVector_Construct") Vector_Construct :: proc "c" (vector: rawptr) ---
	@(link_name="ImVector_Destruct") Vector_Destruct :: proc "c" (vector: rawptr) ---
	@(link_name="ImGuiStyle_ScaleAllSizes") Style_ScaleAllSizes :: proc "c" (self: ^Style, scale_factor: f32) ---
	@(link_name="ImGuiIO_AddKeyEvent") IO_AddKeyEvent :: proc "c" (self: ^IO, key: Key, down: bool) ---
	@(link_name="ImGuiIO_AddKeyAnalogEvent") IO_AddKeyAnalogEvent :: proc "c" (self: ^IO, key: Key, down: bool, v: f32) ---
	@(link_name="ImGuiIO_AddMousePosEvent") IO_AddMousePosEvent :: proc "c" (self: ^IO, x: f32, y: f32) ---
	@(link_name="ImGuiIO_AddMouseButtonEvent") IO_AddMouseButtonEvent :: proc "c" (self: ^IO, button: c.int, down: bool) ---
	@(link_name="ImGuiIO_AddMouseWheelEvent") IO_AddMouseWheelEvent :: proc "c" (self: ^IO, wheel_x: f32, wheel_y: f32) ---
	@(link_name="ImGuiIO_AddFocusEvent") IO_AddFocusEvent :: proc "c" (self: ^IO, focused: bool) ---
	@(link_name="ImGuiIO_AddInputCharacter") IO_AddInputCharacter :: proc "c" (self: ^IO, c: c.uint) ---
	@(link_name="ImGuiIO_AddInputCharacterUTF16") IO_AddInputCharacterUTF16 :: proc "c" (self: ^IO, c: Wchar16) ---
	@(link_name="ImGuiIO_AddInputCharactersUTF8") IO_AddInputCharactersUTF8 :: proc "c" (self: ^IO, str: cstring) ---
	@(link_name="ImGuiIO_SetKeyEventNativeData") IO_SetKeyEventNativeData :: proc "c" (self: ^IO, key: Key, native_keycode: c.int, native_scancode: c.int) ---
	@(link_name="ImGuiIO_SetKeyEventNativeDataEx") IO_SetKeyEventNativeDataEx :: proc "c" (self: ^IO, key: Key, native_keycode: c.int, native_scancode: c.int, native_legacy_index: c.int) ---
	@(link_name="ImGuiIO_SetAppAcceptingEvents") IO_SetAppAcceptingEvents :: proc "c" (self: ^IO, accepting_events: bool) ---
	@(link_name="ImGuiIO_ClearInputCharacters") IO_ClearInputCharacters :: proc "c" (self: ^IO) ---
	@(link_name="ImGuiIO_ClearInputKeys") IO_ClearInputKeys :: proc "c" (self: ^IO) ---
	@(link_name="ImGuiInputTextCallbackData_DeleteChars") InputTextCallbackData_DeleteChars :: proc "c" (self: ^InputTextCallbackData, pos: c.int, bytes_count: c.int) ---
	@(link_name="ImGuiInputTextCallbackData_InsertChars") InputTextCallbackData_InsertChars :: proc "c" (self: ^InputTextCallbackData, pos: c.int, text: cstring, text_end: cstring) ---
	@(link_name="ImGuiInputTextCallbackData_SelectAll") InputTextCallbackData_SelectAll :: proc "c" (self: ^InputTextCallbackData) ---
	@(link_name="ImGuiInputTextCallbackData_ClearSelection") InputTextCallbackData_ClearSelection :: proc "c" (self: ^InputTextCallbackData) ---
	@(link_name="ImGuiInputTextCallbackData_HasSelection") InputTextCallbackData_HasSelection :: proc "c" (self: ^InputTextCallbackData) -> bool ---
	@(link_name="ImGuiPayload_Clear") Payload_Clear :: proc "c" (self: ^Payload) ---
	@(link_name="ImGuiPayload_IsDataType") Payload_IsDataType :: proc "c" (self: ^Payload, type: cstring) -> bool ---
	@(link_name="ImGuiPayload_IsPreview") Payload_IsPreview :: proc "c" (self: ^Payload) -> bool ---
	@(link_name="ImGuiPayload_IsDelivery") Payload_IsDelivery :: proc "c" (self: ^Payload) -> bool ---
	@(link_name="ImGuiTextFilter_ImGuiTextRange_empty") TextFilter_ImGuiTextRange_empty :: proc "c" (self: ^TextFilter_ImGuiTextRange) -> bool ---
	@(link_name="ImGuiTextFilter_ImGuiTextRange_split") TextFilter_ImGuiTextRange_split :: proc "c" (self: ^TextFilter_ImGuiTextRange, separator: c.char, out: ^Vector_TextFilter_ImGuiTextRange) ---
	@(link_name="ImGuiTextFilter_Draw") TextFilter_Draw :: proc "c" (self: ^TextFilter, label: cstring, width: f32) -> bool ---
	@(link_name="ImGuiTextFilter_PassFilter") TextFilter_PassFilter :: proc "c" (self: ^TextFilter, text: cstring, text_end: cstring) -> bool ---
	@(link_name="ImGuiTextFilter_Build") TextFilter_Build :: proc "c" (self: ^TextFilter) ---
	@(link_name="ImGuiTextFilter_Clear") TextFilter_Clear :: proc "c" (self: ^TextFilter) ---
	@(link_name="ImGuiTextFilter_IsActive") TextFilter_IsActive :: proc "c" (self: ^TextFilter) -> bool ---
	@(link_name="ImGuiTextBuffer_begin") TextBuffer_begin :: proc "c" (self: ^TextBuffer) -> cstring ---
	@(link_name="ImGuiTextBuffer_end") TextBuffer_end :: proc "c" (self: ^TextBuffer) -> cstring ---
	@(link_name="ImGuiTextBuffer_size") TextBuffer_size :: proc "c" (self: ^TextBuffer) -> c.int ---
	@(link_name="ImGuiTextBuffer_empty") TextBuffer_empty :: proc "c" (self: ^TextBuffer) -> bool ---
	@(link_name="ImGuiTextBuffer_clear") TextBuffer_clear :: proc "c" (self: ^TextBuffer) ---
	@(link_name="ImGuiTextBuffer_reserve") TextBuffer_reserve :: proc "c" (self: ^TextBuffer, capacity: c.int) ---
	@(link_name="ImGuiTextBuffer_c_str") TextBuffer_c_str :: proc "c" (self: ^TextBuffer) -> cstring ---
	@(link_name="ImGuiTextBuffer_append") TextBuffer_append :: proc "c" (self: ^TextBuffer, str: cstring, str_end: cstring) ---
	@(link_name="ImGuiTextBuffer_appendf") TextBuffer_appendf :: proc "c" (self: ^TextBuffer, fmt: cstring, #c_vararg args: ..any) ---
	// @(link_name="ImGuiTextBuffer_appendfv") TextBuffer_appendfv :: proc "c" (self: ^TextBuffer, fmt: cstring, args: libc.va_list) ---
	@(link_name="ImGuiListClipper_Begin") ListClipper_Begin :: proc "c" (self: ^ListClipper, items_count: c.int, items_height: f32) ---
	@(link_name="ImGuiListClipper_End") ListClipper_End :: proc "c" (self: ^ListClipper) ---
	@(link_name="ImGuiListClipper_Step") ListClipper_Step :: proc "c" (self: ^ListClipper) -> bool ---
	@(link_name="ImGuiListClipper_ForceDisplayRangeByIndices") ListClipper_ForceDisplayRangeByIndices :: proc "c" (self: ^ListClipper, item_min: c.int, item_max: c.int) ---
	@(link_name="ImColor_SetHSV") Color_SetHSV :: proc "c" (self: ^Color, h: f32, s: f32, v: f32, a: f32) ---
	@(link_name="ImColor_HSV") Color_HSV :: proc "c" (self: ^Color, h: f32, s: f32, v: f32, a: f32) -> Color ---
	@(link_name="ImDrawCmd_GetTexID") DrawCmd_GetTexID :: proc "c" (self: ^DrawCmd) -> TextureID ---
	@(link_name="ImDrawListSplitter_Clear") DrawListSplitter_Clear :: proc "c" (self: ^DrawListSplitter) ---
	@(link_name="ImDrawListSplitter_ClearFreeMemory") DrawListSplitter_ClearFreeMemory :: proc "c" (self: ^DrawListSplitter) ---
	@(link_name="ImDrawListSplitter_Split") DrawListSplitter_Split :: proc "c" (self: ^DrawListSplitter, draw_list: ^DrawList, count: c.int) ---
	@(link_name="ImDrawListSplitter_Merge") DrawListSplitter_Merge :: proc "c" (self: ^DrawListSplitter, draw_list: ^DrawList) ---
	@(link_name="ImDrawListSplitter_SetCurrentChannel") DrawListSplitter_SetCurrentChannel :: proc "c" (self: ^DrawListSplitter, draw_list: ^DrawList, channel_idx: c.int) ---
	@(link_name="ImDrawList_PushClipRect") DrawList_PushClipRect :: proc "c" (self: ^DrawList, clip_rect_min: Vec2, clip_rect_max: Vec2, intersect_with_current_clip_rect: bool) ---
	@(link_name="ImDrawList_PushClipRectFullScreen") DrawList_PushClipRectFullScreen :: proc "c" (self: ^DrawList) ---
	@(link_name="ImDrawList_PopClipRect") DrawList_PopClipRect :: proc "c" (self: ^DrawList) ---
	@(link_name="ImDrawList_PushTextureID") DrawList_PushTextureID :: proc "c" (self: ^DrawList, texture_id: TextureID) ---
	@(link_name="ImDrawList_PopTextureID") DrawList_PopTextureID :: proc "c" (self: ^DrawList) ---
	@(link_name="ImDrawList_GetClipRectMin") DrawList_GetClipRectMin :: proc "c" (self: ^DrawList) -> Vec2 ---
	@(link_name="ImDrawList_GetClipRectMax") DrawList_GetClipRectMax :: proc "c" (self: ^DrawList) -> Vec2 ---
	@(link_name="ImDrawList_AddLine") DrawList_AddLine :: proc "c" (self: ^DrawList, p1: Vec2, p2: Vec2, col: U32) ---
	@(link_name="ImDrawList_AddLineEx") DrawList_AddLineEx :: proc "c" (self: ^DrawList, p1: Vec2, p2: Vec2, col: U32, thickness: f32) ---
	@(link_name="ImDrawList_AddRect") DrawList_AddRect :: proc "c" (self: ^DrawList, p_min: Vec2, p_max: Vec2, col: U32) ---
	@(link_name="ImDrawList_AddRectEx") DrawList_AddRectEx :: proc "c" (self: ^DrawList, p_min: Vec2, p_max: Vec2, col: U32, rounding: f32, flags: DrawFlags, thickness: f32) ---
	@(link_name="ImDrawList_AddRectFilled") DrawList_AddRectFilled :: proc "c" (self: ^DrawList, p_min: Vec2, p_max: Vec2, col: U32) ---
	@(link_name="ImDrawList_AddRectFilledEx") DrawList_AddRectFilledEx :: proc "c" (self: ^DrawList, p_min: Vec2, p_max: Vec2, col: U32, rounding: f32, flags: DrawFlags) ---
	@(link_name="ImDrawList_AddRectFilledMultiColor") DrawList_AddRectFilledMultiColor :: proc "c" (self: ^DrawList, p_min: Vec2, p_max: Vec2, col_upr_left: U32, col_upr_right: U32, col_bot_right: U32, col_bot_left: U32) ---
	@(link_name="ImDrawList_AddQuad") DrawList_AddQuad :: proc "c" (self: ^DrawList, p1: Vec2, p2: Vec2, p3: Vec2, p4: Vec2, col: U32) ---
	@(link_name="ImDrawList_AddQuadEx") DrawList_AddQuadEx :: proc "c" (self: ^DrawList, p1: Vec2, p2: Vec2, p3: Vec2, p4: Vec2, col: U32, thickness: f32) ---
	@(link_name="ImDrawList_AddQuadFilled") DrawList_AddQuadFilled :: proc "c" (self: ^DrawList, p1: Vec2, p2: Vec2, p3: Vec2, p4: Vec2, col: U32) ---
	@(link_name="ImDrawList_AddTriangle") DrawList_AddTriangle :: proc "c" (self: ^DrawList, p1: Vec2, p2: Vec2, p3: Vec2, col: U32) ---
	@(link_name="ImDrawList_AddTriangleEx") DrawList_AddTriangleEx :: proc "c" (self: ^DrawList, p1: Vec2, p2: Vec2, p3: Vec2, col: U32, thickness: f32) ---
	@(link_name="ImDrawList_AddTriangleFilled") DrawList_AddTriangleFilled :: proc "c" (self: ^DrawList, p1: Vec2, p2: Vec2, p3: Vec2, col: U32) ---
	@(link_name="ImDrawList_AddCircle") DrawList_AddCircle :: proc "c" (self: ^DrawList, center: Vec2, radius: f32, col: U32) ---
	@(link_name="ImDrawList_AddCircleEx") DrawList_AddCircleEx :: proc "c" (self: ^DrawList, center: Vec2, radius: f32, col: U32, num_segments: c.int, thickness: f32) ---
	@(link_name="ImDrawList_AddCircleFilled") DrawList_AddCircleFilled :: proc "c" (self: ^DrawList, center: Vec2, radius: f32, col: U32, num_segments: c.int) ---
	@(link_name="ImDrawList_AddNgon") DrawList_AddNgon :: proc "c" (self: ^DrawList, center: Vec2, radius: f32, col: U32, num_segments: c.int) ---
	@(link_name="ImDrawList_AddNgonEx") DrawList_AddNgonEx :: proc "c" (self: ^DrawList, center: Vec2, radius: f32, col: U32, num_segments: c.int, thickness: f32) ---
	@(link_name="ImDrawList_AddNgonFilled") DrawList_AddNgonFilled :: proc "c" (self: ^DrawList, center: Vec2, radius: f32, col: U32, num_segments: c.int) ---
	@(link_name="ImDrawList_AddText") DrawList_AddText :: proc "c" (self: ^DrawList, pos: Vec2, col: U32, text_begin: cstring) ---
	@(link_name="ImDrawList_AddTextEx") DrawList_AddTextEx :: proc "c" (self: ^DrawList, pos: Vec2, col: U32, text_begin: cstring, text_end: cstring) ---
	@(link_name="ImDrawList_AddTextImFontPtr") DrawList_AddTextImFontPtr :: proc "c" (self: ^DrawList, font: ^Font, font_size: f32, pos: Vec2, col: U32, text_begin: cstring) ---
	@(link_name="ImDrawList_AddTextImFontPtrEx") DrawList_AddTextImFontPtrEx :: proc "c" (self: ^DrawList, font: ^Font, font_size: f32, pos: Vec2, col: U32, text_begin: cstring, text_end: cstring, wrap_width: f32, cpu_fine_clip_rect: ^Vec4) ---
	@(link_name="ImDrawList_AddPolyline") DrawList_AddPolyline :: proc "c" (self: ^DrawList, points: ^Vec2, num_points: c.int, col: U32, flags: DrawFlags, thickness: f32) ---
	@(link_name="ImDrawList_AddConvexPolyFilled") DrawList_AddConvexPolyFilled :: proc "c" (self: ^DrawList, points: ^Vec2, num_points: c.int, col: U32) ---
	@(link_name="ImDrawList_AddBezierCubic") DrawList_AddBezierCubic :: proc "c" (self: ^DrawList, p1: Vec2, p2: Vec2, p3: Vec2, p4: Vec2, col: U32, thickness: f32, num_segments: c.int) ---
	@(link_name="ImDrawList_AddBezierQuadratic") DrawList_AddBezierQuadratic :: proc "c" (self: ^DrawList, p1: Vec2, p2: Vec2, p3: Vec2, col: U32, thickness: f32, num_segments: c.int) ---
	@(link_name="ImDrawList_AddImage") DrawList_AddImage :: proc "c" (self: ^DrawList, user_texture_id: TextureID, p_min: Vec2, p_max: Vec2) ---
	@(link_name="ImDrawList_AddImageEx") DrawList_AddImageEx :: proc "c" (self: ^DrawList, user_texture_id: TextureID, p_min: Vec2, p_max: Vec2, uv_min: Vec2, uv_max: Vec2, col: U32) ---
	@(link_name="ImDrawList_AddImageQuad") DrawList_AddImageQuad :: proc "c" (self: ^DrawList, user_texture_id: TextureID, p1: Vec2, p2: Vec2, p3: Vec2, p4: Vec2) ---
	@(link_name="ImDrawList_AddImageQuadEx") DrawList_AddImageQuadEx :: proc "c" (self: ^DrawList, user_texture_id: TextureID, p1: Vec2, p2: Vec2, p3: Vec2, p4: Vec2, uv1: Vec2, uv2: Vec2, uv3: Vec2, uv4: Vec2, col: U32) ---
	@(link_name="ImDrawList_AddImageRounded") DrawList_AddImageRounded :: proc "c" (self: ^DrawList, user_texture_id: TextureID, p_min: Vec2, p_max: Vec2, uv_min: Vec2, uv_max: Vec2, col: U32, rounding: f32, flags: DrawFlags) ---
	@(link_name="ImDrawList_PathClear") DrawList_PathClear :: proc "c" (self: ^DrawList) ---
	@(link_name="ImDrawList_PathLineTo") DrawList_PathLineTo :: proc "c" (self: ^DrawList, pos: Vec2) ---
	@(link_name="ImDrawList_PathLineToMergeDuplicate") DrawList_PathLineToMergeDuplicate :: proc "c" (self: ^DrawList, pos: Vec2) ---
	@(link_name="ImDrawList_PathFillConvex") DrawList_PathFillConvex :: proc "c" (self: ^DrawList, col: U32) ---
	@(link_name="ImDrawList_PathStroke") DrawList_PathStroke :: proc "c" (self: ^DrawList, col: U32, flags: DrawFlags, thickness: f32) ---
	@(link_name="ImDrawList_PathArcTo") DrawList_PathArcTo :: proc "c" (self: ^DrawList, center: Vec2, radius: f32, a_min: f32, a_max: f32, num_segments: c.int) ---
	@(link_name="ImDrawList_PathArcToFast") DrawList_PathArcToFast :: proc "c" (self: ^DrawList, center: Vec2, radius: f32, a_min_of_12: c.int, a_max_of_12: c.int) ---
	@(link_name="ImDrawList_PathBezierCubicCurveTo") DrawList_PathBezierCubicCurveTo :: proc "c" (self: ^DrawList, p2: Vec2, p3: Vec2, p4: Vec2, num_segments: c.int) ---
	@(link_name="ImDrawList_PathBezierQuadraticCurveTo") DrawList_PathBezierQuadraticCurveTo :: proc "c" (self: ^DrawList, p2: Vec2, p3: Vec2, num_segments: c.int) ---
	@(link_name="ImDrawList_PathRect") DrawList_PathRect :: proc "c" (self: ^DrawList, rect_min: Vec2, rect_max: Vec2, rounding: f32, flags: DrawFlags) ---
	@(link_name="ImDrawList_AddCallback") DrawList_AddCallback :: proc "c" (self: ^DrawList, callback: DrawCallback, callback_data: rawptr) ---
	@(link_name="ImDrawList_AddDrawCmd") DrawList_AddDrawCmd :: proc "c" (self: ^DrawList) ---
	@(link_name="ImDrawList_CloneOutput") DrawList_CloneOutput :: proc "c" (self: ^DrawList) -> ^DrawList ---
	@(link_name="ImDrawList_ChannelsSplit") DrawList_ChannelsSplit :: proc "c" (self: ^DrawList, count: c.int) ---
	@(link_name="ImDrawList_ChannelsMerge") DrawList_ChannelsMerge :: proc "c" (self: ^DrawList) ---
	@(link_name="ImDrawList_ChannelsSetCurrent") DrawList_ChannelsSetCurrent :: proc "c" (self: ^DrawList, n: c.int) ---
	@(link_name="ImDrawList_PrimReserve") DrawList_PrimReserve :: proc "c" (self: ^DrawList, idx_count: c.int, vtx_count: c.int) ---
	@(link_name="ImDrawList_PrimUnreserve") DrawList_PrimUnreserve :: proc "c" (self: ^DrawList, idx_count: c.int, vtx_count: c.int) ---
	@(link_name="ImDrawList_PrimRect") DrawList_PrimRect :: proc "c" (self: ^DrawList, a: Vec2, b: Vec2, col: U32) ---
	@(link_name="ImDrawList_PrimRectUV") DrawList_PrimRectUV :: proc "c" (self: ^DrawList, a: Vec2, b: Vec2, uv_a: Vec2, uv_b: Vec2, col: U32) ---
	@(link_name="ImDrawList_PrimQuadUV") DrawList_PrimQuadUV :: proc "c" (self: ^DrawList, a: Vec2, b: Vec2, c: Vec2, d: Vec2, uv_a: Vec2, uv_b: Vec2, uv_c: Vec2, uv_d: Vec2, col: U32) ---
	@(link_name="ImDrawList_PrimWriteVtx") DrawList_PrimWriteVtx :: proc "c" (self: ^DrawList, pos: Vec2, uv: Vec2, col: U32) ---
	@(link_name="ImDrawList_PrimWriteIdx") DrawList_PrimWriteIdx :: proc "c" (self: ^DrawList, idx: DrawIdx) ---
	@(link_name="ImDrawList_PrimVtx") DrawList_PrimVtx :: proc "c" (self: ^DrawList, pos: Vec2, uv: Vec2, col: U32) ---
	@(link_name="ImDrawList__ResetForNewFrame") DrawList__ResetForNewFrame :: proc "c" (self: ^DrawList) ---
	@(link_name="ImDrawList__ClearFreeMemory") DrawList__ClearFreeMemory :: proc "c" (self: ^DrawList) ---
	@(link_name="ImDrawList__PopUnusedDrawCmd") DrawList__PopUnusedDrawCmd :: proc "c" (self: ^DrawList) ---
	@(link_name="ImDrawList__TryMergeDrawCmds") DrawList__TryMergeDrawCmds :: proc "c" (self: ^DrawList) ---
	@(link_name="ImDrawList__OnChangedClipRect") DrawList__OnChangedClipRect :: proc "c" (self: ^DrawList) ---
	@(link_name="ImDrawList__OnChangedTextureID") DrawList__OnChangedTextureID :: proc "c" (self: ^DrawList) ---
	@(link_name="ImDrawList__OnChangedVtxOffset") DrawList__OnChangedVtxOffset :: proc "c" (self: ^DrawList) ---
	@(link_name="ImDrawList__CalcCircleAutoSegmentCount") DrawList__CalcCircleAutoSegmentCount :: proc "c" (self: ^DrawList, radius: f32) -> c.int ---
	@(link_name="ImDrawList__PathArcToFastEx") DrawList__PathArcToFastEx :: proc "c" (self: ^DrawList, center: Vec2, radius: f32, a_min_sample: c.int, a_max_sample: c.int, a_step: c.int) ---
	@(link_name="ImDrawList__PathArcToN") DrawList__PathArcToN :: proc "c" (self: ^DrawList, center: Vec2, radius: f32, a_min: f32, a_max: f32, num_segments: c.int) ---
	@(link_name="ImDrawData_Clear") DrawData_Clear :: proc "c" (self: ^DrawData) ---
	@(link_name="ImDrawData_DeIndexAllBuffers") DrawData_DeIndexAllBuffers :: proc "c" (self: ^DrawData) ---
	@(link_name="ImDrawData_ScaleClipRects") DrawData_ScaleClipRects :: proc "c" (self: ^DrawData, fb_scale: Vec2) ---
	@(link_name="ImFontGlyphRangesBuilder_Clear") FontGlyphRangesBuilder_Clear :: proc "c" (self: ^FontGlyphRangesBuilder) ---
	@(link_name="ImFontGlyphRangesBuilder_GetBit") FontGlyphRangesBuilder_GetBit :: proc "c" (self: ^FontGlyphRangesBuilder, n: c.size_t) -> bool ---
	@(link_name="ImFontGlyphRangesBuilder_SetBit") FontGlyphRangesBuilder_SetBit :: proc "c" (self: ^FontGlyphRangesBuilder, n: c.size_t) ---
	@(link_name="ImFontGlyphRangesBuilder_AddChar") FontGlyphRangesBuilder_AddChar :: proc "c" (self: ^FontGlyphRangesBuilder, c: Wchar) ---
	@(link_name="ImFontGlyphRangesBuilder_AddText") FontGlyphRangesBuilder_AddText :: proc "c" (self: ^FontGlyphRangesBuilder, text: cstring, text_end: cstring) ---
	@(link_name="ImFontGlyphRangesBuilder_AddRanges") FontGlyphRangesBuilder_AddRanges :: proc "c" (self: ^FontGlyphRangesBuilder, ranges: ^Wchar) ---
	@(link_name="ImFontGlyphRangesBuilder_BuildRanges") FontGlyphRangesBuilder_BuildRanges :: proc "c" (self: ^FontGlyphRangesBuilder, out_ranges: ^Vector_Wchar) ---
	@(link_name="ImFontAtlasCustomRect_IsPacked") FontAtlasCustomRect_IsPacked :: proc "c" (self: ^FontAtlasCustomRect) -> bool ---
	@(link_name="ImFontAtlas_AddFont") FontAtlas_AddFont :: proc "c" (self: ^FontAtlas, font_cfg: ^FontConfig) -> ^Font ---
	@(link_name="ImFontAtlas_AddFontDefault") FontAtlas_AddFontDefault :: proc "c" (self: ^FontAtlas, font_cfg: ^FontConfig) -> ^Font ---
	@(link_name="ImFontAtlas_AddFontFromFileTTF") FontAtlas_AddFontFromFileTTF :: proc "c" (self: ^FontAtlas, filename: cstring, size_pixels: f32, font_cfg: ^FontConfig, glyph_ranges: ^Wchar) -> ^Font ---
	@(link_name="ImFontAtlas_AddFontFromMemoryTTF") FontAtlas_AddFontFromMemoryTTF :: proc "c" (self: ^FontAtlas, font_data: rawptr, font_size: c.int, size_pixels: f32, font_cfg: ^FontConfig, glyph_ranges: ^Wchar) -> ^Font ---
	@(link_name="ImFontAtlas_AddFontFromMemoryCompressedTTF") FontAtlas_AddFontFromMemoryCompressedTTF :: proc "c" (self: ^FontAtlas, compressed_font_data: rawptr, compressed_font_size: c.int, size_pixels: f32, font_cfg: ^FontConfig, glyph_ranges: ^Wchar) -> ^Font ---
	@(link_name="ImFontAtlas_AddFontFromMemoryCompressedBase85TTF") FontAtlas_AddFontFromMemoryCompressedBase85TTF :: proc "c" (self: ^FontAtlas, compressed_font_data_base85: cstring, size_pixels: f32, font_cfg: ^FontConfig, glyph_ranges: ^Wchar) -> ^Font ---
	@(link_name="ImFontAtlas_ClearInputData") FontAtlas_ClearInputData :: proc "c" (self: ^FontAtlas) ---
	@(link_name="ImFontAtlas_ClearTexData") FontAtlas_ClearTexData :: proc "c" (self: ^FontAtlas) ---
	@(link_name="ImFontAtlas_ClearFonts") FontAtlas_ClearFonts :: proc "c" (self: ^FontAtlas) ---
	@(link_name="ImFontAtlas_Clear") FontAtlas_Clear :: proc "c" (self: ^FontAtlas) ---
	@(link_name="ImFontAtlas_Build") FontAtlas_Build :: proc "c" (self: ^FontAtlas) -> bool ---
	@(link_name="ImFontAtlas_GetTexDataAsAlpha8") FontAtlas_GetTexDataAsAlpha8 :: proc "c" (self: ^FontAtlas, out_pixels: ^^c.uchar, out_width: ^c.int, out_height: ^c.int, out_bytes_per_pixel: ^c.int) ---
	@(link_name="ImFontAtlas_GetTexDataAsRGBA32") FontAtlas_GetTexDataAsRGBA32 :: proc "c" (self: ^FontAtlas, out_pixels: ^^c.uchar, out_width: ^c.int, out_height: ^c.int, out_bytes_per_pixel: ^c.int) ---
	@(link_name="ImFontAtlas_IsBuilt") FontAtlas_IsBuilt :: proc "c" (self: ^FontAtlas) -> bool ---
	@(link_name="ImFontAtlas_SetTexID") FontAtlas_SetTexID :: proc "c" (self: ^FontAtlas, id: TextureID) ---
	@(link_name="ImFontAtlas_GetGlyphRangesDefault") FontAtlas_GetGlyphRangesDefault :: proc "c" (self: ^FontAtlas) -> ^Wchar ---
	@(link_name="ImFontAtlas_GetGlyphRangesGreek") FontAtlas_GetGlyphRangesGreek :: proc "c" (self: ^FontAtlas) -> ^Wchar ---
	@(link_name="ImFontAtlas_GetGlyphRangesKorean") FontAtlas_GetGlyphRangesKorean :: proc "c" (self: ^FontAtlas) -> ^Wchar ---
	@(link_name="ImFontAtlas_GetGlyphRangesJapanese") FontAtlas_GetGlyphRangesJapanese :: proc "c" (self: ^FontAtlas) -> ^Wchar ---
	@(link_name="ImFontAtlas_GetGlyphRangesChineseFull") FontAtlas_GetGlyphRangesChineseFull :: proc "c" (self: ^FontAtlas) -> ^Wchar ---
	@(link_name="ImFontAtlas_GetGlyphRangesChineseSimplifiedCommon") FontAtlas_GetGlyphRangesChineseSimplifiedCommon :: proc "c" (self: ^FontAtlas) -> ^Wchar ---
	@(link_name="ImFontAtlas_GetGlyphRangesCyrillic") FontAtlas_GetGlyphRangesCyrillic :: proc "c" (self: ^FontAtlas) -> ^Wchar ---
	@(link_name="ImFontAtlas_GetGlyphRangesThai") FontAtlas_GetGlyphRangesThai :: proc "c" (self: ^FontAtlas) -> ^Wchar ---
	@(link_name="ImFontAtlas_GetGlyphRangesVietnamese") FontAtlas_GetGlyphRangesVietnamese :: proc "c" (self: ^FontAtlas) -> ^Wchar ---
	@(link_name="ImFontAtlas_AddCustomRectRegular") FontAtlas_AddCustomRectRegular :: proc "c" (self: ^FontAtlas, width: c.int, height: c.int) -> c.int ---
	@(link_name="ImFontAtlas_AddCustomRectFontGlyph") FontAtlas_AddCustomRectFontGlyph :: proc "c" (self: ^FontAtlas, font: ^Font, id: Wchar, width: c.int, height: c.int, advance_x: f32, offset: Vec2) -> c.int ---
	@(link_name="ImFontAtlas_GetCustomRectByIndex") FontAtlas_GetCustomRectByIndex :: proc "c" (self: ^FontAtlas, index: c.int) -> ^FontAtlasCustomRect ---
	@(link_name="ImFontAtlas_CalcCustomRectUV") FontAtlas_CalcCustomRectUV :: proc "c" (self: ^FontAtlas, rect: ^FontAtlasCustomRect, out_uv_min: ^Vec2, out_uv_max: ^Vec2) ---
	@(link_name="ImFontAtlas_GetMouseCursorTexData") FontAtlas_GetMouseCursorTexData :: proc "c" (self: ^FontAtlas, cursor: MouseCursor, out_offset: ^Vec2, out_size: ^Vec2, out_uv_border: ^[2]Vec2, out_uv_fill: ^[2]Vec2) -> bool ---
	@(link_name="ImFont_FindGlyph") Font_FindGlyph :: proc "c" (self: ^Font, c: Wchar) -> ^FontGlyph ---
	@(link_name="ImFont_FindGlyphNoFallback") Font_FindGlyphNoFallback :: proc "c" (self: ^Font, c: Wchar) -> ^FontGlyph ---
	@(link_name="ImFont_GetCharAdvance") Font_GetCharAdvance :: proc "c" (self: ^Font, c: Wchar) -> f32 ---
	@(link_name="ImFont_IsLoaded") Font_IsLoaded :: proc "c" (self: ^Font) -> bool ---
	@(link_name="ImFont_GetDebugName") Font_GetDebugName :: proc "c" (self: ^Font) -> cstring ---
	@(link_name="ImFont_CalcTextSizeA") Font_CalcTextSizeA :: proc "c" (self: ^Font, size: f32, max_width: f32, wrap_width: f32, text_begin: cstring) -> Vec2 ---
	@(link_name="ImFont_CalcTextSizeAEx") Font_CalcTextSizeAEx :: proc "c" (self: ^Font, size: f32, max_width: f32, wrap_width: f32, text_begin: cstring, text_end: cstring, remaining: ^cstring) -> Vec2 ---
	@(link_name="ImFont_CalcWordWrapPositionA") Font_CalcWordWrapPositionA :: proc "c" (self: ^Font, scale: f32, text: cstring, text_end: cstring, wrap_width: f32) -> cstring ---
	@(link_name="ImFont_RenderChar") Font_RenderChar :: proc "c" (self: ^Font, draw_list: ^DrawList, size: f32, pos: Vec2, col: U32, c: Wchar) ---
	@(link_name="ImFont_RenderText") Font_RenderText :: proc "c" (self: ^Font, draw_list: ^DrawList, size: f32, pos: Vec2, col: U32, clip_rect: Vec4, text_begin: cstring, text_end: cstring, wrap_width: f32, cpu_fine_clip: bool) ---
	@(link_name="ImFont_BuildLookupTable") Font_BuildLookupTable :: proc "c" (self: ^Font) ---
	@(link_name="ImFont_ClearOutputData") Font_ClearOutputData :: proc "c" (self: ^Font) ---
	@(link_name="ImFont_GrowIndex") Font_GrowIndex :: proc "c" (self: ^Font, new_size: c.int) ---
	@(link_name="ImFont_AddGlyph") Font_AddGlyph :: proc "c" (self: ^Font, src_cfg: ^FontConfig, c: Wchar, x0: f32, y0: f32, x1: f32, y1: f32, u0: f32, v0: f32, u1: f32, v1: f32, advance_x: f32) ---
	@(link_name="ImFont_AddRemapChar") Font_AddRemapChar :: proc "c" (self: ^Font, dst: Wchar, src: Wchar, overwrite_dst: bool) ---
	@(link_name="ImFont_SetGlyphVisible") Font_SetGlyphVisible :: proc "c" (self: ^Font, c: Wchar, visible: bool) ---
	@(link_name="ImFont_IsGlyphRangeUnused") Font_IsGlyphRangeUnused :: proc "c" (self: ^Font, c_begin: c.uint, c_last: c.uint) -> bool ---
	@(link_name="ImGuiViewport_GetCenter") Viewport_GetCenter :: proc "c" (self: ^Viewport) -> Vec2 ---
	@(link_name="ImGuiViewport_GetWorkCenter") Viewport_GetWorkCenter :: proc "c" (self: ^Viewport) -> Vec2 ---
	@(link_name="GetKeyIndex") GetKeyIndex :: proc "c" (key: Key) -> Key ---
	@(link_name="ImGui_PushAllowKeyboardFocus") PushAllowKeyboardFocus :: proc "c" (tab_stop: bool) ---
	@(link_name="ImGui_PopAllowKeyboardFocus") PopAllowKeyboardFocus :: proc "c" () ---
	@(link_name="ImGui_ImageButtonImTextureID") ImageButtonImTextureID :: proc "c" (user_texture_id: TextureID, size: Vec2, uv0: Vec2, uv1: Vec2, frame_padding: c.int, bg_col: Vec4, tint_col: Vec4) -> bool ---
	@(link_name="ImGui_CaptureKeyboardFromApp") CaptureKeyboardFromApp :: proc "c" (want_capture_keyboard: bool) ---
	@(link_name="ImGui_CaptureMouseFromApp") CaptureMouseFromApp :: proc "c" (want_capture_mouse: bool) ---
	@(link_name="ImGui_CalcListClipping") CalcListClipping :: proc "c" (items_count: c.int, items_height: f32, out_items_display_start: ^c.int, out_items_display_end: ^c.int) ---
	@(link_name="ImGui_GetWindowContentRegionWidth") GetWindowContentRegionWidth :: proc "c" () -> f32 ---
	@(link_name="ImGui_ListBoxHeaderInt") ListBoxHeaderInt :: proc "c" (label: cstring, items_count: c.int, height_in_items: c.int) -> bool ---
	@(link_name="ImGui_ListBoxHeader") ListBoxHeader :: proc "c" (label: cstring, size: Vec2) -> bool ---
	@(link_name="ImGui_ListBoxFooter") ListBoxFooter :: proc "c" () ---
}

////////////////////////////////////////////////////////////
// TYPEDEFS
////////////////////////////////////////////////////////////

KeyChord :: c.int
TextureID :: rawptr
DrawIdx :: c.ushort
ID :: c.uint
S8 :: c.char
U8 :: c.uchar
S16 :: c.short
U16 :: c.ushort
S32 :: c.int
U32 :: c.uint
Wchar16 :: c.ushort
Wchar32 :: c.uint
InputTextCallback :: proc "c" (data: ^InputTextCallbackData) -> c.int
SizeCallback :: proc "c" (data: ^SizeCallbackData)
MemAllocFunc :: proc "c" (sz: c.size_t, user_data: rawptr) -> rawptr
MemFreeFunc :: proc "c" (ptr: rawptr, user_data: rawptr)
DrawCallback :: proc "c" (parent_list: ^DrawList, cmd: ^DrawCmd)
Wchar :: Wchar16
