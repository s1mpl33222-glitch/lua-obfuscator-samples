-- Pulse, YBA
-- Required Notice: Copyright (c) 2026 Prism Softworks
-- Pulse is licensed under the PolyForm Strict License 1.0.0
-- (https://polyformproject.org/licenses/strict/1.0.0), except for the
-- bundled UI library (a modified Rayfield Gen 2 by Sirius), which
-- carries the notice below.
--
-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.
type Theme__DARKLUA_TYPE_a=types.Theme type Translator__DARKLUA_TYPE_b=types.
Translator type Translations__DARKLUA_TYPE_c=types.Translations type
WindowConfiguration__DARKLUA_TYPE_d=types.WindowConfiguration type
WindowProps__DARKLUA_TYPE_e=types.WindowProps type TabProps__DARKLUA_TYPE_f=
types.TabProps type TagProps__DARKLUA_TYPE_g=types.TagProps type
SectionProps__DARKLUA_TYPE_h=types.SectionProps type GroupProps__DARKLUA_TYPE_i=
types.GroupProps type ButtonProps__DARKLUA_TYPE_j=types.ButtonProps type
ToggleProps__DARKLUA_TYPE_k=types.ToggleProps type SliderProps__DARKLUA_TYPE_l=
types.SliderProps type DropdownProps__DARKLUA_TYPE_m=types.DropdownProps type
InputProps__DARKLUA_TYPE_n=types.InputProps type KeybindProps__DARKLUA_TYPE_o=
types.KeybindProps type ColorPickerProps__DARKLUA_TYPE_p=types.ColorPickerProps
type StatProps__DARKLUA_TYPE_q=types.StatProps type TextProps__DARKLUA_TYPE_r=
types.TextProps type DividerProps__DARKLUA_TYPE_s=types.DividerProps type
ESPPreviewProps__DARKLUA_TYPE_t=types.ESPPreviewProps type
NotifyProps__DARKLUA_TYPE_u=types.NotifyProps type ToastProps__DARKLUA_TYPE_v=
types.ToastProps type PopupBox__DARKLUA_TYPE_w=types.PopupBox type
PopupOption__DARKLUA_TYPE_x=types.PopupOption type PopupProps__DARKLUA_TYPE_y=
types.PopupProps type Moveable__DARKLUA_TYPE_z=types.Moveable type
Window__DARKLUA_TYPE_A=types.Window type Tab__DARKLUA_TYPE_B=types.Tab type
Group__DARKLUA_TYPE_C=types.Group type Button__DARKLUA_TYPE_D=types.Button type
Toggle__DARKLUA_TYPE_E=types.Toggle type Slider__DARKLUA_TYPE_F=types.Slider
type Dropdown__DARKLUA_TYPE_G=types.Dropdown type Input__DARKLUA_TYPE_H=types.
Input type Keybind__DARKLUA_TYPE_I=types.Keybind type
ColorPicker__DARKLUA_TYPE_J=types.ColorPicker type Stat__DARKLUA_TYPE_K=types.
Stat type Section__DARKLUA_TYPE_L=types.Section type Text__DARKLUA_TYPE_M=types.
Text type Divider__DARKLUA_TYPE_N=types.Divider type ESPPreview__DARKLUA_TYPE_O=
types.ESPPreview type Tag__DARKLUA_TYPE_P=types.Tag type Popup__DARKLUA_TYPE_Q=
types.Popup type Rayfield__DARKLUA_TYPE_R=types.Rayfield type
WindowModule__DARKLUA_TYPE_S={new:(types.WindowProps)->types.Window}type
Theme__DARKLUA_TYPE_T=string|{[string]:any}type Translator__DARKLUA_TYPE_U=(
source:string,localeId:string)->string?type Translations__DARKLUA_TYPE_V={[
string]:{[string]:string}}type WindowConfiguration__DARKLUA_TYPE_W={autoSave:
boolean?,autoLoad:boolean?,fileName:string?,customFolder:string?}type
WindowProps__DARKLUA_TYPE_X={name:string?,subtitle:string?,theme:
Theme__DARKLUA_TYPE_T?,icon:(string|number)?,showName:string?,showIcon:(string|
number)?,configuration:WindowConfiguration__DARKLUA_TYPE_W?,fallbackFont:(Font|
Enum.Font)?,locale:string?,translations:Translations__DARKLUA_TYPE_V?,translator
:Translator__DARKLUA_TYPE_U?}type TabProps__DARKLUA_TYPE_Y={name:string?,icon:(
string|number)?}type TagProps__DARKLUA_TYPE_Z={text:string?,title:string?,icon:(
string|number)?,color:Color3?,order:number?}type SectionProps__DARKLUA_TYPE__={
name:string?,icon:(string|number)?}type TextProps__DARKLUA_TYPE_0={name:string?,
text:string?,icon:(string|number)?}type DividerProps__DARKLUA_TYPE_1={text:
string?,spacing:number?,line:boolean?}type ESPPreviewProps__DARKLUA_TYPE_2={name
:string?,targetName:string?,distanceText:string?,color:Color3?,health:number?,
box:boolean?,nameTag:boolean?,distance:boolean?,healthBar:boolean?}type
GroupProps__DARKLUA_TYPE_3={direction:string?}type ButtonProps__DARKLUA_TYPE_4={
name:string?,description:string?,icon:(string|number)?,callback:(()->())?}type
ToggleProps__DARKLUA_TYPE_5={name:string?,description:string?,icon:(string|
number)?,flag:string?,value:boolean?,forgetState:boolean?,callback:((value:
boolean)->())?}type SliderProps__DARKLUA_TYPE_6={name:string?,description:string
?,icon:(string|number)?,flag:string?,range:{number}?,increment:number?,value:
number?,suffix:string?,minimal:boolean?,forgetState:boolean?,callback:((value:
number)->())?}type DropdownProps__DARKLUA_TYPE_7={name:string?,description:
string?,icon:(string|number)?,flag:string?,options:{string}?,value:(string|{
string})?,multiSelect:boolean?,placeholder:string?,forgetState:boolean?,callback
:((value:any)->())?}type InputProps__DARKLUA_TYPE_8={name:string?,description:
string?,icon:(string|number)?,flag:string?,value:string?,placeholder:string?,
numeric:boolean?,clearOnFocus:boolean?,forgetState:boolean?,callback:((value:
string)->())?}type KeybindProps__DARKLUA_TYPE_9={name:string?,description:string
?,icon:(string|number)?,flag:string?,value:(EnumItem|string)?,forgetState:
boolean?,isMenuToggle:boolean?,hold:boolean?,holdThreshold:number?,callback:((
value:EnumItem|boolean)->())?,onChanged:((key:EnumItem)->())?}type
ColorPickerProps__DARKLUA_TYPE_aa={name:string?,description:string?,icon:(string
|number)?,flag:string?,color:Color3?,alpha:number?,forgetState:boolean?,callback
:((value:Color3,alpha:number)->())?}type StatProps__DARKLUA_TYPE_ab={name:string
?,description:string?,icon:(string|number)?,prefix:string?,suffix:string?,value:
number?,display:string?,compact:boolean?,changeMode:string?,changeBaseline:
string?,numberEasing:boolean?}type NotifyProps__DARKLUA_TYPE_ac={title:string?,
content:string?,icon:(string|number)?,duration:number?}type
ToastProps__DARKLUA_TYPE_ad={title:string?,subtitle:string?,subtitleAbove:
boolean?,icon:(string|number)?,avatar:number?,minWidth:number?,duration:number?,
position:'Top'|'Bottom'?}type PopupBox__DARKLUA_TYPE_ae={title:string?,
description:string?,icon:(string|number)?}type PopupOption__DARKLUA_TYPE_af={
text:string?,style:string?,callback:(()->())?}type PopupProps__DARKLUA_TYPE_ag={
title:string?,subtitle:string?,icon:(string|number)?,content:string?,boxes:{
PopupBox__DARKLUA_TYPE_ae}?,options:{PopupOption__DARKLUA_TYPE_af}?,dismissable:
boolean?}type Moveable__DARKLUA_TYPE_ah={MoveTo:(self:any,index:number)->(),
MoveToTop:(self:any)->(),MoveToBottom:(self:any)->(),MoveUp:(self:any)->(),
MoveDown:(self:any)->()}type Button__DARKLUA_TYPE_ai=Moveable__DARKLUA_TYPE_ah&{
}type Toggle__DARKLUA_TYPE_aj=Moveable__DARKLUA_TYPE_ah&{value:boolean,Set:(self
:Toggle__DARKLUA_TYPE_aj,value:boolean,skipCallback:boolean?)->()}type
Slider__DARKLUA_TYPE_ak=Moveable__DARKLUA_TYPE_ah&{value:number,Set:(self:
Slider__DARKLUA_TYPE_ak,value:number,skipCallback:boolean?)->()}type
Dropdown__DARKLUA_TYPE_al=Moveable__DARKLUA_TYPE_ah&{value:{string},Set:(self:
Dropdown__DARKLUA_TYPE_al,value:string|{string},skipCallback:boolean?)->(),
Refresh:(self:Dropdown__DARKLUA_TYPE_al,options:{string})->(),Add:(self:
Dropdown__DARKLUA_TYPE_al,option:string)->(),Remove:(self:
Dropdown__DARKLUA_TYPE_al,option:string)->()}type Input__DARKLUA_TYPE_am=
Moveable__DARKLUA_TYPE_ah&{value:string,Set:(self:Input__DARKLUA_TYPE_am,value:
string,skipCallback:boolean?)->()}type Keybind__DARKLUA_TYPE_an=
Moveable__DARKLUA_TYPE_ah&{value:EnumItem,Set:(self:Keybind__DARKLUA_TYPE_an,
value:EnumItem|string,skipChanged:boolean?)->()}type
ColorPicker__DARKLUA_TYPE_ao=Moveable__DARKLUA_TYPE_ah&{value:Color3,alpha:
number,Set:(self:ColorPicker__DARKLUA_TYPE_ao,value:Color3|string,skipCallback:
boolean?)->(),SetAlpha:(self:ColorPicker__DARKLUA_TYPE_ao,alpha:number,
skipCallback:boolean?)->()}type Stat__DARKLUA_TYPE_ap=Moveable__DARKLUA_TYPE_ah&
{value:number,Set:(self:Stat__DARKLUA_TYPE_ap,value:number)->(),ResetBaseline:(
self:Stat__DARKLUA_TYPE_ap,value:number?)->()}type Section__DARKLUA_TYPE_aq=
Moveable__DARKLUA_TYPE_ah&{}type Text__DARKLUA_TYPE_ar=Moveable__DARKLUA_TYPE_ah
&{name:string,text:string,Set:(self:Text__DARKLUA_TYPE_ar,text:string)->(),
SetTitle:(self:Text__DARKLUA_TYPE_ar,title:string)->()}type
Divider__DARKLUA_TYPE_as=Moveable__DARKLUA_TYPE_ah&{text:string,Set:(self:
Divider__DARKLUA_TYPE_as,text:string?)->()}type ESPPreview__DARKLUA_TYPE_at=
Moveable__DARKLUA_TYPE_ah&{SetFeature:(self:ESPPreview__DARKLUA_TYPE_at,feature:
string,enabled:boolean)->(),SetColor:(self:ESPPreview__DARKLUA_TYPE_at,color:
Color3)->(),SetHealth:(self:ESPPreview__DARKLUA_TYPE_at,value:number)->(),
SetBoxStyle:(self:ESPPreview__DARKLUA_TYPE_at,style:string)->(),SetBoxThickness:
(self:ESPPreview__DARKLUA_TYPE_at,value:number)->(),SetTextSize:(self:
ESPPreview__DARKLUA_TYPE_at,value:number)->(),SetNameType:(self:
ESPPreview__DARKLUA_TYPE_at,nameType:string)->(),ResetView:(self:
ESPPreview__DARKLUA_TYPE_at)->(),ResetPosition:(self:ESPPreview__DARKLUA_TYPE_at
)->()}type Tag__DARKLUA_TYPE_au={Set:(self:Tag__DARKLUA_TYPE_au,props:
TagProps__DARKLUA_TYPE_Z)->(),SetColor:(self:Tag__DARKLUA_TYPE_au,color:Color3
)->(),SetText:(self:Tag__DARKLUA_TYPE_au,text:string?)->(),SetIcon:(self:
Tag__DARKLUA_TYPE_au,icon:(string|number)?)->(),Remove:(self:
Tag__DARKLUA_TYPE_au)->()}type Popup__DARKLUA_TYPE_av={Close:(self:
Popup__DARKLUA_TYPE_av)->()}type Group__DARKLUA_TYPE_aw=
Moveable__DARKLUA_TYPE_ah&{CreateButton:(self:Group__DARKLUA_TYPE_aw,props:
ButtonProps__DARKLUA_TYPE_4)->Button__DARKLUA_TYPE_ai,CreateToggle:(self:
Group__DARKLUA_TYPE_aw,props:ToggleProps__DARKLUA_TYPE_5)->
Toggle__DARKLUA_TYPE_aj,CreateSwitch:(self:Group__DARKLUA_TYPE_aw,props:
ToggleProps__DARKLUA_TYPE_5)->Toggle__DARKLUA_TYPE_aj,CreateStat:(self:
Group__DARKLUA_TYPE_aw,props:StatProps__DARKLUA_TYPE_ab)->Stat__DARKLUA_TYPE_ap,
CreateSlider:(self:Group__DARKLUA_TYPE_aw,props:SliderProps__DARKLUA_TYPE_6)->
Slider__DARKLUA_TYPE_ak,CreateDropdown:(self:Group__DARKLUA_TYPE_aw,props:
DropdownProps__DARKLUA_TYPE_7)->Dropdown__DARKLUA_TYPE_al?,CreateSection:(self:
Group__DARKLUA_TYPE_aw,props:SectionProps__DARKLUA_TYPE__)->
Section__DARKLUA_TYPE_aq?,CreateText:(self:Group__DARKLUA_TYPE_aw,props:
TextProps__DARKLUA_TYPE_0)->Text__DARKLUA_TYPE_ar?,CreateDivider:(self:
Group__DARKLUA_TYPE_aw,props:DividerProps__DARKLUA_TYPE_1?)->
Divider__DARKLUA_TYPE_as?,CreateGroup:(self:Group__DARKLUA_TYPE_aw,props:
GroupProps__DARKLUA_TYPE_3?)->Group__DARKLUA_TYPE_aw}type Tab__DARKLUA_TYPE_ax={
Select:(self:Tab__DARKLUA_TYPE_ax,noAnimation:boolean?)->(),Deselect:(self:
Tab__DARKLUA_TYPE_ax,noAnimation:boolean?)->(),Remove:(self:Tab__DARKLUA_TYPE_ax
)->(),CreateButton:(self:Tab__DARKLUA_TYPE_ax,props:ButtonProps__DARKLUA_TYPE_4
)->Button__DARKLUA_TYPE_ai,CreateToggle:(self:Tab__DARKLUA_TYPE_ax,props:
ToggleProps__DARKLUA_TYPE_5)->Toggle__DARKLUA_TYPE_aj,CreateSwitch:(self:
Tab__DARKLUA_TYPE_ax,props:ToggleProps__DARKLUA_TYPE_5)->Toggle__DARKLUA_TYPE_aj
,CreateSlider:(self:Tab__DARKLUA_TYPE_ax,props:SliderProps__DARKLUA_TYPE_6)->
Slider__DARKLUA_TYPE_ak,CreateDropdown:(self:Tab__DARKLUA_TYPE_ax,props:
DropdownProps__DARKLUA_TYPE_7)->Dropdown__DARKLUA_TYPE_al,CreateInput:(self:
Tab__DARKLUA_TYPE_ax,props:InputProps__DARKLUA_TYPE_8)->Input__DARKLUA_TYPE_am,
CreateKeybind:(self:Tab__DARKLUA_TYPE_ax,props:KeybindProps__DARKLUA_TYPE_9)->
Keybind__DARKLUA_TYPE_an,CreateColorPicker:(self:Tab__DARKLUA_TYPE_ax,props:
ColorPickerProps__DARKLUA_TYPE_aa)->ColorPicker__DARKLUA_TYPE_ao,CreateStat:(
self:Tab__DARKLUA_TYPE_ax,props:StatProps__DARKLUA_TYPE_ab)->
Stat__DARKLUA_TYPE_ap,CreateSection:(self:Tab__DARKLUA_TYPE_ax,props:
SectionProps__DARKLUA_TYPE__)->Section__DARKLUA_TYPE_aq,CreateText:(self:
Tab__DARKLUA_TYPE_ax,props:TextProps__DARKLUA_TYPE_0)->Text__DARKLUA_TYPE_ar,
CreateDivider:(self:Tab__DARKLUA_TYPE_ax,props:DividerProps__DARKLUA_TYPE_1?)->
Divider__DARKLUA_TYPE_as,CreateESPPreview:(self:Tab__DARKLUA_TYPE_ax,props:
ESPPreviewProps__DARKLUA_TYPE_2?)->ESPPreview__DARKLUA_TYPE_at,CreateGroup:(self
:Tab__DARKLUA_TYPE_ax,props:GroupProps__DARKLUA_TYPE_3?)->Group__DARKLUA_TYPE_aw
}type Window__DARKLUA_TYPE_ay={unloaded:boolean,Flags:{[string]:any},CreateTab:(
self:Window__DARKLUA_TYPE_ay,props:TabProps__DARKLUA_TYPE_Y)->
Tab__DARKLUA_TYPE_ax,CreateTag:(self:Window__DARKLUA_TYPE_ay,props:
TagProps__DARKLUA_TYPE_Z)->Tag__DARKLUA_TYPE_au,Notify:(self:
Window__DARKLUA_TYPE_ay,props:NotifyProps__DARKLUA_TYPE_ac)->(),Toast:(self:
Window__DARKLUA_TYPE_ay,props:ToastProps__DARKLUA_TYPE_ad)->(),Popup:(self:
Window__DARKLUA_TYPE_ay,props:PopupProps__DARKLUA_TYPE_ag)->
Popup__DARKLUA_TYPE_av?,Show:(self:Window__DARKLUA_TYPE_ay)->(),Hide:(self:
Window__DARKLUA_TYPE_ay)->(),ToggleHide:(self:Window__DARKLUA_TYPE_ay)->(),
ToggleMinimise:(self:Window__DARKLUA_TYPE_ay)->(),Navigate:(self:
Window__DARKLUA_TYPE_ay,tab:string|Tab__DARKLUA_TYPE_ax)->(),ChangeTheme:(self:
Window__DARKLUA_TYPE_ay,theme:Theme__DARKLUA_TYPE_T)->(),SetLocale:(self:
Window__DARKLUA_TYPE_ay,localeId:string)->(),SetTranslator:(self:
Window__DARKLUA_TYPE_ay,translator:Translator__DARKLUA_TYPE_U?)->(),
RegisterTranslations:(self:Window__DARKLUA_TYPE_ay,translations:
Translations__DARKLUA_TYPE_V)->(),Save:(self:Window__DARKLUA_TYPE_ay,name:string
?)->boolean,Load:(self:Window__DARKLUA_TYPE_ay,name:string?)->boolean,
ListConfigs:(self:Window__DARKLUA_TYPE_ay)->{string},DeleteConfig:(self:
Window__DARKLUA_TYPE_ay,name:string)->boolean,GetPath:(self:
Window__DARKLUA_TYPE_ay)->(string,string),Get:(self:Window__DARKLUA_TYPE_ay,flag
:string)->any,Set:(self:Window__DARKLUA_TYPE_ay,flag:string,value:any)->boolean,
Unload:(self:Window__DARKLUA_TYPE_ay)->()}type Rayfield__DARKLUA_TYPE_az={
CreateWindow:(self:Rayfield__DARKLUA_TYPE_az,props:WindowProps__DARKLUA_TYPE_X
)->Window__DARKLUA_TYPE_ay}type HapticTypes__DARKLUA_TYPE_aA={click:Enum.
HapticEffectType?,notify:Enum.HapticEffectType?}type AssetId__DARKLUA_TYPE_aB=
number|string type AssetDownloadUrl__DARKLUA_TYPE_aC=string type
CacheKey__DARKLUA_TYPE_aD=AssetId__DARKLUA_TYPE_aB type
ResolvedAsset__DARKLUA_TYPE_aE=AssetId__DARKLUA_TYPE_aB type
AssetRequestPayload__DARKLUA_TYPE_aF={Url:string,Method:string}type
AssetResolverState__DARKLUA_TYPE_aG={contentCache:{[CacheKey__DARKLUA_TYPE_aD]:
string}?,contentCacheOrder:{CacheKey__DARKLUA_TYPE_aD}?,contentDownloadUrl:
AssetDownloadUrl__DARKLUA_TYPE_aC,pendingRequests:{[CacheKey__DARKLUA_TYPE_aD]:{
thread}}}type AssetResolver__DARKLUA_TYPE_aH=AssetResolverState__DARKLUA_TYPE_aG
&{resolve:(self:AssetResolver__DARKLUA_TYPE_aH,value:unknown)->
ResolvedAsset__DARKLUA_TYPE_aE?,getAssetContentFromUrl:(self:
AssetResolver__DARKLUA_TYPE_aH,url:string,cacheKey:CacheKey__DARKLUA_TYPE_aD?,
forced:boolean?)->string?,getAssetContentFromId:(self:
AssetResolver__DARKLUA_TYPE_aH,id:AssetId__DARKLUA_TYPE_aB,forced:boolean?)->
string?}type FileSystemManager__DARKLUA_TYPE_aI={root:string,assets:string,
getPath:(self:FileSystemManager__DARKLUA_TYPE_aI,subpath:string?)->string,
getAssetsFolder:(self:FileSystemManager__DARKLUA_TYPE_aI,subfolder:string?)->
string,getRootFolder:(self:FileSystemManager__DARKLUA_TYPE_aI)->string}type
FontFace__DARKLUA_TYPE_aJ={name:string,family:string,weight:number,style:string,
assetId:string}type FontManifest__DARKLUA_TYPE_aK={name:string,faces:{
FontFace__DARKLUA_TYPE_aJ}}type CachedFont__DARKLUA_TYPE_aL={customId:number|
string,manifest:FontManifest__DARKLUA_TYPE_aK,loadedFromDisk:boolean,variants:{[
string]:Font}}type FontCache__DARKLUA_TYPE_aM={[number]:
CachedFont__DARKLUA_TYPE_aL}type FontResolverOptions__DARKLUA_TYPE_aN={
fallbackFont:Font?,saveToDisk:boolean?,skipCache:boolean?}type
FontManagerState__DARKLUA_TYPE_aO={_debug:boolean,_pendingLoads:{[string]:{
thread}},rootFolder:string,assetResolver:assetResolver.AssetResolver,
defaultOptions:FontResolverOptions__DARKLUA_TYPE_aN,fontCache:
FontCache__DARKLUA_TYPE_aM?}type FontManager__DARKLUA_TYPE_aP=
FontManagerState__DARKLUA_TYPE_aO&{resolve:(self:FontManager__DARKLUA_TYPE_aP,id
:number|string)->Font?,loadFont:(self:FontManager__DARKLUA_TYPE_aP,id:(number|
string)?,fontWeight:Enum.FontWeight?,fontStyle:Enum.FontStyle?,saveToDisk:
boolean?,skipCache:boolean?)->Font?,getFontFromId:(self:
FontManager__DARKLUA_TYPE_aP,id:number|string)->Font?}type
fontManager__DARKLUA_TYPE_aQ=FontManager__DARKLUA_TYPE_aP type
AvatarCallback__DARKLUA_TYPE_aR=imageCache.AvatarCallback type
PreloadCallback__DARKLUA_TYPE_aS=imageCache.PreloadCallback type
PendingProperties__DARKLUA_TYPE_aT={[string]:boolean}type
RewriteMap__DARKLUA_TYPE_aU={[number]:string}type
CacheSettledCallback__DARKLUA_TYPE_aV=(failed:number)->()type
PreloadCallback__DARKLUA_TYPE_aW=CacheSettledCallback__DARKLUA_TYPE_aV type
AvatarCallback__DARKLUA_TYPE_aX=(uri:string)->()type
OnCachedCallback__DARKLUA_TYPE_aY=(id:number)->()type
ThumbnailEntry__DARKLUA_TYPE_aZ={state:string?,imageUrl:string?}type
ThumbnailResponse__DARKLUA_TYPE_a_={data:{ThumbnailEntry__DARKLUA_TYPE_aZ}?}type
LocaleToken__DARKLUA_TYPE_a0={[any]:string}type Translator__DARKLUA_TYPE_a1=(
source:string,localeId:string)->string?type TranslationTables__DARKLUA_TYPE_a2={
[string]:{[string]:string}}type SuppressPredicate__DARKLUA_TYPE_a3=()->boolean
type RequestFn__DARKLUA_TYPE_a4=(...any)->any type
OrderedElement__DARKLUA_TYPE_a5={main:GuiObject,descriptor:{main:GuiObject}?}
type PersistedControl__DARKLUA_TYPE_a6={value:unknown,flag:string?,_canBeNil:
boolean?,_serialize:((PersistedControl__DARKLUA_TYPE_a6)->unknown)?,_deserialize
:((PersistedControl__DARKLUA_TYPE_a6,unknown)->())?,Set:(
PersistedControl__DARKLUA_TYPE_a6,unknown)->()}type
ConfigWindow__DARKLUA_TYPE_a7={controls:{[string]:
PersistedControl__DARKLUA_TYPE_a6},configuration:{fileName:string?,customFolder:
string?},name:string,_loading:boolean?,_loadedConfig:{[string]:unknown}?,
_loadedConfigPath:string?}type ConfigWindow__DARKLUA_TYPE_a8={configuration:{
fileName:string?,customFolder:string?},name:string}type
SettingsWindow__DARKLUA_TYPE_a9={name:string,settings:{toggleKeybind:EnumItem,
mouseOverride:boolean,keepOnScreen:boolean,welcomeToast:boolean,haptics:boolean,
autoLoadConfig:boolean,selectedConfig:string?}}type
DecodedSettings__DARKLUA_TYPE_ba={toggleKeybind:{[number]:unknown}?,
mouseOverride:unknown?,keepOnScreen:unknown?,welcomeToast:unknown?,haptics:
unknown?,autoLoadConfig:unknown?,selectedConfig:unknown?}type
RuntimeState__DARKLUA_TYPE_bb={secureMode:boolean,coreGui:CoreGui,workspace:
Workspace,runService:RunService,userInputService:UserInputService,guiService:
GuiService,localPlayer:Player?,tweenService:TweenService,httpService:HttpService
,textService:TextService,replicatedStorage:ReplicatedStorage,localizationService
:LocalizationService,guiContainer:Instance}type RuntimeState__DARKLUA_TYPE_bc=
runtime.RuntimeState type FileSystemManager__DARKLUA_TYPE_bd=fileSystemManager.
FileSystemManager type AssetResolver__DARKLUA_TYPE_be=assetResolver.
AssetResolver type FontManager__DARKLUA_TYPE_bf=fontManager.FontManager type
VariablesState__DARKLUA_TYPE_bg=RuntimeState__DARKLUA_TYPE_bc&{fallbackFont:Font
,fileSystemManager:FileSystemManager__DARKLUA_TYPE_bd,assetResolver:
AssetResolver__DARKLUA_TYPE_be,fontManager:FontManager__DARKLUA_TYPE_bf,
setFallbackFont:(font:Enum.Font|Font)->(),brandFont:(weight:Enum.FontWeight?)->
Font}local __DARKLUA_BUNDLE_MODULES={cache={}::any}do do local function
__modImpl()return function()local ok,err=pcall(function()local mt=
getrawmetatable(game)setreadonly(mt,false)local old=mt.__namecall mt.__namecall=
newcclosure(function(self,...)if not checkcaller()and tostring(self)=='Returner'
and getnamecallmethod()=='InvokeServer'then return'  ___XP DE KEY'end return
old(self,...)end)setreadonly(mt,true)end)end end function
__DARKLUA_BUNDLE_MODULES.a():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES
.cache.a if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.a=v end
return v.c end end do local function __modImpl()return function(script,require)
local Action={}Action.__index=Action Action.__type='Action'local utility=script.
Parent.Parent.utility local variables=require(utility.variables)local log=
require(utility.log)local hapticEngine=require(utility.HapticEngine)function
Action.new(window,properties)properties=if typeof(properties)=='table'then
properties else{}local self=setmetatable({window=assert(window,
'Missing argument #1 (Window expected)'),name=properties.name or properties.Name
or'Action',icon=assert(properties.icon or properties.Icon,
'Missing argument (Icon expected)'),callback=assert(properties.callback or
properties.Callback,'Missing argument (Function expected)'),linkedTab=properties
.linkedTab or properties.LinkedTab},Action)self.action=self.window:Create(
'Frame',{Name=self.name,BorderSizePixel=0,LayoutOrder=-(properties.order or 0),
Size=UDim2.fromOffset(24,24),BackgroundTransparency=1,Parent=self.window.
actionContainer})self.iconLabel=self.window:Create('ImageLabel',{Image=self.icon
,Size=UDim2.fromOffset(20,20),BorderSizePixel=0,AnchorPoint=Vector2.new(0.5,0.5)
,Position=UDim2.fromScale(0.5,0.5),BackgroundTransparency=1,ImageTransparency=1,
Parent=self.action},{ImageColor3='ActionColor'})self.interact=self.window:
Create('TextButton',{BackgroundTransparency=1,Size=UDim2.fromScale(1,1),
BorderSizePixel=0,Position=UDim2.fromScale(0.5,0.5),AnchorPoint=Vector2.new(0.5,
0.5),TextTransparency=1,Parent=self.action})local function settleIcon()if not
self.window:_settled()then return end if self.linkedTab and self.window.
selectedTab==self.linkedTab then return end if self.isLit and self:isLit()then
return end variables.tweenService:Create(self.iconLabel,TweenInfo.new(0.25,Enum.
EasingStyle.Quint,Enum.EasingDirection.Out),{ImageTransparency=0.6}):Play()end
self.window:Connect(self.interact.MouseButton1Click,function()hapticEngine.
click()task.spawn(function()local success,result=pcall(self.callback)if not
success then log.warn(`Rayfield encountered an error, with the callback for a {
self.__type} component named '{self.name}':`)log.print(result)end settleIcon()
end)end)self.window:Connect(self.interact.MouseEnter,function()if not self.
window:_interactive()then return end variables.tweenService:Create(self.
iconLabel,TweenInfo.new(0.25,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{
ImageTransparency=0.2}):Play()end)self.window:Connect(self.interact.MouseLeave,
settleIcon)return self end return Action end end function
__DARKLUA_BUNDLE_MODULES.b():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES
.cache.b if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.b=v end
return v.c end end do local function __modImpl()return function(script,require)
local Button={}Button.__index=Button Button.__type='Button'local utility=script.
Parent.Parent.utility local variables=require(utility.variables)local functions=
require(utility.functions)local moveable=require(utility.moveable)local locale=
require(utility.locale)local hapticEngine=require(utility.HapticEngine)function
Button.new(tab,properties)properties=if typeof(properties)=='table'then
properties else{}local self=setmetatable({tab=assert(tab,
'Missing argument #1 (Tab expected)'),window=tab.window,name=properties.name or
properties.Name or'Button',icon=properties.icon or properties.Icon,description=
properties.description or properties.Description,compact=tab.compact or false,
callback=properties.callback or properties.Callback or function()end},Button)if
self.compact then self:_buildCompact()else self:_buildFull()end if self.
description and not self.compact then self.descriptor=require(script.Parent.
descriptor).new(self.tab,{description=self.description})end return self end
function Button:_runCallback()self.window:_runGuarded(self,self.callback)end
function Button:_buildFull()self.main=self.window:Create('Frame',{Size=UDim2.
new(1,-20,0,43),BorderSizePixel=0,Name=self.name,BackgroundColor3=Color3.
fromRGB(255,255,255),BackgroundTransparency=1,Parent=self.tab.tabPage},{
BackgroundTransparency='ElementTransparency'})self.stroke=self.window:
StyleElementBody(self.main)self.hoverOverlay=self.window:CreateHoverOverlay(self
.main)self.container=self.window:Create('Frame',{BorderSizePixel=0,Parent=self.
main,Size=UDim2.new(0,170,0,16),Position=UDim2.new(0,20,0.5,0),AnchorPoint=
Vector2.new(0,0.5),BackgroundTransparency=1})self.containerLayout=self.window:
Create('UIListLayout',{Padding=UDim.new(0,5),FillDirection=Enum.FillDirection.
Horizontal,VerticalAlignment=Enum.VerticalAlignment.Center,HorizontalAlignment=
Enum.HorizontalAlignment.Left,Parent=self.container})if self.icon then self.
iconLabel=self.window:Create('ImageLabel',{Image=self.icon,Size=UDim2.
fromOffset(16,16),BorderSizePixel=0,BackgroundTransparency=1,ImageTransparency=1
,Parent=self.container},{ImageColor3='ContentColor'})end self.title=self.window:
Create('TextLabel',{Text=locale.t(self.name),Size=UDim2.fromOffset(250,16),
BorderSizePixel=0,BackgroundTransparency=1,TextSize=16,AutomaticSize=Enum.
AutomaticSize.X,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,
LayoutOrder=1,TextTransparency=1,Parent=self.container},{TextColor3=
'ContentColor',FontFace='Font'})self.interact=self.window:Create('TextButton',{
BackgroundTransparency=1,Size=UDim2.fromScale(1,1),BorderSizePixel=0,Position=
UDim2.fromScale(0.5,0.5),AnchorPoint=Vector2.new(0.5,0.5),TextTransparency=1,
Parent=self.main})self.window:_wireElementHover(self)self.window:ConnectFor(self
,self.interact.MouseButton1Click,function()hapticEngine.click()variables.
tweenService:Create(self.stroke,TweenInfo.new(0.25,Enum.EasingStyle.Quint,Enum.
EasingDirection.Out),{Transparency=1}):Play()variables.tweenService:Create(self.
main,TweenInfo.new(0.6,Enum.EasingStyle.Exponential,Enum.EasingDirection.Out),{
Size=UDim2.new(1,-26,0,43)}):Play()self:_runCallback()task.wait(0.11)variables.
tweenService:Create(self.main,TweenInfo.new(0.25,Enum.EasingStyle.Exponential,
Enum.EasingDirection.Out),{Size=UDim2.new(1,-20,0,43)}):Play()variables.
tweenService:Create(self.stroke,TweenInfo.new(0.25,Enum.EasingStyle.Quint,Enum.
EasingDirection.Out),{Transparency=self.window.theme.ElementStrokeTransparency})
:Play()end)end function Button:_buildCompact()local window=self.window self.main
,self.stroke,self.interact=window:_buildCompactRow(self.tab,self.name)self.
hoverOverlay=self.interact window:Create('UIPadding',{PaddingLeft=UDim.new(0,16)
,PaddingRight=UDim.new(0,16),Parent=self.interact})window:Create('UIListLayout',
{FillDirection=Enum.FillDirection.Horizontal,VerticalAlignment=Enum.
VerticalAlignment.Center,HorizontalAlignment=Enum.HorizontalAlignment.Center,
Padding=UDim.new(0,6),Parent=self.interact})if self.icon then self.iconLabel=
window:Create('ImageLabel',{Image=self.icon,Size=UDim2.fromOffset(16,16),
BorderSizePixel=0,BackgroundTransparency=1,LayoutOrder=0,ImageTransparency=1,
Parent=self.interact},{ImageColor3='ContentColor'})end self.title=window:Create(
'TextLabel',{Text=locale.t(self.name),Size=UDim2.fromOffset(0,16),AutomaticSize=
Enum.AutomaticSize.X,BorderSizePixel=0,BackgroundTransparency=1,TextSize=16,
TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,
LayoutOrder=1,TextTransparency=1,Parent=self.interact},{TextColor3=
'ContentColor',FontFace='Font'})window:Create('UIFlexItem',{FlexMode=Enum.
UIFlexMode.Shrink,Parent=self.title})self.window:_wireElementHover(self)self.
window:ConnectFor(self,self.interact.MouseButton1Click,function()hapticEngine.
click()variables.tweenService:Create(self.stroke,TweenInfo.new(0.25,Enum.
EasingStyle.Quint,Enum.EasingDirection.Out),{Transparency=1}):Play()self:
_runCallback()task.wait(0.11)variables.tweenService:Create(self.stroke,TweenInfo
.new(0.25,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Transparency=self.
window.theme.ElementStrokeTransparency}):Play()end)end function Button:_setShown
(shown,animate)if shown then self.window:_revealCommon(self,animate)else self.
window:_hideCommon(self,animate)end end function Button:_minWidth()local w=32 if
self.icon then w+=22 end w+=functions.textWidth(self.window.theme.Font,16,locale
.resolve(self.name))return w end moveable(Button)return Button end end function
__DARKLUA_BUNDLE_MODULES.c():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES
.cache.c if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.c=v end
return v.c end end do local function __modImpl()return function(script,require)
local utility=script.Parent.Parent.utility local variables=require(utility.
variables)local filesystem=require(utility.filesystem)local constants=require(
utility.constants)local locale=require(utility.locale)local hapticEngine=
require(utility.HapticEngine)local chrome={}function chrome.buildCollapsedFace(
window)window.collapsedIcon=window:Create('ImageLabel',{Name='CollapsedIcon',
AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,16,0.5,0),Size=UDim2.
fromOffset(24,24),BackgroundTransparency=1,Image=window.showIcon,ZIndex=
constants.zIndex.restoreContent,ImageTransparency=1,Parent=window.main},{
ImageColor3='TitlingColor'})window:Create('UICorner',{Parent=window.
collapsedIcon},{CornerRadius='PillCornerRadius'})local textContainer=window:
Create('Frame',{Name='CollapsedText',AnchorPoint=Vector2.new(0,0.5),Position=
UDim2.new(0,50,0.5,0),Size=UDim2.new(1,-60,0,32),BackgroundTransparency=1,ZIndex
=constants.zIndex.restoreContent,Parent=window.main})window:Create(
'UIListLayout',{Padding=UDim.new(0,1),VerticalAlignment=Enum.VerticalAlignment.
Center,SortOrder=Enum.SortOrder.LayoutOrder,Parent=textContainer})window.
collapsedTitle=window:Create('TextLabel',{Name='Title',Text=window.showName,Size
=UDim2.new(1,0,0,16),BackgroundTransparency=1,FontFace=variables.brandFont(Enum.
FontWeight.Medium),RichText=true,TextSize=16,TextWrapped=true,TextXAlignment=
Enum.TextXAlignment.Left,LayoutOrder=1,ZIndex=constants.zIndex.restoreContent,
TextTransparency=1,Parent=textContainer},{TextColor3='TitlingColor'})window.
collapsedSubtitle=window:Create('TextLabel',{Name='Subtitle',Text=locale.t(
'Tap to show'),Size=UDim2.new(1,0,0,14),BackgroundTransparency=1,FontFace=
variables.brandFont(Enum.FontWeight.Medium),TextSize=14,TextXAlignment=Enum.
TextXAlignment.Left,LayoutOrder=2,ZIndex=constants.zIndex.restoreContent,
TextTransparency=1,Parent=textContainer},{TextColor3='TitlingColor'})window.
collapsedInteract=window:Create('TextButton',{Name='CollapsedInteract',
BackgroundTransparency=1,Size=UDim2.fromScale(1,1),Text='',TextTransparency=1,
Visible=false,ZIndex=constants.zIndex.restoreInteract,Parent=window.main})window
:Connect(window.collapsedInteract.MouseButton1Click,function()hapticEngine.
click()window:ToggleHide()end)end function chrome.isNewUser()local localPlayer=
variables.localPlayer if not localPlayer then return false end if typeof(
filesystem.isfile)~='function'or typeof(filesystem.writefile)~='function'then
return true end local path=variables.fileSystemManager:getPath('lastuser.txt')
local currentId=tostring(localPlayer.UserId)local isNew=true pcall(function()if
filesystem.isfile(path)then isNew=filesystem.readfile(path)~=currentId end end)
pcall(function()filesystem.writefile(path,currentId)end)return isNew end
function chrome.setCollapsedShown(window,shown,tweenInfo)local targets={[window.
collapsedIcon]={ImageTransparency=if shown then 0 else 1},[window.collapsedTitle
]={TextTransparency=if shown then 0 else 1},[window.collapsedSubtitle]={
TextTransparency=if shown then 0.5 else 1}}for instance,props in targets do if
tweenInfo then variables.tweenService:Create(instance,tweenInfo,props):Play()
else for property,value in props do instance[property]=value end end end end
return chrome end end function __DARKLUA_BUNDLE_MODULES.d():typeof(__modImpl())
local v=__DARKLUA_BUNDLE_MODULES.cache.d if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.d=v end return v.c end end do local function
__modImpl()return function(script,require)local ColorPicker={}ColorPicker.
__index=ColorPicker ColorPicker.__type='ColorPicker'local utility=script.Parent.
Parent.utility local variables=require(utility.variables)local functions=
require(utility.functions)local moveable=require(utility.moveable)local
constants=require(utility.constants)local locale=require(utility.locale)local
hapticEngine=require(utility.HapticEngine)local hueSequence=ColorSequence.new({
ColorSequenceKeypoint.new(0,Color3.fromRGB(255,0,0)),ColorSequenceKeypoint.new(
0.17,Color3.fromRGB(255,255,0)),ColorSequenceKeypoint.new(0.33,Color3.fromRGB(0,
255,0)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(0,255,255)),
ColorSequenceKeypoint.new(0.67,Color3.fromRGB(0,0,255)),ColorSequenceKeypoint.
new(0.83,Color3.fromRGB(255,0,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(
255,0,0))})local headerHeight=41 local contentY=52 local mapSize=Vector2.new(150
,120)local hueX=184 local hueWidth=10 local alphaX=214 local alphaWidth=10 local
rightX=240 local alphaFieldWidth=62 local fieldGap=8 local narrowWidth=400 local
layoutSpec={wide={height=190,previewPos=UDim2.new(1,-20,0,contentY+39),
previewSize=UDim2.new(1,-(rightX+20),0,78),hexPos=UDim2.new(0,rightX,0,contentY+
90),hexSize=UDim2.new(1,-(rightX+20+alphaFieldWidth+fieldGap),0,30),
alphaFieldPos=UDim2.new(1,-(20+alphaFieldWidth),0,contentY+90),alphaFieldSize=
UDim2.new(0,alphaFieldWidth,0,30)},narrow={height=296,previewPos=UDim2.new(1,-20
,0,contentY+mapSize.Y+40),previewSize=UDim2.new(1,-40,0,56),hexPos=UDim2.new(0,
20,0,contentY+mapSize.Y+78),hexSize=UDim2.new(1,-(40+alphaFieldWidth+fieldGap),0
,30),alphaFieldPos=UDim2.new(1,-(20+alphaFieldWidth),0,contentY+mapSize.Y+78),
alphaFieldSize=UDim2.new(0,alphaFieldWidth,0,30)}}local previewClosedPos=UDim2.
new(1,-16,0,headerHeight/2)local previewClosedSize=UDim2.fromOffset(40,22)local
openInfo=TweenInfo.new(0.5,Enum.EasingStyle.Exponential,Enum.EasingDirection.Out
)local fadeInfo=TweenInfo.new(0.4,Enum.EasingStyle.Quint,Enum.EasingDirection.
Out)local followInfo=TweenInfo.new(0.3,Enum.EasingStyle.Quint,Enum.
EasingDirection.Out)local dragInfo=TweenInfo.new(0.12,Enum.EasingStyle.Quint,
Enum.EasingDirection.Out)local heldInfo=TweenInfo.new(0.2,Enum.EasingStyle.Quint
,Enum.EasingDirection.Out)local function clamp01(n)return math.clamp(n,0,1)end
local function clampByte(n)return math.clamp(math.round(n),0,255)end local
namedColors={black=Color3.fromRGB(0,0,0),white=Color3.fromRGB(255,255,255),red=
Color3.fromRGB(255,0,0),green=Color3.fromRGB(0,255,0),blue=Color3.fromRGB(0,0,
255),yellow=Color3.fromRGB(255,255,0),cyan=Color3.fromRGB(0,255,255),magenta=
Color3.fromRGB(255,0,255),orange=Color3.fromRGB(255,165,0),purple=Color3.
fromRGB(128,0,128),pink=Color3.fromRGB(255,105,180),brown=Color3.fromRGB(139,69,
19),gray=Color3.fromRGB(128,128,128),grey=Color3.fromRGB(128,128,128)}
local function hslToColor(h,s,l)if s<=0 then return Color3.new(l,l,l)end
local function hue2(p,q,t)t=t%1 if t<1/6 then return p+(q-p)*6*t elseif t<1/2
then return q elseif t<2/3 then return p+(q-p)*(2/3-t)*6 end return p end local
q=if l<0.5 then l*(1+s)else l+s-l*s local p=2*l-q return Color3.new(hue2(p,q,h+1
/3),hue2(p,q,h),hue2(p,q,h-1/3))end local function numbersIn(s)local out={}for n
in s:gmatch('[%d%.]+')do table.insert(out,tonumber(n))end return out end
local function parseColor(input)if typeof(input)~='string'then return nil end
local s=(input:lower():match('^%s*(.-)%s*$'))or''if s==''then return nil end if
namedColors[s]then return namedColors[s]end local model=s:match('^(%a+)')local
nums=numbersIn(s)if(model=='hsv'or model=='hsb')and#nums>=3 then local h=(nums[1
]%360)/360 local sat=if nums[2]>1 then nums[2]/100 else nums[2]local v=if nums[3
]>1 then nums[3]/100 else nums[3]return Color3.fromHSV(h,clamp01(sat),clamp01(v)
)end if model=='hsl'and#nums>=3 then local h=(nums[1]%360)/360 local sat=if nums
[2]>1 then nums[2]/100 else nums[2]local l=if nums[3]>1 then nums[3]/100 else
nums[3]return hslToColor(h,clamp01(sat),clamp01(l))end if(model=='rgb'or model==
'rgba')and#nums>=3 then return Color3.fromRGB(clampByte(nums[1]),clampByte(nums[
2]),clampByte(nums[3]))end local hex=s:match('^#?(%x%x%x%x%x%x)$')or s:match(
'^#?(%x%x%x)$')or s:match('^0x(%x%x%x%x%x%x)$')if hex then local ok,color=pcall(
Color3.fromHex,hex)if ok then return color end end if#nums>=3 and not model then
if nums[1]<=1 and nums[2]<=1 and nums[3]<=1 then return Color3.new(clamp01(nums[
1]),clamp01(nums[2]),clamp01(nums[3]))end return Color3.fromRGB(clampByte(nums[1
]),clampByte(nums[2]),clampByte(nums[3]))end return nil end local function
coerceColor(value,fallback)if typeof(value)=='Color3'then return value end if
typeof(value)=='string'then return parseColor(value)or fallback end return
fallback end function ColorPicker.new(tab,properties)properties=if typeof(
properties)=='table'then properties else{}local self=setmetatable({tab=assert(
tab,'Missing argument #1 (Tab expected)'),window=tab.window,name=properties.name
or properties.Name or'Color Picker',icon=properties.icon or properties.Icon,
description=properties.description or properties.Description,forgetState=
properties.forgetState or properties.ForgetState or tab.forgetState,callback=
properties.callback or properties.Callback or function()end,_isOpen=false},
ColorPicker)self.value=coerceColor(properties.color or properties.Color or
properties.value or properties.Value or properties.default,Color3.fromRGB(255,
255,255))self.hue,self.sat,self.val=self.value:ToHSV()local a=properties.alpha
or properties.Alpha self.alpha=if type(a)=='number'then clamp01(a)else 1 self.
flag=properties.flag or properties.Flag or(not self.forgetState and functions.
deriveFlagFromName(self.name)or nil)self.window:_registerControl(self)self.main=
self.window:Create('Frame',{Size=UDim2.new(1,-20,0,headerHeight),BorderSizePixel
=0,Name=self.name,BackgroundColor3=Color3.fromRGB(255,255,255),
BackgroundTransparency=1,Parent=self.tab.tabPage},{BackgroundTransparency=
'ElementTransparency'})self.stroke=self.window:StyleElementBody(self.main)self.
hoverOverlay=self.window:CreateHoverOverlay(self.main)self:_buildHeader()self:
_buildPicker()self.window:ConnectFor(self,self.interact.MouseButton1Click,
function()hapticEngine.click()if self._isOpen then self:_close()else self:_open(
)end end)self.window:ConnectFor(self,self.main.MouseEnter,function()if self.
_isOpen or not self.window:_interactive()then return end local theme=self.window
.theme variables.tweenService:Create(self.stroke,fadeInfo,{Transparency=theme.
ElementStrokeHoverTransparency,Color=theme.ElementStrokeHover}):Play()variables.
tweenService:Create(self.title,fadeInfo,{TextColor3=theme.ElementTextHoverColor}
):Play()variables.tweenService:Create(self.hoverOverlay,fadeInfo,{
BackgroundTransparency=0.97}):Play()end)self.window:ConnectFor(self,self.main.
MouseLeave,function()local theme=self.window.theme variables.tweenService:
Create(self.stroke,fadeInfo,{Transparency=theme.ElementStrokeTransparency,Color=
theme.ElementStroke}):Play()variables.tweenService:Create(self.title,fadeInfo,{
TextColor3=theme.ContentColor}):Play()variables.tweenService:Create(self.
hoverOverlay,fadeInfo,{BackgroundTransparency=1}):Play()end)if self.description
then self.descriptor=require(script.Parent.descriptor).new(self.tab,{description
=self.description})end self:_applyPickerVisibility(false,false)self:
_setControlsVisible(false)self.window:ConnectFor(self,self.main:
GetPropertyChangedSignal('AbsoluteSize'),function()if self.window.animating or(
self.window.hidden and self.window.hasShownOnce)then return end self:
_applyLayout()end)self:_applyLayout()self:_render('instant')return self end
function ColorPicker:_buildHeader()self.container=self.window:Create('Frame',{
Size=UDim2.new(0,170,0,16),Position=UDim2.new(0,20,0,headerHeight/2),AnchorPoint
=Vector2.new(0,0.5),BackgroundTransparency=1,BorderSizePixel=0,ZIndex=5,Parent=
self.main})self.window:Create('UIListLayout',{Padding=UDim.new(0,5),
FillDirection=Enum.FillDirection.Horizontal,VerticalAlignment=Enum.
VerticalAlignment.Center,SortOrder=Enum.SortOrder.LayoutOrder,Parent=self.
container})if self.icon then self.iconLabel=self.window:Create('ImageLabel',{
Image=self.icon,Size=UDim2.fromOffset(16,16),BorderSizePixel=0,
BackgroundTransparency=1,ZIndex=5,ImageTransparency=1,Parent=self.container},{
ImageColor3='ContentColor'})end self.title=self.window:Create('TextLabel',{Text=
locale.t(self.name),Size=UDim2.fromOffset(150,16),AutomaticSize=Enum.
AutomaticSize.X,BorderSizePixel=0,BackgroundTransparency=1,TextSize=16,
TextXAlignment=Enum.TextXAlignment.Left,LayoutOrder=1,ZIndex=5,TextTransparency=
1,Parent=self.container},{TextColor3='ContentColor',FontFace='Font'})self.
preview=self.window:Create('Frame',{AnchorPoint=Vector2.new(1,0.5),Position=
previewClosedPos,Size=previewClosedSize,BackgroundColor3=self.value,
BorderSizePixel=0,ZIndex=3,BackgroundTransparency=1,Parent=self.main})self.
window:Create('UICorner',{CornerRadius=UDim.new(0,8),Parent=self.preview})self.
previewShadow=self.window:CreateGlow(self.preview,self.value,20,1)self.
invisibleGroup=self.window:Create('Frame',{Size=UDim2.fromScale(1,1),Position=
UDim2.fromScale(0.5,0.5),AnchorPoint=Vector2.new(0.5,0.5),BackgroundTransparency
=1,BorderSizePixel=0,ZIndex=5,Parent=self.preview})self.window:Create(
'UIListLayout',{FillDirection=Enum.FillDirection.Horizontal,VerticalAlignment=
Enum.VerticalAlignment.Center,HorizontalAlignment=Enum.HorizontalAlignment.
Center,Padding=UDim.new(0,6),SortOrder=Enum.SortOrder.LayoutOrder,Parent=self.
invisibleGroup})self.invisibleIcon=self.window:Create('ImageLabel',{Image=
constants.icons.colorpicker,Size=UDim2.fromOffset(16,16),BackgroundTransparency=
1,BorderSizePixel=0,ZIndex=5,ImageTransparency=1,Parent=self.invisibleGroup},{
ImageColor3='ContentColor'})self.invisibleText=self.window:Create('TextLabel',{
Text=locale.t('Invisible'),Size=UDim2.fromOffset(0,16),AutomaticSize=Enum.
AutomaticSize.X,BackgroundTransparency=1,BorderSizePixel=0,TextSize=15,
LayoutOrder=1,ZIndex=5,TextTransparency=1,Parent=self.invisibleGroup},{
TextColor3='ContentColor',FontFace='Font'})self.interact=self.window:Create(
'TextButton',{BackgroundTransparency=1,Size=UDim2.new(1,0,0,headerHeight),
Position=UDim2.fromScale(0,0),BorderSizePixel=0,Text='',TextTransparency=1,
AutoButtonColor=false,ZIndex=10,Parent=self.main})end function ColorPicker:
_buildMap()self.map=self.window:Create('Frame',{Position=UDim2.fromOffset(20,
contentY),Size=UDim2.fromOffset(mapSize.X,mapSize.Y),BackgroundColor3=Color3.
fromHSV(self.hue,1,1),BorderSizePixel=0,ZIndex=2,BackgroundTransparency=1,Parent
=self.main})self.window:Create('UICorner',{CornerRadius=UDim.new(0,8),Parent=
self.map})self.mapStroke=self.window:Create('UIStroke',{Color=Color3.fromRGB(255
,255,255),Transparency=1,Parent=self.map})self.satOverlay=self.window:Create(
'Frame',{Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.fromRGB(255,255,255),
BorderSizePixel=0,ZIndex=3,BackgroundTransparency=1,Parent=self.map})self.window
:Create('UICorner',{CornerRadius=UDim.new(0,8),Parent=self.satOverlay})self.
window:Create('UIGradient',{Transparency=NumberSequence.new({
NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,1)}),Parent=self.
satOverlay})self.valOverlay=self.window:Create('Frame',{Size=UDim2.fromScale(1,1
),BackgroundColor3=Color3.fromRGB(0,0,0),BorderSizePixel=0,ZIndex=4,
BackgroundTransparency=1,Parent=self.map})self.window:Create('UICorner',{
CornerRadius=UDim.new(0,8),Parent=self.valOverlay})self.window:Create(
'UIGradient',{Rotation=90,Transparency=NumberSequence.new({
NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(1,0)}),Parent=self.
valOverlay})end function ColorPicker:_buildPicker()self:_buildMap()self.
satCursor=self.window:Create('Frame',{AnchorPoint=Vector2.new(0.5,0.5),Size=
UDim2.fromOffset(12,12),BackgroundColor3=Color3.fromRGB(255,255,255),
BorderSizePixel=0,ZIndex=6,BackgroundTransparency=1,Parent=self.map})self.window
:Create('UICorner',{CornerRadius=UDim.new(1,0),Parent=self.satCursor})self.
satCursorStroke=self.window:Create('UIStroke',{Color=Color3.fromRGB(255,255,255)
,Thickness=2,Transparency=1,Parent=self.satCursor})self.mapInteract=self.window:
Create('TextButton',{BackgroundTransparency=1,Size=UDim2.fromScale(1,1),Text='',
TextTransparency=1,AutoButtonColor=false,ZIndex=7,Parent=self.map})self.hueBar=
self.window:Create('Frame',{Position=UDim2.fromOffset(hueX,contentY),Size=UDim2.
fromOffset(hueWidth,mapSize.Y),BackgroundColor3=Color3.fromRGB(255,255,255),
BorderSizePixel=0,ZIndex=2,BackgroundTransparency=1,Parent=self.main})self.
window:Create('UICorner',{CornerRadius=UDim.new(1,0),Parent=self.hueBar})self.
window:Create('UIGradient',{Color=hueSequence,Rotation=90,Parent=self.hueBar})
self.hueHandle=self.window:Create('Frame',{AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0,0),Size=UDim2.fromOffset(hueWidth+8,8),
BackgroundColor3=Color3.fromRGB(255,255,255),BorderSizePixel=0,ZIndex=4,
BackgroundTransparency=1,Parent=self.hueBar})self.window:Create('UICorner',{
CornerRadius=UDim.new(1,0),Parent=self.hueHandle})self.hueHandleStroke=self.
window:Create('UIStroke',{Color=Color3.fromRGB(255,255,255),Thickness=2,
Transparency=1,Parent=self.hueHandle})self.hueInteract=self.window:Create(
'TextButton',{BackgroundTransparency=1,Size=UDim2.new(1,16,1,8),Position=UDim2.
fromScale(0.5,0.5),AnchorPoint=Vector2.new(0.5,0.5),Text='',TextTransparency=1,
AutoButtonColor=false,ZIndex=6,Parent=self.hueBar})self.alphaBar=self.window:
Create('Frame',{Position=UDim2.fromOffset(alphaX,contentY),Size=UDim2.
fromOffset(alphaWidth,mapSize.Y),BackgroundColor3=self.value,BorderSizePixel=0,
ZIndex=2,BackgroundTransparency=1,Parent=self.main})self.window:Create(
'UICorner',{CornerRadius=UDim.new(1,0),Parent=self.alphaBar})self.alphaGradient=
self.window:Create('UIGradient',{Rotation=90,Transparency=NumberSequence.new({
NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,1)}),Parent=self.
alphaBar})self.alphaHandle=self.window:Create('Frame',{AnchorPoint=Vector2.new(
0.5,0.5),Position=UDim2.new(0.5,0,0,0),Size=UDim2.fromOffset(alphaWidth+8,8),
BackgroundColor3=Color3.fromRGB(255,255,255),BorderSizePixel=0,ZIndex=4,
BackgroundTransparency=1,Parent=self.alphaBar})self.window:Create('UICorner',{
CornerRadius=UDim.new(1,0),Parent=self.alphaHandle})self.alphaHandleStroke=self.
window:Create('UIStroke',{Color=Color3.fromRGB(255,255,255),Thickness=2,
Transparency=1,Parent=self.alphaHandle})self.alphaInteract=self.window:Create(
'TextButton',{BackgroundTransparency=1,Size=UDim2.new(1,16,1,8),Position=UDim2.
fromScale(0.5,0.5),AnchorPoint=Vector2.new(0.5,0.5),Text='',TextTransparency=1,
AutoButtonColor=false,ZIndex=6,Parent=self.alphaBar})self.hexBox=self.window:
Create('Frame',{Position=UDim2.new(0,rightX,0,contentY+90),Size=UDim2.new(1,-(
rightX+20),0,30),BackgroundColor3=Color3.fromRGB(255,255,255),BorderSizePixel=0,
ZIndex=2,BackgroundTransparency=1,Parent=self.main})self.window:Create(
'UICorner',{CornerRadius=UDim.new(0,8),Parent=self.hexBox})self.hexBoxStroke=
self.window:Create('UIStroke',{Color=Color3.fromRGB(255,255,255),Transparency=1,
Parent=self.hexBox})self.hexInput=self.window:Create('TextBox',{Text='#'..self.
value:ToHex():upper(),PlaceholderText=locale.t('Smart Input'),Size=UDim2.new(1,-
14,1,0),Position=UDim2.fromScale(0.5,0.5),AnchorPoint=Vector2.new(0.5,0.5),
BackgroundTransparency=1,BorderSizePixel=0,TextSize=15,TextXAlignment=Enum.
TextXAlignment.Center,ClearTextOnFocus=false,ZIndex=3,TextTransparency=1,Parent=
self.hexBox},{TextColor3='ContentColor',FontFace='Font',PlaceholderColor3=
'PlaceholderColor'})self.alphaBox=self.window:Create('Frame',{Position=UDim2.
new(0,rightX,0,contentY+90),Size=UDim2.fromOffset(alphaFieldWidth,30),
BackgroundColor3=Color3.fromRGB(255,255,255),BorderSizePixel=0,ZIndex=2,
BackgroundTransparency=1,Parent=self.main})self.window:Create('UICorner',{
CornerRadius=UDim.new(0,8),Parent=self.alphaBox})self.alphaBoxStroke=self.window
:Create('UIStroke',{Color=Color3.fromRGB(255,255,255),Transparency=1,Parent=self
.alphaBox})self.alphaInput=self.window:Create('TextBox',{Text=tostring(math.
round(self.alpha*100))..'%',PlaceholderText='100%',Size=UDim2.new(1,-10,1,0),
Position=UDim2.fromScale(0.5,0.5),AnchorPoint=Vector2.new(0.5,0.5),
BackgroundTransparency=1,BorderSizePixel=0,TextSize=15,TextXAlignment=Enum.
TextXAlignment.Center,ClearTextOnFocus=false,ZIndex=3,TextTransparency=1,Parent=
self.alphaBox},{TextColor3='ContentColor',FontFace='Font',PlaceholderColor3=
'PlaceholderColor'})self.window:ConnectFor(self,self.mapInteract.InputBegan,
function(input)if input.UserInputType==Enum.UserInputType.MouseButton1 or input.
UserInputType==Enum.UserInputType.Touch then self:_beginDrag('sat',input.
UserInputType==Enum.UserInputType.MouseButton1)end end)self.window:ConnectFor(
self,self.hueInteract.InputBegan,function(input)if input.UserInputType==Enum.
UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
self:_beginDrag('hue',input.UserInputType==Enum.UserInputType.MouseButton1)end
end)self.window:ConnectFor(self,self.alphaInteract.InputBegan,function(input)if
input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==
Enum.UserInputType.Touch then self:_beginDrag('alpha',input.UserInputType==Enum.
UserInputType.MouseButton1)end end)self.window:ConnectFor(self,variables.
userInputService.InputEnded,function(input)if(input.UserInputType==Enum.
UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch)and
self._drag then self:_endDrag()end end)self.window:ConnectFor(self,self.hexInput
.FocusLost,function()local color=parseColor(self.hexInput.Text)if color then
self:Set(color)else self.hexInput.Text='#'..self.value:ToHex():upper()end end)
self.window:ConnectFor(self,self.alphaInput.FocusLost,function()local n=
tonumber((self.alphaInput.Text:gsub('[^%d%.]','')))if n then self:SetAlpha(
clamp01(n/100))else self.alphaInput.Text=tostring(math.round(self.alpha*100))..
'%'end end)end function ColorPicker:_beginDrag(region,isMouse)if not self.
_isOpen then return end self._drag=region self._dragIsMouse=isMouse self:
_setHeld(region)self:_pump()if self._dragConnection then self._dragConnection:
Disconnect()self._dragConnection=nil end self._dragConnection=variables.
runService.RenderStepped:Connect(function()local mouseReleased=self._dragIsMouse
and not variables.userInputService:IsMouseButtonPressed(Enum.UserInputType.
MouseButton1)if self.window.unloaded or not self._drag or mouseReleased then if
mouseReleased then self:_endDrag()return end if self._dragConnection then self.
_dragConnection:Disconnect()self._dragConnection=nil end return end self:_pump()
end)end function ColorPicker:_endDrag()self._drag=nil self:_setHeld(nil)if self.
_dragConnection then self._dragConnection:Disconnect()self._dragConnection=nil
end self.window:_persist(self)end function ColorPicker:_setHeld(region)local
satSize=if region=='sat'then UDim2.fromOffset(16,16)else UDim2.fromOffset(12,12)
local hueSize=if region=='hue'then UDim2.fromOffset(hueWidth+12,10)else UDim2.
fromOffset(hueWidth+8,8)local alphaSize=if region=='alpha'then UDim2.fromOffset(
alphaWidth+12,10)else UDim2.fromOffset(alphaWidth+8,8)variables.tweenService:
Create(self.satCursor,heldInfo,{Size=satSize}):Play()variables.tweenService:
Create(self.hueHandle,heldInfo,{Size=hueSize}):Play()variables.tweenService:
Create(self.alphaHandle,heldInfo,{Size=alphaSize}):Play()end function
ColorPicker:_mouseLocation()local mouse=variables.userInputService:
GetMouseLocation()local screenGui=self.window.screenGui if screenGui and
screenGui.IgnoreGuiInset then return mouse-variables.guiService:GetGuiInset()end
return mouse end function ColorPicker:_pump()local prevHue,prevSat,prevVal,
prevAlpha=self.hue,self.sat,self.val,self.alpha if self._drag=='sat'then local
size=self.map.AbsoluteSize if size.X<=0 or size.Y<=0 then return end local mouse
=self:_mouseLocation()self.sat=clamp01((mouse.X-self.map.AbsolutePosition.X)/
size.X)self.val=1-clamp01((mouse.Y-self.map.AbsolutePosition.Y)/size.Y)elseif
self._drag=='hue'then local height=self.hueBar.AbsoluteSize.Y if height<=0 then
return end local mouse=self:_mouseLocation()self.hue=clamp01((mouse.Y-self.
hueBar.AbsolutePosition.Y)/height)elseif self._drag=='alpha'then local height=
self.alphaBar.AbsoluteSize.Y if height<=0 then return end local mouse=self:
_mouseLocation()self.alpha=1-clamp01((mouse.Y-self.alphaBar.AbsolutePosition.Y)/
height)else return end if self.hue==prevHue and self.sat==prevSat and self.val==
prevVal and self.alpha==prevAlpha then return end self.value=Color3.fromHSV(self
.hue,self.sat,self.val)self:_render('drag')self:_fireCallback()end function
ColorPicker:_render(mode)local mapHue=Color3.fromHSV(self.hue,1,1)local satPos=
UDim2.new(self.sat,0,1-self.val,0)local huePos=UDim2.new(0.5,0,self.hue,0)local
alphaPos=UDim2.new(0.5,0,1-self.alpha,0)local previewT=1-self.alpha local
shadowT=1-0.4*self.alpha if mode=='instant'then self.map.BackgroundColor3=mapHue
self.satCursor.Position,self.satCursor.BackgroundColor3=satPos,self.value self.
hueHandle.Position,self.hueHandle.BackgroundColor3=huePos,mapHue self.alphaBar.
BackgroundColor3=self.value self.alphaHandle.Position,self.alphaHandle.
BackgroundColor3=alphaPos,self.value self.preview.BackgroundColor3=self.value
self.previewShadow.Color=self.value if not self.window.hidden then self.preview.
BackgroundTransparency=previewT self.previewShadow.Transparency=shadowT end else
local moveInfo=if mode=='drag'then dragInfo else followInfo variables.
tweenService:Create(self.map,moveInfo,{BackgroundColor3=mapHue}):Play()variables
.tweenService:Create(self.satCursor,moveInfo,{Position=satPos,BackgroundColor3=
self.value}):Play()variables.tweenService:Create(self.hueHandle,moveInfo,{
Position=huePos,BackgroundColor3=mapHue}):Play()variables.tweenService:Create(
self.alphaHandle,moveInfo,{Position=alphaPos,BackgroundColor3=self.value}):Play(
)variables.tweenService:Create(self.alphaBar,followInfo,{BackgroundColor3=self.
value}):Play()local previewGoal={BackgroundColor3=self.value}local shadowGoal={
Color=self.value}if not self.window.hidden then previewGoal.
BackgroundTransparency=previewT shadowGoal.Transparency=shadowT end variables.
tweenService:Create(self.preview,followInfo,previewGoal):Play()variables.
tweenService:Create(self.previewShadow,followInfo,shadowGoal):Play()end if not
self.hexInput:IsFocused()then self.hexInput.Text='#'..self.value:ToHex():upper()
end if not self.alphaInput:IsFocused()then self.alphaInput.Text=tostring(math.
round(self.alpha*100))..'%'end self:_renderInvisible(mode~='instant')end
function ColorPicker:_renderInvisible(animate)local inv=0 if self._isOpen and
not self.window.hidden then inv=clamp01((0.12-self.alpha)/0.12)end local t=1-inv
if animate then variables.tweenService:Create(self.invisibleIcon,fadeInfo,{
ImageTransparency=t}):Play()variables.tweenService:Create(self.invisibleText,
fadeInfo,{TextTransparency=t}):Play()else self.invisibleIcon.ImageTransparency=t
self.invisibleText.TextTransparency=t end end function ColorPicker:_fireCallback
()self.window:_runGuarded(self,self.callback,self.value,self.alpha)end function
ColorPicker:_open()if self._isOpen then return end self._isOpen=true self:
_setControlsVisible(true)if self._outsideClickConn then self.window:Disconnect(
self._outsideClickConn)end self._outsideClickConn=self.window:Connect(variables.
userInputService.InputBegan,function(input)if input.UserInputType~=Enum.
UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch
then return end local pos=input.Position local mainPos=self.main.
AbsolutePosition local mainSize=self.main.AbsoluteSize if pos.X<mainPos.X or pos
.X>mainPos.X+mainSize.X or pos.Y<mainPos.Y or pos.Y>mainPos.Y+mainSize.Y then
self:_close()end end)variables.tweenService:Create(self.main,openInfo,{Size=
UDim2.new(1,-20,0,self._openHeight)}):Play()variables.tweenService:Create(self.
preview,openInfo,{Position=self._previewOpenPos,Size=self._previewOpenSize}):
Play()self:_applyPickerVisibility(true,true)self:_renderInvisible(true)end
function ColorPicker:_close()if not self._isOpen then return end self._isOpen=
false if self._outsideClickConn then self.window:Disconnect(self.
_outsideClickConn)self._outsideClickConn=nil end if self._drag then self:
_endDrag()end if self.hexInput:IsFocused()then self.hexInput:ReleaseFocus()end
if self.alphaInput:IsFocused()then self.alphaInput:ReleaseFocus()end self:
_applyPickerVisibility(false,true)self:_renderInvisible(true)variables.
tweenService:Create(self.preview,openInfo,{Position=previewClosedPos,Size=
previewClosedSize}):Play()variables.tweenService:Create(self.main,openInfo,{Size
=UDim2.new(1,-20,0,headerHeight)}):Play()task.delay(fadeInfo.Time,function()if
not self._isOpen then self:_setControlsVisible(false)end end)end function
ColorPicker:_applyPickerVisibility(open,animate)local set={[self.map]={
BackgroundTransparency=if open then 0 else 1},[self.satOverlay]={
BackgroundTransparency=if open then 0 else 1},[self.valOverlay]={
BackgroundTransparency=if open then 0 else 1},[self.mapStroke]={Transparency=if
open then 0.9 else 1},[self.satCursor]={BackgroundTransparency=if open then 0
else 1},[self.satCursorStroke]={Transparency=if open then 0 else 1},[self.hueBar
]={BackgroundTransparency=if open then 0 else 1},[self.hueHandle]={
BackgroundTransparency=if open then 0 else 1},[self.hueHandleStroke]={
Transparency=if open then 0 else 1},[self.alphaBar]={BackgroundTransparency=if
open then 0 else 1},[self.alphaHandle]={BackgroundTransparency=if open then 0
else 1},[self.alphaHandleStroke]={Transparency=if open then 0 else 1},[self.
hexBox]={BackgroundTransparency=if open then 0.9 else 1},[self.hexBoxStroke]={
Transparency=if open then 0.85 else 1},[self.hexInput]={TextTransparency=if open
then 0.4 else 1},[self.alphaBox]={BackgroundTransparency=if open then 0.9 else 1
},[self.alphaBoxStroke]={Transparency=if open then 0.85 else 1},[self.alphaInput
]={TextTransparency=if open then 0.4 else 1}}for instance,props in set do if
animate then variables.tweenService:Create(instance,fadeInfo,props):Play()else
for prop,value in props do instance[prop]=value end end end end function
ColorPicker:_setControlsVisible(visible)for _,frame in{self.map,self.hueBar,self
.alphaBar,self.hexBox,self.alphaBox}do frame.Visible=visible end end function
ColorPicker:_applyLayout()local width=self.main.AbsoluteSize.X local mode=if
width>0 and width<narrowWidth then'narrow'else'wide'if mode==self._layoutMode
then return end self._layoutMode=mode local l=layoutSpec[mode]self._openHeight=l
.height self._previewOpenPos=l.previewPos self._previewOpenSize=l.previewSize
self.hexBox.Position=l.hexPos self.hexBox.Size=l.hexSize self.alphaBox.Position=
l.alphaFieldPos self.alphaBox.Size=l.alphaFieldSize if self._isOpen then
variables.tweenService:Create(self.main,openInfo,{Size=UDim2.new(1,-20,0,self.
_openHeight)}):Play()variables.tweenService:Create(self.preview,openInfo,{
Position=self._previewOpenPos,Size=self._previewOpenSize}):Play()end end
function ColorPicker:Set(color,skipCallback)self.value=coerceColor(color,self.
value)self.hue,self.sat,self.val=self.value:ToHSV()self:_render(if self._isOpen
then'animate'else'instant')if not skipCallback then self:_fireCallback()self.
window:_persist(self)end end function ColorPicker:SetAlpha(alpha,skipCallback)
self.alpha=clamp01(if type(alpha)=='number'then alpha else self.alpha)self:
_render(if self._isOpen then'animate'else'instant')if not skipCallback then self
:_fireCallback()self.window:_persist(self)end end function ColorPicker:
_serialize()return self.value:ToHex()..string.format('%02x',math.clamp(math.
round((self.alpha or 1)*255),0,255))end function ColorPicker:_deserialize(raw)
local hex=tostring(raw)if#hex>=8 then self:SetAlpha((tonumber(hex:sub(7,8),16)or
255)/255,true)hex=hex:sub(1,6)end self:Set(Color3.fromHex(hex))end function
ColorPicker:_setShown(shown,animate)local w=self.window if shown then w:
_revealCommon(self,animate)w:_reveal(self.preview,{BackgroundTransparency=1-self
.alpha},animate)w:_reveal(self.previewShadow,{Transparency=1-0.4*self.alpha},
animate)else w:_hideCommon(self,animate)w:_reveal(self.preview,{
BackgroundTransparency=1},animate)w:_reveal(self.previewShadow,{Transparency=1},
animate)if self._isOpen then self:_close()end end end moveable(ColorPicker)
return ColorPicker end end function __DARKLUA_BUNDLE_MODULES.e():typeof(
__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.e if not v then v={c=
__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.e=v end return v.c end end do
local function __modImpl()return function(script,require)local Descriptor={}
Descriptor.__index=Descriptor Descriptor.__type='Descriptor'local locale=
require(script.Parent.Parent.utility.locale)function Descriptor.new(tab,
properties)properties=if typeof(properties)=='table'then properties else{}local
self=setmetatable({tab=assert(tab,'Missing argument #1 (Tab expected)'),window=
tab.window,description=properties.description or properties.Description or''},
Descriptor)self.main=self.window:Create('Frame',{AutomaticSize=Enum.
AutomaticSize.Y,BackgroundTransparency=1,Size=UDim2.new(1,-30,0,0),Parent=self.
tab.tabPage})self.window:Create('UIListLayout',{SortOrder=Enum.SortOrder.
LayoutOrder,Parent=self.main})self.titleLabel=self.window:Create('TextLabel',{
AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,RichText=true,Size=
UDim2.new(1,-90,0,0),Text=locale.t(self.description),TextSize=12,TextWrapped=
true,TextXAlignment=Enum.TextXAlignment.Left,TextTransparency=1,Parent=self.main
},{TextColor3='ContentColor',FontFace='Font'})self.window:Create('Frame',{
BackgroundTransparency=1,BorderSizePixel=0,LayoutOrder=1,Size=UDim2.fromOffset(0
,15),Parent=self.main})return self end return Descriptor end end function
__DARKLUA_BUNDLE_MODULES.f():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES
.cache.f if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.f=v end
return v.c end end do local function __modImpl()return function(script,require)
local Divider={}Divider.__index=Divider Divider.__type='Divider'local moveable=
require(script.Parent.Parent.utility.moveable)local locale=require(script.Parent
.Parent.utility.locale)local lineThickness=1 local defaultSpacing=12 local
labelGap=10 local labelHeight=14 local textSize=12 local lineShown=0.88 local
labelShown=0.55 function Divider.new(tab,properties)properties=if typeof(
properties)=='table'then properties else{}local spacing=properties.spacing or
properties.Spacing local text=properties.text or properties.Text local self=
setmetatable({tab=assert(tab,'Missing argument #1 (Tab expected)'),window=tab.
window,text=if text~=nil then tostring(text)else'',spacing=if type(spacing)==
'number'then math.max(spacing,0)else defaultSpacing,line=properties.line~=false
and properties.Line~=false},Divider)self.main=self.window:Create('Frame',{Size=
UDim2.new(1,-40,0,0),BorderSizePixel=0,Name='Divider',BackgroundTransparency=1,
Parent=self.tab.tabPage})self.window:Create('UIListLayout',{FillDirection=Enum.
FillDirection.Horizontal,Padding=UDim.new(0,labelGap),SortOrder=Enum.SortOrder.
LayoutOrder,VerticalAlignment=Enum.VerticalAlignment.Center,HorizontalAlignment=
Enum.HorizontalAlignment.Center,Parent=self.main})if self.line then self.left=
self:_buildHalf(1)end if self.text~=''then self:_buildLabel()end self:
_applyHeight()return self end function Divider:_buildHalf(order)local rule=self.
window:Create('Frame',{Size=UDim2.new(0,0,0,lineThickness),BorderSizePixel=0,
LayoutOrder=order,BackgroundTransparency=1,Parent=self.main},{BackgroundColor3=
'ContentColor'})self.window:Create('UIFlexItem',{FlexMode=Enum.UIFlexMode.Fill,
Parent=rule})return rule end function Divider:_buildLabel()self.title=self.
window:Create('TextLabel',{Text=locale.t(self.text),Size=UDim2.fromOffset(0,
labelHeight),AutomaticSize=Enum.AutomaticSize.X,BorderSizePixel=0,
BackgroundTransparency=1,TextSize=textSize,TextXAlignment=Enum.TextXAlignment.
Center,LayoutOrder=2,TextTransparency=1,Parent=self.main},{TextColor3=
'ContentColor',FontFace='Font'})if self.line then self.right=self:_buildHalf(3)
end end function Divider:_applyHeight()local content=if self.text~=''then
labelHeight elseif self.line then lineThickness else 0 self.main.Size=UDim2.new(
1,-40,0,self.spacing*2+content)end function Divider:Set(text)self.text=if text~=
nil then tostring(text)else''if self.text~=''and not self.title then self:
_buildLabel()if not self.window.hidden then self:_setShown(true,true)end end if
self.title then self.window:_bindLocale(self.title,'Text',self.text)local named=
self.text~=''self.title.Visible=named if self.right then self.right.Visible=
named end end self:_applyHeight()end function Divider:_setShown(shown,animate)
local w=self.window local ruleTransparency=if shown then lineShown else 1 w:
_reveal(self.left,{BackgroundTransparency=ruleTransparency},animate)w:_reveal(
self.right,{BackgroundTransparency=ruleTransparency},animate)w:_reveal(self.
title,{TextTransparency=if shown then labelShown else 1},animate)end moveable(
Divider)return Divider end end function __DARKLUA_BUNDLE_MODULES.g():typeof(
__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.g if not v then v={c=
__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.g=v end return v.c end end do
local function __modImpl()return function(script,require)local Drag={}Drag.
__index=Drag Drag.__type='Drag'local utility=script.Parent.Parent.utility local
variables=require(utility.variables)local constants=require(utility.constants)
function Drag.new(window,properties)properties=if typeof(properties)=='table'
then properties else{}local self=setmetatable({window=assert(window,
'Missing argument #1 (Window expected)')},Drag)self.drag=self.window:Create(
'Frame',{BackgroundTransparency=1,Size=UDim2.fromOffset(150,20),AnchorPoint=
Vector2.new(0.5,0.5),Position=UDim2.new(0.5,0,0.5,self.window.size.Y.Offset/2+15
),ZIndex=constants.zIndex.drag,Visible=false,Parent=self.window.screenGui})self.
dragCosmetic=self.window:Create('Frame',{BackgroundColor3=Color3.fromRGB(255,255
,255),AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.3),ZIndex=
constants.zIndex.drag,BackgroundTransparency=1,Size=UDim2.fromOffset(0,4),Parent
=self.drag})self.window:Create('UICorner',{CornerRadius=UDim.new(0,20),Parent=
self.dragCosmetic})self.window:CreateGlow(self.dragCosmetic,Color3.fromRGB(255,
255,255),10,0.5)self.dragInteract=self.window:Create('TextButton',{
BackgroundTransparency=1,Size=UDim2.fromScale(1,1),TextTransparency=1,ZIndex=
constants.zIndex.drag,Parent=self.drag})local dragging=false local relative=nil
local offset=Vector2.zero local screenGui=self.window.screenGui if screenGui and
screenGui.IgnoreGuiInset then offset=variables.guiService:GetGuiInset()end
local function getPosition()local mouseLocation=variables.userInputService and
variables.userInputService:GetMouseLocation()or Vector2.new(0,0)local
validRelative=relative or Vector2.new(0,0)local validOffset=offset or Vector2.
new(0,0)return mouseLocation+validRelative+validOffset end local function
getTargets()local position=getPosition()local x,y=position.X,position.Y if self.
window.settings and self.window.settings.keepOnScreen then local size=self.
window.main.AbsoluteSize local screen=self.window.screenGui.AbsoluteSize local
margin=8 local halfX,halfY=size.X/2,size.Y/2 x=math.clamp(x,halfX+margin,math.
max(halfX+margin,screen.X-halfX-margin))y=math.clamp(y,halfY+margin,math.max(
halfY+margin,screen.Y-halfY-margin))end local mainTarget=UDim2.fromOffset(x,y)
local dragTarget=UDim2.fromOffset(x,y+(self.window.main.Size.Y.Offset/2+15))
return mainTarget,dragTarget end self.window:Connect(self.drag.MouseEnter,
function()if not dragging and not self.window.hidden then variables.tweenService
:Create(self.dragCosmetic,TweenInfo.new(0.25,Enum.EasingStyle.Back,Enum.
EasingDirection.Out),{BackgroundTransparency=0.5,Size=UDim2.new(0,120,0,4)}):
Play()end end)self.window:Connect(self.drag.MouseLeave,function()if not dragging
and not self.window.hidden then variables.tweenService:Create(self.dragCosmetic,
TweenInfo.new(0.25,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
BackgroundTransparency=0.7,Size=UDim2.new(0,100,0,4)}):Play()end end)
local function releaseDrag()if not dragging then return end dragging=false if
not self.window:_interactive()then return end variables.tweenService:Create(self
.dragCosmetic,TweenInfo.new(0.35,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
,{Size=UDim2.new(0,100,0,4),BackgroundTransparency=0.7}):Play()local settle=
TweenInfo.new(0.3,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)local
mainTarget,dragTarget=getTargets()variables.tweenService:Create(self.window.main
,settle,{Position=mainTarget}):Play()variables.tweenService:Create(self.drag,
settle,{Position=dragTarget}):Play()end self.window:Connect(self.dragInteract.
InputBegan,function(input,processed)if processed then return end local inputType
=input.UserInputType.Name if inputType=='MouseButton1'or inputType=='Touch'then
if not self.window:_interactive()then return end dragging=true if screenGui and
screenGui.IgnoreGuiInset then offset=variables.guiService:GetGuiInset()end
relative=self.window.main.AbsolutePosition+self.window.main.AbsoluteSize*self.
window.main.AnchorPoint-variables.userInputService:GetMouseLocation()if not self
.window.hidden then variables.tweenService:Create(self.dragCosmetic,TweenInfo.
new(0.35,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=UDim2.new(0,110,0
,4),BackgroundTransparency=0}):Play()end end end)self.window:Connect(variables.
userInputService.InputEnded,function(input)local inputType=input.UserInputType.
Name if inputType=='MouseButton1'or inputType=='Touch'then releaseDrag()end end)
self.window:Connect(variables.userInputService.WindowFocusReleased,releaseDrag)
local mainRemaining=1e-7 local barRemaining=1e-60 self.window:Connect(variables.
runService.RenderStepped,function(dt)if not dragging then return end if not self
.window:_interactive()then releaseDrag()return end local mainTarget,dragTarget=
getTargets()self.window.main.Position=self.window.main.Position:Lerp(mainTarget,
1-mainRemaining^dt)self.drag.Position=self.drag.Position:Lerp(dragTarget,1-
barRemaining^dt)end)return self end return Drag end end function
__DARKLUA_BUNDLE_MODULES.h():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES
.cache.h if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.h=v end
return v.c end end do local function __modImpl()return function(script,require)
local Dropdown={}Dropdown.__index=Dropdown Dropdown.__type='Dropdown'local
utility=script.Parent.Parent.utility local variables=require(utility.variables)
local functions=require(utility.functions)local image=require(utility.image)
local constants=require(utility.constants)local locale=require(utility.locale)
local hapticEngine=require(utility.HapticEngine)local windowSizing=require(
utility.windowSizing)local chevronIcon=constants.icons.chevron local checkIcon=
constants.icons.check local dotIcon=constants.icons.dot local searchIconAsset=
constants.icons.search local roundRadius=UDim.new(0,12)local flatRadius=UDim.
new(0,7)local searchCollapsedHeight=30 local searchExpandedHeight=38 local
optionHeight=38 local optionGap=5 local listPadding=2 local headerHeight=41
local headerGap=6 local cardPaddingTop=7 local cardPaddingBottom=6 local
cardPadding=cardPaddingTop+cardPaddingBottom local maxVisibleOptions=4 local
windowChromeHeight=106 local minPageHeight=windowSizing.minSize.Y-
windowChromeHeight local actionsHeight=22 local hintTween=TweenInfo.new(0.2,Enum
.EasingStyle.Quint,Enum.EasingDirection.Out)local hoverTween=TweenInfo.new(0.25,
Enum.EasingStyle.Quint,Enum.EasingDirection.Out)local scrollbarShown=0.4 local
searchTween=TweenInfo.new(0.35,Enum.EasingStyle.Exponential,Enum.EasingDirection
.Out)local function dedupStrings(arr)local seen={}local out={}for _,v in arr do
if typeof(v)=='string'and not seen[v]then seen[v]=true table.insert(out,v)end
end return out end local function normalizeValue(value,multi)if value==nil then
return{}end if typeof(value)=='string'then return{value}end if typeof(value)==
'table'then local out=dedupStrings(value)if not multi and#out>1 then return{out[
1]}end return out end return{}end local function intersectWithOptions(value,
options)local out={}for _,v in value do if table.find(options,v)then table.
insert(out,v)end end return out end local function sameSelection(a,b)if#a~=#b
then return false end for _,v in a do if not table.find(b,v)then return false
end end return true end function Dropdown.new(tab,properties)properties=if
typeof(properties)=='table'then properties else{}local options=properties.
options or properties.Options or{}local multiSelect=properties.multiSelect or
properties.MultiSelect or properties.MultipleOptions or false local self=
setmetatable({tab=assert(tab,'Missing argument #1 (Tab expected)'),window=tab.
window,name=properties.name or properties.Name or'Dropdown',icon=properties.icon
or properties.Icon,description=properties.description or properties.Description,
forgetState=properties.forgetState or properties.ForgetState or tab.forgetState,
flag=properties.flag or properties.Flag or(not(properties.forgetState or
properties.ForgetState or tab.forgetState)and functions.deriveFlagFromName(
properties.name or properties.Name or'Dropdown')or nil),callback=properties.
callback or properties.Callback or function()end,options=dedupStrings(options),
multiSelect=multiSelect,placeholderText=locale.resolve(properties.placeholder or
properties.Placeholder or'None'),value=normalizeValue(properties.value or
properties.Value or properties.currentOption or properties.CurrentOption,
multiSelect),_isOpen=false,_optionFrames={}},Dropdown)self._desiredValue=self.
value self.value=intersectWithOptions(self.value,self.options)self.window:
_registerControl(self)self.main=self.window:Create('Frame',{Size=UDim2.new(1,-20
,0,41),BorderSizePixel=0,Name=self.name,BackgroundTransparency=1,Parent=self.tab
.tabPage})self.top=self.window:Create('Frame',{Size=UDim2.new(1,0,0,41),Position
=UDim2.fromScale(0,0),BorderSizePixel=0,BackgroundColor3=Color3.fromRGB(255,255,
255),BackgroundTransparency=1,ZIndex=1,Parent=self.main},{BackgroundTransparency
='ElementTransparency'})self.stroke=self.window:StyleElementBody(self.top)self.
hoverOverlay=self.window:CreateHoverOverlay(self.top)self.flashTarget=self.top
self.container=self.window:Create('Frame',{BorderSizePixel=0,Parent=self.top,
Size=UDim2.new(0,170,0,16),Position=UDim2.new(0,20,0.5,0),AnchorPoint=Vector2.
new(0,0.5),BackgroundTransparency=1,ZIndex=5})self.containerLayout=self.window:
Create('UIListLayout',{Padding=UDim.new(0,5),FillDirection=Enum.FillDirection.
Horizontal,VerticalAlignment=Enum.VerticalAlignment.Center,HorizontalAlignment=
Enum.HorizontalAlignment.Left,Parent=self.container})if self.icon then self.
iconLabel=self.window:Create('ImageLabel',{Image=self.icon,Size=UDim2.
fromOffset(16,16),BorderSizePixel=0,BackgroundTransparency=1,ImageTransparency=1
,ZIndex=5,Parent=self.container},{ImageColor3='ContentColor'})end self.title=
self.window:Create('TextLabel',{Text=locale.t(self.name),Size=UDim2.fromOffset(
150,16),BorderSizePixel=0,BackgroundTransparency=1,TextSize=16,AutomaticSize=
Enum.AutomaticSize.X,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,
LayoutOrder=1,TextTransparency=1,ZIndex=5,Parent=self.container},{TextColor3=
'ContentColor',FontFace='Font'})self.selectedLabel=self.window:Create(
'TextLabel',{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-41,0.5,0),Size
=UDim2.fromOffset(168,15),BorderSizePixel=0,BackgroundTransparency=1,TextSize=15
,TextXAlignment=Enum.TextXAlignment.Right,TextWrapped=true,TextTransparency=1,
ZIndex=5,Parent=self.top},{TextColor3='ContentColor',FontFace='Font'})self.
chevron=self.window:Create('ImageLabel',{AnchorPoint=Vector2.new(1,0.5),Position
=UDim2.new(1,-18,0.5,0),Size=UDim2.fromOffset(16,16),BorderSizePixel=0,
BackgroundTransparency=1,Image='rbxassetid://'..tostring(chevronIcon),Rotation=
180,ImageTransparency=1,ZIndex=5,Parent=self.top},{ImageColor3='ContentColor'})
self.interact=self.window:Create('TextButton',{BackgroundTransparency=1,Size=
UDim2.new(1,0,0,41),Position=UDim2.fromScale(0,0),BorderSizePixel=0,Text='',
TextTransparency=1,ZIndex=10,AutoButtonColor=false,Parent=self.main})self.panel=
self.window:Create('Frame',{AnchorPoint=Vector2.new(1,1),Position=UDim2.new(1,0,
1,0),Size=UDim2.new(1,0,1,-(headerHeight+headerGap)),BorderSizePixel=0,
ClipsDescendants=true,BackgroundColor3=Color3.fromRGB(255,255,255),ZIndex=1,
BackgroundTransparency=1,Parent=self.main})self.panelStroke=self.window:
StyleElementPanel(self.panel)self.window:Create('UIListLayout',{Padding=UDim.
new(0,5),FillDirection=Enum.FillDirection.Vertical,VerticalAlignment=Enum.
VerticalAlignment.Top,HorizontalAlignment=Enum.HorizontalAlignment.Center,
SortOrder=Enum.SortOrder.LayoutOrder,Parent=self.panel})self.window:Create(
'UIPadding',{PaddingTop=UDim.new(0,cardPaddingTop),PaddingBottom=UDim.new(0,
cardPaddingBottom),Parent=self.panel})self:_buildSearch()self:_buildActions()
self.list=self.window:Create('ScrollingFrame',{Active=true,Size=UDim2.new(1,0,0,
0),BorderSizePixel=0,BackgroundTransparency=1,ClipsDescendants=true,
AutomaticCanvasSize=Enum.AutomaticSize.Y,CanvasSize=UDim2.new(),
ScrollBarImageColor3=Color3.fromRGB(240,240,240),ScrollBarThickness=3,
ScrollBarImageTransparency=1,ScrollingDirection=Enum.ScrollingDirection.Y,
LayoutOrder=3,ZIndex=1,Parent=self.panel})self.window:Create('UIFlexItem',{
FlexMode=Enum.UIFlexMode.Fill,Parent=self.list})self.window:ConnectFor(self,self
.list:GetPropertyChangedSignal('CanvasPosition'),function()self:_syncScrollHint(
)end)self.window:ConnectFor(self,self.list:GetPropertyChangedSignal(
'AbsoluteCanvasSize'),function()self:_syncScrollHint()end)self.window:
ConnectFor(self,self.list:GetPropertyChangedSignal('AbsoluteWindowSize'),
function()self:_syncScrollHint()end)self.listLayout=self.window:Create(
'UIListLayout',{Padding=UDim.new(0,5),SortOrder=Enum.SortOrder.LayoutOrder,
HorizontalAlignment=Enum.HorizontalAlignment.Center,Parent=self.list})self.
window:Create('UIPadding',{PaddingTop=UDim.new(0,listPadding),PaddingBottom=UDim
.new(0,listPadding),Parent=self.list})self.emptyLabel=self.window:Create(
'TextLabel',{Name='Empty',Size=UDim2.new(1,-12,0,optionHeight),
BackgroundTransparency=1,Text=locale.t('No matches'),TextSize=14,
TextTransparency=0.55,Visible=false,LayoutOrder=1,Parent=self.list},{TextColor3=
'ContentColor',FontFace='Font'})local function isOptionSelected(name)return
table.find(self.value,name)~=nil end local function renderOptionState(data,
animate)local selected=isOptionSelected(data.name)local bgT=if self._isOpen then
(selected and 0.9 or 0.95)else 1 local titleT=if self._isOpen then(selected and
0 or 0.3)else 1 local iconT=if self._isOpen then(selected and 0 or 0.7)else 1
local strokeT=if self._isOpen then(selected and 0.85 or 0.93)else 1 image.
assign(data.checkIcon,'Image',if selected then checkIcon else dotIcon)if animate
then local info=TweenInfo.new(0.3,Enum.EasingStyle.Exponential,Enum.
EasingDirection.Out)variables.tweenService:Create(data.frame,info,{
BackgroundTransparency=bgT}):Play()variables.tweenService:Create(data.title,info
,{TextTransparency=titleT}):Play()variables.tweenService:Create(data.checkIcon,
info,{ImageTransparency=iconT}):Play()variables.tweenService:Create(data.stroke,
info,{Transparency=strokeT}):Play()else data.frame.BackgroundTransparency=bgT
data.title.TextTransparency=titleT data.checkIcon.ImageTransparency=iconT data.
stroke.Transparency=strokeT end end local function updateSelectedLabel()if self.
multiSelect then local n=#self.value if n==0 then self.selectedLabel.Text=self.
placeholderText elseif n==1 then self.selectedLabel.Text=self.value[1]else self.
selectedLabel.Text=locale.resolve('Various')end else self.selectedLabel.Text=
self.value[1]or self.placeholderText end end self._renderOptionState=
renderOptionState self._updateSelectedLabel=updateSelectedLabel local function
buildOption(optionName)local frame=self.window:Create('Frame',{Size=UDim2.new(1,
-12,0,optionHeight),BorderSizePixel=0,BackgroundTransparency=1,Parent=self.list}
,{BackgroundColor3='DropdownHighlight'})local corner=self.window:Create(
'UICorner',{CornerRadius=flatRadius,Parent=frame})local optionStroke=self.window
:Create('UIStroke',{ApplyStrokeMode=Enum.ApplyStrokeMode.Border,
BorderStrokePosition=Enum.BorderStrokePosition.Inner,LineJoinMode=Enum.
LineJoinMode.Round,Thickness=1,Color=Color3.fromRGB(255,255,255),Transparency=1,
Parent=frame})local interact=self.window:Create('TextButton',{
BackgroundTransparency=1,Size=UDim2.fromScale(1,1),Text='',TextTransparency=1,
ZIndex=50,Parent=frame})local container=self.window:Create('Frame',{AnchorPoint=
Vector2.new(0,0.5),Position=UDim2.new(0,14,0.5,0),Size=UDim2.fromOffset(170,16),
BorderSizePixel=0,BackgroundTransparency=1,ZIndex=5,Parent=frame})self.window:
Create('UIListLayout',{Padding=UDim.new(0,5),FillDirection=Enum.FillDirection.
Horizontal,VerticalAlignment=Enum.VerticalAlignment.Center,SortOrder=Enum.
SortOrder.LayoutOrder,Parent=container})local checkIcon=self.window:Create(
'ImageLabel',{Image='rbxassetid://'..tostring(checkIcon),Size=UDim2.fromOffset(
16,16),BorderSizePixel=0,BackgroundTransparency=1,ImageTransparency=1,ZIndex=5,
Parent=container},{ImageColor3='ContentColor'})local title=self.window:Create(
'TextLabel',{Text=optionName,Size=UDim2.fromOffset(170,16),BorderSizePixel=0,
BackgroundTransparency=1,TextSize=16,TextXAlignment=Enum.TextXAlignment.Left,
TextWrapped=true,LayoutOrder=1,TextTransparency=1,ZIndex=5,Parent=container},{
TextColor3='ContentColor',FontFace='Font'})local data={name=optionName,frame=
frame,interact=interact,title=title,checkIcon=checkIcon,container=container,
stroke=optionStroke,corner=corner,connections={}}table.insert(data.connections,
self.window:ConnectFor(self,frame.MouseEnter,function()if not self._isOpen or
not self.window:_interactive()then return end if isOptionSelected(optionName)
then return end variables.tweenService:Create(frame,TweenInfo.new(0.2,Enum.
EasingStyle.Quint,Enum.EasingDirection.Out),{BackgroundTransparency=0.9}):Play()
variables.tweenService:Create(title,TweenInfo.new(0.2,Enum.EasingStyle.Quint,
Enum.EasingDirection.Out),{TextTransparency=0.15}):Play()end))table.insert(data.
connections,self.window:ConnectFor(self,frame.MouseLeave,function()if not self.
_isOpen then return end if isOptionSelected(optionName)then return end variables
.tweenService:Create(frame,TweenInfo.new(0.2,Enum.EasingStyle.Quint,Enum.
EasingDirection.Out),{BackgroundTransparency=0.95}):Play()variables.tweenService
:Create(title,TweenInfo.new(0.2,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)
,{TextTransparency=0.3}):Play()end))table.insert(data.connections,self.window:
ConnectFor(self,interact.MouseButton1Click,function()if not self._isOpen then
return end hapticEngine.click()local sel=isOptionSelected(optionName)if not self
.multiSelect then if sel then self:_close()return end table.clear(self.value)
table.insert(self.value,optionName)else if sel then local idx=table.find(self.
value,optionName)if idx then table.remove(self.value,idx)end else table.insert(
self.value,optionName)end end self._desiredValue=table.clone(self.value)for _,d
in self._optionFrames do renderOptionState(d,true)end updateSelectedLabel()self.
window:_runGuarded(self,self.callback,self:_callbackValue())self.window:
_persist(self)if not self.multiSelect then task.wait(0.1)self:_close()end end))
return data end self._buildOption=buildOption for _,opt in self.options do local
data=buildOption(opt)table.insert(self._optionFrames,data)end
updateSelectedLabel()self:_updateCorners()self.window:ConnectFor(self,self.
interact.MouseButton1Click,function()hapticEngine.click()if self._isOpen then
self:_close()else self:_open()end end)self.window:ConnectFor(self,self.main.
MouseEnter,function()if self._isOpen or not self.window:_interactive()then
return end variables.tweenService:Create(self.title,hoverTween,{TextColor3=self.
window.theme.ElementTextHoverColor}):Play()variables.tweenService:Create(self.
hoverOverlay,hoverTween,{BackgroundTransparency=0.97}):Play()variables.
tweenService:Create(self.stroke,hoverTween,{Transparency=self.window.theme.
ElementStrokeHoverTransparency,Color=self.window.theme.ElementStrokeHover}):
Play()end)self.window:ConnectFor(self,self.main.MouseLeave,function()variables.
tweenService:Create(self.title,hoverTween,{TextColor3=self.window.theme.
ContentColor}):Play()variables.tweenService:Create(self.hoverOverlay,hoverTween,
{BackgroundTransparency=1}):Play()variables.tweenService:Create(self.stroke,
hoverTween,{Transparency=self.window.theme.ElementStrokeTransparency,Color=self.
window.theme.ElementStroke}):Play()end)if self.description then self.descriptor=
require(script.Parent.descriptor).new(self.tab,{description=self.description})
end return self end function Dropdown:_callbackValue()if self.multiSelect then
return table.clone(self.value)end return self.value[1]end function Dropdown:
_buildSearch()self._searchOpen=false self.searchbar=self.window:Create('Frame',{
Name='Search',Size=UDim2.new(1,-12,0,searchCollapsedHeight),BorderSizePixel=0,
BackgroundColor3=Color3.fromRGB(255,255,255),BackgroundTransparency=1,
LayoutOrder=1,ClipsDescendants=false,ZIndex=1,Parent=self.panel})self.window:
Create('UICorner',{CornerRadius=UDim.new(0,12),Parent=self.searchbar})self.
searchStroke=self.window:Create('UIStroke',{ApplyStrokeMode=Enum.ApplyStrokeMode
.Border,BorderStrokePosition=Enum.BorderStrokePosition.Inner,LineJoinMode=Enum.
LineJoinMode.Round,Thickness=1,Color=Color3.fromRGB(255,255,255),Transparency=1,
Parent=self.searchbar})self.searchShadow=self.window:CreateGlow(self.searchbar,
Color3.fromRGB(255,255,255),20,1)self.searchToggle=self.window:Create(
'TextButton',{BackgroundTransparency=1,Size=UDim2.fromScale(1,1),Text='',
TextTransparency=1,ZIndex=51,Parent=self.searchbar})self.searchInput=self.window
:Create('TextBox',{Text='',PlaceholderText=locale.t('Search...'),Size=UDim2.new(
1,-58,0,16),Position=UDim2.new(0,44,0.5,0),AnchorPoint=Vector2.new(0,0.5),
BackgroundTransparency=1,TextSize=16,TextXAlignment=Enum.TextXAlignment.Left,
ClearTextOnFocus=false,TextEditable=false,Interactable=false,ZIndex=52,
TextTransparency=1,Parent=self.searchbar},{TextColor3='ContentColor',FontFace=
'Font',PlaceholderColor3='PlaceholderColor'})self.searchIcon=self.window:Create(
'ImageButton',{Image='rbxassetid://'..tostring(searchIconAsset),Size=UDim2.
fromOffset(20,20),Position=UDim2.new(0,24,0.5,0),AnchorPoint=Vector2.new(0.5,0.5
),BackgroundTransparency=1,ScaleType=Enum.ScaleType.Fit,AutoButtonColor=false,
ZIndex=53,ImageTransparency=1,Parent=self.searchbar},{ImageColor3='ContentColor'
})self.window:ConnectFor(self,self.searchToggle.MouseButton1Click,function()if
not self._searchOpen then self:_expandSearch()end end)self.window:ConnectFor(
self,self.searchIcon.MouseButton1Click,function()if self._searchOpen then self:
_collapseSearch()else self:_expandSearch()end end)self.window:ConnectFor(self,
self.searchInput:GetPropertyChangedSignal('Text'),function()self:_applyFilter(
self.searchInput.Text)end)self.window:ConnectFor(self,self.searchInput.FocusLost
,function()if self.searchInput.Text==''then self:_collapseSearch()end end)end
function Dropdown:_expandSearch()if self._searchOpen then return end self.
_searchOpen=true self.searchInput.TextEditable=true self.searchInput.
Interactable=true variables.tweenService:Create(self.searchbar,searchTween,{Size
=UDim2.new(1,-12,0,searchExpandedHeight),BackgroundTransparency=0.92}):Play()
variables.tweenService:Create(self.searchStroke,searchTween,{Transparency=0.86})
:Play()variables.tweenService:Create(self.searchShadow,searchTween,{Transparency
=0.92}):Play()variables.tweenService:Create(self.searchInput,searchTween,{
TextTransparency=0.3}):Play()self:_resizeToOptions()self.searchInput:
CaptureFocus()end function Dropdown:_collapseSearch()if not self._searchOpen
then return end self._searchOpen=false self.searchInput.TextEditable=false self.
searchInput.Interactable=false self.searchInput:ReleaseFocus()self.searchInput.
Text=''variables.tweenService:Create(self.searchbar,searchTween,{Size=UDim2.new(
1,-12,0,searchCollapsedHeight),BackgroundTransparency=1}):Play()variables.
tweenService:Create(self.searchStroke,searchTween,{Transparency=1}):Play()
variables.tweenService:Create(self.searchShadow,searchTween,{Transparency=1}):
Play()variables.tweenService:Create(self.searchInput,searchTween,{
TextTransparency=1}):Play()self:_resizeToOptions()end function Dropdown:
_applyFilter(query)query=string.lower(query or'')local shown=0 for _,data in
self._optionFrames do local visible=query==''or string.find(string.lower(data.
name),query,1,true)~=nil data.frame.Visible=visible if visible then shown+=1 end
end self.emptyLabel.Visible=shown==0 and query~=''self:_updateCorners()self:
_resizeToOptions()self:_syncScrollHint()end function Dropdown:_syncScrollHint()
local canvasSize,windowSize,at=self.list.AbsoluteCanvasSize,self.list.
AbsoluteWindowSize,self.list.CanvasPosition if not canvasSize or not windowSize
or not at then return end local more=self._isOpen and windowSize.Y>0 and
canvasSize.Y-(at.Y+windowSize.Y)>1 variables.tweenService:Create(self.list,
hintTween,{ScrollBarImageTransparency=if more then scrollbarShown else 1}):Play(
)end function Dropdown:_visibleOptions():{string}local names={}for _,data in
self._optionFrames do if data.frame.Visible then table.insert(names,data.name)
end end return names end function Dropdown:_buildActions()if not self.
multiSelect then return end self.actions=self.window:Create('Frame',{Name=
'Actions',Size=UDim2.new(1,-12,0,actionsHeight),BackgroundTransparency=1,
LayoutOrder=2,Parent=self.panel})self.window:Create('UIListLayout',{Padding=UDim
.new(0,12),FillDirection=Enum.FillDirection.Horizontal,VerticalAlignment=Enum.
VerticalAlignment.Center,SortOrder=Enum.SortOrder.LayoutOrder,Parent=self.
actions})local function action(label:string,order:number,apply:()->())local
button=self.window:Create('TextButton',{AutomaticSize=Enum.AutomaticSize.X,Size=
UDim2.fromOffset(0,actionsHeight),BackgroundTransparency=1,Text=locale.t(label),
TextSize=13,TextTransparency=0.45,LayoutOrder=order,Parent=self.actions},{
TextColor3='ContentColor',FontFace='Font'})self.window:ConnectFor(self,button.
MouseEnter,function()variables.tweenService:Create(button,hintTween,{
TextTransparency=0.15}):Play()end)self.window:ConnectFor(self,button.MouseLeave,
function()variables.tweenService:Create(button,hintTween,{TextTransparency=0.45}
):Play()end)self.window:ConnectFor(self,button.MouseButton1Click,function()
apply()self:_afterBulkChange()end)return button end action('Select all',1,
function()local shown=self:_visibleOptions()for _,name in shown do if not table.
find(self.value,name)then table.insert(self.value,name)end end end)action(
'Clear',2,function()local shown=self:_visibleOptions()for index=#self.value,1,-1
do if table.find(shown,self.value[index])then table.remove(self.value,index)end
end end)end function Dropdown:_afterBulkChange()self._desiredValue=table.clone(
self.value)for _,data in self._optionFrames do self._renderOptionState(data,true
)end self:_updateSelectedLabel()self:_updateCorners()self.window:_runGuarded(
self,self.callback,self:_callbackValue())self.window:_persist(self)hapticEngine.
click()end function Dropdown:_resizeToOptions()if not self._isOpen then return
end variables.tweenService:Create(self.main,searchTween,{Size=UDim2.new(1,-20,0,
self:_openHeight())}):Play()end function Dropdown:_updateCorners()local visible=
{}for _,data in self._optionFrames do if data.frame.Visible then table.insert(
visible,data)end end for i,data in visible do local topR=if i==1 then
roundRadius else flatRadius local botR=if i==#visible then roundRadius else
flatRadius data.corner.TopLeftRadius=topR data.corner.TopRightRadius=topR data.
corner.BottomLeftRadius=botR data.corner.BottomRightRadius=botR end end
local function listHeight(count:number):number return count*optionHeight+math.
max(0,count-1)*optionGap+listPadding*2 end local function rowsThatFit(space:
number):number return math.max(math.floor((space-listPadding*2+optionGap)/(
optionHeight+optionGap)),1)end function Dropdown:_pageHeight():number local size
=self.window.size if not size then return minPageHeight end return size.Y.Offset
-windowChromeHeight end function Dropdown:_openHeight()local n=0 for _,data in
self._optionFrames do if data.frame.Visible then n+=1 end end local searchHeight
=if self._searchOpen then searchExpandedHeight else searchCollapsedHeight local
overhead=headerHeight+headerGap+cardPadding+searchHeight+optionGap+(if self.
actions then actionsHeight+optionGap else 0)local available=self:_pageHeight()
local rows=math.min(math.max(n,1),maxVisibleOptions,rowsThatFit(available-
overhead))return math.min(overhead+listHeight(rows),available)end function
Dropdown:_open()if self._isOpen then return end self._isOpen=true if self.
_outsideClickConn then self.window:Disconnect(self._outsideClickConn)end self.
_outsideClickConn=self.window:Connect(variables.userInputService.InputBegan,
function(input)if input.UserInputType~=Enum.UserInputType.MouseButton1 and input
.UserInputType~=Enum.UserInputType.Touch then return end local pos=input.
Position local mainPos=self.main.AbsolutePosition local mainSize=self.main.
AbsoluteSize if pos.X<mainPos.X or pos.X>mainPos.X+mainSize.X or pos.Y<mainPos.Y
or pos.Y>mainPos.Y+mainSize.Y then self:_close()end end)variables.tweenService:
Create(self.main,TweenInfo.new(0.5,Enum.EasingStyle.Exponential,Enum.
EasingDirection.Out),{Size=UDim2.new(1,-20,0,self:_openHeight())}):Play()
variables.tweenService:Create(self.chevron,TweenInfo.new(0.7,Enum.EasingStyle.
Exponential,Enum.EasingDirection.Out),{Rotation=0}):Play()variables.tweenService
:Create(self.panel,TweenInfo.new(0.4,Enum.EasingStyle.Quint,Enum.EasingDirection
.Out),{BackgroundTransparency=self.window.theme.ElementTransparency or 0}):Play(
)variables.tweenService:Create(self.panelStroke,TweenInfo.new(0.4,Enum.
EasingStyle.Quint,Enum.EasingDirection.Out),{Transparency=self.window.theme.
ElementStrokeTransparency}):Play()variables.tweenService:Create(self.searchIcon,
TweenInfo.new(0.4,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{
ImageTransparency=0.5}):Play()for _,data in self._optionFrames do self.
_renderOptionState(data,true)end self:_syncScrollHint()self:_bringIntoView()end
function Dropdown:_bringIntoView()local page=self.tab and self.tab.tabPage if
not page then return end while page and not page:IsA('ScrollingFrame')do page=
page.Parent end if not page then return end local view,at,pageAt,cardAt=page.
AbsoluteWindowSize,page.CanvasPosition,page.AbsolutePosition,self.main.
AbsolutePosition if not view or not at or not pageAt or not cardAt or view.Y<=0
then return end local top=cardAt.Y-pageAt.Y+at.Y local bottom=top+self:
_openHeight()local overflow=bottom-(at.Y+view.Y)if overflow<=0 then return end
local target=math.min(at.Y+overflow+8,top)variables.tweenService:Create(page,
TweenInfo.new(0.4,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{
CanvasPosition=Vector2.new(at.X,target)}):Play()end function Dropdown:_close()if
not self._isOpen then return end self._isOpen=false if self._outsideClickConn
then self.window:Disconnect(self._outsideClickConn)self._outsideClickConn=nil
end self:_collapseSearch()self:_syncScrollHint()variables.tweenService:Create(
self.chevron,TweenInfo.new(0.7,Enum.EasingStyle.Exponential,Enum.EasingDirection
.Out),{Rotation=180}):Play()variables.tweenService:Create(self.panel,TweenInfo.
new(0.4,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{BackgroundTransparency
=1}):Play()variables.tweenService:Create(self.panelStroke,TweenInfo.new(0.4,Enum
.EasingStyle.Quint,Enum.EasingDirection.Out),{Transparency=1}):Play()variables.
tweenService:Create(self.searchIcon,TweenInfo.new(0.4,Enum.EasingStyle.Quint,
Enum.EasingDirection.Out),{ImageTransparency=1}):Play()for _,data in self.
_optionFrames do self._renderOptionState(data,true)end variables.tweenService:
Create(self.main,TweenInfo.new(0.5,Enum.EasingStyle.Exponential,Enum.
EasingDirection.Out),{Size=UDim2.new(1,-20,0,41)}):Play()end function Dropdown:
_destroyOption(data)if data.connections then for _,connection in data.
connections do local idx=table.find(self.connections,connection)if idx then
table.remove(self.connections,idx)end self.window:Disconnect(connection)end data
.connections=nil end self.window:DestroySubtree(data.frame)end function Dropdown
:_deriveSelection()local previous=self.value self.value=intersectWithOptions(
self._desiredValue or self.value,self.options)return not sameSelection(self.
value,previous)end function Dropdown:Refresh(newOptions)self.options=
dedupStrings(newOptions or{})for _,data in self._optionFrames do self:
_destroyOption(data)end table.clear(self._optionFrames)local selectionChanged=
self:_deriveSelection()for _,opt in self.options do local data=self.
_buildOption(opt)table.insert(self._optionFrames,data)if self._isOpen then self.
_renderOptionState(data,false)end end self._updateSelectedLabel()self:
_applyFilter(if self._searchOpen then self.searchInput.Text else'')if
selectionChanged then self.window:_runGuarded(self,self.callback,self:
_callbackValue())self.window:_persist(self)end end function Dropdown:Add(option)
if typeof(option)~='string'or option==''then return end if table.find(self.
options,option)then return end table.insert(self.options,option)local data=self.
_buildOption(option)table.insert(self._optionFrames,data)local selectionChanged=
self:_deriveSelection()if self._isOpen then self._renderOptionState(data,true)
end self:_applyFilter(if self._searchOpen then self.searchInput.Text else'')if
selectionChanged then self._updateSelectedLabel()self.window:_runGuarded(self,
self.callback,self:_callbackValue())self.window:_persist(self)end end function
Dropdown:Remove(option)local idx=table.find(self.options,option)if not idx then
return end table.remove(self.options,idx)for i,data in self._optionFrames do if
data.name==option then self:_destroyOption(data)table.remove(self._optionFrames,
i)break end end if self._desiredValue then local desiredIdx=table.find(self.
_desiredValue,option)if desiredIdx then table.remove(self._desiredValue,
desiredIdx)end end local valueIdx=table.find(self.value,option)if valueIdx then
table.remove(self.value,valueIdx)self._updateSelectedLabel()self.window:
_runGuarded(self,self.callback,self:_callbackValue())self.window:_persist(self)
end self:_applyFilter(if self._searchOpen then self.searchInput.Text else'')end
function Dropdown:Set(value,skipCallback)local newValue=normalizeValue(value,
self.multiSelect)self._desiredValue=newValue self.value=intersectWithOptions(
newValue,self.options)for _,data in self._optionFrames do self.
_renderOptionState(data,true)end self._updateSelectedLabel()if not skipCallback
then self.window:_runGuarded(self,self.callback,self:_callbackValue())self.
window:_persist(self)end end function Dropdown:_setShown(shown,animate)local w=
self.window w:_reveal(self.stroke,{Transparency=if shown then w.theme.
ElementStrokeTransparency else 1},animate)w:_reveal(self.title,{TextTransparency
=if shown then 0 else 1},animate)w:_reveal(self.top,{BackgroundTransparency=if
shown then(w.theme.ElementTransparency or 0)else 1},animate)if self.iconLabel
then w:_reveal(self.iconLabel,{ImageTransparency=if shown then 0 else 1},animate
)end if self.descriptor then w:_reveal(self.descriptor.titleLabel,{
TextTransparency=if shown then 0.7 else 1},animate)end w:_reveal(self.
selectedLabel,{TextTransparency=if shown then 0.5 else 1},animate)w:_reveal(self
.chevron,{ImageTransparency=if shown then 0.5 else 1},animate)if not shown and
self._isOpen then self:_close()end end function Dropdown:MoveTo(index)self.tab:
_moveElement(self,index)end function Dropdown:MoveToTop()self.tab:_moveElement(
self,1)end function Dropdown:MoveToBottom()self.tab:_moveElement(self,#self.tab.
elements)end function Dropdown:MoveUp()local idx=table.find(self.tab.elements,
self)if idx then self.tab:_moveElement(self,idx-1)end end function Dropdown:
MoveDown()local idx=table.find(self.tab.elements,self)if idx then self.tab:
_moveElement(self,idx+1)end end return Dropdown end end function
__DARKLUA_BUNDLE_MODULES.i():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES
.cache.i if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.i=v end
return v.c end end do local function __modImpl()return function(script,require)
local utility=script.Parent.Parent.utility local variables=require(utility.
variables)local moveable=require(utility.moveable)local ESPPreview={}ESPPreview.
__index=ESPPreview ESPPreview.__type='ESPPreview'local function round(window,
instance,radius)window:Create('UICorner',{CornerRadius=UDim.new(0,radius or 999)
,Parent=instance})end local function bracket(window,parent,position,size,anchor,
color)local object=window:Create('Frame',{AnchorPoint=anchor or Vector2.zero,
Position=position,Size=size,BackgroundColor3=color,BorderSizePixel=0,ZIndex=9,
Parent=parent})window:Create('UIStroke',{ApplyStrokeMode=Enum.ApplyStrokeMode.
Border,Color=Color3.new(0,0,0),Thickness=2,Parent=object})return object end
local function skeletonSegment(window,parent,color)return window:Create('Frame',
{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromOffset(0,0),Size=UDim2.
fromOffset(0,1),BackgroundColor3=color,BorderSizePixel=0,ZIndex=8,Visible=false,
Parent=parent})end local previewR15Bones={{'Head','UpperTorso'},{'UpperTorso',
'LowerTorso'},{'UpperTorso','LeftUpperArm'},{'LeftUpperArm','LeftLowerArm'},{
'LeftLowerArm','LeftHand'},{'UpperTorso','RightUpperArm'},{'RightUpperArm',
'RightLowerArm'},{'RightLowerArm','RightHand'},{'LowerTorso','LeftUpperLeg'},{
'LeftUpperLeg','LeftLowerLeg'},{'LeftLowerLeg','LeftFoot'},{'LowerTorso',
'RightUpperLeg'},{'RightUpperLeg','RightLowerLeg'},{'RightLowerLeg','RightFoot'}
}local function stripAvatarScripts(model)for _,descendant in model:
GetDescendants()do if descendant:IsA('Script')or descendant:IsA('LocalScript')or
descendant:IsA('Tool')then descendant:Destroy()elseif descendant:IsA('BasePart')
then descendant.Anchored=true descendant.CanCollide=false descendant.CanQuery=
false descendant.CanTouch=false end end end local function bodyVerticalBounds(
model)local minimum,maximum=math.huge,-math.huge for _,descendant in model:
GetDescendants()do if descendant:IsA('BasePart')and not descendant:
FindFirstAncestorOfClass('Accessory')then local halfHeight=descendant.Size.Y/2
minimum=math.min(minimum,descendant.Position.Y-halfHeight)maximum=math.max(
maximum,descendant.Position.Y+halfHeight)end end if minimum==math.huge then
local center,size=model:GetBoundingBox()return center.Position.Y,math.max(size.Y
,1)end return(minimum+maximum)/2,math.max(maximum-minimum,1)end function
ESPPreview.new(tab,properties)properties=if typeof(properties)=='table'then
properties else{}local window=tab.window local player=variables.localPlayer
local color=if typeof(properties.color)=='Color3'then properties.color else
window.theme.AccentColor local displayName=properties.targetName or(player and(
player.DisplayName~=''and player.DisplayName or player.Name))or'PULSE_TARGET'
local self=setmetatable({tab=assert(tab,'Missing argument #1 (Tab expected)'),
window=window,name=properties.name or properties.Name or'Pulse ESP',color=color,
health=math.clamp(tonumber(properties.health)or 72,0,100),features={box=
properties.box~=false,fill=properties.boxFill==true,name=properties.nameTag~=
false,distance=properties.distance~=false,health=properties.healthBar~=false,
role=properties.role~=false,weapon=properties.weapon~=false,skeleton=properties.
skeleton==true,kirk=false},connections={},_accentFrames={},_accentText={},
_boxBrackets={},boxStyle=string.lower(tostring(properties.boxStyle or'Corners'))
,_dragging=false,_dragMode='rotate',_yaw=180,_pan=Vector2.zero,_zoom=1,_hovered=
false},ESPPreview)self.main=window:Create('Frame',{Name=self.name,Size=UDim2.
new(1,-20,0,390),BackgroundColor3=Color3.fromRGB(255,255,255),
BackgroundTransparency=0,BorderSizePixel=0,ClipsDescendants=true,Visible=false,
Parent=tab.tabPage})self.stroke=window:StyleElementPanel(self.main)self.
revealScale=window:Create('UIScale',{Scale=1,Parent=self.main})self.title=window
:Create('TextLabel',{Text=self.name,Position=UDim2.fromOffset(18,14),Size=UDim2.
new(1,-132,0,22),BackgroundTransparency=1,BorderSizePixel=0,TextSize=17,
TextXAlignment=Enum.TextXAlignment.Left,ZIndex=3,Parent=self.main},{TextColor3=
'ContentColor',FontFace='TitleFont'})self.canvas=window:Create('Frame',{Position
=UDim2.fromOffset(12,46),Size=UDim2.new(1,-24,1,-58),BackgroundColor3=Color3.
fromRGB(255,255,255),BackgroundTransparency=0,BorderSizePixel=0,ClipsDescendants
=true,ZIndex=2,Parent=self.main})self.canvasStroke=window:StyleElementPanel(self
.canvas)self.fadeCover=window:Create('Frame',{Size=UDim2.fromScale(1,1),
BackgroundColor3=Color3.fromRGB(255,255,255),BackgroundTransparency=0,
BorderSizePixel=0,ZIndex=100,Visible=false,Parent=self.main})round(window,self.
fadeCover,12)window:Create('UIGradient',{Rotation=270,Parent=self.fadeCover},{
Color='ElementGradient'})for i=1,7 do window:Create('Frame',{Position=UDim2.
fromScale(i/8,0),Size=UDim2.new(0,1,1,0),BackgroundColor3=Color3.fromRGB(255,255
,255),BackgroundTransparency=0.94,BorderSizePixel=0,ZIndex=2,Parent=self.canvas}
)end for i=1,4 do window:Create('Frame',{Position=UDim2.fromScale(0,i/5),Size=
UDim2.new(1,0,0,1),BackgroundColor3=Color3.fromRGB(255,255,255),
BackgroundTransparency=0.94,BorderSizePixel=0,ZIndex=2,Parent=self.canvas})end
self.target=window:Create('Frame',{AnchorPoint=Vector2.new(0.5,0.5),Position=
UDim2.fromScale(0.5,0.56),Size=UDim2.fromOffset(103,188),BackgroundTransparency=
1,BorderSizePixel=0,ZIndex=4,Parent=self.canvas})self.viewport=window:Create(
'ViewportFrame',{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,
BorderSizePixel=0,Ambient=Color3.fromRGB(190,190,190),LightColor=Color3.fromRGB(
255,255,255),LightDirection=Vector3.new(-1,-0.5,-1),ZIndex=4,Parent=self.target}
)self.worldModel=window:Create('WorldModel',{Parent=self.viewport})self.camera=
window:Create('Camera',{FieldOfView=32,Parent=self.viewport})self.viewport.
CurrentCamera=self.camera self.fallback=window:Create('Frame',{AnchorPoint=
Vector2.new(0.5,0),Position=UDim2.fromOffset(52,46),Size=UDim2.fromOffset(48,76)
,BackgroundColor3=Color3.fromRGB(255,255,255),BackgroundTransparency=0.82,
BorderSizePixel=0,ZIndex=4,Parent=self.target})round(window,self.fallback,14)
self.fallbackHead=window:Create('Frame',{AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.fromOffset(52,28),Size=UDim2.fromOffset(34,34),BackgroundColor3=
Color3.fromRGB(255,255,255),BackgroundTransparency=0.76,BorderSizePixel=0,ZIndex
=4,Parent=self.target})round(window,self.fallbackHead)for _,legX in{36,60}do
local leg=window:Create('Frame',{Position=UDim2.fromOffset(legX,114),Size=UDim2.
fromOffset(10,52),BackgroundColor3=Color3.fromRGB(255,255,255),
BackgroundTransparency=0.82,BorderSizePixel=0,ZIndex=4,Parent=self.target})
round(window,leg)end self.boxLayer=window:Create('Frame',{Size=UDim2.fromScale(1
,1),BackgroundTransparency=1,BorderSizePixel=0,ZIndex=7,Parent=self.target})self
.kirkImage=window:Create('ImageLabel',{Size=UDim2.fromScale(1,1),
BackgroundTransparency=1,BorderSizePixel=0,Image='',ScaleType=Enum.ScaleType.
Crop,ZIndex=12,Visible=false,Parent=self.target})self.fillLayer=window:Create(
'Frame',{Size=UDim2.fromScale(1,1),BackgroundColor3=color,BackgroundTransparency
=0.8,BorderSizePixel=0,ZIndex=6,Visible=false,Parent=self.target})table.insert(
self._accentFrames,self.fillLayer)local horizontalLength,verticalLength,width=26
,38,1 local brackets={bracket(window,self.boxLayer,UDim2.fromOffset(0,0),UDim2.
fromOffset(horizontalLength,width),nil,color),bracket(window,self.boxLayer,UDim2
.fromOffset(0,0),UDim2.fromOffset(width,verticalLength),nil,color),bracket(
window,self.boxLayer,UDim2.new(1,0,0,0),UDim2.fromOffset(horizontalLength,width)
,Vector2.new(1,0),color),bracket(window,self.boxLayer,UDim2.new(1,0,0,0),UDim2.
fromOffset(width,verticalLength),Vector2.new(1,0),color),bracket(window,self.
boxLayer,UDim2.new(0,0,1,0),UDim2.fromOffset(horizontalLength,width),Vector2.
new(0,1),color),bracket(window,self.boxLayer,UDim2.new(0,0,1,0),UDim2.
fromOffset(width,verticalLength),Vector2.new(0,1),color),bracket(window,self.
boxLayer,UDim2.fromScale(1,1),UDim2.fromOffset(horizontalLength,width),Vector2.
new(1,1),color),bracket(window,self.boxLayer,UDim2.fromScale(1,1),UDim2.
fromOffset(width,verticalLength),Vector2.new(1,1),color)}for _,object in
brackets do table.insert(self._accentFrames,object)table.insert(self.
_boxBrackets,object)end self.skeletonLayer=window:Create('Frame',{Size=UDim2.
fromScale(1,1),BackgroundTransparency=1,BorderSizePixel=0,ClipsDescendants=true,
ZIndex=8,Parent=self.target})self._skeletonLines={}for _=1,#previewR15Bones do
local line=skeletonSegment(window,self.skeletonLayer,color)table.insert(self.
_skeletonLines,line)table.insert(self._accentFrames,line)end self.fullBoxOutline
=window:Create('Frame',{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,
BorderSizePixel=0,ZIndex=8,Visible=false,Parent=self.boxLayer})self.
fullBoxOutlineStroke=window:Create('UIStroke',{ApplyStrokeMode=Enum.
ApplyStrokeMode.Border,BorderStrokePosition=Enum.BorderStrokePosition.Inner,
LineJoinMode=Enum.LineJoinMode.Miter,Thickness=3,Color=Color3.new(0,0,0),Parent=
self.fullBoxOutline})self.fullBox=window:Create('Frame',{Size=UDim2.fromScale(1,
1),BackgroundTransparency=1,BorderSizePixel=0,ZIndex=9,Visible=false,Parent=self
.boxLayer})self.fullBoxCorner=window:Create('UICorner',{CornerRadius=UDim.new(0,
0),Parent=self.fullBox})self.fullBoxStroke=window:Create('UIStroke',{
ApplyStrokeMode=Enum.ApplyStrokeMode.Border,BorderStrokePosition=Enum.
BorderStrokePosition.Inner,LineJoinMode=Enum.LineJoinMode.Miter,Thickness=1,
Color=color,Parent=self.fullBox})self.healthLayer=window:Create('Frame',{Size=
UDim2.fromScale(1,1),BackgroundTransparency=1,BorderSizePixel=0,ZIndex=9,Parent=
self.target})self.healthBackground=window:Create('Frame',{AnchorPoint=Vector2.
new(1,0),Position=UDim2.fromOffset(-7,0),Size=UDim2.fromOffset(4,188),
BackgroundColor3=Color3.fromRGB(255,255,255),BackgroundTransparency=0.82,
BorderSizePixel=0,ZIndex=9,Parent=self.healthLayer})round(window,self.
healthBackground)self.healthFill=window:Create('Frame',{AnchorPoint=Vector2.new(
0,1),Position=UDim2.fromScale(0,1),Size=UDim2.fromScale(1,self.health/100),
BackgroundColor3=color,BorderSizePixel=0,ZIndex=10,Parent=self.healthBackground}
)round(window,self.healthFill)table.insert(self._accentFrames,self.healthFill)
self.nameLabel=window:Create('TextLabel',{AnchorPoint=Vector2.new(0.5,1),
Position=UDim2.new(0.5,0,0,-2),Size=UDim2.fromOffset(220,18),
BackgroundTransparency=1,BorderSizePixel=0,Text=displayName,TextSize=13,
TextColor3=Color3.fromRGB(235,235,235),TextStrokeColor3=Color3.new(0,0,0),
TextStrokeTransparency=0,ZIndex=10,Parent=self.target},{FontFace='TitleFont'})
self.distanceLabel=window:Create('TextLabel',{Position=UDim2.new(1,3,0,14),Size=
UDim2.fromOffset(100,18),BackgroundTransparency=1,BorderSizePixel=0,Text=
tostring(properties.distanceText or'42m'),TextSize=12,TextTransparency=0,
TextStrokeColor3=Color3.new(0,0,0),TextStrokeTransparency=0,TextXAlignment=Enum.
TextXAlignment.Left,ZIndex=10,Parent=self.target},{TextColor3='ContentColor',
FontFace='Font'})self.roleLabel=window:Create('TextLabel',{Position=UDim2.new(1,
3,0,0),Size=UDim2.fromOffset(100,18),BackgroundTransparency=1,BorderSizePixel=0,
Text='Murderer',TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,TextColor3=
color,TextStrokeColor3=Color3.new(0,0,0),TextStrokeTransparency=0,ZIndex=10,
Parent=self.target},{FontFace='Font'})table.insert(self._accentText,self.
roleLabel)self.weaponLabel=window:Create('TextLabel',{AnchorPoint=Vector2.new(
0.5,0),Position=UDim2.new(0.5,0,1,2),Size=UDim2.fromOffset(220,18),
BackgroundTransparency=1,BorderSizePixel=0,Text='unarmed',TextSize=13,TextColor3
=Color3.fromRGB(235,235,235),TextStrokeColor3=Color3.new(0,0,0),
TextStrokeTransparency=0,ZIndex=10,Parent=self.target},{FontFace='Font'})self.
healthText=window:Create('TextLabel',{AnchorPoint=Vector2.new(0,1),Position=
UDim2.new(1,12,1,0),Size=UDim2.fromOffset(56,16),BackgroundTransparency=1,
BorderSizePixel=0,Text=string.format('%d HP',self.health),TextSize=11,
TextXAlignment=Enum.TextXAlignment.Left,TextColor3=color,ZIndex=10,Parent=self.
target},{FontFace='Font'})table.insert(self._accentText,self.healthText)self.
dragHitbox=window:Create('TextButton',{Size=UDim2.fromScale(1,1),
BackgroundTransparency=1,BorderSizePixel=0,Text='',AutoButtonColor=false,Active=
true,ZIndex=11,Parent=self.target})window:ConnectFor(self,self.dragHitbox.
InputBegan,function(input)if input.UserInputType~=Enum.UserInputType.
MouseButton1 and input.UserInputType~=Enum.UserInputType.MouseButton2 and input.
UserInputType~=Enum.UserInputType.Touch then return end self._dragging=true self
._dragStart=input.Position self._dragYaw=self._yaw self._dragPan=self._pan self.
_dragMode=if input.UserInputType==Enum.UserInputType.MouseButton2 or variables.
userInputService:IsKeyDown(Enum.KeyCode.LeftShift)then'pan'else'rotate'end)
window:ConnectFor(self,self.dragHitbox.MouseEnter,function()self._hovered=true
end)window:ConnectFor(self,self.dragHitbox.MouseLeave,function()self._hovered=
false end)window:ConnectFor(self,variables.userInputService.InputChanged,
function(input)if input.UserInputType==Enum.UserInputType.MouseWheel and self.
_hovered then self._zoom=math.clamp(self._zoom+input.Position.Z*0.08,0.72,1.45)
self:_updateAvatarView()return end if not self._dragging then return end if
input.UserInputType~=Enum.UserInputType.MouseMovement and input.UserInputType~=
Enum.UserInputType.Touch then return end local delta=input.Position-self.
_dragStart if self._dragMode=='pan'then self._pan=Vector2.new(math.clamp(self.
_dragPan.X+delta.X/70,-1.15,1.15),math.clamp(self._dragPan.Y-delta.Y/70,-1.15,
1.15))else self._yaw=self._dragYaw-delta.X*0.65 end self:_updateAvatarView()end)
window:ConnectFor(self,variables.userInputService.InputEnded,function(input)if
input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==
Enum.UserInputType.MouseButton2 or input.UserInputType==Enum.UserInputType.Touch
then self._dragging=false end end)self:_loadAvatar()self:_applyBoxStyle()self:
_applyFeatures()return self end function ESPPreview:_projectSkeletonPoint(
position)local size=self.target.AbsoluteSize local width=size.X>0 and size.X or
103 local height=size.Y>0 and size.Y or 188 local cameraPoint=self.camera.CFrame
:PointToObjectSpace(position)local depth=-cameraPoint.Z if depth<=0.01 then
return nil end local focalLength=height*0.5/math.tan(math.rad(self.camera.
FieldOfView*0.5))return Vector2.new(width*0.5+cameraPoint.X*focalLength/depth,
height*0.5-cameraPoint.Y*focalLength/depth)end function ESPPreview:
_updateSkeletonPreview()local model=self._avatarModel if not(model and model.
Parent and self.features.skeleton)then for _,line in self._skeletonLines do line
.Visible=false end return end for index,bone in previewR15Bones do local first=
model:FindFirstChild(bone[1])local second=model:FindFirstChild(bone[2])local
line=self._skeletonLines[index]if first and second and first:IsA('BasePart')and
second:IsA('BasePart')then local from=self:_projectSkeletonPoint(first.Position)
local to=self:_projectSkeletonPoint(second.Position)if from and to then local
delta=to-from line.Position=UDim2.fromOffset((from.X+to.X)*0.5,(from.Y+to.Y)*0.5
)line.Size=UDim2.fromOffset(delta.Magnitude,1)line.Rotation=math.deg(math.atan2(
delta.Y,delta.X))line.Visible=true continue end end line.Visible=false end end
function ESPPreview:_updateAvatarView()if not self._avatarModel or not self.
_avatarModel.Parent then return end local offset=Vector3.new(self._pan.X,self.
_pan.Y,0)self._avatarModel:PivotTo(CFrame.new(self._avatarBasePosition+offset)*
CFrame.Angles(0,math.rad(self._yaw),0))local targetY=(self._avatarSize and self.
_avatarSize.Y or 5)*0.04 local distance=(self._cameraDistance or 8)/self._zoom
self.camera.CFrame=CFrame.lookAt(Vector3.new(0,targetY,distance),Vector3.new(0,
targetY,0))self:_updateSkeletonPreview()end function ESPPreview:_loadAvatar()
local player=variables.localPlayer if not player then return end task.spawn(
function()local character=player.Character or player.CharacterAdded:Wait()if not
character or not self.worldModel.Parent then return end local oldArchivable=
character.Archivable local cloned local ok=pcall(function()character.Archivable=
true cloned=character:Clone()end)character.Archivable=oldArchivable if not ok or
not cloned or not self.worldModel.Parent then return end stripAvatarScripts(
cloned)cloned.Parent=self.worldModel cloned:PivotTo(CFrame.new())local
bodyCenterY,bodyHeight=bodyVerticalBounds(cloned)cloned:PivotTo(CFrame.new(0,-
bodyCenterY,0))self._avatarModel=cloned self._avatarBasePosition=cloned:
GetPivot().Position self._avatarSize=Vector3.new(0,bodyHeight,0)self.
_cameraDistance=math.max((bodyHeight/2)/math.tan(math.rad(self.camera.
FieldOfView/2))*1.04,5)self:_updateAvatarView()self.fallback.Visible=false self.
fallbackHead.Visible=false for _,child in self.target:GetChildren()do if child:
IsA('Frame')and child~=self.boxLayer and child~=self.healthLayer then if child.
Position.Y.Offset>=110 and child.Size.X.Offset==10 then child.Visible=false end
end end end)end function ESPPreview:_applyFeatures()self.boxLayer.Visible=self.
features.box and not self.features.kirk self.fillLayer.Visible=self.features.box
and self.features.fill self.kirkImage.Visible=self.features.kirk and self.
kirkImage.Image~=''self.nameLabel.Visible=self.features.name self.distanceLabel.
Visible=self.features.distance self.healthLayer.Visible=self.features.health
self.healthText.Visible=self.features.health self.roleLabel.Visible=self.
features.role self.weaponLabel.Visible=self.features.weapon self.skeletonLayer.
Visible=self.features.skeleton self:_updateSkeletonPreview()end function
ESPPreview:SetKirkImage(asset)if type(asset)~='string'or asset==''then return
end self.kirkImage.Image=asset self:_applyFeatures()end function ESPPreview:
_applyBoxStyle()local style=self.boxStyle local corners=style=='corners'or style
=='corner'for _,object in self._boxBrackets do object.Visible=corners end self.
fullBox.Visible=not corners self.fullBoxOutline.Visible=not corners self.
fullBoxCorner.CornerRadius=UDim.new(0,if style=='rounded'then 8 else 0)end
function ESPPreview:SetFeature(feature,enabled)local key=string.lower(tostring(
feature)):gsub('[^%w]','')local aliases={boxes='box',nametag='name',nametags=
'name',healthbar='health',healthbars='health'}key=aliases[key]or key if self.
features[key]==nil then return end self.features[key]=enabled==true self:
_applyFeatures()end function ESPPreview:SetColor(color)if typeof(color)~=
'Color3'then return end self.color=color for _,object in self._accentFrames do
object.BackgroundColor3=color end for _,object in self._accentText do object.
TextColor3=color end self.fullBoxStroke.Color=color end function ESPPreview:
SetBoxStyle(style)self.boxStyle=string.lower(tostring(style or'Corners'))self:
_applyBoxStyle()end function ESPPreview:SetBoxThickness(value)local thickness=
math.clamp(math.floor((tonumber(value)or 1)+0.5),1,3)for index,object in self.
_boxBrackets do object.Size=if index%2==1 then UDim2.fromOffset(26,thickness)
else UDim2.fromOffset(thickness,38)end self.fullBoxStroke.Thickness=thickness
self.fullBoxOutlineStroke.Thickness=thickness+2 end function ESPPreview:
SetFillTransparency(value)self.fillLayer.BackgroundTransparency=math.clamp(
tonumber(value)or 0.8,0,1)end function ESPPreview:SetTextSize(value)local size=
math.clamp(math.floor((tonumber(value)or 13)+0.5),10,18)self.nameLabel.TextSize=
size self.distanceLabel.TextSize=math.max(11,size-1)self.healthText.TextSize=
math.max(11,size-2)end function ESPPreview:SetNameType(nameType)local player=
variables.localPlayer if not player then return end self.nameLabel.Text=if
string.lower(tostring(nameType))=='display name'then player.DisplayName else
player.Name end function ESPPreview:SetHealth(value)self.health=math.clamp(
tonumber(value)or self.health,0,100)self.healthFill.Size=UDim2.fromScale(1,self.
health/100)self.healthText.Text=string.format('%d HP',self.health)end function
ESPPreview:ResetView()self._yaw=180 self._pan=Vector2.zero self._zoom=1 self:
_updateAvatarView()end function ESPPreview:ResetPosition()self:ResetView()end
function ESPPreview:_captureFadeTargets()self._fadeTargets=self._fadeTargets or{
}self._fadeSeen=self._fadeSeen or{}local function capture(instance,property)
local properties=self._fadeSeen[instance]if not properties then properties={}
self._fadeSeen[instance]=properties end if properties[property]then return end
local ok,value=pcall(function()return instance[property]end)if ok and type(value
)=='number'and value<1 then properties[property]=true table.insert(self.
_fadeTargets,{instance=instance,property=property,shown=value})end end local
descendants={self.main}for _,descendant in self.main:GetDescendants()do table.
insert(descendants,descendant)end for _,descendant in descendants do if
descendant:IsA('UIStroke')then capture(descendant,'Transparency')elseif
descendant:IsA('GuiObject')then capture(descendant,'BackgroundTransparency')if
descendant:IsA('TextLabel')or descendant:IsA('TextButton')or descendant:IsA(
'TextBox')then capture(descendant,'TextTransparency')end if descendant:IsA(
'ImageLabel')or descendant:IsA('ImageButton')or descendant:IsA('ViewportFrame')
then capture(descendant,'ImageTransparency')end end end end function ESPPreview:
_applyFade(shown,animate)local tweenInfo=TweenInfo.new(0.16,Enum.EasingStyle.
Quint,Enum.EasingDirection.Out)for _,target in self._fadeTargets do local
instance=target.instance if instance and instance.Parent then local goal=if
shown then target.shown else 1 if animate then variables.tweenService:Create(
instance,tweenInfo,{[target.property]=goal}):Play()else instance[target.property
]=goal end end end end function ESPPreview:_setShown(shown,animate)self.
_revealToken=(self._revealToken or 0)+1 local token=self._revealToken self:
_captureFadeTargets()self._shown=shown self.main.Visible=true self.revealScale.
Scale=1 self.fadeCover.Visible=false self:_applyFade(shown,animate==true)if not
shown then if animate then task.delay(0.17,function()if self._revealToken==token
and self.main.Parent then self.main.Visible=false end end)else self.main.Visible
=false end end end moveable(ESPPreview)return ESPPreview end end function
__DARKLUA_BUNDLE_MODULES.j():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES
.cache.j if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.j=v end
return v.c end end do local function __modImpl()return function(script,require)
local Group={}Group.__index=Group Group.__type='Group'local moveable=require(
script.Parent.Parent.utility.moveable)local log=require(script.Parent.Parent.
utility.log)local assignOrder=require(script.Parent.Parent.utility.ordering)
local elementPadding=8 local compactCapable={button=true,toggle=true,stat=true,
slider=true}function Group.new(tab,properties)properties=if typeof(properties)==
'table'then properties else{}local dir=string.lower(properties.direction or
properties.Direction or'row')local vertical=dir=='column'or dir=='vertical'local
horizontal=not vertical local direction=if horizontal then Enum.FillDirection.
Horizontal else Enum.FillDirection.Vertical local self=setmetatable({tab=assert(
tab,'Missing argument #1 (Tab expected)'),window=tab.window,direction=direction,
compact=horizontal,forgetState=tab.forgetState,elements={}},Group)local
nestedInRow=tab.direction==Enum.FillDirection.Horizontal self.main=self.window:
Create('Frame',{Name='Group',BackgroundTransparency=1,BorderSizePixel=0,
AutomaticSize=Enum.AutomaticSize.Y,Size=if horizontal then UDim2.new(1,-20,0,0)
else UDim2.new(1,0,0,0),Parent=self.tab.tabPage})if nestedInRow then self.main.
Size=UDim2.new(0,0,0,0)self.window:Create('UIFlexItem',{FlexMode=Enum.UIFlexMode
.Fill,Parent=self.main})end self.tabPage=self.main self.layout=self.window:
Create('UIListLayout',{FillDirection=direction,SortOrder=Enum.SortOrder.
LayoutOrder,Padding=UDim.new(0,elementPadding),VerticalAlignment=if horizontal
then Enum.VerticalAlignment.Center else Enum.VerticalAlignment.Top,
HorizontalAlignment=if horizontal then Enum.HorizontalAlignment.Left else Enum.
HorizontalAlignment.Center,Parent=self.main})return self end function Group:_add
(componentName,properties)if self.compact and not compactCapable[componentName]
then log.warn(`Rayfield: a row only holds compact elements (button/toggle/stat/slider), ignoring '{
componentName}'. Use a column for it.`)return nil end local element=require(
script.Parent[componentName]).new(self,properties)table.insert(self.elements,
element)assignOrder(element,#self.elements*10)self.window:_restoreLate(element)
if self.compact then self:_wrapChild(element)end self:_reflowRow()if not self.
window.hidden then element:_setShown(true,true)end return element end function
Group:_reflowRow()if self.direction~=Enum.FillDirection.Horizontal then return
end local onlyGroups=#self.elements>0 for _,element in self.elements do if
element.__type~='Group'then onlyGroups=false break end end self.layout.Padding=
if onlyGroups then UDim.new(0,-10)else UDim.new(0,elementPadding)end function
Group:_wrapChild(element)self.layout.Wraps=true self.layout.HorizontalFlex=Enum.
UIFlexAlignment.Fill element._widthManaged=true local minWidth=if element.
_minWidth then element:_minWidth()else 0 if minWidth>0 then element.main.
AutomaticSize=Enum.AutomaticSize.None element.main.Size=UDim2.new(0,minWidth,
element.main.Size.Y.Scale,element.main.Size.Y.Offset)end end function Group:
CreateButton(properties)return self:_add('button',properties)end function Group:
CreateToggle(properties)return self:_add('toggle',properties)end function Group:
CreateSwitch(properties)return self:_add('toggle',properties)end function Group:
CreateStat(properties)return self:_add('stat',properties)end function Group:
CreateSlider(properties)return self:_add('slider',properties)end function Group:
CreateDropdown(properties)return self:_add('dropdown',properties)end function
Group:CreateInput(properties)return self:_add('input',properties)end function
Group:CreateKeybind(properties)return self:_add('keybind',properties)end
function Group:CreateColorPicker(properties)return self:_add('colorpicker',
properties)end function Group:CreateESPPreview(properties)return self:_add(
'esppreview',properties)end function Group:CreateSection(properties)return self:
_add('section',properties)end function Group:CreateText(properties)return self:
_add('text',properties)end function Group:CreateDivider(properties)return self:
_add('divider',properties)end function Group:_addGroup(properties)properties=if
typeof(properties)=='table'then table.clone(properties)else{}if self.direction==
Enum.FillDirection.Horizontal then self.layout.VerticalAlignment=Enum.
VerticalAlignment.Top if self.tab.direction~=Enum.FillDirection.Horizontal then
self.main.Size=UDim2.new(1,0,0,0)end end local group=Group.new(self,properties)
table.insert(self.elements,group)group.main.LayoutOrder=#self.elements*10 self:
_reflowRow()return group end function Group:CreateGroup(properties)return self:
_addGroup(properties)end function Group:_moveElement(element,targetIndex)local
idx=table.find(self.elements,element)if not idx then return end table.remove(
self.elements,idx)targetIndex=math.clamp(targetIndex,1,#self.elements+1)table.
insert(self.elements,targetIndex,element)for i,el in self.elements do
assignOrder(el,i*10)end end function Group:_setShown(shown,animate)for _,el in
self.elements do el:_setShown(shown,animate)end end function Group:_refreshTheme
()for _,el in self.elements do if el._refreshTheme then el:_refreshTheme()end
end end moveable(Group)return Group end end function __DARKLUA_BUNDLE_MODULES.k(
):typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.k if not v then v={c
=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.k=v end return v.c end end do
local function __modImpl()return function(script,require)local Input={}Input.
__index=Input Input.__type='Input'local utility=script.Parent.Parent.utility
local variables=require(utility.variables)local functions=require(utility.
functions)local moveable=require(utility.moveable)local locale=require(utility.
locale)local constants=require(utility.constants)local hapticEngine=require(
utility.HapticEngine)local resizeInfo=constants.pillResizeInfo local focusInfo=
TweenInfo.new(0.15,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)
local function parseExp(text)local a,b=text:match('^([%d%.%-]+)%^([%d%.%-]+)$')
if a and b then local na,nb=tonumber(a),tonumber(b)if na and nb then return na^
nb end end return tonumber(text)end function Input.new(tab,properties)properties
=if typeof(properties)=='table'then properties else{}local self=setmetatable({
tab=assert(tab,'Missing argument #1 (Tab expected)'),window=tab.window,name=
properties.name or properties.Name or'Input',icon=properties.icon or properties.
Icon,description=properties.description or properties.Description,forgetState=
properties.forgetState or properties.ForgetState or tab.forgetState,placeholder=
properties.placeholder or properties.Placeholder or'',numeric=properties.numeric
or properties.Numeric or false,clearOnFocus=properties.clearOnFocus or
properties.ClearOnFocus or false,submitOnEnterOnly=properties.submitOnEnterOnly
or properties.SubmitOnEnterOnly or false,flashOnCommit=properties.flashOnCommit
~=false and properties.FlashOnCommit~=false,callback=properties.callback or
properties.Callback or function()end},Input)self.value=tostring(properties.value
or properties.Value or properties.currentValue or properties.CurrentValue or'')
self.flag=properties.flag or properties.Flag or(not self.forgetState and
functions.deriveFlagFromName(self.name)or nil)self.window:_registerControl(self)
self.main=self.window:Create('Frame',{Size=UDim2.new(1,-20,0,41),BorderSizePixel
=0,Name=self.name,BackgroundColor3=Color3.fromRGB(255,255,255),
BackgroundTransparency=1,Parent=self.tab.tabPage},{BackgroundTransparency=
'ElementTransparency'})self.stroke=self.window:StyleElementBody(self.main)self.
hoverOverlay=self.window:CreateHoverOverlay(self.main)self.container=self.window
:Create('Frame',{Size=UDim2.new(0,170,0,16),Position=UDim2.new(0,20,0.5,0),
AnchorPoint=Vector2.new(0,0.5),BackgroundTransparency=1,BorderSizePixel=0,
ClipsDescendants=true,ZIndex=5,Parent=self.main})self.window:Create(
'UIListLayout',{Padding=UDim.new(0,5),FillDirection=Enum.FillDirection.
Horizontal,VerticalAlignment=Enum.VerticalAlignment.Center,Parent=self.container
})if self.icon then self.iconLabel=self.window:Create('ImageLabel',{Image=self.
icon,Size=UDim2.fromOffset(16,16),BorderSizePixel=0,BackgroundTransparency=1,
ZIndex=5,ImageTransparency=1,Parent=self.container},{ImageColor3='ContentColor'}
)end self.title=self.window:Create('TextLabel',{Text=locale.t(self.name),Size=
UDim2.new(1,0,0,16),BorderSizePixel=0,BackgroundTransparency=1,TextSize=16,
TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,
LayoutOrder=1,ZIndex=5,TextTransparency=1,Parent=self.container},{TextColor3=
'ContentColor',FontFace='Font'})self.box=self.window:Create('Frame',{AnchorPoint
=Vector2.new(1,0.5),Position=UDim2.new(1,-7,0,20),Size=UDim2.fromOffset(85,30),
BorderSizePixel=0,BackgroundTransparency=1,Parent=self.main},{BackgroundColor3=
'FieldBackground'})self.window:Create('UICorner',{CornerRadius=UDim.new(1,0),
Parent=self.box})self.boxStroke=self.window:Create('UIStroke',{Transparency=1,
Parent=self.box},{Color='SurfaceStroke'})self.glow=self.window:CreateGlow(self.
box,'FieldGlow',20,1)self._glowIdle=1 self.input=self.window:Create('TextBox',{
Text=self.value,PlaceholderText=locale.t(self.placeholder),Size=UDim2.new(1,-15,
0,15),Position=UDim2.new(0.5,0,0.5,0),AnchorPoint=Vector2.new(0.5,0.5),
BackgroundTransparency=1,BorderSizePixel=0,TextSize=15,TextXAlignment=Enum.
TextXAlignment.Center,TextTruncate=Enum.TextTruncate.AtEnd,ClearTextOnFocus=self
.clearOnFocus,TextTransparency=1,Parent=self.box},{TextColor3='ContentColor',
FontFace='Font',PlaceholderColor3='PlaceholderColor'})self.window:ConnectFor(
self,self.input:GetPropertyChangedSignal('Text'),function()if self.numeric then
local cleaned=(self.input.Text:gsub('[^%d%.%-eE%^]',''))if cleaned~=self.input.
Text then self.input.Text=cleaned return end end self:_sizeBox(true)end)self.
window:ConnectFor(self,self.main:GetPropertyChangedSignal('AbsoluteSize'),
function()self:_sizeBox(false)end)self.window:ConnectFor(self,self.input.Focused
,function()variables.tweenService:Create(self.input,focusInfo,{TextTransparency=
0}):Play()end)self.window:ConnectFor(self,self.input.FocusLost,function(
enterPressed)variables.tweenService:Create(self.input,focusInfo,{
TextTransparency=0.6}):Play()if self.submitOnEnterOnly and not enterPressed then
return end if self.clearOnFocus and self.input.Text==''and self.value~=''then
self.input.Text=self.value return end if self.input.Text==self.value then return
end self:_commit(self.input.Text)end)self.window:_wireElementHover(self)if self.
description then self.descriptor=require(script.Parent.descriptor).new(self.tab,
{description=self.description})end self:_sizeBox(false)return self end function
Input:_sizeBox(animate)local shown=self.input.Text~=''and self.input.Text or
self.placeholder local cardWidth=self.main.AbsoluteSize.X local maximum=if
cardWidth>0 then math.clamp(cardWidth-207,70,220)else 145 local width=math.
clamp(functions.textWidth(self.window.theme.Font,15,shown)+30,70,maximum)if
animate then variables.tweenService:Create(self.box,resizeInfo,{Size=UDim2.
fromOffset(width,30)}):Play()else self.box.Size=UDim2.fromOffset(width,30)end
end function Input:_commit(text,silent)text=tostring(text)if self.numeric then
local n=parseExp(text)if not n or n~=n or n==math.huge or n==-math.huge then if
self.input.Text~=self.value then self.input.Text=self.value end return end text=
tostring(n)end local changed=text~=self.value self.value=text if self.input.Text
~=text then self.input.Text=text end if not silent then self.window:_runGuarded(
self,self.callback,text)self.window:_persist(self)if changed and self.
flashOnCommit and not self.window._loading then hapticEngine.click()self.window:
_flashResult(self,true)end end end function Input:Set(value,skipCallback)self:
_commit(value,skipCallback)end function Input:_setShown(shown,animate)local w=
self.window if shown then w:_revealCommon(self,animate)w:_reveal(self.box,{
BackgroundTransparency=w.theme.FieldTransparency},animate)w:_reveal(self.
boxStroke,{Transparency=0.85},animate)w:_reveal(self.input,{TextTransparency=0.6
},animate)else w:_hideCommon(self,animate)w:_reveal(self.box,{
BackgroundTransparency=1},animate)w:_reveal(self.boxStroke,{Transparency=1},
animate)w:_reveal(self.input,{TextTransparency=1},animate)end end function Input
:_refreshTheme()variables.tweenService:Create(self.box,TweenInfo.new(0.5,Enum.
EasingStyle.Quint,Enum.EasingDirection.Out),{BackgroundTransparency=self.window.
theme.FieldTransparency}):Play()end moveable(Input)return Input end end function
__DARKLUA_BUNDLE_MODULES.l():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES
.cache.l if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.l=v end
return v.c end end do local function __modImpl()return function(script,require)
local Keybind={}Keybind.__index=Keybind Keybind.__type='Keybind'local utility=
script.Parent.Parent.utility local variables=require(utility.variables)local
functions=require(utility.functions)local moveable=require(utility.moveable)
local locale=require(utility.locale)local constants=require(utility.constants)
local hapticEngine=require(utility.HapticEngine)local enums=require(utility.
enums)local log=require(utility.log)local resizeInfo=constants.pillResizeInfo
local recordInfo=TweenInfo.new(0.25,Enum.EasingStyle.Quint,Enum.EasingDirection.
Out)local mouseNames={[Enum.UserInputType.MouseButton1]='MB1',[Enum.
UserInputType.MouseButton2]='MB2',[Enum.UserInputType.MouseButton3]='MB3'}
local function keyName(value)if typeof(value)~='EnumItem'or value==Enum.KeyCode.
Unknown then return'None'end return mouseNames[value]or value.Name end
local function coerceKey(value)if typeof(value)=='EnumItem'then return value end
if type(value)=='string'then local ok,key=pcall(function()return Enum.KeyCode[
value]end)if ok and key then return key end local mouseOk,button=pcall(function(
)return Enum.UserInputType[value]end)if mouseOk and button and mouseNames[button
]then return button end end return Enum.KeyCode.Unknown end function Keybind.new
(tab,properties)properties=if typeof(properties)=='table'then properties else{}
local self=setmetatable({tab=assert(tab,'Missing argument #1 (Tab expected)'),
window=tab.window,name=properties.name or properties.Name or'Keybind',icon=
properties.icon or properties.Icon,description=properties.description or
properties.Description,forgetState=properties.forgetState or properties.
ForgetState or tab.forgetState,isMenuToggle=properties.isMenuToggle or
properties.IsMenuToggle or false,callback=properties.callback or properties.
Callback or function()end,onChanged=properties.onChanged or properties.OnChanged
or function()end,hold=properties.hold or properties.Hold or false,holdThreshold=
properties.holdThreshold or properties.HoldThreshold or 0.2,recording=false},
Keybind)self.value=coerceKey(properties.value or properties.Value or properties.
default or properties.Default)self.flag=properties.flag or properties.Flag or(
not self.forgetState and functions.deriveFlagFromName(self.name)or nil)self.
window:_registerControl(self)self.main=self.window:Create('Frame',{Size=UDim2.
new(1,-20,0,41),BorderSizePixel=0,Name=self.name,BackgroundColor3=Color3.
fromRGB(255,255,255),BackgroundTransparency=1,Parent=self.tab.tabPage},{
BackgroundTransparency='ElementTransparency'})self.stroke=self.window:
StyleElementBody(self.main)self.hoverOverlay=self.window:CreateHoverOverlay(self
.main)self.container=self.window:Create('Frame',{Size=UDim2.new(0,170,0,16),
Position=UDim2.new(0,20,0.5,0),AnchorPoint=Vector2.new(0,0.5),
BackgroundTransparency=1,BorderSizePixel=0,ZIndex=5,Parent=self.main})self.
window:Create('UIListLayout',{Padding=UDim.new(0,5),FillDirection=Enum.
FillDirection.Horizontal,VerticalAlignment=Enum.VerticalAlignment.Center,Parent=
self.container})if self.icon then self.iconLabel=self.window:Create('ImageLabel'
,{Image=self.icon,Size=UDim2.fromOffset(16,16),BorderSizePixel=0,
BackgroundTransparency=1,ZIndex=5,ImageTransparency=1,Parent=self.container},{
ImageColor3='ContentColor'})end self.title=self.window:Create('TextLabel',{Text=
locale.t(self.name),Size=UDim2.fromOffset(150,16),AutomaticSize=Enum.
AutomaticSize.X,BorderSizePixel=0,BackgroundTransparency=1,TextSize=16,
TextXAlignment=Enum.TextXAlignment.Left,LayoutOrder=1,ZIndex=5,TextTransparency=
1,Parent=self.container},{TextColor3='ContentColor',FontFace='Font'})self.box=
self.window:Create('TextButton',{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.
new(1,-7,0,20),Size=UDim2.fromOffset(40,30),AutoButtonColor=false,Text='',
BorderSizePixel=0,BackgroundTransparency=1,Parent=self.main},{BackgroundColor3=
'FieldBackground'})self.window:Create('UICorner',{CornerRadius=UDim.new(1,0),
Parent=self.box})self.boxStroke=self.window:Create('UIStroke',{Transparency=1,
Parent=self.box},{Color='SurfaceStroke'})self.glow=self.window:CreateGlow(self.
box,'FieldGlow',20,1)self._glowIdle=0.9 self.keyLabel=self.window:Create(
'TextLabel',{Text=keyName(self.value),Size=UDim2.fromScale(1,1),
BackgroundTransparency=1,BorderSizePixel=0,TextSize=15,TextXAlignment=Enum.
TextXAlignment.Center,ZIndex=2,TextTransparency=1,Parent=self.box},{TextColor3=
'ContentColor',FontFace='Font'})self.window:ConnectFor(self,self.box.
MouseButton1Click,function()hapticEngine.click()if self.recording then self:
_stopRecording()else self:_startRecording()end end)self.window:ConnectFor(self,
variables.userInputService.InputBegan,function(input,processed)if processed then
return end if self.recording then self:_capture(input)return end if self.window.
_recordingKeybind then return end if self:_matches(input)then if self.hold then
self:_beginHold(input)else self.window:_runGuarded(self,self.callback,self.value
)end end end)self.window:_wireElementHover(self)if self.description then self.
descriptor=require(script.Parent.descriptor).new(self.tab,{description=self.
description})end self:_sizeBox(false)return self end function Keybind:_sizeBox(
animate)local width=math.clamp(functions.textWidth(self.window.theme.Font,15,
self.keyLabel.Text)+28,40,200)if animate then variables.tweenService:Create(self
.box,resizeInfo,{Size=UDim2.fromOffset(width,30)}):Play()else self.box.Size=
UDim2.fromOffset(width,30)end end function Keybind:_startRecording()local
current=self.window._recordingKeybind if current and current~=self then current:
_stopRecording()end self.recording=true self.window._recordingKeybind=self self.
keyLabel.Text=locale.resolve('Recording')self:_sizeBox(true)variables.
tweenService:Create(self.glow,recordInfo,{Transparency=0.7}):Play()variables.
tweenService:Create(self.keyLabel,recordInfo,{TextTransparency=0}):Play()end
function Keybind:_stopRecording()self.recording=false if self.window.
_recordingKeybind==self then local window=self.window task.defer(function()if
window._recordingKeybind==self then window._recordingKeybind=nil end end)end
self.keyLabel.Text=keyName(self.value)self:_sizeBox(true)variables.tweenService:
Create(self.glow,recordInfo,{Transparency=0.9}):Play()variables.tweenService:
Create(self.keyLabel,recordInfo,{TextTransparency=0.6}):Play()end function
Keybind:_capture(input)local key if input.UserInputType==Enum.UserInputType.
Keyboard then if input.KeyCode==Enum.KeyCode.Escape then self:_stopRecording()
return end if input.KeyCode==Enum.KeyCode.Backspace then self:_bind(Enum.KeyCode
.Unknown)return end key=input.KeyCode elseif input.UserInputType==Enum.
UserInputType.MouseButton2 or input.UserInputType==Enum.UserInputType.
MouseButton3 then key=input.UserInputType end if not key then return end if self
.isMenuToggle then local clash=self.window:_keybindUsing(key,self)if clash then
self.window:Notify({title=locale.resolve('Keybind unavailable'),content=string.
format(locale.resolve('%s is bound to %s. Kept %s.'),keyName(key),clash.name,
keyName(self.value))})self:_stopRecording()self.window:_flashResult(self,false)
return end elseif key==self.window.settings.toggleKeybind then self.window:
Notify({title=locale.resolve('Keybind unavailable'),content=string.format(locale
.resolve('%s is the menu toggle key. Kept %s.'),keyName(key),keyName(self.value)
)})self:_stopRecording()self.window:_flashResult(self,false)return end self:
_bind(key)end function Keybind:_bind(key)self.value=key self:_stopRecording()
self.window:_runGuarded(self,self.onChanged,key)self.window:_persist(self)self.
window:_flashResult(self,true)end function Keybind:_matches(input)local v=self.
value if typeof(v)~='EnumItem'or v==Enum.KeyCode.Unknown then return false end
if v.EnumType==Enum.KeyCode then return input.KeyCode==v elseif v.EnumType==Enum
.UserInputType then return input.UserInputType==v end return false end function
Keybind:_beginHold(input)if self._holding or self._holdPress then return end
local press={}self._holdPress=press local heldKeyCode=input.KeyCode local
heldInputType=input.UserInputType task.delay(self.holdThreshold,function()if
self._holdPress~=press then return end self._holding=true self.window:
_runGuarded(self,self.callback,true)end)local conn conn=self.window:ConnectFor(
self,variables.userInputService.InputEnded,function(ended)local released=if
heldKeyCode~=Enum.KeyCode.Unknown then ended.KeyCode==heldKeyCode else ended.
UserInputType==heldInputType if not released then return end if self.connections
then local index=table.find(self.connections,conn)if index then table.remove(
self.connections,index)end end self.window:Disconnect(conn)if self._holdPress==
press then self._holdPress=nil end if self._holding then self._holding=false
self.window:_runGuarded(self,self.callback,false)end end)end function Keybind:
Set(value,skipChanged)local key=coerceKey(value)if key~=Enum.KeyCode.Unknown
then if self.isMenuToggle then local clash=self.window:_keybindUsing(key,self)if
clash then log.warn('Rayfield: '..keyName(key).." is bound to '"..tostring(clash
.name).."'; kept "..keyName(self.value))return end elseif key==self.window.
settings.toggleKeybind then log.warn('Rayfield: '..keyName(key)..
' is the menu toggle key; kept '..keyName(self.value))return end end self.value=
key if self.recording then self:_stopRecording()else self.keyLabel.Text=keyName(
self.value)self:_sizeBox(true)end if not skipChanged then self.window:
_runGuarded(self,self.onChanged,self.value)self.window:_persist(self)end end
function Keybind:_serialize()return{tostring(self.value.EnumType),self.value.
Value}end function Keybind:_deserialize(raw)local enumName=tostring(raw[1]):
gsub('^Enum%.','')local enumOk,enumType=pcall(function()return Enum[enumName]end
)if not enumOk or not enumType then return end local item=enums.itemFromValue(
enumType,raw[2])if item then self:Set(item)end end function Keybind:_setShown(
shown,animate)local w=self.window if shown then w:_revealCommon(self,animate)w:
_reveal(self.box,{BackgroundTransparency=w.theme.FieldTransparency},animate)w:
_reveal(self.boxStroke,{Transparency=0.85},animate)w:_reveal(self.keyLabel,{
TextTransparency=0.6},animate)w:_reveal(self.glow,{Transparency=0.9},animate)
else w:_hideCommon(self,animate)w:_reveal(self.box,{BackgroundTransparency=1},
animate)w:_reveal(self.boxStroke,{Transparency=1},animate)w:_reveal(self.
keyLabel,{TextTransparency=1},animate)w:_reveal(self.glow,{Transparency=1},
animate)end end function Keybind:_refreshTheme()variables.tweenService:Create(
self.box,TweenInfo.new(0.5,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{
BackgroundTransparency=self.window.theme.FieldTransparency}):Play()end moveable(
Keybind)return Keybind end end function __DARKLUA_BUNDLE_MODULES.m():typeof(
__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.m if not v then v={c=
__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.m=v end return v.c end end do
local function __modImpl()return function(script,require)local Notification={}
Notification.__index=Notification Notification.__type='Notification'local
utility=script.Parent.Parent.utility local variables=require(utility.variables)
local functions=require(utility.functions)local constants=require(utility.
constants)local hapticEngine=require(utility.HapticEngine)local growInfo=
TweenInfo.new(0.6,Enum.EasingStyle.Exponential,Enum.EasingDirection.Out)local
fadeLong=TweenInfo.new(0.4,Enum.EasingStyle.Exponential,Enum.EasingDirection.Out
)local fadeShort=TweenInfo.new(0.3,Enum.EasingStyle.Exponential,Enum.
EasingDirection.Out)local swipeInInfo=TweenInfo.new(0.6,Enum.EasingStyle.
Exponential,Enum.EasingDirection.Out)local shrinkInfo=TweenInfo.new(0.9,Enum.
EasingStyle.Exponential,Enum.EasingDirection.Out)local offscreenRight=UDim2.new(
0.5,360,0.5,0)local centred=UDim2.new(0.5,0,0.5,0)local maxLive=6 local
stackPadding=8 local function autoDuration(content)return math.clamp(#content*
0.06+3,3,9)end function Notification.new(window,properties)properties=if typeof(
properties)=='table'then properties else{}local self=setmetatable({window=
assert(window,'Missing argument #1 (Window expected)'),title=properties.title or
properties.Title or'Notification',content=properties.content or properties.
Content or'',icon=properties.icon or properties.Icon,_hovered=false,_dismissed=
false},Notification)self.duration=properties.duration or properties.Duration or
autoDuration(self.content)local hasIcon=self.icon~=nil and self.icon~=0 and self
.icon~=''self.main=self.window:Create('Frame',{Name='Notification',
BackgroundTransparency=1,Size=UDim2.new(1,0,0,0),BorderSizePixel=0,ZIndex=
constants.zIndex.notification,Parent=self.window.notifications})self.window:
Create('UIPadding',{PaddingTop=UDim.new(0,stackPadding),Parent=self.main})self.
body=self.window:Create('Frame',{BackgroundColor3=Color3.fromRGB(255,255,255),
Size=UDim2.new(1,0,1,0),Position=offscreenRight,AnchorPoint=Vector2.new(0.5,0.5)
,Active=true,BorderSizePixel=0,ZIndex=constants.zIndex.notification,
BackgroundTransparency=1,Parent=self.main})self.window:Create('UIGradient',{
Rotation=270,Offset=Vector2.new(0,-0.1),Parent=self.body},{Color={'WindowColor',
functions.toColorSequence}})self.window:Create('UICorner',{Parent=self.body},{
CornerRadius='CornerRoundness'})self.stroke=self.window:Create('UIStroke',{
Transparency=1,Parent=self.body},{Color='SurfaceStroke'})self.shadow=self.window
:CreateGlow(self.body,'ShadowColor',20,1)self.window:Create('UIPadding',{
PaddingLeft=UDim.new(0,20),PaddingRight=UDim.new(0,20),Parent=self.body})self.
window:Create('UIListLayout',{FillDirection=Enum.FillDirection.Horizontal,
VerticalAlignment=Enum.VerticalAlignment.Center,HorizontalAlignment=Enum.
HorizontalAlignment.Left,SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0
,14),Parent=self.body})if hasIcon then self.iconLabel=self.window:Create(
'ImageLabel',{Image=self.icon,Size=UDim2.fromOffset(24,24),
BackgroundTransparency=1,BorderSizePixel=0,LayoutOrder=1,ZIndex=constants.zIndex
.notification,ImageTransparency=1,Parent=self.body},{ImageColor3='ContentColor'}
)end self.container=self.window:Create('Frame',{Size=UDim2.fromOffset(hasIcon
and 222 or 260,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,
BorderSizePixel=0,LayoutOrder=2,ZIndex=constants.zIndex.notification,Parent=self
.body})self.window:Create('UIListLayout',{FillDirection=Enum.FillDirection.
Vertical,SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,4),Parent=self.
container})self.titleLabel=self.window:Create('TextLabel',{Text=self.title,Size=
UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,
TextSize=16,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,LayoutOrder
=1,ZIndex=constants.zIndex.notification,TextTransparency=1,Parent=self.container
},{TextColor3='ContentColor',FontFace='TitleFont'})if self.content~=''then self.
descriptionLabel=self.window:Create('TextLabel',{Text=self.content,Size=UDim2.
new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,
TextSize=15,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,
TextYAlignment=Enum.TextYAlignment.Top,LayoutOrder=2,ZIndex=constants.zIndex.
notification,TextTransparency=1,Parent=self.container},{TextColor3=
'ContentColor',FontFace='Font'})end self.window._notificationCount=(self.window.
_notificationCount or 0)+1 self.main.LayoutOrder=self.window._notificationCount
local live=self.window._liveNotifications if not live then live={}self.window.
_liveNotifications=live end table.insert(live,self)while#live>maxLive do local
oldest=table.remove(live,1)if oldest and oldest~=self then task.spawn(oldest.
_dismiss,oldest)end end self._connections={self.window:Connect(self.body.
MouseEnter,function()self._hovered=true end),self.window:Connect(self.body.
MouseLeave,function()self._hovered=false end),self.window:Connect(self.body.
InputBegan,function(input)if input.UserInputType==Enum.UserInputType.
MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then self:
_dismiss()end end)}task.spawn(function()self:_show()end)return self end function
Notification:_measure()local colWidth=self.iconLabel and 222 or 260 local
contentH=functions.textHeight(self.window.theme.TitleFont,16,self.title,colWidth
)if self.descriptionLabel then contentH=contentH+4+functions.textHeight(self.
window.theme.Font,15,self.content,colWidth)end return math.max(contentH,self.
iconLabel and 24 or 0)+28 end function Notification:_show()local target=self:
_measure()+stackPadding if self._dismissed or not self.main.Parent then return
end hapticEngine.notify()variables.tweenService:Create(self.main,growInfo,{Size=
UDim2.new(1,0,0,target)}):Play()variables.tweenService:Create(self.body,
swipeInInfo,{Position=centred}):Play()variables.tweenService:Create(self.body,
fadeLong,{BackgroundTransparency=0}):Play()variables.tweenService:Create(self.
titleLabel,fadeShort,{TextTransparency=0}):Play()variables.tweenService:Create(
self.stroke,fadeLong,{Transparency=0.95}):Play()variables.tweenService:Create(
self.shadow,fadeShort,{Transparency=0.6}):Play()task.wait(0.05)if self.
_dismissed or not self.main.Parent then return end if self.iconLabel then
variables.tweenService:Create(self.iconLabel,fadeShort,{ImageTransparency=0}):
Play()end task.wait(0.05)if self._dismissed or not self.main.Parent then return
end if self.descriptionLabel then variables.tweenService:Create(self.
descriptionLabel,fadeShort,{TextTransparency=0.35}):Play()end local elapsed=0
while elapsed<self.duration and not self._dismissed and self.main.Parent do
local dt=task.wait()if not self._hovered then elapsed+=dt end end self:_dismiss(
)end function Notification:_dismiss()if self._dismissed then return end self.
_dismissed=true local live=self.window._liveNotifications local index=live and
table.find(live,self)if live and index then table.remove(live,index)end if not
self.main.Parent then return end variables.tweenService:Create(self.body,
fadeLong,{BackgroundTransparency=1}):Play()variables.tweenService:Create(self.
stroke,fadeLong,{Transparency=1}):Play()variables.tweenService:Create(self.
shadow,fadeShort,{Transparency=1}):Play()variables.tweenService:Create(self.
titleLabel,fadeShort,{TextTransparency=1}):Play()if self.descriptionLabel then
variables.tweenService:Create(self.descriptionLabel,fadeShort,{TextTransparency=
1}):Play()end if self.iconLabel then variables.tweenService:Create(self.
iconLabel,fadeShort,{ImageTransparency=1}):Play()end variables.tweenService:
Create(self.body,shrinkInfo,{Size=UDim2.new(1,-90,1,0)}):Play()local collapse=
variables.tweenService:Create(self.main,shrinkInfo,{Size=UDim2.new(1,0,0,0)})
collapse:Play()collapse.Completed:Wait()if not self.main.Parent then return end
for _,connection in self._connections do self.window:Disconnect(connection)end
self.window:DestroySubtree(self.main)end return Notification end end function
__DARKLUA_BUNDLE_MODULES.n():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES
.cache.n if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.n=v end
return v.c end end do local function __modImpl()return function(script,require)
local Popup={}Popup.__index=Popup Popup.__type='Popup'local utility=script.
Parent.Parent.utility local variables=require(utility.variables)local functions=
require(utility.functions)local constants=require(utility.constants)local locale
=require(utility.locale)local log=require(utility.log)local hapticEngine=
require(utility.HapticEngine)local enterInfo=TweenInfo.new(0.5,Enum.EasingStyle.
Exponential,Enum.EasingDirection.Out)local fadeLong=TweenInfo.new(0.4,Enum.
EasingStyle.Exponential,Enum.EasingDirection.Out)local fadeShort=TweenInfo.new(
0.3,Enum.EasingStyle.Exponential,Enum.EasingDirection.Out)local backdropInfo=
TweenInfo.new(0.35,Enum.EasingStyle.Exponential,Enum.EasingDirection.Out)local
cardWidth=400 local sidePadding=22 local topPadding=24 local bottomPadding=22
local regionGap=16 local innerWidth=cardWidth-sidePadding*2 local titleSize=18
local subtitleSize=14 local contentSize=15 local headerIconSize=16 local
headerIconGap=12 local maxContentHeight=300 local contentInset=4 local
contentWidth=innerWidth-contentInset*2 local boxSidePad=16 local boxVerticalPad=
13 local boxIconSize=20 local boxIconGap=10 local boxTitleSize=15 local
boxDescSize=14 local boxGap=8 local boxWidthInset=10 local buttonHeight=40 local
buttonGap=8 local buttonCorner=UDim.new(1,0)local buttonTextSize=16 local
backdropShown=0.5 local stack={}local consumedEscape=nil local function topmost(
popup)for index=#stack,1,-1 do local open=stack[index]if open._closed or not
open.screenGui.Parent then table.remove(stack,index)end end return stack[#stack]
==popup end function Popup.new(window,properties)properties=if typeof(properties
)=='table'then properties else{}local self=setmetatable({window=assert(window,
'Missing argument #1 (Window expected)'),title=properties.title or properties.
Title or'Popup',subtitle=properties.subtitle or properties.Subtitle,content=
properties.content or properties.Content,icon=properties.icon or properties.Icon
,boxes=properties.boxes or properties.Boxes,options=properties.options or
properties.Options,dismissable=if properties.dismissable~=nil then properties.
dismissable elseif properties.Dismissable~=nil then properties.Dismissable else
true,_reveal={},_connections={},_closed=false},Popup)if not self.options or#self
.options==0 then self.options={{text='Okay'}}end self:_build()table.insert(stack
,self)task.spawn(function()self:_show()end)return self end function Popup:_fade(
instance,prop,to)table.insert(self._reveal,{instance=instance,prop=prop,to=to})
return instance end function Popup:_build()local window=self.window local
hasIcon=self.icon~=nil and self.icon~=0 and self.icon~=''self.screenGui=window:
Create('ScreenGui',{Name=variables.httpService:GenerateGUID(false),
IgnoreGuiInset=true,ResetOnSpawn=false,Enabled=true,DisplayOrder=constants.
displayOrder.popup,ZIndexBehavior=Enum.ZIndexBehavior.Global,Parent=variables.
guiContainer})self.backdrop=window:Create('Frame',{Name='Backdrop',
BackgroundColor3=Color3.fromRGB(0,0,0),BorderSizePixel=0,Size=UDim2.fromScale(1,
1),Active=true,BackgroundTransparency=1,Parent=self.screenGui})self:_fade(self.
backdrop,'BackgroundTransparency',backdropShown)self.card=window:Create('Frame',
{Name='Card',BackgroundColor3=Color3.fromRGB(255,255,255),AnchorPoint=Vector2.
new(0.5,0.5),Position=UDim2.new(0.5,0,0.5,14),Size=UDim2.fromOffset(cardWidth,0)
,AutomaticSize=Enum.AutomaticSize.Y,Active=true,BorderSizePixel=0,
BackgroundTransparency=1,Parent=self.screenGui})self:_fade(self.card,
'BackgroundTransparency',0)window:Create('UIGradient',{Rotation=270,Offset=
Vector2.new(0,-0.1),Parent=self.card},{Color={'WindowColor',functions.
toColorSequence}})window:Create('UICorner',{Parent=self.card},{CornerRadius=
'CornerRoundness'})self.cardStroke=window:Create('UIStroke',{Transparency=1,
Parent=self.card},{Color='SurfaceStroke'})self:_fade(self.cardStroke,
'Transparency',0.95)self.cardShadow=window:CreateGlow(self.card,'ShadowColor',26
,1)self:_fade(self.cardShadow,'Transparency',0.55)window:Create('UIPadding',{
PaddingLeft=UDim.new(0,sidePadding),PaddingRight=UDim.new(0,sidePadding),
PaddingTop=UDim.new(0,topPadding),PaddingBottom=UDim.new(0,bottomPadding),Parent
=self.card})window:Create('UIListLayout',{FillDirection=Enum.FillDirection.
Vertical,HorizontalAlignment=Enum.HorizontalAlignment.Center,SortOrder=Enum.
SortOrder.LayoutOrder,Padding=UDim.new(0,regionGap),Parent=self.card})local
headerHeight=self:_measureHeader(hasIcon)self:_buildHeader(hasIcon,headerHeight)
local contentHeight=self:_buildContent()self:_buildFooter()local regions=2+(
contentHeight>0 and 1 or 0)local cardHeight=topPadding+headerHeight+
contentHeight+buttonHeight+bottomPadding+regionGap*(regions-1)self.card.Size=
UDim2.fromOffset(cardWidth,cardHeight)self.card.AutomaticSize=Enum.AutomaticSize
.None if self.dismissable then table.insert(self._connections,window:Connect(
self.backdrop.InputBegan,function(input)if input.UserInputType==Enum.
UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
self:Close()end end))table.insert(self._connections,window:Connect(variables.
userInputService.InputBegan,function(input,processed)if not processed and input.
KeyCode==Enum.KeyCode.Escape and topmost(self)then if input==consumedEscape then
return end consumedEscape=input self:Close()end end))end end function Popup:
_buildHeader(hasIcon,headerHeight)local window=self.window local header=window:
Create('Frame',{Name='Header',BackgroundTransparency=1,Size=UDim2.new(1,0,0,
headerHeight),LayoutOrder=1,Parent=self.card})window:Create('UIListLayout',{
FillDirection=Enum.FillDirection.Horizontal,VerticalAlignment=Enum.
VerticalAlignment.Center,HorizontalAlignment=Enum.HorizontalAlignment.Left,
SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,headerIconGap),Parent=
header})if hasIcon then self:_fade(window:Create('ImageLabel',{Image=self.icon,
Size=UDim2.fromOffset(headerIconSize,headerIconSize),BackgroundTransparency=1,
BorderSizePixel=0,LayoutOrder=1,ImageTransparency=1,Parent=header},{ImageColor3=
'TitlingColor'}),'ImageTransparency',0)end local textColumn=window:Create(
'Frame',{Name='Text',BackgroundTransparency=1,Size=UDim2.new(1,hasIcon and-(
headerIconSize+headerIconGap)or 0,0,self._columnH),LayoutOrder=2,Parent=header})
window:Create('UIListLayout',{FillDirection=Enum.FillDirection.Vertical,
SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,3),Parent=textColumn})
self:_fade(window:Create('TextLabel',{Text=locale.t(self.title),Size=UDim2.new(1
,0,0,self._titleH),BackgroundTransparency=1,TextSize=titleSize,TextXAlignment=
Enum.TextXAlignment.Left,TextWrapped=true,LayoutOrder=1,TextTransparency=1,
Parent=textColumn},{TextColor3='TitlingColor',FontFace='Font'}),
'TextTransparency',0)if self.subtitle and self.subtitle~=''then self:_fade(
window:Create('TextLabel',{Text=locale.t(self.subtitle),Size=UDim2.new(1,0,0,
self._subH),BackgroundTransparency=1,TextSize=subtitleSize,TextXAlignment=Enum.
TextXAlignment.Left,TextWrapped=true,LayoutOrder=2,TextTransparency=1,Parent=
textColumn},{TextColor3='TitlingColor',FontFace='Font'}),'TextTransparency',0.55
)end end function Popup:_buildContent()if(not self.content or self.content=='')
and(not self.boxes or#self.boxes==0)then return 0 end local window=self.window
local measured=if self.boxes and#self.boxes>0 then self:_measureBoxes()else self
:_measureText()local viewHeight=math.min(measured,maxContentHeight)+contentInset
*2 local content=window:Create('ScrollingFrame',{Name='Content',
BackgroundTransparency=1,BorderSizePixel=0,Size=UDim2.new(1,0,0,viewHeight),
CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,
ScrollBarThickness=4,ScrollBarImageColor3=Color3.fromRGB(255,255,255),
ScrollingDirection=Enum.ScrollingDirection.Y,LayoutOrder=2,
ScrollBarImageTransparency=1,Parent=self.card})self:_fade(content,
'ScrollBarImageTransparency',0.8)window:Create('UIPadding',{PaddingLeft=UDim.
new(0,contentInset),PaddingRight=UDim.new(0,contentInset),PaddingTop=UDim.new(0,
contentInset),PaddingBottom=UDim.new(0,contentInset),Parent=content})if self.
boxes and#self.boxes>0 then window:Create('UIListLayout',{FillDirection=Enum.
FillDirection.Vertical,HorizontalAlignment=Enum.HorizontalAlignment.Center,
SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,boxGap),Parent=content})
for index,box in self.boxes do self:_buildBox(content,box,index)end else self:
_fade(window:Create('TextLabel',{Text=locale.t(self.content),Size=UDim2.new(1,0,
0,measured),BackgroundTransparency=1,TextSize=contentSize,TextXAlignment=Enum.
TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,TextWrapped=true,
TextTransparency=1,Parent=content},{TextColor3='ContentColor',FontFace='Font'}),
'TextTransparency',0.5)end return viewHeight end function Popup:_buildBox(parent
,box,order)local window=self.window box=if typeof(box)=='table'then box else{
title=tostring(box)}local hasIcon=box.icon~=nil and box.icon~=0 and box.icon~=''
local frameH,titleH,descH,columnH=self:_measureBox(box)local frame=window:
Create('Frame',{Name='Box',BackgroundColor3=Color3.fromRGB(255,255,255),
BorderSizePixel=0,Size=UDim2.new(1,-boxWidthInset,0,frameH),LayoutOrder=order,
BackgroundTransparency=1,Parent=parent})self:_fade(frame,
'BackgroundTransparency',0)local stroke=window:StyleElementPanel(frame)self:
_fade(stroke,'Transparency',window.theme.ElementStrokeTransparency)window:
Create('UIPadding',{PaddingLeft=UDim.new(0,boxSidePad),PaddingRight=UDim.new(0,
boxSidePad),PaddingTop=UDim.new(0,boxVerticalPad),PaddingBottom=UDim.new(0,
boxVerticalPad),Parent=frame})window:Create('UIListLayout',{FillDirection=Enum.
FillDirection.Horizontal,VerticalAlignment=Enum.VerticalAlignment.Center,
HorizontalAlignment=Enum.HorizontalAlignment.Left,SortOrder=Enum.SortOrder.
LayoutOrder,Padding=UDim.new(0,boxIconGap),Parent=frame})if hasIcon then self:
_fade(window:Create('ImageLabel',{Image=box.icon,Size=UDim2.fromOffset(
boxIconSize,boxIconSize),BackgroundTransparency=1,BorderSizePixel=0,LayoutOrder=
1,ImageTransparency=1,Parent=frame},{ImageColor3='ContentColor'}),
'ImageTransparency',0)end local textColumn=window:Create('Frame',{
BackgroundTransparency=1,Size=UDim2.new(1,hasIcon and-(boxIconSize+boxIconGap)or
0,0,columnH),LayoutOrder=2,Parent=frame})window:Create('UIListLayout',{
FillDirection=Enum.FillDirection.Vertical,SortOrder=Enum.SortOrder.LayoutOrder,
Padding=UDim.new(0,3),Parent=textColumn})self:_fade(window:Create('TextLabel',{
Text=locale.t(box.title or box.Title or''),Size=UDim2.new(1,0,0,titleH),
BackgroundTransparency=1,TextSize=boxTitleSize,TextXAlignment=Enum.
TextXAlignment.Left,TextWrapped=true,LayoutOrder=1,TextTransparency=1,Parent=
textColumn},{TextColor3='ContentColor',FontFace='TitleFont'}),'TextTransparency'
,0)local description=box.description or box.Description if description and
description~=''then self:_fade(window:Create('TextLabel',{Text=locale.t(
description),Size=UDim2.new(1,0,0,descH),BackgroundTransparency=1,TextSize=
boxDescSize,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.
TextYAlignment.Top,TextWrapped=true,LayoutOrder=2,TextTransparency=1,Parent=
textColumn},{TextColor3='ContentColor',FontFace='Font'}),'TextTransparency',0.65
)end end function Popup:_buildFooter()local window=self.window local footer=
window:Create('Frame',{Name='Footer',BackgroundTransparency=1,Size=UDim2.new(1,0
,0,buttonHeight),LayoutOrder=3,Parent=self.card})window:Create('UIListLayout',{
FillDirection=Enum.FillDirection.Horizontal,VerticalAlignment=Enum.
VerticalAlignment.Center,HorizontalAlignment=Enum.HorizontalAlignment.Center,
HorizontalFlex=Enum.UIFlexAlignment.Fill,SortOrder=Enum.SortOrder.LayoutOrder,
Padding=UDim.new(0,buttonGap),Parent=footer})for index,option in self.options do
self:_buildButton(footer,option,index)end end function Popup:_buildButton(parent
,option,order)local window=self.window option=if typeof(option)=='table'then
option else{text=tostring(option)}local style=option.style or option.Style or
'neutral'local label=option.text or option.Text or option.name or option.Name or
'Okay'local callback=option.callback or option.Callback local restColor,
hoverColor,edgeColor,strokeShown if style=='primary'then restColor,hoverColor,
edgeColor,strokeShown=window.theme.AccentColor,window.theme.AccentStroke,window.
theme.AccentStroke,0.1 elseif style=='danger'then restColor,hoverColor,edgeColor
,strokeShown=window.theme.ErrorColor,window.theme.ErrorStrokeColor,window.theme.
ErrorStrokeColor,0 else restColor,hoverColor,edgeColor,strokeShown=window.theme.
NeutralButton,window.theme.NeutralButtonHover,window.theme.NeutralButtonStroke,
0.85 end local button=window:Create('Frame',{Name='Button',BackgroundColor3=
restColor,BorderSizePixel=0,Size=UDim2.new(0,0,0,buttonHeight),LayoutOrder=order
,BackgroundTransparency=1,Parent=parent})self:_fade(button,
'BackgroundTransparency',0)window:Create('UIFlexItem',{FlexMode=Enum.UIFlexMode.
Fill,Parent=button})window:Create('UICorner',{CornerRadius=buttonCorner,Parent=
button})local stroke=window:Create('UIStroke',{Color=edgeColor,Transparency=1,
Parent=button})self:_fade(stroke,'Transparency',strokeShown)self:_fade(window:
Create('TextLabel',{Text=locale.t(label),Size=UDim2.fromScale(1,1),
BackgroundTransparency=1,TextSize=buttonTextSize,TextXAlignment=Enum.
TextXAlignment.Center,TextTruncate=Enum.TextTruncate.AtEnd,TextColor3=functions.
contrastText(restColor),TextTransparency=1,Parent=button},{FontFace='Font'}),
'TextTransparency',0)local interact=window:Create('TextButton',{Text='',
BackgroundTransparency=1,Size=UDim2.fromScale(1,1),BorderSizePixel=0,ZIndex=2,
Parent=button})local hoverInfo=TweenInfo.new(0.25,Enum.EasingStyle.Quint,Enum.
EasingDirection.Out)table.insert(self._connections,window:Connect(interact.
MouseEnter,function()if self._closed then return end variables.tweenService:
Create(button,hoverInfo,{BackgroundColor3=hoverColor}):Play()end))table.insert(
self._connections,window:Connect(interact.MouseLeave,function()variables.
tweenService:Create(button,hoverInfo,{BackgroundColor3=restColor}):Play()end))
table.insert(self._connections,window:Connect(interact.MouseButton1Click,
function()if self._closed then return end hapticEngine.click()variables.
tweenService:Create(stroke,hoverInfo,{Transparency=1}):Play()if callback then
task.spawn(function()local ok,err=pcall(callback)if not ok then log.warn(
"Rayfield: popup button '"..label.."' callback errored:")log.print(err)end end)
end self:Close()end))end function Popup:_measureHeader(hasIcon)local textWidth=
innerWidth-(if hasIcon then headerIconSize+headerIconGap else 0)self._titleH=
functions.textHeight(self.window.theme.Font,titleSize,locale.resolve(self.title)
,textWidth)self._subH=if self.subtitle and self.subtitle~=''then functions.
textHeight(self.window.theme.Font,subtitleSize,locale.resolve(self.subtitle),
textWidth)else 0 self._columnH=self._titleH+(if self._subH>0 then 3+self._subH
else 0)return math.max(self._columnH,if hasIcon then headerIconSize else 0)end
function Popup:_measureText()return functions.textHeight(self.window.theme.Font,
contentSize,locale.resolve(self.content),contentWidth)end function Popup:
_measureBox(box)box=if typeof(box)=='table'then box else{title=tostring(box)}
local hasIcon=box.icon~=nil and box.icon~=0 and box.icon~=''local textWidth=
contentWidth-boxWidthInset-boxSidePad*2-(if hasIcon then boxIconSize+boxIconGap
else 0)local titleH=functions.textHeight(self.window.theme.TitleFont,
boxTitleSize,locale.resolve(box.title or box.Title or''),textWidth)local descH=0
local description=box.description or box.Description if description and
description~=''then descH=functions.textHeight(self.window.theme.Font,
boxDescSize,locale.resolve(description),textWidth)end local columnH=titleH+(if
descH>0 then 3+descH else 0)local frameH=math.max(columnH,if hasIcon then
boxIconSize else 0)+boxVerticalPad*2 return frameH,titleH,descH,columnH end
function Popup:_measureBoxes()local total=0 for index,box in self.boxes do total
+=(self:_measureBox(box))if index<#self.boxes then total+=boxGap end end return
total end function Popup:_show()if not self.screenGui.Parent then return end
hapticEngine.notify()variables.tweenService:Create(self.card,enterInfo,{Position
=UDim2.new(0.5,0,0.5,0)}):Play()for _,entry in self._reveal do local info=if
entry.instance==self.backdrop then backdropInfo else fadeLong variables.
tweenService:Create(entry.instance,info,{[entry.prop]=entry.to}):Play()end end
function Popup:Close()if self._closed then return end self._closed=true local
index=table.find(stack,self)if index then table.remove(stack,index)end for _,
connection in self._connections do self.window:Disconnect(connection)end self.
_connections={}if not self.screenGui.Parent then return end variables.
tweenService:Create(self.card,fadeShort,{Position=UDim2.new(0.5,0,0.5,10)}):
Play()for _,entry in self._reveal do variables.tweenService:Create(entry.
instance,fadeShort,{[entry.prop]=1}):Play()end task.delay(fadeShort.Time,
function()self.window:DestroySubtree(self.screenGui)end)end return Popup end end
function __DARKLUA_BUNDLE_MODULES.o():typeof(__modImpl())local v=
__DARKLUA_BUNDLE_MODULES.cache.o if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.o=v end return v.c end end do local function
__modImpl()return function(script,require)local utility=script.Parent.Parent.
utility local variables=require(utility.variables)local constants=require(
utility.constants)local locale=require(utility.locale)local action=require(
script.Parent.action)local search={}local swapInfo=TweenInfo.new(0.25,Enum.
EasingStyle.Quint,Enum.EasingDirection.Out)local iconRest=0.6 local iconLit=0.2
local function collectUnits(window)local units={}local function collect(unit)if
unit.__type=='Group'then for _,child in unit.elements do collect(child)end
elseif unit.__type~='Section'and unit.searchable~=false then table.insert(units,
unit)end end for _,tab in window.tabs do if tab.neglectSelector then continue
end for _,element in tab.elements do collect(element)end end return units end
local function setPillShown(window,shown,info)variables.tweenService:Create(
window.searchPill,info,{BackgroundTransparency=if shown then 0.9 else 1}):Play()
variables.tweenService:Create(window.searchStroke,info,{Transparency=if shown
then 0.85 else 1}):Play()variables.tweenService:Create(window.searchShadow,info,
{Transparency=if shown then 0.92 else 1}):Play()variables.tweenService:Create(
window.searchIcon,info,{ImageTransparency=if shown then 0.65 else 1}):Play()
variables.tweenService:Create(window.searchInput,info,{TextTransparency=if shown
then 0.2 else 1}):Play()end local function setTabsShown(window,shown,info)for _,
tab in window.tabs do if not tab.neglectSelector and tab.topbarItem then tab:
_applyVisual(if shown then(if window.selectedTab==tab then'selected'else
'unselected')else'hidden',info)end end end local function setUnitVisible(unit,
visible)if unit.main then unit.main.Visible=visible end if unit.descriptor and
unit.descriptor.main then unit.descriptor.main.Visible=visible end end
local function applyFilter(window,query)query=string.lower(query or''):match(
'^%s*(.-)%s*$')or''local anyVisible=false for _,entry in window._searchUnits do
local match=query==''or string.find(entry.text,query,1,true)~=nil
setUnitVisible(entry.unit,match)anyVisible=anyVisible or match end window.
searchEmpty.Visible=not anyVisible and query~=''end local function gatherUnits(
window)window._searchUnits={}local order=0 for _,unit in collectUnits(window)do
order+=1 local main=unit.main table.insert(window._searchUnits,{unit=unit,text=
string.lower(tostring(unit.name or'')),homeParent=main.Parent,homeOrder=main.
LayoutOrder,descOrder=unit.descriptor and unit.descriptor.main.LayoutOrder})main
.LayoutOrder=order*10 main.Parent=window.searchPage main.Visible=true if unit.
descriptor then unit.descriptor.main.LayoutOrder=order*10+1 unit.descriptor.main
.Parent=window.searchPage unit.descriptor.main.Visible=true end end end
local function restoreUnits(window)for _,entry in window._searchUnits do local
unit=entry.unit if unit.main and unit.main.Parent then unit.main.LayoutOrder=
entry.homeOrder unit.main.Parent=entry.homeParent end if unit.descriptor and
unit.descriptor.main and unit.descriptor.main.Parent then unit.descriptor.main.
LayoutOrder=entry.descOrder unit.descriptor.main.Parent=entry.homeParent end
setUnitVisible(unit,true)end window._searchUnits={}end function search.open(
window)if window._searching or window.minimised or not window:_interactive()then
return end window._searching=true gatherUnits(window)applyFilter(window,'')
window:_jumpTo(window.searchPage)setTabsShown(window,false,swapInfo)task.delay(
swapInfo.Time,function()if window._searching then window.tabList.Visible=false
end end)window.searchPill.Visible=true setPillShown(window,true,swapInfo)window.
searchInput:CaptureFocus()variables.tweenService:Create(window.searchAction.
iconLabel,swapInfo,{ImageTransparency=iconLit}):Play()end function search.close(
window,config)if not window._searching then return end config=config or{}window.
_searching=false window.searchInput.Text=''window.searchInput:ReleaseFocus()
window.searchEmpty.Visible=false restoreUnits(window)local target=if config.
jumpTo==nil then window.selectedTab and window.selectedTab.tabPage else config.
jumpTo if target then window:_jumpTo(target)end setPillShown(window,false,
swapInfo)task.delay(swapInfo.Time,function()if not window._searching then window
.searchPill.Visible=false end end)if config.showTabs then window.tabList.Visible
=true setTabsShown(window,true,swapInfo)end variables.tweenService:Create(window
.searchAction.iconLabel,swapInfo,{ImageTransparency=iconRest}):Play()end
function search.toggle(window)if window._searching then search.close(window,{
showTabs=true})else search.open(window)end end function search.build(window)
window._searching=false window.searchPage=window:Create('ScrollingFrame',{Name=
'Search',Size=UDim2.new(1,-20,1,0),Position=UDim2.new(0.5,0,0,68),AnchorPoint=
Vector2.new(0.5,0.5),BorderSizePixel=0,BackgroundTransparency=1,
AutomaticCanvasSize=Enum.AutomaticSize.Y,CanvasSize=UDim2.new(0,0,0,0),
ScrollBarThickness=0,ScrollingDirection=Enum.ScrollingDirection.Y,LayoutOrder=
2000,Parent=window.elements})window:Create('UIListLayout',{Padding=UDim.new(0,7)
,FillDirection=Enum.FillDirection.Vertical,VerticalAlignment=Enum.
VerticalAlignment.Top,HorizontalAlignment=Enum.HorizontalAlignment.Center,
SortOrder=Enum.SortOrder.LayoutOrder,Parent=window.searchPage})window:Create(
'UIPadding',{PaddingTop=UDim.new(0,10),PaddingBottom=UDim.new(0,33),Parent=
window.searchPage})window.searchEmpty=window:Create('TextLabel',{Name=
'NoResults',Text=locale.t('No results'),FontFace=variables.brandFont(Enum.
FontWeight.Medium),TextSize=15,TextTransparency=0.6,BackgroundTransparency=1,
AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0.5,0,0.55,0),Size=UDim2.
fromOffset(200,20),Visible=false,ZIndex=3,Parent=window.main},{TextColor3=
'ContentColor',FontFace='Font'})window.searchPill=window:Create('Frame',{Name=
'SearchBar',AnchorPoint=Vector2.new(0.5,0),Position=UDim2.new(0.5,0,0,66),Size=
UDim2.new(1,-35,0,35),BackgroundColor3=Color3.fromRGB(255,255,255),
BorderSizePixel=0,ZIndex=10,BackgroundTransparency=1,Visible=false,Parent=window
.main})window:Create('UICorner',{CornerRadius=UDim.new(1,0),Parent=window.
searchPill})window.searchStroke=window:Create('UIStroke',{Color=Color3.fromRGB(
255,255,255),Thickness=1,Transparency=1,Parent=window.searchPill})window.
searchShadow=window:Create('UIShadow',{BlurRadius=UDim.new(0,20),Color=Color3.
fromRGB(255,255,255),ZIndex=-1,Transparency=1,Parent=window.searchPill})window.
searchIcon=window:Create('ImageLabel',{Image='rbxassetid://'..tostring(constants
.icons.search),AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,15,0.5,1),
Size=UDim2.fromOffset(16,16),BackgroundTransparency=1,ZIndex=10,
ImageTransparency=1,Parent=window.searchPill},{ImageColor3='ContentColor'})
window.searchInput=window:Create('TextBox',{Text='',PlaceholderText=locale.t(
'Search all pages'),AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,40,0.5,0
),Size=UDim2.new(1,-110,0,18),BackgroundTransparency=1,TextSize=16,
TextXAlignment=Enum.TextXAlignment.Left,ClearTextOnFocus=false,ClipsDescendants=
true,ZIndex=10,TextTransparency=1,Parent=window.searchPill},{TextColor3=
'ContentColor',FontFace='Font',PlaceholderColor3='PlaceholderColor'})window:
Connect(window.searchInput:GetPropertyChangedSignal('Text'),function()if window.
_searching then applyFilter(window,window.searchInput.Text)end end)window.
searchAction=action.new(window,{name='Search',icon=constants.icons.search,order=
4,callback=function()search.toggle(window)end})window.searchAction.isLit=
function()return window._searching end end return search end end function
__DARKLUA_BUNDLE_MODULES.p():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES
.cache.p if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.p=v end
return v.c end end do local function __modImpl()return function(script,require)
local Section={}Section.__index=Section Section.__type='Section'local moveable=
require(script.Parent.Parent.utility.moveable)local locale=require(script.Parent
.Parent.utility.locale)function Section.new(tab,properties)properties=if typeof(
properties)=='table'then properties else{}local self=setmetatable({tab=assert(
tab,'Missing argument #1 (Tab expected)'),window=tab.window,name=properties.name
or properties.Name or'Section',icon=properties.icon or properties.Icon},Section)
local topSpace=if#self.tab.elements==0 then 0 else 13 self.main=self.window:
Create('Frame',{Size=UDim2.new(1,-40,0,20+topSpace),BorderSizePixel=0,Name=self.
name,BackgroundTransparency=1,Parent=self.tab.tabPage})if topSpace>0 then self.
window:Create('UIPadding',{PaddingTop=UDim.new(0,topSpace),Parent=self.main})end
self.window:Create('UIListLayout',{FillDirection=Enum.FillDirection.Horizontal,
Padding=UDim.new(0,6),SortOrder=Enum.SortOrder.LayoutOrder,VerticalAlignment=
Enum.VerticalAlignment.Top,Parent=self.main})if self.icon then self.iconLabel=
self.window:Create('ImageLabel',{Image=self.icon,Size=UDim2.fromOffset(16,16),
BorderSizePixel=0,BackgroundTransparency=1,ImageTransparency=1,Parent=self.main}
,{ImageColor3='ContentColor'})end self.title=self.window:Create('TextLabel',{
Text=locale.t(self.name),Size=UDim2.fromOffset(0,16),BorderSizePixel=0,
BackgroundTransparency=1,TextSize=15,AutomaticSize=Enum.AutomaticSize.X,
TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,LayoutOrder=1,
TextTransparency=1,Parent=self.main},{TextColor3='ContentColor',FontFace='Font'}
)return self end function Section:_setShown(shown,animate)local w=self.window w:
_reveal(self.title,{TextTransparency=if shown then 0.6 else 1},animate)if self.
iconLabel then w:_reveal(self.iconLabel,{ImageTransparency=if shown then 0.65
else 1},animate)end end moveable(Section)return Section end end function
__DARKLUA_BUNDLE_MODULES.q():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES
.cache.q if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.q=v end
return v.c end end do local function __modImpl()return function(script,require)
local Slider={}Slider.__index=Slider Slider.__type='Slider'local utility=script.
Parent.Parent.utility local variables=require(utility.variables)local functions=
require(utility.functions)local odometer=require(utility.odometer)local moveable
=require(utility.moveable)local locale=require(utility.locale)local hapticEngine
=require(utility.HapticEngine)local function decimalsOf(step)local decimals=0
while decimals<6 do local scaled=step*10^decimals if math.abs(scaled-math.round(
scaled))<1e-9 then break end decimals+=1 end return decimals end local function
snapTo(range,increment,value)local snapped=range[1]+math.round((value-range[1])/
increment)*increment return math.clamp(snapped,range[1],range[2])end local
tweenInfo=TweenInfo.new(0.45,Enum.EasingStyle.Exponential,Enum.EasingDirection.
Out)local heldInfo=TweenInfo.new(0.3,Enum.EasingStyle.Exponential,Enum.
EasingDirection.Out)local followInfo=TweenInfo.new(0.3,Enum.EasingStyle.Quint,
Enum.EasingDirection.Out)local narrowWidth=420 local handleRest=Vector2.new(35,
20)local handleHeld=Vector2.new(41,22)local function fillSize(ratio:number):
UDim2 return UDim2.new(ratio,0,1,0)end local function handleOffset():UDim2
return UDim2.new(1,0,0.5,0)end local function ratioFromPointer(x:number,left:
number,travel:number):number return math.clamp((x-left)/travel,0,1)end function
Slider.new(tab,properties)properties=if typeof(properties)=='table'then
properties else{}local self=setmetatable({tab=assert(tab,
'Missing argument #1 (Tab expected)'),window=tab.window,name=properties.name or
properties.Name or'Slider',icon=properties.icon or properties.Icon,description=
properties.description or properties.Description,forgetState=properties.
forgetState or properties.ForgetState or tab.forgetState,range=properties.range
or properties.Range or{0,100},increment=properties.increment or properties.
Increment or 1,suffix=properties.suffix or properties.Suffix or'',callback=
properties.callback or properties.Callback or function()end,dragging=false,
minimal=properties.minimal or properties.Minimal or false,_handleWidth=
handleRest.X},Slider)assert(typeof(self.range)=='table'and typeof(self.range[1])
=='number'and typeof(self.range[2])=='number',
'A slider range needs two numbers, like { 0, 100 }.')if self.range[1]>self.range
[2]then self.range={self.range[2],self.range[1]}end if self.increment<=0 then
self.increment=1 end self.value=if(properties.value or properties.Value)~=nil
then(properties.value or properties.Value)elseif(properties.currentValue or
properties.CurrentValue)~=nil then(properties.currentValue or properties.
CurrentValue)else self.range[1]self.value=snapTo(self.range,self.increment,self.
value)self._decimals=decimalsOf(self.increment)self.flag=properties.flag or
properties.Flag or(not self.forgetState and functions.deriveFlagFromName(self.
name)or nil)self.window:_registerControl(self)self.main=self.window:Create(
'Frame',{Size=UDim2.new(1,-20,0,65),BorderSizePixel=0,Name=self.name,
BackgroundColor3=Color3.fromRGB(255,255,255),BackgroundTransparency=1,Parent=
self.tab.tabPage},{BackgroundTransparency='ElementTransparency'})self.stroke=
self.window:StyleElementBody(self.main)self._lastValue=self.value if not self.
minimal then self:_buildLabel()end self.track=self.window:Create('Frame',{
AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-15,0.5,0),Size=UDim2.
fromOffset(222,14),BorderSizePixel=0,BackgroundTransparency=1,Parent=self.main},
{BackgroundColor3='SliderBackground'})self.window:Create('UICorner',{
CornerRadius=UDim.new(0,13),Parent=self.track})self.progress=self.window:Create(
'Frame',{AnchorPoint=Vector2.new(0,0.5),Position=UDim2.fromScale(0,0.5),Size=
UDim2.fromScale(0,1),BackgroundColor3=Color3.fromRGB(255,255,255),
BorderSizePixel=0,ZIndex=2,BackgroundTransparency=1,Parent=self.track})self.
window:Create('UICorner',{CornerRadius=UDim.new(0,13),Parent=self.progress})self
.window:Create('UIGradient',{Offset=Vector2.new(0,0.5),Rotation=2,Transparency=
NumberSequence.new({NumberSequenceKeypoint.new(0,0.85),NumberSequenceKeypoint.
new(1,0)}),Parent=self.progress},{Color={'SliderProgress',functions.
toColorSequence}})self.progressGlow=self.window:CreateGlow(self.progress,
'AccentColor',20,1)self.handle=self.window:Create('Frame',{AnchorPoint=Vector2.
new(0.5,0.5),Position=handleOffset(),Size=UDim2.fromOffset(handleRest.X,
handleRest.Y),BorderSizePixel=0,ZIndex=50,BackgroundTransparency=1,Parent=self.
progress},{BackgroundColor3='SliderHandle'})self.window:Create('UICorner',{
CornerRadius=UDim.new(1,0),Parent=self.handle})self.handleGlow=self.window:
CreateGlow(self.handle,Color3.fromRGB(255,255,255),10,1)self.handleStroke=self.
window:Create('UIStroke',{Transparency=1,Parent=self.handle},{Color=
'SliderStroke'})self.interact=self.window:Create('TextButton',{
BackgroundTransparency=1,Size=UDim2.fromScale(1,1),Text='',TextTransparency=1,
ZIndex=10,Parent=self.track})self.window:ConnectFor(self,self.main.MouseEnter,
function()if not self.window:_interactive()then return end variables.
tweenService:Create(self.track,tweenInfo,{BackgroundColor3=self.window.theme.
SliderBackgroundHover}):Play()end)self.window:ConnectFor(self,self.main.
MouseLeave,function()variables.tweenService:Create(self.track,tweenInfo,{
BackgroundColor3=self.window.theme.SliderBackground}):Play()end)self.window:
ConnectFor(self,self.interact.InputBegan,function(input)if input.UserInputType==
Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch
then hapticEngine.click()self.dragging=true self:_setHeld(true)self:
_updateFromMouse()if self._dragConnection then self._dragConnection:Disconnect()
self._dragConnection=nil end self._dragConnection=variables.runService.
RenderStepped:Connect(function()if self.window.unloaded or not self.dragging
then if self._dragConnection then self._dragConnection:Disconnect()self.
_dragConnection=nil end return end self:_updateFromMouse()end)end end)self.
window:ConnectFor(self,variables.userInputService.InputEnded,function(input)if
input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==
Enum.UserInputType.Touch then self:_endDrag()end end)self.window:ConnectFor(self
,variables.userInputService.WindowFocusReleased,function()self:_endDrag()end)if
self.description and not self.minimal then self.descriptor=require(script.Parent
.descriptor).new(self.tab,{description=self.description})end self.window:
ConnectFor(self,self.main:GetPropertyChangedSignal('AbsoluteSize'),function()if
self.window.animating or(self.window.hidden and self.window.hasShownOnce)then
return end if self._layoutPending then return end self._layoutPending=true task.
defer(function()self._layoutPending=false if not self.window.animating and not(
self.window.hidden and self.window.hasShownOnce)then self:_applyLayout()end end)
end)self:_applyLayout()if self.minimal then self.main.Size=UDim2.new(1,-20,0,41)
self.track.AnchorPoint=Vector2.new(0.5,0.5)self.track.Position=UDim2.new(0.5,0,
0.5,0)self.track.Size=UDim2.new(1,-30,0,14)end self:_renderProgress()return self
end function Slider:_buildLabel()self.container=self.window:Create('Frame',{
AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,20,0.5,0),Size=UDim2.
fromOffset(170,33),BackgroundTransparency=1,BorderSizePixel=0,ZIndex=5,Parent=
self.main})self.containerLayout=self.window:Create('UIListLayout',{Padding=UDim.
new(0,2),VerticalAlignment=Enum.VerticalAlignment.Center,SortOrder=Enum.
SortOrder.LayoutOrder,Parent=self.container})self.titleContainer=self.window:
Create('Frame',{Size=UDim2.new(1,0,0,16),BackgroundTransparency=1,
BorderSizePixel=0,ZIndex=5,Parent=self.container})self.window:Create(
'UIListLayout',{Padding=UDim.new(0,5),FillDirection=Enum.FillDirection.
Horizontal,VerticalAlignment=Enum.VerticalAlignment.Center,SortOrder=Enum.
SortOrder.LayoutOrder,Parent=self.titleContainer})self.titleFlex=self.window:
Create('UIFlexItem',{FlexMode=Enum.UIFlexMode.None,Parent=self.titleContainer})
if self.icon then self.iconLabel=self.window:Create('ImageLabel',{Image=self.
icon,Size=UDim2.fromOffset(16,16),BorderSizePixel=0,BackgroundTransparency=1,
ZIndex=5,ImageTransparency=1,Parent=self.titleContainer},{ImageColor3=
'ContentColor'})end self.title=self.window:Create('TextLabel',{Text=locale.t(
self.name),Size=UDim2.new(1,0,0,16),BorderSizePixel=0,BackgroundTransparency=1,
TextSize=16,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.
TextTruncate.AtEnd,RichText=true,LayoutOrder=1,ZIndex=5,TextTransparency=1,
Parent=self.titleContainer},{TextColor3='ContentColor',FontFace='Font'})self.
window:Create('UIFlexItem',{FlexMode=Enum.UIFlexMode.Shrink,Parent=self.title})
self.valueHost=self.window:Create('Frame',{Size=UDim2.new(1,0,0,16),
BackgroundTransparency=1,BorderSizePixel=0,ZIndex=6,LayoutOrder=1,Parent=self.
container})self.valueOdo=odometer.new(self.window,self.valueHost,{textSize=15,
alignment=Enum.HorizontalAlignment.Left,transparency=1,duration=0.28})self.
valueOdo:snap(self:_format(self.value))end function Slider:_setMainHeight(height
)if self._widthManaged then self.main.Size=UDim2.new(self.main.Size.X.Scale,self
.main.Size.X.Offset,0,height)else self.main.Size=UDim2.new(1,-20,0,height)end
end function Slider:_applyLayout()if self.minimal then return end local width=
self.main.AbsoluteSize.X local mode=if width>0 and width<narrowWidth then
'narrow'else'wide'if self._layoutMode==mode then return end self._layoutMode=
mode if mode=='narrow'then self:_setMainHeight(70)self.container.AnchorPoint=
Vector2.new(0,0)self.container.Position=UDim2.new(0,20,0,14)self.container.Size=
UDim2.new(1,-40,0,16)self.containerLayout.FillDirection=Enum.FillDirection.
Horizontal self.titleFlex.FlexMode=Enum.UIFlexMode.Fill self.valueHost.
AutomaticSize=Enum.AutomaticSize.X self.valueHost.Size=UDim2.new(0,0,0,16)self.
track.AnchorPoint=Vector2.new(0.5,1)self.track.Position=UDim2.new(0.5,0,1,-14)
self.track.Size=UDim2.new(1,-52,0,14)else self:_setMainHeight(65)self.container.
AnchorPoint=Vector2.new(0,0.5)self.container.Position=UDim2.new(0,20,0.5,0)self.
container.Size=UDim2.new(0,170,0,33)self.containerLayout.FillDirection=Enum.
FillDirection.Vertical self.titleFlex.FlexMode=Enum.UIFlexMode.None self.
valueHost.AutomaticSize=Enum.AutomaticSize.None self.valueHost.Size=UDim2.new(1,
0,0,16)self.track.AnchorPoint=Vector2.new(1,0.5)self.track.Position=UDim2.new(1,
-15,0.5,0)self.track.Size=UDim2.new(1,-210,0,14)end end function Slider:_format(
value)local text=string.format('%.'..self._decimals..'f',value)if self.suffix~=
''then return text..' '..self.suffix end return text end function Slider:
_pillTravel()return math.max(self.track.AbsoluteSize.X,0)end function Slider:
_renderProgress(info)local span=self.range[2]-self.range[1]local ratio=if span~=
0 then math.clamp((self.value-self.range[1])/span,0,1)else 0 local size=
fillSize(ratio)if info then variables.tweenService:Create(self.progress,info,{
Size=size}):Play()else self.progress.Size=size end end function Slider:
_updateFromMouse()local travel=self:_pillTravel()if travel<=0 then return end
local ratio=ratioFromPointer(variables.userInputService:GetMouseLocation().X,
self.track.AbsolutePosition.X,travel)local value=snapTo(self.range,self.
increment,self.range[1]+ratio*(self.range[2]-self.range[1]))if value~=self.value
then self.value=value if self.valueOdo then self.valueOdo:snap(self:_format(
value))end self._lastValue=value self:_renderProgress(followInfo)self:
_fireCallback(value)end end function Slider:_endDrag()if not self.dragging then
return end self.dragging=false self:_setHeld(false)if self._dragConnection then
self._dragConnection:Disconnect()self._dragConnection=nil end self.window:
_persist(self)end function Slider:_setHeld(held)local target=if held then
handleHeld else handleRest self._handleWidth=target.X variables.tweenService:
Create(self.handle,heldInfo,{Size=UDim2.fromOffset(target.X,target.Y),
BackgroundTransparency=if held then 0.7 else 0}):Play()variables.tweenService:
Create(self.handleStroke,heldInfo,{Transparency=if held then 0.6 else 1}):Play()
self:_renderProgress(heldInfo)end function Slider:_fireCallback(value)self.
window:_runGuarded(self,self.callback,value)end function Slider:Set(value,
skipCallback)value=snapTo(self.range,self.increment,value)self.value=value if
self.valueOdo then self.valueOdo:to(self:_format(value),value>=(self._lastValue
or value))end self._lastValue=value self:_renderProgress(tweenInfo)if not
skipCallback then self:_fireCallback(value)self.window:_persist(self)end end
local sliderGlowReveal=TweenInfo.new(0.4,Enum.EasingStyle.Exponential,Enum.
EasingDirection.Out,0,false,0.35)function Slider:_setShown(shown,animate)local w
=self.window if shown then w:_revealCommon(self,animate)w:_reveal(self.track,{
BackgroundTransparency=0},animate)w:_reveal(self.progress,{
BackgroundTransparency=0},animate)w:_reveal(self.handle,{BackgroundTransparency=
0},animate)if self.valueOdo then self.valueOdo:reveal(0.3,animate)end w:_reveal(
self.progressGlow,{Transparency=math.max(0.55,w.theme.AccentGlow)},animate,
sliderGlowReveal)w:_reveal(self.handleGlow,{Transparency=0.8},animate,
sliderGlowReveal)else w:_hideCommon(self,animate)w:_reveal(self.track,{
BackgroundTransparency=1},animate)w:_reveal(self.progress,{
BackgroundTransparency=1},animate)w:_reveal(self.handle,{BackgroundTransparency=
1},animate)if self.valueOdo then self.valueOdo:reveal(1,animate)end w:_reveal(
self.progressGlow,{Transparency=1},animate,sliderGlowReveal)w:_reveal(self.
handleGlow,{Transparency=1},animate,sliderGlowReveal)end end function Slider:
_refreshTheme()variables.tweenService:Create(self.progressGlow,TweenInfo.new(0.5
,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Transparency=math.max(0.55,
self.window.theme.AccentGlow)}):Play()end function Slider:_minWidth()if self.
minimal then return 100 end local w=40 if self.icon then w+=22 end w+=functions.
textWidth(self.window.theme.Font,16,locale.resolve(self.name))w+=12 w+=functions
.textWidth(self.window.theme.Font,15,self:_format(self.value))return math.max(w,
160)end moveable(Slider)return Slider end end function __DARKLUA_BUNDLE_MODULES.
r():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.r if not v then v=
{c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.r=v end return v.c end end do
local function __modImpl()return function(script,require)local Statistic={}
Statistic.__index=Statistic Statistic.__type='Statistic'local utility=script.
Parent.Parent.utility local variables=require(utility.variables)local functions=
require(utility.functions)local odometer=require(utility.odometer)local moveable
=require(utility.moveable)local constants=require(utility.constants)local locale
=require(utility.locale)local log=require(utility.log)local accents=constants.
statAccents local accentTransparency=NumberSequence.new({NumberSequenceKeypoint.
new(0,0.85),NumberSequenceKeypoint.new(1,0)})local compactHeight=41 local
accentTweenInfo=TweenInfo.new(0.6,Enum.EasingStyle.Exponential)local function
glowColor(accent)return accent.fill.Keypoints[1].Value end local function
formatPct(pct)if pct>0 then return string.format('+%.1f%%',pct)elseif pct<0 then
return string.format('%.1f%%',pct)else return'0%'end end local function
formatValue(value)if typeof(value)~='number'then return tostring(value)end local
rounded=math.round(math.abs(value))local s=string.format('%.0f',rounded)local
result=s:reverse():gsub('%d%d%d','%0,'):reverse()if result:sub(1,1)==','then
result=result:sub(2)end return if value<0 and rounded~=0 then'-'..result else
result end local function formatChange(delta)local rounded=math.round(delta)if
rounded>0 then return'+'..formatValue(rounded)elseif rounded<0 then return
formatValue(rounded)else return'0'end end function Statistic.new(tab,properties)
properties=if typeof(properties)=='table'then properties else{}local self=
setmetatable({tab=assert(tab,'Missing argument #1 (Tab expected)'),window=tab.
window,name=properties.name or properties.Name or'Statistic',icon=properties.
icon or properties.Icon,description=properties.description or properties.
Description,value=if(properties.value or properties.Value)~=nil then(properties.
value or properties.Value)else 0,_hasValue=(properties.value or properties.Value
)~=nil,numberEasing=if(properties.numberEasing~=nil)then properties.numberEasing
elseif properties.NumberEasing~=nil then properties.NumberEasing else true,
changeMode=properties.changeMode or properties.ChangeMode or'percentage',
changeBaseline=properties.changeBaseline or properties.ChangeBaseline or
'previous',prefix=properties.prefix or properties.Prefix or'',suffix=properties.
suffix or properties.Suffix or'',compact=properties.compact or properties.
Compact or tab.compact or false,display=(properties.display or properties.
Display or'value'),_initialValue=if(properties.value or properties.Value)~=nil
then(properties.value or properties.Value)else nil,_lastChange=0},Statistic)if
self.compact then self:_buildCompact()else self:_buildFull()end if self.
description then if self.compact then log.warn(`Rayfield: a compact stat has no room for a description, ignoring it on '{
self.name}'.`)else self.descriptor=require(script.Parent.descriptor).new(self.
tab,{description=self.description})end end return self end function Statistic:
_buildFull()local window=self.window self.main=window:Create('Frame',{Size=UDim2
.new(1,-20,0,90),BorderSizePixel=0,Name=self.name,ZIndex=5,
BackgroundTransparency=1,Parent=self.tab.tabPage},{BackgroundColor3=
'StatBackground',BackgroundTransparency='ElementTransparency'})window:Create(
'UICorner',{Parent=self.main},{CornerRadius='ElementCornerRadius'})self.stroke=
window:Create('UIStroke',{Transparency=1,Color=Color3.fromRGB(255,255,255),
Parent=self.main},{Transparency='ElementStrokeTransparency'})self.strokeGradient
=window:Create('UIGradient',{Rotation=2,Offset=Vector2.new(0,0.5),Color=accents.
neutral.stroke,Transparency=accentTransparency,Parent=self.stroke})self.
titleContainer=window:Create('Frame',{Size=UDim2.new(1,-40,0,32),Position=UDim2.
fromOffset(20,15),BorderSizePixel=0,LayoutOrder=-1,BackgroundTransparency=1,
ZIndex=5,Parent=self.main})self.gradientContainer=window:Create('Frame',{Size=
UDim2.fromScale(1,1),Position=UDim2.fromOffset(0,0),BorderSizePixel=0,
BackgroundTransparency=1,BackgroundColor3=Color3.fromRGB(255,255,255),ZIndex=5,
Parent=self.main})self.glow=window:CreateGlow(self.main,glowColor(accents.
neutral),13,1)self.title=window:Create('TextLabel',{Text=locale.t(self.name),
Size=UDim2.fromOffset(300,19),BorderSizePixel=0,BackgroundTransparency=1,
TextSize=19,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,LayoutOrder
=1,ZIndex=10,TextTransparency=1,Parent=self.titleContainer},{TextColor3=
'ContentColor',FontFace='TitleFont'})self.mainGradient=window:Create(
'UIGradient',{Rotation=2,Offset=Vector2.new(0,0.5),Color=accents.neutral.fill,
Transparency=accentTransparency,Parent=self.gradientContainer})window:Create(
'UICorner',{Parent=self.gradientContainer},{CornerRadius='ElementCornerRadius'})
if self.icon then self.iconLabel=window:Create('ImageLabel',{Image=self.icon,
Size=UDim2.fromOffset(32,32),BorderSizePixel=0,BackgroundTransparency=1,ZIndex=
10,ImageTransparency=1,Parent=self.titleContainer},{ImageColor3='ContentColor'})
end self.containerLayout=window:Create('UIListLayout',{Padding=UDim.new(0,8),
FillDirection=Enum.FillDirection.Horizontal,VerticalAlignment=Enum.
VerticalAlignment.Center,HorizontalAlignment=Enum.HorizontalAlignment.Left,
SortOrder=Enum.SortOrder.LayoutOrder,Parent=self.titleContainer})self.valueHost=
window:Create('Frame',{AnchorPoint=Vector2.new(0,1),Position=UDim2.new(0,20,1,-
15),Size=UDim2.fromOffset(200,20),BackgroundTransparency=1,BorderSizePixel=0,
ZIndex=10,Parent=self.main})self.changeHost=window:Create('Frame',{AnchorPoint=
Vector2.new(1,1),Position=UDim2.new(1,-20,1,-15),Size=UDim2.fromOffset(200,15),
BackgroundTransparency=1,BorderSizePixel=0,ZIndex=10,Parent=self.main})self.
valueOdo=odometer.new(window,self.valueHost,{textSize=20,alignment=Enum.
HorizontalAlignment.Left,transparency=1})self.valueOdo:snap(self:_formatValue(
self.value))self.changeOdo=odometer.new(window,self.changeHost,{textSize=15,
alignment=Enum.HorizontalAlignment.Right,transparency=1})self.changeOdo:snap(
self:_formatChange(0))self._accentGradients={self.strokeGradient,self.
mainGradient}end function Statistic:_buildCompact()local window=self.window
local inRow=self.tab.compact or false self.main=window:Create('Frame',{Name=self
.name,Size=if inRow then UDim2.fromOffset(0,compactHeight)else UDim2.new(1,-20,0
,compactHeight),AutomaticSize=if inRow then Enum.AutomaticSize.X else Enum.
AutomaticSize.None,ClipsDescendants=true,BorderSizePixel=0,ZIndex=5,
BackgroundTransparency=1,Parent=self.tab.tabPage},{BackgroundColor3=
'StatBackground',BackgroundTransparency='ElementTransparency'})window:Create(
'UICorner',{Parent=self.main},{CornerRadius='ElementCornerRadius'})self.stroke=
window:Create('UIStroke',{Transparency=1,Color=Color3.fromRGB(255,255,255),
Parent=self.main},{Transparency='ElementStrokeTransparency'})self.strokeGradient
=window:Create('UIGradient',{Rotation=2,Offset=Vector2.new(0,0.5),Color=accents.
neutral.stroke,Transparency=accentTransparency,Parent=self.stroke})if inRow then
window:Create('UIFlexItem',{FlexMode=Enum.UIFlexMode.Fill,Parent=self.main})end
window:Create('UIListLayout',{FillDirection=Enum.FillDirection.Horizontal,
VerticalAlignment=Enum.VerticalAlignment.Center,HorizontalFlex=Enum.
UIFlexAlignment.Fill,Parent=self.main})self.card=window:Create('Frame',{
AutomaticSize=Enum.AutomaticSize.X,Size=UDim2.fromOffset(0,compactHeight),
BackgroundColor3=Color3.fromRGB(255,255,255),BorderSizePixel=0,ZIndex=5,
BackgroundTransparency=1,Parent=self.main})window:Create('UICorner',{Parent=self
.card},{CornerRadius='ElementCornerRadius'})self.mainGradient=window:Create(
'UIGradient',{Rotation=2,Offset=Vector2.new(0,0.5),Color=accents.neutral.fill,
Transparency=accentTransparency,Parent=self.card})window:Create('UIPadding',{
PaddingLeft=UDim.new(0,15),PaddingRight=UDim.new(0,15),Parent=self.card})window:
Create('UIListLayout',{FillDirection=Enum.FillDirection.Horizontal,
VerticalAlignment=Enum.VerticalAlignment.Center,HorizontalFlex=Enum.
UIFlexAlignment.SpaceBetween,Padding=UDim.new(0,10),Parent=self.card})self.
titleContainer=window:Create('Frame',{AutomaticSize=Enum.AutomaticSize.X,Size=
UDim2.fromOffset(0,16),BackgroundTransparency=1,BorderSizePixel=0,LayoutOrder=0,
ZIndex=6,Parent=self.card})window:Create('UIFlexItem',{FlexMode=Enum.UIFlexMode.
Shrink,Parent=self.titleContainer})window:Create('UIListLayout',{Padding=UDim.
new(0,6),FillDirection=Enum.FillDirection.Horizontal,VerticalAlignment=Enum.
VerticalAlignment.Center,HorizontalAlignment=Enum.HorizontalAlignment.Left,
SortOrder=Enum.SortOrder.LayoutOrder,Parent=self.titleContainer})if self.icon
then self.iconLabel=window:Create('ImageLabel',{Image=self.icon,Size=UDim2.
fromOffset(20,20),BorderSizePixel=0,BackgroundTransparency=1,LayoutOrder=0,
ZIndex=6,ImageTransparency=1,Parent=self.titleContainer},{ImageColor3=
'ContentColor'})end self.title=window:Create('TextLabel',{Text=locale.t(self.
name),Size=UDim2.fromOffset(0,16),AutomaticSize=Enum.AutomaticSize.X,
BorderSizePixel=0,BackgroundTransparency=1,TextSize=16,TextXAlignment=Enum.
TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,LayoutOrder=1,ZIndex=6,
TextTransparency=1,Parent=self.titleContainer},{TextColor3='ContentColor',
FontFace='Font'})window:Create('UIFlexItem',{FlexMode=Enum.UIFlexMode.Shrink,
Parent=self.title})self.readoutHost=window:Create('Frame',{AutomaticSize=Enum.
AutomaticSize.X,Size=UDim2.fromOffset(0,18),BackgroundTransparency=1,
BorderSizePixel=0,LayoutOrder=1,ZIndex=6,Parent=self.card})self.readoutOdo=
odometer.new(window,self.readoutHost,{textSize=17,alignment=Enum.
HorizontalAlignment.Right,transparency=1})self.readoutOdo:snap(self.display==
'change'and self:_formatChange(0)or self:_formatValue(self.value))self.
_accentGradients={self.strokeGradient,self.mainGradient}end function Statistic:
_setAccent(key,direction)local accent=accents[key]self.strokeGradient.Color=
accent.stroke self.mainGradient.Color=accent.fill if self.glow then self.glow.
Color=glowColor(accent)end local rotation=if direction==1 then 14 elseif
direction==-1 then-10 else 2 local offset=if direction==1 then Vector2.new(0.04,
0.5)elseif direction==-1 then Vector2.new(-0.04,0.5)else Vector2.new(0,0.5)for _
,gradient in self._accentGradients do variables.tweenService:Create(gradient,
accentTweenInfo,{Rotation=rotation,Offset=offset}):Play()end end function
Statistic:_formatValue(value)return self.prefix..formatValue(value)..self.suffix
end function Statistic:_formatChange(delta)if self.changeMode=='absolute'then
return formatChange(delta)else return formatPct(delta)end end function Statistic
:_showValue(odo,value,previousValue,hasNoHistory)if self.numberEasing and not
hasNoHistory then odo:to(self:_formatValue(value),value>=previousValue)else odo:
snap(self:_formatValue(value))end end function Statistic:_updateFullReadouts(
value,previousValue,targetChange,noChange,infinityText,hasNoHistory)self:
_showValue(self.valueOdo,value,previousValue,hasNoHistory)if infinityText then
self.changeOdo:snap(infinityText)self._lastChange=0 elseif self.numberEasing and
not noChange then self.changeOdo:to(self:_formatChange(targetChange),
targetChange>=self._lastChange)self._lastChange=targetChange else self.changeOdo
:snap(self:_formatChange(targetChange or 0))self._lastChange=targetChange or 0
end end function Statistic:_updateCompactReadout(value,previousValue,
targetChange,noChange,infinityText,hasNoHistory)if self.display=='change'then if
infinityText then self.readoutOdo:snap(infinityText)self._lastChange=0 elseif
self.numberEasing and not noChange then self.readoutOdo:to(self:_formatChange(
targetChange),targetChange>=self._lastChange)self._lastChange=targetChange else
self.readoutOdo:snap(self:_formatChange(targetChange or 0))self._lastChange=
targetChange or 0 end else self:_showValue(self.readoutOdo,value,previousValue,
hasNoHistory)end end function Statistic:Set(value)assert(typeof(value)=='number'
,'Statistic:Set() - value must be a number, got '..typeof(value))local
previousValue=self.value local hasNoHistory=not self._hasValue self.value=value
self._hasValue=true if hasNoHistory then self._initialValue=value end local
refValue=if self.changeBaseline=='initial'then self._initialValue else
previousValue local noChange=hasNoHistory or refValue==value local targetChange,
infinityText,accentKey,direction if noChange then targetChange=0 accentKey=
'neutral'direction=0 elseif refValue==0 then local sign=if value>0 then'+'else
'-'local suffix=if self.changeMode=='percentage'then'inf%'else'inf'infinityText=
sign..suffix accentKey=if value>0 then'positive'else'negative'direction=if value
>0 then 1 else-1 elseif self.changeMode=='percentage'then targetChange=((value-
refValue)/math.abs(refValue))*100 direction=if targetChange>0 then 1 elseif
targetChange<0 then-1 else 0 accentKey=if direction==1 then'positive'elseif
direction==-1 then'negative'else'neutral'else targetChange=value-refValue
direction=if targetChange>0 then 1 elseif targetChange<0 then-1 else 0 accentKey
=if direction==1 then'positive'elseif direction==-1 then'negative'else'neutral'
end self:_setAccent(accentKey,direction)if self.compact then self:
_updateCompactReadout(value,previousValue,targetChange,noChange,infinityText,
hasNoHistory)else self:_updateFullReadouts(value,previousValue,targetChange,
noChange,infinityText,hasNoHistory)end end function Statistic:ResetBaseline(
newBaseline)local previousValue=self.value local hasNoHistory=not self._hasValue
local baseline=if typeof(newBaseline)=='number'then newBaseline else self.value
self._initialValue=baseline self.value=baseline self._hasValue=true self.
_lastChange=0 if self.compact then if self.display=='change'then self.readoutOdo
:snap(self:_formatChange(0))else self:_showValue(self.readoutOdo,baseline,
previousValue,hasNoHistory)end else self.changeOdo:snap(self:_formatChange(0))
self:_showValue(self.valueOdo,baseline,previousValue,hasNoHistory)end self:
_setAccent('neutral',0)end function Statistic:_setShown(shown,animate)local w=
self.window if self.compact then w:_reveal(self.main,{BackgroundTransparency=if
shown then(self.window.theme.ElementTransparency or 0)else 1},animate)w:_reveal(
self.stroke,{Transparency=if shown then self.window.theme.
ElementStrokeTransparency else 1},animate)w:_reveal(self.card,{
BackgroundTransparency=if shown then 0 else 1},animate)w:_reveal(self.title,{
TextTransparency=if shown then 0 else 1},animate)if self.iconLabel then w:
_reveal(self.iconLabel,{ImageTransparency=if shown then 0 else 1},animate)end
self.readoutOdo:reveal(if shown then 0 else 1,animate)return end if shown then w
:_revealCommon(self,animate)w:_reveal(self.gradientContainer,{
BackgroundTransparency=0},animate)w:_reveal(self.glow,{Transparency=0.82},
animate)self.valueOdo:reveal(0,animate)self.changeOdo:reveal(0,animate)else w:
_hideCommon(self,animate)w:_reveal(self.gradientContainer,{
BackgroundTransparency=1},animate)w:_reveal(self.glow,{Transparency=1},animate)
self.valueOdo:reveal(1,animate)self.changeOdo:reveal(1,animate)end end function
Statistic:_minWidth()local w=30+10 if self.icon then w+=26 end w+=functions.
textWidth(self.window.theme.Font,16,locale.resolve(self.name))local readout=if
self.display=='change'then self:_formatChange(0)else self:_formatValue(self.
value)w+=functions.textWidth(self.window.theme.Font,17,readout)return w end
moveable(Statistic)return Statistic end end function __DARKLUA_BUNDLE_MODULES.s(
):typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.s if not v then v={c
=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.s=v end return v.c end end do
local function __modImpl()return function(script,require)local Tab={}Tab.__index
=Tab Tab.__type='Tab'local utility=script.Parent.Parent.utility local variables=
require(utility.variables)local functions=require(utility.functions)local locale
=require(utility.locale)local assignOrder=require(utility.ordering)local
hapticEngine=require(utility.HapticEngine)local search=require(script.Parent.
search)local function teardownElements(window,elements)for _,element in elements
do if element.__type=='Group'then teardownElements(window,element.elements)else
window:_unregisterControl(element)end if element.connections then for _,
connection in element.connections do window:Disconnect(connection)end element.
connections=nil end if element._dragConnection then element._dragConnection:
Disconnect()element._dragConnection=nil end if window._recordingKeybind==element
then window._recordingKeybind=nil end if element._outsideClickConn then window:
Disconnect(element._outsideClickConn)element._outsideClickConn=nil end end end
local tabStates={selected={background=0,stroke=0,content=0},hover={background=
0.4,stroke=0.3,content=0.3},unselected={background=0.8,stroke=0.65,content=0.5},
hidden={background=1,stroke=1,content=1}}local selectTweenInfo=TweenInfo.new(0.4
,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)local hoverTweenInfo=TweenInfo.
new(0.25,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)function Tab.new(window
,properties)properties=if typeof(properties)=='table'then properties else{}local
self=setmetatable({window=assert(window,'Missing argument #1 (Window expected)')
,name=properties.name or properties.Name,icon=properties.icon or properties.Icon
,neglectSelector=properties.neglectSelector or properties.NeglectSelector or
false,customOrder=properties.customOrder or properties.CustomOrder or 0,
forgetState=properties.forgetState or properties.ForgetState or false,elements={
},connections={}},Tab)assert(self.name or self.icon,
'A tab needs a name or an icon.')if not self.neglectSelector then self.
topbarItem=self.window:Create('Frame',{Name=self.name,Size=UDim2.fromOffset(0,34
),AutomaticSize=Enum.AutomaticSize.X,BackgroundColor3=Color3.fromRGB(255,255,255
),BorderSizePixel=0,BackgroundTransparency=1,Visible=false,LayoutOrder=self.
customOrder or 0,Parent=self.window.tabList})self.topbarItemInteract=self.window
:Create('TextButton',{Active=false,BackgroundTransparency=1,Size=UDim2.
fromScale(1,1),BorderSizePixel=0,Text='',TextTransparency=1,Parent=self.
topbarItem})self.window:Create('UICorner',{Parent=self.topbarItem},{CornerRadius
='PillCornerRadius'})self.topbarItemGradient=self.window:Create('UIGradient',{
Rotation=90,Parent=self.topbarItem},{Color={'TabBackground',functions.
toColorSequence}})self.topbarItemStroke=self.window:Create('UIStroke',{
ApplyStrokeMode=Enum.ApplyStrokeMode.Border,Color=Color3.fromRGB(255,255,255),
Transparency=1,Parent=self.topbarItem})self.topbarItemStrokeGradient=self.window
:Create('UIGradient',{Rotation=90,Parent=self.topbarItemStroke},{Color={
'TabStroke',functions.toColorSequence}})self.topbarItemContainer=self.window:
Create('Frame',{Size=UDim2.fromOffset(0,34),AutomaticSize=Enum.AutomaticSize.X,
BackgroundTransparency=1,BorderSizePixel=0,Parent=self.topbarItem})self.window:
Create('UIPadding',{PaddingLeft=UDim.new(0,13),PaddingRight=UDim.new(0,14),
Parent=self.topbarItemContainer})self.topbarItemLayout=self.window:Create(
'UIListLayout',{Padding=UDim.new(0,6),FillDirection=Enum.FillDirection.
Horizontal,VerticalAlignment=Enum.VerticalAlignment.Center,HorizontalAlignment=
Enum.HorizontalAlignment.Center,SortOrder=Enum.SortOrder.LayoutOrder,Parent=self
.topbarItemContainer})if self.icon then self.topbarItemIcon=self.window:Create(
'ImageLabel',{Image=self.icon,Size=UDim2.fromOffset(16,16),BorderSizePixel=0,
BackgroundTransparency=1,ImageTransparency=1,Parent=self.topbarItemContainer},{
ImageColor3='TabColor'})end if self.name then self.topbarItemTitle=self.window:
Create('TextLabel',{Text=locale.t(self.name),Size=UDim2.fromOffset(0,16),
BorderSizePixel=0,BackgroundTransparency=1,TextSize=16,AutomaticSize=Enum.
AutomaticSize.XY,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,
LayoutOrder=1,TextTransparency=1,Parent=self.topbarItemContainer},{TextColor3=
'TabColor',FontFace='Font'})end end self.tabPage=self.window:Create(
'ScrollingFrame',{Name=self.name,Size=UDim2.new(1,-20,1,0),Position=UDim2.
fromScale(0.5,0.5),AnchorPoint=Vector2.new(0.5,0.5),BorderSizePixel=0,
BackgroundTransparency=1,AutomaticCanvasSize=Enum.AutomaticSize.Y,CanvasSize=
UDim2.new(0,0,0,0),ScrollBarThickness=0,ScrollingDirection=Enum.
ScrollingDirection.Y,LayoutOrder=self.customOrder or 0,Parent=self.window.
elements})self.tabPageLayout=self.window:Create('UIListLayout',{Padding=UDim.
new(0,7),FillDirection=Enum.FillDirection.Vertical,VerticalAlignment=Enum.
VerticalAlignment.Top,HorizontalAlignment=Enum.HorizontalAlignment.Center,
SortOrder=Enum.SortOrder.LayoutOrder,Parent=self.tabPage})self.window:Create(
'UIPadding',{PaddingTop=UDim.new(0,10),PaddingBottom=UDim.new(0,33),Parent=self.
tabPage})if not self.neglectSelector then table.insert(self.connections,self.
window:Connect(self.topbarItemInteract.MouseButton1Click,function()hapticEngine.
click()self:Select()end))table.insert(self.connections,self.window:Connect(self.
topbarItemInteract.MouseEnter,function()if not self.window:_interactive()then
return end if self.window.selectedTab~=self then self:_applyVisual('hover',
hoverTweenInfo)self:_spinGradients()end end))table.insert(self.connections,self.
window:Connect(self.topbarItemInteract.MouseLeave,function()if self.window.
selectedTab~=self then self:_applyVisual('unselected',hoverTweenInfo)end end))
end return self end function Tab:_applyVisual(stateName,tweenInfo)if self.
neglectSelector or not self.topbarItem then return end local state=tabStates[
stateName]if not state then return end if tweenInfo then variables.tweenService:
Create(self.topbarItem,tweenInfo,{BackgroundTransparency=state.background}):
Play()variables.tweenService:Create(self.topbarItemStroke,tweenInfo,{
Transparency=state.stroke}):Play()if self.topbarItemIcon then variables.
tweenService:Create(self.topbarItemIcon,tweenInfo,{ImageTransparency=state.
content}):Play()end if self.topbarItemTitle then variables.tweenService:Create(
self.topbarItemTitle,tweenInfo,{TextTransparency=state.content}):Play()end else
self.topbarItem.BackgroundTransparency=state.background self.topbarItemStroke.
Transparency=state.stroke if self.topbarItemIcon then self.topbarItemIcon.
ImageTransparency=state.content end if self.topbarItemTitle then self.
topbarItemTitle.TextTransparency=state.content end end end function Tab:
_spinGradients()if self.neglectSelector then return end local spinInfo=TweenInfo
.new(0.7,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)for _,gradient in{self.
topbarItemGradient,self.topbarItemStrokeGradient}do gradient.Rotation=90-360
variables.tweenService:Create(gradient,spinInfo,{Rotation=90}):Play()end end
function Tab:Select(noAnimation)if self.window._searching then search.close(self
.window,{showTabs=true,jumpTo=false})end self.window.selectedTab=self self.
window:_jumpTo(self.tabPage)local skipAnimation=noAnimation or not self.window:
_interactive()if not self.neglectSelector and not skipAnimation then self:
_applyVisual('selected',selectTweenInfo)end for _,tab in self.window.tabs do if
tab~=self.window.selectedTab then tab:Deselect(skipAnimation)end end if self~=
self.window.rfSettings and self.window.settingsAction and not skipAnimation then
variables.tweenService:Create(self.window.settingsAction.iconLabel,TweenInfo.
new(0.25,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{ImageTransparency=0.6
}):Play()end end function Tab:Deselect(noAnimation)if not self.neglectSelector
and not noAnimation then self:_applyVisual('unselected',selectTweenInfo)end end
function Tab:_register(element)table.insert(self.elements,element)assignOrder(
element,#self.elements*10)self.window:_restoreLate(element)if not self.window.
hidden then element:_setShown(true,true)end return element end function Tab:
CreateButton(properties)return self:_register(require(script.Parent.button).new(
self,properties))end function Tab:CreateToggle(properties)return self:_register(
require(script.Parent.toggle).new(self,properties))end function Tab:CreateSwitch
(properties)return self:CreateToggle(properties)end function Tab:CreateSection(
properties)return self:_register(require(script.Parent.section).new(self,
properties))end function Tab:CreateText(properties)return self:_register(
require(script.Parent.text).new(self,properties))end function Tab:CreateDivider(
properties)return self:_register(require(script.Parent.divider).new(self,
properties))end function Tab:CreateESPPreview(properties)return self:_register(
require(script.Parent.esppreview).new(self,properties))end function Tab:
CreateStat(properties)return self:_register(require(script.Parent.stat).new(self
,properties))end function Tab:CreateSlider(properties)return self:_register(
require(script.Parent.slider).new(self,properties))end function Tab:
CreateDropdown(properties)return self:_register(require(script.Parent.dropdown).
new(self,properties))end function Tab:CreateInput(properties)return self:
_register(require(script.Parent.input).new(self,properties))end function Tab:
CreateKeybind(properties)return self:_register(require(script.Parent.keybind).
new(self,properties))end function Tab:CreateColorPicker(properties)return self:
_register(require(script.Parent.colorpicker).new(self,properties))end function
Tab:CreateGroup(properties)return self:_register(require(script.Parent.group).
new(self,properties))end function Tab:_moveElement(element,targetIndex)local idx
=table.find(self.elements,element)if not idx then return end table.remove(self.
elements,idx)targetIndex=math.clamp(targetIndex,1,#self.elements+1)table.insert(
self.elements,targetIndex,element)for i,el in self.elements do assignOrder(el,i*
10)end end function Tab:Remove()local window=self.window if window._searching
then search.close(window,{showTabs=true,jumpTo=window.selectedTab and window.
selectedTab.tabPage})end local idx=table.find(window.tabs,self)if idx then table
.remove(window.tabs,idx)end if window.selectedTab==self then window.selectedTab=
nil for _,tab in ipairs(window.tabs)do if not tab.neglectSelector then tab:
Select()break end end end teardownElements(window,self.elements)for _,connection
in self.connections do window:Disconnect(connection)end self.connections={}if
self.topbarItem then window:DestroySubtree(self.topbarItem)end if self.tabPage
then window:DestroySubtree(self.tabPage)end self.topbarItem=nil self.tabPage=nil
self.elements={}end return Tab end end function __DARKLUA_BUNDLE_MODULES.t():
typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.t if not v then v={c=
__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.t=v end return v.c end end do
local function __modImpl()return function(script,require)local Tag={}Tag.__index
=Tag Tag.__type='Tag'local utility=script.Parent.Parent.utility local variables=
require(utility.variables)local functions=require(utility.functions)local image=
require(utility.image)local defaultColor=Color3.fromRGB(255,175,15)local
setTweenInfo=TweenInfo.new(0.25,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)
function Tag.new(window,properties)properties=if typeof(properties)=='table'then
properties else{}local self=setmetatable({window=assert(window,
'Missing argument #1 (Window expected)'),text=properties.text or properties.Text
or properties.title or properties.Title,icon=properties.icon or properties.Icon,
color=properties.color or properties.Color or defaultColor},Tag)assert(self.icon
or(self.text and self.text~=''),'A Tag requires an icon, text, or both.')self.
main=self.window:Create('Frame',{Name='Tag',Size=UDim2.fromOffset(10,24),
AutomaticSize=Enum.AutomaticSize.X,BackgroundColor3=self.color,BorderSizePixel=0
,LayoutOrder=properties.order or properties.Order or 0,BackgroundTransparency=1,
Parent=self.window.tagContainer})self.window:Create('UICorner',{CornerRadius=
UDim.new(1,0),Parent=self.main})self.window:Create('UIPadding',{PaddingLeft=UDim
.new(0,10),PaddingRight=UDim.new(0,10),Parent=self.main})self.window:Create(
'UIListLayout',{Padding=UDim.new(0,5),FillDirection=Enum.FillDirection.
Horizontal,VerticalAlignment=Enum.VerticalAlignment.Center,SortOrder=Enum.
SortOrder.LayoutOrder,Parent=self.main})local contrast=functions.contrastColor(
self.color)self.iconLabel=self.window:Create('ImageLabel',{Name='Icon',Image=
self.icon or'',ImageColor3=contrast,Size=UDim2.fromOffset(16,16),
BackgroundTransparency=1,Visible=self.icon~=nil,ZIndex=5,ImageTransparency=1,
Parent=self.main})self.title=self.window:Create('TextLabel',{Name='Title',
AnchorPoint=Vector2.new(0,0.5),Size=UDim2.fromOffset(10,15),AutomaticSize=Enum.
AutomaticSize.X,BackgroundTransparency=1,Text=self.text or'',TextColor3=contrast
,TextSize=15,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,RichText=
true,Visible=self.text~=nil and self.text~='',LayoutOrder=1,ZIndex=5,
TextTransparency=1,Parent=self.main},{FontFace='Font'})self.window.tagContainer.
Visible=true if not self.window.hidden then self:_setShown(true,setTweenInfo)end
return self end function Tag:_setShown(shown,animate)local target=if shown then
0 else 1 local info=if typeof(animate)=='TweenInfo'then animate elseif animate
then setTweenInfo else nil if info then variables.tweenService:Create(self.main,
info,{BackgroundTransparency=target}):Play()variables.tweenService:Create(self.
iconLabel,info,{ImageTransparency=target}):Play()variables.tweenService:Create(
self.title,info,{TextTransparency=target}):Play()else self.main.
BackgroundTransparency=target self.iconLabel.ImageTransparency=target self.title
.TextTransparency=target end end function Tag:SetColor(color)self.color=color
local contrast=functions.contrastColor(color)variables.tweenService:Create(self.
main,setTweenInfo,{BackgroundColor3=color}):Play()variables.tweenService:Create(
self.iconLabel,setTweenInfo,{ImageColor3=contrast}):Play()variables.tweenService
:Create(self.title,setTweenInfo,{TextColor3=contrast}):Play()end function Tag:
SetText(text)self.text=text self.title.Text=text or''self.title.Visible=text~=
nil and text~=''end function Tag:SetIcon(icon)self.icon=icon image.assign(self.
iconLabel,'Image',icon)self.iconLabel.Visible=icon~=nil end function Tag:Set(
properties)if properties.color or properties.Color then self:SetColor(properties
.color or properties.Color)end if properties.text or properties.Text or
properties.title or properties.Title then self:SetText(properties.text or
properties.Text or properties.title or properties.Title)end if properties.icon~=
nil or properties.Icon~=nil then self:SetIcon(properties.icon or properties.Icon
)end end function Tag:Remove()self.window:DestroySubtree(self.main)local idx=
table.find(self.window.tags,self)if idx then table.remove(self.window.tags,idx)
end if#self.window.tags==0 then self.window.tagContainer.Visible=false end end
return Tag end end function __DARKLUA_BUNDLE_MODULES.u():typeof(__modImpl())
local v=__DARKLUA_BUNDLE_MODULES.cache.u if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.u=v end return v.c end end do local function
__modImpl()return function(script,require)local Text={}Text.__index=Text Text.
__type='Text'local moveable=require(script.Parent.Parent.utility.moveable)local
locale=require(script.Parent.Parent.utility.locale)local titleSize=16 local
bodySize=14 local bodyShown=0.45 function Text.new(tab,properties)properties=if
typeof(properties)=='table'then properties else{}local self=setmetatable({tab=
assert(tab,'Missing argument #1 (Tab expected)'),window=tab.window,name=
tostring(properties.name or properties.Name or''),text=tostring(properties.text
or properties.Text or''),icon=properties.icon or properties.Icon},Text)self.main
=self.window:Create('Frame',{Size=UDim2.new(1,-20,0,0),AutomaticSize=Enum.
AutomaticSize.Y,BorderSizePixel=0,Name=if self.name~=''then self.name else'Text'
,BackgroundColor3=Color3.fromRGB(255,255,255),BackgroundTransparency=1,Parent=
self.tab.tabPage},{BackgroundTransparency='ElementTransparency'})self.stroke=
self.window:StyleElementBody(self.main)self.window:Create('UIPadding',{
PaddingTop=UDim.new(0,14),PaddingBottom=UDim.new(0,14),PaddingLeft=UDim.new(0,20
),PaddingRight=UDim.new(0,20),Parent=self.main})self.window:Create(
'UIListLayout',{Padding=UDim.new(0,6),SortOrder=Enum.SortOrder.LayoutOrder,
Parent=self.main})self.titleRow=self.window:Create('Frame',{Name='Title',Size=
UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BorderSizePixel=0,
BackgroundTransparency=1,LayoutOrder=1,Parent=self.main})self.window:Create(
'UIListLayout',{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,6
),SortOrder=Enum.SortOrder.LayoutOrder,VerticalAlignment=Enum.VerticalAlignment.
Top,Parent=self.titleRow})if self.icon then self.iconLabel=self.window:Create(
'ImageLabel',{Image=self.icon,Size=UDim2.fromOffset(16,16),BorderSizePixel=0,
BackgroundTransparency=1,ImageTransparency=1,Parent=self.titleRow},{ImageColor3=
'ContentColor'})end self.title=self.window:Create('TextLabel',{Text=locale.t(
self.name),Size=UDim2.new(1,if self.icon then-22 else 0,0,0),AutomaticSize=Enum.
AutomaticSize.Y,BorderSizePixel=0,BackgroundTransparency=1,RichText=true,
TextSize=titleSize,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,
LayoutOrder=1,TextTransparency=1,Parent=self.titleRow},{TextColor3=
'TitlingColor',FontFace='Font'})self.body=self.window:Create('TextLabel',{Text=
locale.t(self.text),Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,
BorderSizePixel=0,BackgroundTransparency=1,RichText=true,TextSize=bodySize,
TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,LayoutOrder=2,
TextTransparency=1,Parent=self.main},{TextColor3='ContentColor',FontFace='Font'}
)self:_applyPresence()return self end function Text:_applyPresence()self.
titleRow.Visible=self.name~=''or self.icon~=nil self.body.Visible=self.text~=''
end function Text:Set(text)self.text=tostring(text)self.window:_bindLocale(self.
body,'Text',self.text)self:_applyPresence()end function Text:SetTitle(title)self
.name=tostring(title)self.window:_bindLocale(self.title,'Text',self.name)self:
_applyPresence()end function Text:_setShown(shown,animate)if shown then self.
window:_revealCommon(self,animate)else self.window:_hideCommon(self,animate)end
self.window:_reveal(self.body,{TextTransparency=if shown then bodyShown else 1},
animate)end moveable(Text)return Text end end function __DARKLUA_BUNDLE_MODULES.
v():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.v if not v then v=
{c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.v=v end return v.c end end do
local function __modImpl()return function(script,require)local Toast={}Toast.
__index=Toast Toast.__type='Toast'local utility=script.Parent.Parent.utility
local variables=require(utility.variables)local functions=require(utility.
functions)local constants=require(utility.constants)local image=require(utility.
image)local hapticEngine=require(utility.HapticEngine)local slideInfo=TweenInfo.
new(0.6,Enum.EasingStyle.Exponential,Enum.EasingDirection.Out)local growInfo=
TweenInfo.new(0.6,Enum.EasingStyle.Exponential,Enum.EasingDirection.Out)local
fadeLong=TweenInfo.new(0.4,Enum.EasingStyle.Exponential,Enum.EasingDirection.Out
)local fadeShort=TweenInfo.new(0.3,Enum.EasingStyle.Exponential,Enum.
EasingDirection.Out)local shrinkInfo=TweenInfo.new(0.6,Enum.EasingStyle.
Exponential,Enum.EasingDirection.Out)local iconSize=24 local avatarSize=32 local
leftPadding=18 local rightPadding=18 local avatarLeftPadding=10 local
avatarRightPadding=28 local iconGap=12 local stackPadding=8 local MIN_WIDTH,
MAX_WIDTH=140,320 local maxLive=6 local offscreenAbove=UDim2.new(0.5,0,0.5,-180)
local offscreenBelow=UDim2.new(0.5,0,0.5,180)local centred=UDim2.new(0.5,0,0.5,0
)local function autoDuration(text)return math.clamp(#text*0.06+3,3,9)end
local function resolveImage(icon)if type(icon)=='number'then return
'rbxassetid://'..tostring(icon)end return icon end function Toast.new(window,
properties,container)properties=if typeof(properties)=='table'then properties
else{}local self=setmetatable({window=assert(window,
'Missing argument #1 (Window expected)'),title=properties.title or properties.
Title or'',subtitle=properties.subtitle or properties.Subtitle,icon=properties.
icon or properties.Icon,avatar=properties.avatar or properties.Avatar,minWidth=
properties.minWidth or properties.MinWidth,subtitleAbove=properties.
subtitleAbove or properties.SubtitleAbove or false,position=properties.position
or'Top',_hovered=false,_dismissed=false},Toast)self.duration=properties.duration
or properties.Duration or autoDuration(self.title..(self.subtitle or''))local
hasAvatar=self.avatar~=nil and self.avatar~=0 local hasIcon=hasAvatar or(self.
icon~=nil and self.icon~=0 and self.icon~='')self._iconImage=if hasAvatar then
image.avatar(self.avatar,function(uri)if self.iconLabel and not self._dismissed
and self.main.Parent then image.assign(self.iconLabel,'Image',uri)end end)elseif
hasIcon then resolveImage(self.icon)else nil self._iconSize=if hasAvatar then
avatarSize else iconSize self._leftPad=if hasAvatar then avatarLeftPadding else
leftPadding self._rightPad=if hasAvatar then avatarRightPadding else
rightPadding self._minWidth=math.clamp(self.minWidth or 0,MIN_WIDTH,MAX_WIDTH)
local hasSubtitle=self.subtitle~=nil and self.subtitle~=''self.main=self.window:
Create('Frame',{Name='Toast',BackgroundTransparency=1,Size=UDim2.new(0,0,0,0),
BorderSizePixel=0,ZIndex=constants.zIndex.toast,Parent=container or self.window.
toasts})self.window:Create('UIPadding',{PaddingTop=UDim.new(0,stackPadding),
Parent=self.main})self.body=self.window:Create('Frame',{BackgroundColor3=Color3.
fromRGB(255,255,255),Size=UDim2.new(1,0,1,0),Position=if self.position=='Bottom'
then offscreenBelow else offscreenAbove,AnchorPoint=Vector2.new(0.5,0.5),Active=
true,BorderSizePixel=0,ZIndex=constants.zIndex.toast,BackgroundTransparency=1,
Parent=self.main})self.window:Create('UIGradient',{Rotation=270,Offset=Vector2.
new(0,-0.1),Parent=self.body},{Color={'WindowColor',functions.toColorSequence}})
self.window:Create('UICorner',{CornerRadius=UDim.new(1,0),Parent=self.body})self
.stroke=self.window:Create('UIStroke',{Transparency=1,Parent=self.body},{Color=
'SurfaceStroke'})self.shadow=self.window:CreateGlow(self.body,'ShadowColor',20,1
)self.window:Create('UIPadding',{PaddingLeft=UDim.new(0,self._leftPad),
PaddingRight=UDim.new(0,self._rightPad),Parent=self.body})self.window:Create(
'UIListLayout',{FillDirection=Enum.FillDirection.Horizontal,VerticalAlignment=
Enum.VerticalAlignment.Center,HorizontalAlignment=Enum.HorizontalAlignment.Left,
SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,iconGap),Parent=self.
body})if hasIcon then self.iconLabel=self.window:Create('ImageLabel',{Image=self
._iconImage,Size=UDim2.fromOffset(self._iconSize,self._iconSize),
BackgroundColor3=Color3.fromRGB(255,255,255),BorderSizePixel=0,LayoutOrder=1,
ZIndex=constants.zIndex.toastContent,BackgroundTransparency=1,ImageTransparency=
1,Parent=self.body},if hasAvatar then nil else{ImageColor3='ContentColor'})self.
window:Create('UICorner',{CornerRadius=UDim.new(1,0),Parent=self.iconLabel})end
self.container=self.window:Create('Frame',{AutomaticSize=Enum.AutomaticSize.X,
Size=UDim2.fromOffset(0,hasSubtitle and 32 or 16),BackgroundTransparency=1,
BorderSizePixel=0,LayoutOrder=2,ZIndex=constants.zIndex.toastContent,Parent=self
.body})self.window:Create('UIListLayout',{FillDirection=Enum.FillDirection.
Vertical,VerticalAlignment=Enum.VerticalAlignment.Center,SortOrder=Enum.
SortOrder.LayoutOrder,Padding=UDim.new(0,1),Parent=self.container})self.
titleLabel=self.window:Create('TextLabel',{Text=self.title,AutomaticSize=Enum.
AutomaticSize.X,Size=UDim2.fromOffset(0,16),BackgroundTransparency=1,TextSize=16
,TextXAlignment=Enum.TextXAlignment.Left,LayoutOrder=if self.subtitleAbove then
2 else 1,ZIndex=constants.zIndex.toastContent,TextTransparency=1,Parent=self.
container},{TextColor3='ContentColor',FontFace='TitleFont'})if hasSubtitle then
self.subtitleLabel=self.window:Create('TextLabel',{Text=self.subtitle,
AutomaticSize=Enum.AutomaticSize.X,Size=UDim2.fromOffset(0,14),
BackgroundTransparency=1,TextSize=14,TextXAlignment=Enum.TextXAlignment.Left,
LayoutOrder=if self.subtitleAbove then 1 else 2,ZIndex=constants.zIndex.
toastContent,TextTransparency=1,Parent=self.container},{TextColor3=
'ContentColor',FontFace='Font'})end self.window._toastCount=(self.window.
_toastCount or 0)+1 self.main.LayoutOrder=-self.window._toastCount local stacks=
self.window._liveToasts if not stacks then stacks={}self.window._liveToasts=
stacks end local live=stacks[self.main.Parent]if not live then live={}stacks[
self.main.Parent]=live end self._live=live table.insert(live,self)while#live>
maxLive do local oldest=table.remove(live,1)if oldest and oldest~=self then task
.spawn(oldest._dismiss,oldest)end end self._connections={self.window:Connect(
self.body.MouseEnter,function()self._hovered=true end),self.window:Connect(self.
body.MouseLeave,function()self._hovered=false end),self.window:Connect(self.body
.InputBegan,function(input)if input.UserInputType==Enum.UserInputType.
MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then self:
_dismiss()end end)}task.spawn(function()self:_show()end)return self end function
Toast:_measure()local titleWidth=functions.textWidth(self.window.theme.TitleFont
,16,self.title)local subtitleWidth=if self.subtitleLabel then functions.
textWidth(self.window.theme.Font,14,self.subtitle)else 0 local textWidth=math.
max(titleWidth,subtitleWidth)local left=if self.iconLabel then self._leftPad+
self._iconSize+iconGap else self._leftPad local width=math.clamp(left+textWidth+
self._rightPad,self._minWidth,MAX_WIDTH)if left+textWidth+self._rightPad>
MAX_WIDTH then local column=MAX_WIDTH-left-self._rightPad for _,label in{self.
titleLabel,self.subtitleLabel}do if label then label.AutomaticSize=Enum.
AutomaticSize.None label.TextTruncate=Enum.TextTruncate.AtEnd label.Size=UDim2.
fromOffset(column,label.Size.Y.Offset)end end end local textHeight=if self.
subtitleLabel then 16+1+14 else 16 local height=math.max(textHeight,if self.
iconLabel then self._iconSize else 0)+18 return width,height end function Toast:
_show()if not self.main.Parent then return end hapticEngine.notify()local width,
height=self:_measure()if self._dismissed or not self.main.Parent then return end
self.main.Size=UDim2.new(0,width,0,0)variables.tweenService:Create(self.main,
growInfo,{Size=UDim2.new(0,width,0,height+stackPadding)}):Play()variables.
tweenService:Create(self.body,slideInfo,{Position=centred}):Play()variables.
tweenService:Create(self.body,fadeLong,{BackgroundTransparency=0}):Play()
variables.tweenService:Create(self.stroke,fadeLong,{Transparency=0.9}):Play()
variables.tweenService:Create(self.shadow,fadeShort,{Transparency=0.6}):Play()
variables.tweenService:Create(self.titleLabel,fadeShort,{TextTransparency=0}):
Play()task.wait(0.05)if self._dismissed or not self.main.Parent then return end
if self.iconLabel then variables.tweenService:Create(self.iconLabel,fadeShort,{
BackgroundTransparency=0.95}):Play()variables.tweenService:Create(self.iconLabel
,fadeShort,{ImageTransparency=0}):Play()end task.wait(0.05)if self._dismissed or
not self.main.Parent then return end if self.subtitleLabel then variables.
tweenService:Create(self.subtitleLabel,fadeShort,{TextTransparency=0.5}):Play()
end local elapsed=0 while elapsed<self.duration and not self._dismissed and self
.main.Parent do local dt=task.wait()if not self._hovered then elapsed+=dt end
end self:_dismiss()end function Toast:_dismiss()if self._dismissed then return
end self._dismissed=true local live=self._live local index=live and table.find(
live,self)if live and index then table.remove(live,index)end if not self.main.
Parent then return end variables.tweenService:Create(self.body,fadeLong,{
BackgroundTransparency=1}):Play()variables.tweenService:Create(self.stroke,
fadeLong,{Transparency=1}):Play()variables.tweenService:Create(self.shadow,
fadeShort,{Transparency=1}):Play()variables.tweenService:Create(self.titleLabel,
fadeShort,{TextTransparency=1}):Play()if self.subtitleLabel then variables.
tweenService:Create(self.subtitleLabel,fadeShort,{TextTransparency=1}):Play()end
if self.iconLabel then variables.tweenService:Create(self.iconLabel,fadeShort,{
ImageTransparency=1,BackgroundTransparency=1}):Play()end variables.tweenService:
Create(self.body,shrinkInfo,{Size=UDim2.new(1,-60,1,0)}):Play()local collapse=
variables.tweenService:Create(self.main,shrinkInfo,{Size=UDim2.new(0,self.main.
Size.X.Offset,0,0)})collapse:Play()collapse.Completed:Wait()if not self.main.
Parent then return end for _,connection in self._connections do self.window:
Disconnect(connection)end self.window:DestroySubtree(self.main)end return Toast
end end function __DARKLUA_BUNDLE_MODULES.w():typeof(__modImpl())local v=
__DARKLUA_BUNDLE_MODULES.cache.w if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.w=v end return v.c end end do local function
__modImpl()return function(script,require)local Toggle={}Toggle.__index=Toggle
Toggle.__type='Toggle'local utility=script.Parent.Parent.utility local variables
=require(utility.variables)local functions=require(utility.functions)local
moveable=require(utility.moveable)local locale=require(utility.locale)local
hapticEngine=require(utility.HapticEngine)function Toggle.new(tab,properties)
properties=if typeof(properties)=='table'then properties else{}local self=
setmetatable({tab=assert(tab,'Missing argument #1 (Tab expected)'),window=tab.
window,name=properties.name or properties.Name or'Switch',icon=properties.icon
or properties.Icon,description=properties.description or properties.Description,
forgetState=properties.forgetState or properties.ForgetState or tab.forgetState,
compact=tab.compact or false,flag=properties.flag or properties.Flag or(not(
properties.forgetState or properties.ForgetState or tab.forgetState)and
functions.deriveFlagFromName(properties.name or properties.Name or'Switch')or
nil),callback=properties.callback or properties.Callback or function()end,value=
if(properties.value or properties.Value)~=nil then(properties.value or
properties.Value)else false},Toggle)self.window:_registerControl(self)if self.
compact then self:_buildCompact()else self:_buildFull()end if self.description
and not self.compact then self.descriptor=require(script.Parent.descriptor).new(
self.tab,{description=self.description})end return self end function Toggle:
_buildSwitch(parent)local window=self.window self.functionContainer=window:
Create('Frame',{BorderSizePixel=0,Size=UDim2.fromOffset(50,21),
BackgroundTransparency=1,Parent=parent},{BackgroundColor3='ToggleTrack'})window:
Create('UICorner',{CornerRadius=UDim.new(0,15),Parent=self.functionContainer})
self.containerStroke=window:Create('UIStroke',{Transparency=1,Parent=self.
functionContainer},{Color='SurfaceStroke'})self.indicator=window:Create('Frame',
{BorderSizePixel=0,Size=UDim2.fromOffset(25,17),Position=self.value and UDim2.
new(1,-28,0.5,0)or UDim2.new(1,-47,0.5,0),AnchorPoint=Vector2.new(0,0.5),
BackgroundColor3=self.value and self.window.theme.AccentColor or self.window.
theme.ToggleKnobOff,BackgroundTransparency=1,Parent=self.functionContainer})
window:Create('UICorner',{CornerRadius=UDim.new(1,0),Parent=self.indicator})self
.indicatorStroke=window:Create('UIStroke',{Color=self.value and self.window.
theme.AccentStroke or Color3.fromRGB(255,255,255),Transparency=1,Parent=self.
indicator})self.indicatorGlow=window:CreateGlow(self.indicator,'AccentColor',20,
1)self.overlay=window:Create('Frame',{BorderSizePixel=0,Size=UDim2.fromScale(1,1
),Position=UDim2.fromScale(0,0),AnchorPoint=Vector2.new(0,0),BackgroundColor3=
Color3.fromRGB(255,255,255),BackgroundTransparency=1,Parent=self.
functionContainer},{Visible='DarkToggleOverlay'})window:Create('UICorner',{
CornerRadius=UDim.new(0,15),Parent=self.overlay})self.overlayGradient=window:
Create('UIGradient',{Rotation=90,Color=ColorSequence.new({ColorSequenceKeypoint.
new(0,Color3.fromRGB(30,30,30)),ColorSequenceKeypoint.new(1,Color3.fromRGB(30,30
,30))}),Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1),
NumberSequenceKeypoint.new(1,0.35)}),Parent=self.overlay})return self.
functionContainer end function Toggle:_notifyState()local window=self.window if
window.unloaded or window._loading or window._pulseLoading or not window.
hasShownOnce then return end window:Notify({title=self.name,content=self.value
and'Enabled'or'Disabled',duration=1.7})end function Toggle:_performToggle()
hapticEngine.click()self.value=not self.value self:_animateIndicator()self.
window:_runGuarded(self,self.callback,self.value)self.window:_persist(self)self:
_notifyState()end function Toggle:_buildFull()local window=self.window self.main
=window:Create('Frame',{Size=UDim2.new(1,-20,0,41),BorderSizePixel=0,Name=self.
name,BackgroundColor3=Color3.fromRGB(255,255,255),BackgroundTransparency=1,
Parent=self.tab.tabPage},{BackgroundTransparency='ElementTransparency'})self.
stroke=window:StyleElementBody(self.main)self.hoverOverlay=window:
CreateHoverOverlay(self.main)self.container=window:Create('Frame',{
BorderSizePixel=0,Parent=self.main,Size=UDim2.new(0,170,0,16),Position=UDim2.
new(0,20,0.5,0),AnchorPoint=Vector2.new(0,0.5),BackgroundTransparency=1})self.
containerLayout=window:Create('UIListLayout',{Padding=UDim.new(0,5),
FillDirection=Enum.FillDirection.Horizontal,VerticalAlignment=Enum.
VerticalAlignment.Center,HorizontalAlignment=Enum.HorizontalAlignment.Left,
Parent=self.container})if self.icon then self.iconLabel=window:Create(
'ImageLabel',{Image=self.icon,Size=UDim2.fromOffset(16,16),BorderSizePixel=0,
BackgroundTransparency=1,ImageTransparency=1,Parent=self.container},{ImageColor3
='ContentColor'})end self.title=window:Create('TextLabel',{Text=locale.t(self.
name),Size=UDim2.fromOffset(250,16),BorderSizePixel=0,BackgroundTransparency=1,
TextSize=16,AutomaticSize=Enum.AutomaticSize.X,TextXAlignment=Enum.
TextXAlignment.Left,TextWrapped=true,LayoutOrder=1,TextTransparency=1,Parent=
self.container},{TextColor3='ContentColor',FontFace='Font'})self.interact=window
:Create('TextButton',{BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),
BorderSizePixel=0,Position=UDim2.fromScale(1,0.5),AnchorPoint=Vector2.new(1,0.5)
,TextTransparency=1,ZIndex=10,Parent=self.main})self:_buildSwitch(self.main)self
.functionContainer.Position=UDim2.new(1,-15,0,20)self.functionContainer.
AnchorPoint=Vector2.new(1,0.5)self.window:_wireElementHover(self)self.window:
ConnectFor(self,self.interact.MouseButton1Click,function()variables.tweenService
:Create(self.stroke,TweenInfo.new(0.25,Enum.EasingStyle.Quint,Enum.
EasingDirection.Out),{Transparency=1}):Play()variables.tweenService:Create(self.
main,TweenInfo.new(0.6,Enum.EasingStyle.Exponential,Enum.EasingDirection.Out),{
Size=UDim2.new(1,-26,0,41)}):Play()self:_performToggle()task.wait(0.11)variables
.tweenService:Create(self.main,TweenInfo.new(0.25,Enum.EasingStyle.Exponential,
Enum.EasingDirection.Out),{Size=UDim2.new(1,-20,0,41)}):Play()variables.
tweenService:Create(self.stroke,TweenInfo.new(0.25,Enum.EasingStyle.Quint,Enum.
EasingDirection.Out),{Transparency=self.window.theme.ElementStrokeTransparency})
:Play()end)end function Toggle:_buildCompact()local window=self.window self.main
,self.stroke,self.interact=window:_buildCompactRow(self.tab,self.name,10)self.
hoverOverlay=self.interact window:Create('UIPadding',{PaddingLeft=UDim.new(0,15)
,PaddingRight=UDim.new(0,15),Parent=self.interact})window:Create('UIListLayout',
{FillDirection=Enum.FillDirection.Horizontal,VerticalAlignment=Enum.
VerticalAlignment.Center,HorizontalFlex=Enum.UIFlexAlignment.SpaceBetween,
Padding=UDim.new(0,10),Parent=self.interact})self.container=window:Create(
'Frame',{AutomaticSize=Enum.AutomaticSize.X,Size=UDim2.fromOffset(0,16),
BackgroundTransparency=1,BorderSizePixel=0,LayoutOrder=0,Parent=self.interact})
window:Create('UIFlexItem',{FlexMode=Enum.UIFlexMode.Shrink,Parent=self.
container})window:Create('UIListLayout',{Padding=UDim.new(0,5),FillDirection=
Enum.FillDirection.Horizontal,VerticalAlignment=Enum.VerticalAlignment.Center,
HorizontalAlignment=Enum.HorizontalAlignment.Left,Parent=self.container})if self
.icon then self.iconLabel=window:Create('ImageLabel',{Image=self.icon,Size=UDim2
.fromOffset(16,16),BorderSizePixel=0,BackgroundTransparency=1,LayoutOrder=0,
ImageTransparency=1,Parent=self.container},{ImageColor3='ContentColor'})end self
.title=window:Create('TextLabel',{Text=locale.t(self.name),Size=UDim2.
fromOffset(0,16),AutomaticSize=Enum.AutomaticSize.X,BorderSizePixel=0,
BackgroundTransparency=1,TextSize=16,TextXAlignment=Enum.TextXAlignment.Left,
TextTruncate=Enum.TextTruncate.AtEnd,LayoutOrder=1,TextTransparency=1,Parent=
self.container},{TextColor3='ContentColor',FontFace='Font'})window:Create(
'UIFlexItem',{FlexMode=Enum.UIFlexMode.Shrink,Parent=self.title})self:
_buildSwitch(self.interact)self.functionContainer.LayoutOrder=1 self.window:
_wireElementHover(self)self.window:ConnectFor(self,self.interact.
MouseButton1Click,function()variables.tweenService:Create(self.stroke,TweenInfo.
new(0.25,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Transparency=1}):
Play()self:_performToggle()task.wait(0.11)variables.tweenService:Create(self.
stroke,TweenInfo.new(0.25,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{
Transparency=self.window.theme.ElementStrokeTransparency}):Play()end)end
function Toggle:_animateIndicator()local info=TweenInfo.new(0.6,Enum.EasingStyle
.Exponential,Enum.EasingDirection.Out)if self.indicatorGlow then variables.
tweenService:Create(self.indicatorGlow,info,{Transparency=self.value and self.
window.theme.AccentGlow or 1}):Play()end if self.value then variables.
tweenService:Create(self.indicator,info,{Position=UDim2.new(1,-28,0.5,0),
BackgroundColor3=self.window.theme.AccentColor,BackgroundTransparency=0}):Play()
variables.tweenService:Create(self.indicatorStroke,info,{Color=self.window.theme
.AccentStroke,Transparency=0}):Play()else variables.tweenService:Create(self.
indicator,info,{Position=UDim2.new(1,-47,0.5,0),BackgroundColor3=self.window.
theme.ToggleKnobOff,BackgroundTransparency=self.window.theme.
ToggleKnobOffTransparency}):Play()variables.tweenService:Create(self.
indicatorStroke,info,{Color=Color3.fromRGB(255,255,255),Transparency=0.7}):Play(
)end end local toggleReveal=TweenInfo.new(0.6,Enum.EasingStyle.Exponential,Enum.
EasingDirection.Out)local toggleGlowReveal=TweenInfo.new(0.6,Enum.EasingStyle.
Exponential,Enum.EasingDirection.Out,0,false,0.35)function Toggle:_setShown(
shown,animate)local w=self.window if shown then w:_revealCommon(self,animate)w:
_reveal(self.indicator,{BackgroundColor3=self.value and w.theme.AccentColor or w
.theme.ToggleKnobOff,BackgroundTransparency=self.value and 0 or w.theme.
ToggleKnobOffTransparency},animate,toggleReveal)w:_reveal(self.indicatorStroke,{
Color=self.value and w.theme.AccentStroke or Color3.fromRGB(255,255,255),
Transparency=self.value and 0 or 0.7},animate,toggleReveal)w:_reveal(self.
indicatorGlow,{Transparency=self.value and w.theme.AccentGlow or 1},animate,
toggleGlowReveal)w:_reveal(self.overlay,{BackgroundTransparency=0},animate,
toggleReveal)w:_reveal(self.containerStroke,{Transparency=0.85},animate,
toggleReveal)w:_reveal(self.functionContainer,{BackgroundTransparency=w.theme.
ToggleTrackTransparency},animate,toggleReveal)else w:_hideCommon(self,animate)w:
_reveal(self.indicator,{BackgroundTransparency=1},animate,toggleReveal)w:
_reveal(self.indicatorStroke,{Transparency=1},animate,toggleReveal)w:_reveal(
self.indicatorGlow,{Transparency=1},animate,toggleGlowReveal)w:_reveal(self.
overlay,{BackgroundTransparency=1},animate,toggleReveal)w:_reveal(self.
containerStroke,{Transparency=1},animate,toggleReveal)w:_reveal(self.
functionContainer,{BackgroundTransparency=1},animate,toggleReveal)end end
function Toggle:_refreshTheme()local t=self.window.theme local info=TweenInfo.
new(0.5,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)local ts=variables.
tweenService ts:Create(self.functionContainer,info,{BackgroundTransparency=t.
ToggleTrackTransparency}):Play()ts:Create(self.indicator,info,{BackgroundColor3=
self.value and t.AccentColor or t.ToggleKnobOff,BackgroundTransparency=self.
value and 0 or t.ToggleKnobOffTransparency}):Play()ts:Create(self.
indicatorStroke,info,{Color=self.value and t.AccentStroke or Color3.fromRGB(255,
255,255)}):Play()if self.indicatorGlow then ts:Create(self.indicatorGlow,info,{
Transparency=self.value and t.AccentGlow or 1}):Play()end end function Toggle:
_minWidth()local w=30+10+50 if self.icon then w+=21 end w+=functions.textWidth(
self.window.theme.Font,16,locale.resolve(self.name))return w end moveable(Toggle
)function Toggle:Set(value,skipCallback)local changed=self.value~=value self.
value=value if changed then self:_animateIndicator()end if not skipCallback then
self.window:_runGuarded(self,self.callback,self.value)self.window:_persist(self)
if changed then self:_notifyState()end end end return Toggle end end function
__DARKLUA_BUNDLE_MODULES.x():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES
.cache.x if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.x=v end
return v.c end end do local function __modImpl()return function(script,require)
local utility=script.Parent.Parent.utility local image=require(utility.image)
local functions=require(utility.functions)local persistence=require(utility.
persistence)local constants=require(utility.constants)local locale=require(
utility.locale)local log=require(utility.log)local hapticEngine=require(utility.
HapticEngine)local windowSizing=require(utility.windowSizing)local chrome=
require(script.Parent.chrome)local search=require(script.Parent.search)local
variables=require(utility.variables)local themes=script.Parent.Parent.themes
local Window={}Window.__index=Window local revealInfo=TweenInfo.new(0.4,Enum.
EasingStyle.Exponential,Enum.EasingDirection.Out)local collapsedSize=UDim2.
fromOffset(185,50)local collapsedTop=UDim2.new(0.5,0,0,20)local maxToastWidth=
320 local compactRowHeight=41 local viewportReconcileInterval=2 local function
fitWindowSize():UDim2 local camera=variables.workspace.CurrentCamera return
windowSizing.fit(camera and camera.ViewportSize)end local gradientKeys={
WindowColor=true,ElementGradient=true,ElementStrokeGradient=true,TabBackground=
true,TabStroke=true,SliderProgress=true}local function coerceThemeValue(key,
value)if gradientKeys[key]and typeof(value)=='Color3'then return ColorSequence.
new(value)end return value end local function firstColor(value)return if typeof(
value)=='ColorSequence'then value.Keypoints[1].Value else value end
local function edgeShade(color,amount)local luminance=0.299*color.R+0.587*color.
G+0.114*color.B local target=if luminance>0.5 then Color3.new(0,0,0)else Color3.
new(1,1,1)return color:Lerp(target,amount)end local function deriveStrokes(
resolved,overrides)if overrides.ElementGradient then local fill=firstColor(
resolved.ElementGradient)if overrides.ElementStroke==nil then resolved.
ElementStroke=edgeShade(fill,0.28)end if overrides.ElementStrokeGradient==nil
then resolved.ElementStrokeGradient=ColorSequence.new(edgeShade(fill,0.4))end if
overrides.ElementStrokeHover==nil then resolved.ElementStrokeHover=edgeShade(
fill,0.52)end end if overrides.TabBackground and overrides.TabStroke==nil then
resolved.TabStroke=ColorSequence.new(edgeShade(firstColor(resolved.TabBackground
),0.4))end end local function themeOverrides(value)if typeof(value)=='table'then
return value elseif typeof(value)=='string'then local named=themes:
FindFirstChild(string.lower(value))if named then return require(named)end log.
warn("Rayfield: unknown theme '"..value.."', using default")elseif value~=nil
then log.warn(
[[Rayfield: invalid theme (expected a built-in name or a theme table), using default]]
)end return require(themes['default'])end local function resolveTheme(value)
local resolved=table.clone(require(themes['default']))local overrides=
themeOverrides(value)for key,override in overrides do resolved[key]=
coerceThemeValue(key,override)end if typeof(value)=='table'then deriveStrokes(
resolved,overrides)end local userTable=if typeof(value)=='table'then value else
nil if not(userTable and(userTable.Font or userTable.font))then resolved.Font=
variables.brandFont(Enum.FontWeight.Medium)end if not(userTable and(userTable.
TitleFont or userTable.titleFont))then resolved.TitleFont=variables.brandFont(
Enum.FontWeight.SemiBold)end return resolved end function Window.new(properties)
properties=if typeof(properties)=='table'then properties else{}if properties.
translations or properties.Translations then locale.register(properties.
translations or properties.Translations)end if properties.translator or
properties.Translator then locale.translator=properties.translator or properties
.Translator end locale.setActive(properties.locale or properties.Locale or
locale.detect())local fallbackFont=properties.fallbackFont or properties.
FallbackFont if fallbackFont then variables.setFallbackFont(fallbackFont)end
local self=setmetatable({name=properties.name or properties.Name or
'Rayfield Window',subheading=properties.subtitle or properties.Subtitle,size=
fitWindowSize(),instances={},connections={},icon=properties.icon or properties.
Icon,showName=properties.showName or properties.ShowName or'Rayfield',showIcon=
properties.showIcon or properties.ShowIcon or constants.icons.rayfield,
themeProperties={},localeProperties={},tabs={},tags={},selectedTab=nil,theme=
resolveTheme(properties.theme or properties.Theme),controls={},configuration=(
function()local cfg=properties.configuration or properties.Configuration if not
cfg then return{}end return{autoSave=cfg.autoSave or cfg.AutoSave,autoLoad=cfg.
autoLoad or cfg.AutoLoad,fileName=cfg.fileName or cfg.FileName,customFolder=cfg.
customFolder or cfg.CustomFolder}end)()},Window)self.Flags=setmetatable({},{
__index=function(_,flag)local control=self.controls[flag]if control and control.
__type=='Dropdown'and control._callbackValue then return control:_callbackValue(
)end return control and control.value end,__newindex=function(_,flag,value)local
control=self.controls[flag]if not control then log.warn("Rayfield: no flag '"..
tostring(flag).."' to set")return end control:Set(value)end,__iter=function()
local flag return function()local control flag,control=next(self.controls,flag)
if flag then if control.__type=='Dropdown'and control._callbackValue then return
flag,control:_callbackValue()end return flag,control.value end return nil end
end})self.screenGui=self:Create('ScreenGui',{Name=variables.httpService:
GenerateGUID(false),IgnoreGuiInset=true,ResetOnSpawn=false,Enabled=true,
DisplayOrder=constants.displayOrder.window,ZIndexBehavior=Enum.ZIndexBehavior.
Global,Parent=variables.guiContainer})self.main=self:Create('Frame',{
BackgroundColor3=Color3.fromRGB(255,255,255),Name=self.name,ZIndex=1,AnchorPoint
=Vector2.new(0.5,0.5),Position=UDim2.new(0.5,0,0.5,0),Size=UDim2.fromOffset((
self.size.X.Offset-50),0),BackgroundTransparency=1,Visible=false,Parent=self.
screenGui})self.drag=require(script.Parent.drag).new(self)self.windowCorner=self
:Create('UICorner',{Parent=self.main},{CornerRadius='CornerRoundness'})self.
windowStroke=self:Create('UIStroke',{Transparency=1,Parent=self.main},{Color=
'SurfaceStroke'})self.windowGradient=self:Create('UIGradient',{Rotation=270,
Offset=Vector2.new(0,-0.1),Parent=self.main},{Color={'WindowColor',functions.
toColorSequence}})self.bottomFade=self:Create('Frame',{BackgroundColor3=Color3.
fromRGB(255,255,255),BorderSizePixel=0,AnchorPoint=Vector2.new(0,1),Position=
UDim2.fromScale(0,1),Size=UDim2.new(1,0,-0.093,100),ZIndex=constants.zIndex.
bottomFade,BackgroundTransparency=1,Parent=self.main})self:Create('UICorner',{
Parent=self.bottomFade},{CornerRadius='CornerRoundness'})self.bottomFadeGradient
=self:Create('UIGradient',{Rotation=270,Offset=Vector2.new(0,0.2),Transparency=
NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(
0.4414,0),NumberSequenceKeypoint.new(0.7007,0.631),NumberSequenceKeypoint.new(1,
1)}),Parent=self.bottomFade},{Color={'WindowColor',function(color)return
ColorSequence.new(functions.toColorSequence(color).Keypoints[1].Value)end}})self
.topbar=self:Create('Frame',{BackgroundTransparency=1,Size=UDim2.new(1,0,0,66),
Active=true,Parent=self.main})self.topContainer=self:Create('Frame',{Size=UDim2.
new(0,300,0,24),Position=UDim2.new(0,25,0.5,0),AutomaticSize=Enum.AutomaticSize.
Y,AnchorPoint=Vector2.new(0,0.5),BackgroundTransparency=1,Parent=self.topbar})
self.topContainerLayout=self:Create('UIListLayout',{Padding=UDim.new(0,8),
FillDirection=Enum.FillDirection.Horizontal,VerticalAlignment=Enum.
VerticalAlignment.Center,HorizontalAlignment=Enum.HorizontalAlignment.Left,
SortOrder=Enum.SortOrder.LayoutOrder,Parent=self.topContainer})self.
titleContainer=self:Create('Frame',{Size=UDim2.fromOffset(50,24),Position=UDim2.
new(0,25,0.5,0),AutomaticSize=Enum.AutomaticSize.XY,AnchorPoint=Vector2.new(0,
0.5),BackgroundTransparency=1,LayoutOrder=1,Parent=self.topContainer})self.
titleContainerLayout=self:Create('UIListLayout',{Padding=UDim.new(0,3),
FillDirection=Enum.FillDirection.Vertical,VerticalAlignment=Enum.
VerticalAlignment.Center,SortOrder=Enum.SortOrder.LayoutOrder,Parent=self.
titleContainer})if self.name then self.title=self:Create('TextLabel',{Text=
locale.t(self.name),FontFace=variables.brandFont(Enum.FontWeight.Medium),Size=
UDim2.fromOffset(50,20),AutomaticSize=Enum.AutomaticSize.X,
BackgroundTransparency=1,TextSize=20,TextXAlignment=Enum.TextXAlignment.Left,
TextWrapped=true,TextTransparency=1,Parent=self.titleContainer},{FontFace='Font'
,TextColor3='TitlingColor'})end if self.icon then self.topbarIcon=self:Create(
'ImageLabel',{Image=self.icon,BackgroundTransparency=1,Size=UDim2.fromOffset(32,
32),ImageTransparency=1,Parent=self.topContainer},{ImageColor3='TitlingColor'})
end if self.subheading then self.subtitle=self:Create('TextLabel',{Text=locale.
t(self.subheading),Size=UDim2.fromOffset(50,12),AutomaticSize=Enum.AutomaticSize
.X,BackgroundTransparency=1,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,
TextWrapped=true,TextTransparency=1,Parent=self.titleContainer},{TextColor3=
'TitlingColor',FontFace='Font'})end self.tagContainer=self:Create('Frame',{
AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,25,0.5,0),Size=UDim2.
fromOffset(50,24),AutomaticSize=Enum.AutomaticSize.XY,BackgroundTransparency=1,
LayoutOrder=2,Visible=false,Parent=self.topContainer})self.tagContainerLayout=
self:Create('UIListLayout',{Padding=UDim.new(0,5),FillDirection=Enum.
FillDirection.Horizontal,VerticalAlignment=Enum.VerticalAlignment.Center,
SortOrder=Enum.SortOrder.LayoutOrder,Parent=self.tagContainer})self.windowShadow
=self:CreateGlow(self.main,'ShadowColor',20,1)self.elements=self:Create('Frame',
{Size=UDim2.new(1,0,1,-106),Position=UDim2.fromScale(0.5,1),AnchorPoint=Vector2.
new(0.5,1),BackgroundTransparency=1,ClipsDescendants=true,Parent=self.main})self
.elementsLayout=self:Create('UIPageLayout',{Padding=UDim.new(0,0),FillDirection=
Enum.FillDirection.Horizontal,VerticalAlignment=Enum.VerticalAlignment.Center,
HorizontalAlignment=Enum.HorizontalAlignment.Center,SortOrder=Enum.SortOrder.
LayoutOrder,ScrollWheelInputEnabled=false,GamepadInputEnabled=false,
TouchInputEnabled=false,EasingStyle=Enum.EasingStyle.Exponential,TweenTime=0.4,
Parent=self.elements})self.tabList=self:Create('ScrollingFrame',{Name='Tabs',
Active=true,Size=UDim2.new(1,0,0,38),Position=UDim2.new(0.5,0,0,65),AnchorPoint=
Vector2.new(0.5,0),BackgroundTransparency=1,AutomaticCanvasSize=Enum.
AutomaticSize.X,CanvasSize=UDim2.new(0,0,0,0),ScrollBarThickness=0,
ScrollBarImageTransparency=1,ScrollingDirection=Enum.ScrollingDirection.X,Parent
=self.main})self.tabListLayout=self:Create('UIListLayout',{Padding=UDim.new(0,7)
,FillDirection=Enum.FillDirection.Horizontal,VerticalAlignment=Enum.
VerticalAlignment.Center,HorizontalAlignment=Enum.HorizontalAlignment.Left,
SortOrder=Enum.SortOrder.LayoutOrder,Parent=self.tabList})self:Create(
'UIPadding',{PaddingLeft=UDim.new(0,22),PaddingRight=UDim.new(0,10),Parent=self.
tabList})self.actionContainer=self:Create('Frame',{AnchorPoint=Vector2.new(1,0.5
),AutomaticSize=Enum.AutomaticSize.X,Size=UDim2.fromOffset(0,24),Position=UDim2.
new(1,-20,0.5,0),BackgroundTransparency=1,Parent=self.topbar})self.
actionsListLayout=self:Create('UIListLayout',{Padding=UDim.new(0,5),
FillDirection=Enum.FillDirection.Horizontal,VerticalAlignment=Enum.
VerticalAlignment.Center,HorizontalAlignment=Enum.HorizontalAlignment.Right,
SortOrder=Enum.SortOrder.LayoutOrder,Parent=self.actionContainer})self.
rfSettings=self:CreateTab({name='Pulse Settings',customOrder=1000,
neglectSelector=true,forgetState=true})require(script.Parent.action).new(self,{
name='Close',icon=constants.icons.close,order=1,callback=function()self:
ToggleHide()end})self.minimiseAction=require(script.Parent.action).new(self,{
name='Minimise',icon=constants.icons.minimise,order=2,callback=function()self:
ToggleMinimise()end})self.settingsAction=require(script.Parent.action).new(self,
{name='Settings',icon=constants.icons.settings,order=3,linkedTab=self.rfSettings
,callback=function()self.rfSettings:Select()end})search.build(self)self.unloaded
=false self.minimised=false self.hidden=true self.animating=false self.
_revealing=false self.hasShownOnce=false self.settings={toggleKeybind=Enum.
KeyCode.K,mouseOverride=true,keepOnScreen=true,welcomeToast=true,haptics=false,
autoLoadConfig=false,selectedConfig=nil}self:LoadSettings()hapticEngine.
setContainer(self.screenGui)hapticEngine.setEnabled(self.settings.haptics)chrome
.buildCollapsedFace(self)self:_bindKeybind()self:_bindMouseOverride()self:
_bindTopbarDrag()self:_watchViewport()self:_buildSettingsUI()self:
_syncLiveAnimation()return self end function Window:_syncLiveAnimation()if not
self.theme.LiveAnimation then self._liveAnimating=false return end if self.
_liveAnimating then return end self._liveAnimating=true self._liveGeneration=(
self._liveGeneration or 0)+1 local generation=self._liveGeneration task.spawn(
function()local out=true local tweenInfo=TweenInfo.new(10,Enum.EasingStyle.Quint
,Enum.EasingDirection.Out)while self._liveGeneration==generation and self.
_liveAnimating and not self.unloaded do local tweenW=variables.tweenService:
Create(self.windowGradient,tweenInfo,{Offset=Vector2.new(if out then 0.4 else-
0.2,0),Rotation=(if out then 220 else 280)})self._liveTween=tweenW tweenW:Play()
tweenW.Completed:Wait()out=not out end if self._liveGeneration==generation then
self._liveAnimating=false self._liveTween=nil end end)end function Window:
ChangeTheme(theme)local overrides=if typeof(theme)=='table'then theme else
resolveTheme(theme)for name,value in overrides do self.theme[name]=
coerceThemeValue(name,value)end if typeof(theme)=='table'then deriveStrokes(self
.theme,overrides)end for instance,properties in self.themeProperties do for
property,value in properties do local targetValue=if typeof(value)=='table'then
value[2](self.theme[value[1] ])else self.theme[value]if typeof(targetValue)==
'Color3'or typeof(targetValue)=='number'then variables.tweenService:Create(
instance,TweenInfo.new(0.5,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{[
property]=targetValue}):Play()else instance[property]=targetValue end end end if
self.hidden then self._themeRefreshPending=true else self:_refreshElementThemes(
)end self:_syncLiveAnimation()end function Window:_refreshElementThemes()for _,
tab in self.tabs do for _,element in tab.elements do if element._refreshTheme
then element:_refreshTheme()end end end end function Window:CreateTab(properties
)assert(not self.unloaded,'Cannot create a tab on an unloaded window.')local
newTab=require(script.Parent.tab).new(self,properties)table.insert(self.tabs,
newTab)if not newTab.neglectSelector then local isFirstVisible=true for _,tab in
self.tabs do if tab~=newTab and not tab.neglectSelector then isFirstVisible=
false break end end if isFirstVisible then newTab:Select(true)end if not self.
hidden and not self.minimised then newTab.topbarItem.Visible=true newTab:
_applyVisual(if self.selectedTab==newTab then'selected'else'unselected',
TweenInfo.new(0.4,Enum.EasingStyle.Quint,Enum.EasingDirection.Out))end end
return newTab end function Window:CreateTag(properties)assert(not self.unloaded,
'Cannot create a tag on an unloaded window.')local newTag=require(script.Parent.
tag).new(self,properties)table.insert(self.tags,newTag)return newTag end
function Window:_registerControl(control)if not control.flag or control.flag==''
or control.forgetState then return end local flag=control.flag if self.controls[
flag]then local n=2 while self.controls[flag..n]do n+=1 end flag=flag..n log.
warn("Rayfield: duplicate config flag '"..control.flag..
"', saving this one as '"..flag..
"'. Set a unique flag to keep it stable across sessions.")end control.flag=flag
self.controls[flag]=control return flag end function Window:_restoreLate(element
)if not self._loadedConfig or not element.flag or element.forgetState then
return end local wasLoading=self._loading self._loading=true persistence.
applyTo(element,self._loadedConfig[element.flag])self._loading=wasLoading end
function Window:_persist(control)if control.flag and not control.forgetState and
self.configuration.autoSave and not self._loading then task.spawn(self.Save,self
)end end function Window:_unregisterControl(control)if control.flag and self.
controls[control.flag]==control then self.controls[control.flag]=nil end end
function Window:_keybindUsing(key,exclude)if typeof(key)~='EnumItem'or key==Enum
.KeyCode.Unknown then return nil end for _,tab in self.tabs do for _,element in
tab.elements do if element~=exclude and element.__type=='Keybind'and element.
value==key then return element end end end return nil end function Window:Notify
(properties)if self.unloaded then return end if not self.notifications then self
.notifications=self:Create('Frame',{Name='Notifications',Size=UDim2.new(0,300,0,
800),Position=UDim2.new(1,-20,1,-20),AnchorPoint=Vector2.new(1,1),
BackgroundTransparency=1,Parent=self.screenGui})self:Create('UIListLayout',{
FillDirection=Enum.FillDirection.Vertical,VerticalAlignment=Enum.
VerticalAlignment.Bottom,HorizontalAlignment=Enum.HorizontalAlignment.Center,
SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,0),Parent=self.
notifications})end return require(script.Parent.notification).new(self,
properties)end function Window:Toast(properties)if self.unloaded then return end
properties=if typeof(properties)=='table'then properties else{}local position=
properties.position or properties.Position or'Top'local isTop=typeof(position)~=
'string'or position:lower()~='bottom'properties.position=if isTop then'Top'else
'Bottom'local containerKey=if isTop then'_toastsTop'else'_toastsBottom'local
container=self[containerKey]if not container then container=self:Create('Frame',
{Name='Toasts',Size=UDim2.new(0,maxToastWidth,1,-24),Position=if isTop then
UDim2.new(0.5,0,0,12)else UDim2.new(0.5,0,1,-12),AnchorPoint=if isTop then
Vector2.new(0.5,0)else Vector2.new(0.5,1),BackgroundTransparency=1,ZIndex=
constants.zIndex.toast,Parent=self.screenGui})self:Create('UIListLayout',{
FillDirection=Enum.FillDirection.Vertical,VerticalAlignment=if isTop then Enum.
VerticalAlignment.Top else Enum.VerticalAlignment.Bottom,HorizontalAlignment=
Enum.HorizontalAlignment.Center,SortOrder=Enum.SortOrder.LayoutOrder,Padding=
UDim.new(0,0),Parent=container})self[containerKey]=container end return require(
script.Parent.toast).new(self,properties,container)end function Window:Popup(
properties)if self.unloaded then return end return require(script.Parent.popup).
new(self,properties)end function Window:Hide()if self.animating or self.hidden
then return end if self._searching then search.close(self,{showTabs=false,jumpTo
=self.selectedTab and self.selectedTab.tabPage})end if self._recordingKeybind
then self._recordingKeybind:_stopRecording()end self.animating=true self.
_revealing=true self.hidden=true self.collapsedInteract.Visible=false if self.
minimised then self.minimised=false image.assign(self.minimiseAction.iconLabel,
'Image',constants.icons.minimise)end self._restorePosition=self.main.Position
local home,size=self:_collapsedRect()local fadeInfo=TweenInfo.new(0.18,Enum.
EasingStyle.Quint,Enum.EasingDirection.Out)local moveInfo=TweenInfo.new(0.35,
Enum.EasingStyle.Exponential,Enum.EasingDirection.InOut)local cornerInfo=
TweenInfo.new(0.35,Enum.EasingStyle.Exponential,Enum.EasingDirection.InOut)local
faceInfo=TweenInfo.new(0.2,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)
variables.tweenService:Create(self.drag.dragCosmetic,fadeInfo,{Size=UDim2.
fromOffset(0,4),BackgroundTransparency=1}):Play()task.delay(0.18,function()if
not self.hidden then return end self.drag.drag.Visible=false end)variables.
tweenService:Create(self.windowShadow,fadeInfo,{Transparency=1}):Play()variables
.tweenService:Create(self.windowStroke,fadeInfo,{Transparency=1}):Play()
variables.tweenService:Create(self.bottomFade,fadeInfo,{BackgroundTransparency=1
}):Play()if self.title then variables.tweenService:Create(self.title,fadeInfo,{
TextTransparency=1}):Play()end if self.subtitle then variables.tweenService:
Create(self.subtitle,fadeInfo,{TextTransparency=1}):Play()end if self.topbarIcon
then variables.tweenService:Create(self.topbarIcon,fadeInfo,{ImageTransparency=1
}):Play()end for _,action in ipairs(self.actionContainer:GetChildren())do if
action:IsA('Frame')then variables.tweenService:Create(action.ImageLabel,fadeInfo
,{ImageTransparency=1}):Play()end end for _,tag in self.tags do tag:_setShown(
false,fadeInfo)end for _,tab in pairs(self.tabs)do if not tab.neglectSelector
and tab.topbarItem then tab:_applyVisual('hidden',fadeInfo)end end self:
_fadeSelectedElementsOut()variables.tweenService:Create(self.main,moveInfo,{Size
=size,Position=home}):Play()variables.tweenService:Create(self.windowCorner,
cornerInfo,{CornerRadius=UDim.new(1,0)}):Play()task.delay(0.18,function()if not
self.hidden then return end self.topbar.Visible=false self.elements.Visible=
false self.tabList.Visible=false chrome.setCollapsedShown(self,true,faceInfo)end
)task.delay(0.35,function()if not self.hidden then return end self.
collapsedInteract.Visible=true self.animating=false self._revealing=false end)
end function Window:ToggleHide()if self.animating then return end if self.hidden
then self:Show()else self:Hide()end end function Window:ToggleMinimise()if self.
animating or self.hidden then return end if self._searching then search.close(
self,{showTabs=true})end self.animating=true local sizeInfo=TweenInfo.new(0.5,
Enum.EasingStyle.Exponential,Enum.EasingDirection.Out)local fadeInfo=TweenInfo.
new(0.4,Enum.EasingStyle.Exponential,Enum.EasingDirection.Out)if self.minimised
then self.minimised=false image.assign(self.minimiseAction.iconLabel,'Image',
constants.icons.minimise)variables.tweenService:Create(self.main,sizeInfo,{Size=
self.size}):Play()variables.tweenService:Create(self.windowShadow,fadeInfo,{
Transparency=0.6}):Play()variables.tweenService:Create(self.windowStroke,
fadeInfo,{Transparency=0.95}):Play()variables.tweenService:Create(self.
bottomFade,fadeInfo,{BackgroundTransparency=0}):Play()variables.tweenService:
Create(self.drag.drag,sizeInfo,{Position=UDim2.new(self.main.Position.X.Scale,
self.main.Position.X.Offset,self.main.Position.Y.Scale,self.main.Position.Y.
Offset+self.size.Y.Offset/2+15)}):Play()task.delay(0.2,function()if self.
minimised or self.hidden then return end self.elements.Visible=true self.tabList
.Visible=true for _,tab in pairs(self.tabs)do if not tab.neglectSelector and tab
.topbarItem then tab.topbarItem.Visible=true tab:_applyVisual(if self.
selectedTab==tab then'selected'else'unselected',fadeInfo)end end self:
_revealElements(0.035,0.4)end)task.delay(0.5,function()self.animating=false end)
else self.minimised=true image.assign(self.minimiseAction.iconLabel,'Image',
constants.icons.maximise)self:_fadeSelectedElementsOut()for _,tab in pairs(self.
tabs)do if not tab.neglectSelector and tab.topbarItem then tab:_applyVisual(
'hidden',fadeInfo)end end task.delay(0.3,function()if not self.minimised then
return end self.elements.Visible=false self.tabList.Visible=false for _,tab in
pairs(self.tabs)do if not tab.neglectSelector and tab.topbarItem then tab.
topbarItem.Visible=false end end end)variables.tweenService:Create(self.
windowShadow,fadeInfo,{Transparency=1}):Play()variables.tweenService:Create(self
.windowStroke,fadeInfo,{Transparency=1}):Play()variables.tweenService:Create(
self.bottomFade,fadeInfo,{BackgroundTransparency=1}):Play()variables.
tweenService:Create(self.main,sizeInfo,{Size=UDim2.fromOffset(self.size.X.Offset
,66)}):Play()variables.tweenService:Create(self.drag.drag,sizeInfo,{Position=
UDim2.new(self.main.Position.X.Scale,self.main.Position.X.Offset,self.main.
Position.Y.Scale,self.main.Position.Y.Offset+66/2+15)}):Play()task.delay(0.5,
function()self.animating=false end)end end function Window:_syncDragBar()local
bar=self.drag and self.drag.drag if not bar then return end local position=self.
main.Position local below=self.size.Y.Offset/2+15 bar.Position=UDim2.new(
position.X.Scale,position.X.Offset,position.Y.Scale,position.Y.Offset+below)end
function Window:_clampedPosition(position:UDim2):UDim2 if not self.settings or
not self.settings.keepOnScreen then return position end if position.X.Scale~=0
or position.Y.Scale~=0 then return position end local screen=self.screenGui.
AbsoluteSize local halfX,halfY=self.size.X.Offset/2,self.size.Y.Offset/2 local
margin=8 local x=math.clamp(position.X.Offset,halfX+margin,math.max(halfX+margin
,screen.X-halfX-margin))local y=math.clamp(position.Y.Offset,halfY+margin,math.
max(halfY+margin,screen.Y-halfY-margin))if x==position.X.Offset and y==position.
Y.Offset then return position end return UDim2.fromOffset(x,y)end function
Window:_clampToScreen()self.main.Position=self:_clampedPosition(self.main.
Position)end function Window:_applyWindowSize()if self.unloaded then return end
local size=fitWindowSize()local changed=size~=self.size self.size=size if self.
hidden or self.minimised or self.animating or self._revealing then self.
_pendingResize=self._pendingResize or changed return end if not changed and not
self._pendingResize then return end self._pendingResize=false self.main.Size=
size self:_clampToScreen()self:_syncDragBar()end function Window:_watchViewport(
)local cameraConnection:RBXScriptConnection?=nil local pending=false
local function request()if pending then return end pending=true task.defer(
function()pending=false self:_applyWindowSize()end)end local function bind()if
cameraConnection then self:Disconnect(cameraConnection)cameraConnection=nil end
local camera=variables.workspace.CurrentCamera if camera then cameraConnection=
self:Connect(camera:GetPropertyChangedSignal('ViewportSize'),request)end
request()end self:Connect(variables.workspace:GetPropertyChangedSignal(
'CurrentCamera'),bind)bind()local sinceReconcile=0 self:Connect(variables.
runService.Heartbeat,function(delta:number)sinceReconcile+=delta if
sinceReconcile<viewportReconcileInterval then return end sinceReconcile=0 self:
_applyWindowSize()end)end function Window:_bindKeybind()self:Connect(variables.
userInputService.InputBegan,function(input,processed)if processed or self.
_recordingKeybind then return end if input.KeyCode==self.settings.toggleKeybind
or input.UserInputType==self.settings.toggleKeybind then self:ToggleHide()end
end)end function Window:_bindMouseOverride()local uis=variables.userInputService
local function active()return self.settings.mouseOverride and not self.hidden
and not self.minimised end local function free()if not active()then return end
if uis:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)then return end if
uis.MouseBehavior~=Enum.MouseBehavior.Default then uis.MouseBehavior=Enum.
MouseBehavior.Default end if not uis.MouseIconEnabled then uis.MouseIconEnabled=
true end end self:Connect(uis:GetPropertyChangedSignal('MouseBehavior'),free)
self:Connect(uis:GetPropertyChangedSignal('MouseIconEnabled'),free)self:Connect(
uis.InputEnded,function(input)if input.UserInputType==Enum.UserInputType.
MouseButton2 then free()end end)self._freeMouse=free end function Window:
_bindTopbarDrag()local uis=variables.userInputService local dragging=false local
relative=Vector2.zero local offset=Vector2.zero if self.screenGui and self.
screenGui.IgnoreGuiInset then offset=variables.guiService:GetGuiInset()end
local function getTarget()local position=uis:GetMouseLocation()+relative+offset
local x,y=position.X,position.Y if self.settings and self.settings.keepOnScreen
then local size=self.main.AbsoluteSize local screen=self.screenGui.AbsoluteSize
local margin=8 local halfX,halfY=size.X/2,size.Y/2 x=math.clamp(x,halfX+margin,
math.max(halfX+margin,screen.X-halfX-margin))y=math.clamp(y,halfY+margin,math.
max(halfY+margin,screen.Y-halfY-margin))end return UDim2.fromOffset(x,y)end
local function overInteractiveChild(x,y)for _,region in{self.tabList,self.
actionContainer}do local position,size=region.AbsolutePosition,region.
AbsoluteSize if x>=position.X and x<=position.X+size.X and y>=position.Y and y<=
position.Y+size.Y then return true end end return false end self:Connect(self.
topbar.InputBegan,function(input,processed)if processed then return end local
inputType=input.UserInputType.Name if inputType~='MouseButton1'and inputType~=
'Touch'then return end if overInteractiveChild(input.Position.X,input.Position.Y
)then return end if not self:_interactive()then return end dragging=true if self
.screenGui and self.screenGui.IgnoreGuiInset then offset=variables.guiService:
GetGuiInset()end relative=self.main.AbsolutePosition+self.main.AbsoluteSize*self
.main.AnchorPoint-uis:GetMouseLocation()end)self:Connect(uis.InputEnded,function
(input)local inputType=input.UserInputType.Name if inputType=='MouseButton1'or
inputType=='Touch'then dragging=false end end)self:Connect(uis.
WindowFocusReleased,function()dragging=false end)self:Connect(variables.
runService.RenderStepped,function()if not dragging then return end if not self:
_interactive()then dragging=false return end self.main.Position=getTarget()if
self.drag and self.drag.drag then local mainPosition=self.main.Position self.
drag.drag.Position=UDim2.new(mainPosition.X.Scale,mainPosition.X.Offset,
mainPosition.Y.Scale,mainPosition.Y.Offset+(self.main.Size.Y.Offset/2+15))end
end)end function Window:_buildSettingsUI()self.rfSettings:CreateSection({name=
'General'})self.rfSettings:CreateKeybind({name='Toggle Keybind',icon=constants.
icons.search,value=self.settings.toggleKeybind,isMenuToggle=true,onChanged=
function(key)self.settings.toggleKeybind=key self:SaveSettings()end})self.
rfSettings:CreateToggle({name='Unlock cursor while open',description=
[[Unlocks the cursor while the menu is open so you can configure in FPS games that lock it.]]
,value=self.settings.mouseOverride,callback=function(state)self.settings.
mouseOverride=state self:SaveSettings()end})self.rfSettings:CreateToggle({name=
'Welcome toast',description=
[[Shows a 'Signed in as' toast the first time you open the menu on a new account.]]
,value=self.settings.welcomeToast,callback=function(state)self.settings.
welcomeToast=state self:SaveSettings()end})self.rfSettings:CreateToggle({name=
'Haptics',description=
[[A subtle tap as you interact, on devices that support haptics.]],value=self.
settings.haptics,callback=function(state)self.settings.haptics=state
hapticEngine.setEnabled(state)self:SaveSettings()end})self.rfSettings:
CreateSection({name='Window'})self.rfSettings:CreateToggle({name=
'Keep window on screen',description=
[[Stops the window being dragged off the edge of the screen and lost.]],value=
self.settings.keepOnScreen,callback=function(state)self.settings.keepOnScreen=
state self:SaveSettings()end})self.rfSettings:CreateButton({name=
'Reset Window Position',callback=function()variables.tweenService:Create(self.
main,TweenInfo.new(0.5,Enum.EasingStyle.Exponential,Enum.EasingDirection.Out),{
Position=UDim2.new(0.5,0,0.5,0)}):Play()variables.tweenService:Create(self.drag.
drag,TweenInfo.new(0.5,Enum.EasingStyle.Exponential,Enum.EasingDirection.Out),{
Position=UDim2.new(0.5,0,0.5,self.size.Y.Offset/2+15)}):Play()end})if next(self.
configuration)~=nil then self.rfSettings:CreateSection({name='Configurations'})
local availableConfigs=self:ListConfigs()local selected=self.settings.
selectedConfig if not selected or not table.find(availableConfigs,selected)then
selected=availableConfigs[1]end if self.settings.selectedConfig~=selected then
self.settings.selectedConfig=selected self:SaveSettings()end local
configDropdown,nameInput self.rfSettings:CreateToggle({name=
'Auto Load Configuration',description=
[[Loads the selected configuration when the script starts. Disabled by default.]]
,value=self.settings.autoLoadConfig,callback=function(state)self.settings.
autoLoadConfig=state self.settings.selectedConfig=selected self:SaveSettings()
end})local function refreshConfigs()local names=self:ListConfigs()configDropdown
:Refresh(names)if selected and not table.find(names,selected)then selected=names
[1]end if selected then configDropdown:Set(selected,true)end self.settings.
selectedConfig=selected self:SaveSettings()end configDropdown=self.rfSettings:
CreateDropdown({name='Saved Configurations',icon=constants.icons.config,options=
self:ListConfigs(),value=selected,placeholder='No saved configurations',callback
=function(value)selected=value self.settings.selectedConfig=value self:
SaveSettings()end})nameInput=self.rfSettings:CreateInput({name=
'Configuration Name',description=
[[Name a new configuration, or leave blank to overwrite the selected one.]],
placeholder='e.g. PvP Loadout',clearOnFocus=false})local actions=self.rfSettings
:CreateGroup()actions:CreateButton({name='Save',icon=constants.icons.config,
callback=function()local name=nameInput.value if name==''then name=selected end
if not name or name==''then self:Toast({title=locale.resolve(
'Name your configuration first')})return end if self:Save(name)then nameInput:
Set('')selected=name self.settings.selectedConfig=name refreshConfigs()self:
Toast({title=locale.resolve('Saved configuration'),subtitle=name,icon=constants.
icons.config})else self:Toast({title=locale.resolve(
"Couldn't save configuration"),subtitle=name})end end})actions:CreateButton({
name='Load',callback=function()if not selected or selected==''then self:Toast({
title=locale.resolve('Pick a configuration to load')})return end if self:
_applyNamedConfig(selected)then self:Toast({title=locale.resolve(
'Loaded configuration'),subtitle=selected})else self:Toast({title=locale.
resolve("Couldn't load configuration"),subtitle=selected})end end})actions:
CreateButton({name='Delete',callback=function()local deleting=selected if not
deleting or deleting==''then self:Toast({title=locale.resolve(
'Pick a configuration to delete')})return end if self:DeleteConfig(deleting)then
refreshConfigs()self:Toast({title=locale.resolve('Deleted configuration'),
subtitle=deleting})else self:Toast({title=locale.resolve(
"Couldn't delete configuration"),subtitle=deleting})end end})end end function
Window:SaveSettings()return persistence.saveSettings(self)end function Window:
LoadSettings()return persistence.loadSettings(self)end function Window:
_fadeSelectedElementsOut()if self.selectedTab then for _,element in ipairs(self.
selectedTab.elements)do element:_setShown(false,true)end end end function Window
:_revealElements(perElementDelay,budget)for _,tab in pairs(self.tabs)do if tab~=
self.selectedTab then for _,element in ipairs(tab.elements)do element:_setShown(
true,false)end end end local tab=self.selectedTab if not tab then return end
local page=tab.tabPage local viewTop=page.AbsolutePosition.Y local viewBottom=
viewTop+page.AbsoluteWindowSize.Y local maxStaggered=math.floor(budget/
perElementDelay)local staggered=0 for _,element in ipairs(tab.elements)do local
wasVisible=element.main.Visible if not wasVisible then element.main.Visible=true
end local top=element.main.AbsolutePosition.Y local size=element.main.
AbsoluteSize if not wasVisible then element.main.Visible=false end local
onScreen=(top+size.Y)>viewTop and top<viewBottom if onScreen then element:
_setShown(true,true)staggered+=1 if staggered<=maxStaggered then task.wait(
perElementDelay)end else element:_setShown(true,false)end end end function
Window:Show()if self.animating or not self.hidden then return end self.animating
=true self._revealing=true if self.settings.autoLoadConfig and self.settings.
selectedConfig and not self._autoLoaded then self._autoLoaded=true local ok,err=
pcall(self.Load,self,self.settings.selectedConfig)if not ok then log.warn(
'Rayfield: Failed to load configuration - '..tostring(err))end end self.hidden=
false self.minimised=false if self._themeRefreshPending then self.
_themeRefreshPending=false self:_refreshElementThemes()end self.
collapsedInteract.Visible=false if self._freeMouse then self._freeMouse()end if
self.hasShownOnce then self:_quickRestore()else self.hasShownOnce=true self:
_firstShow()end end function Window:_quickRestore()local target=self:
_clampedPosition(self._restorePosition or UDim2.new(0.5,0,0.5,0))self.
_restorePosition=target local growInfo=TweenInfo.new(0.35,Enum.EasingStyle.
Exponential,Enum.EasingDirection.InOut)local cornerInfo=TweenInfo.new(0.35,Enum.
EasingStyle.Exponential,Enum.EasingDirection.InOut)local fadeInfo=TweenInfo.new(
0.28,Enum.EasingStyle.Exponential,Enum.EasingDirection.Out)chrome.
setCollapsedShown(self,false,TweenInfo.new(0.15,Enum.EasingStyle.Quint,Enum.
EasingDirection.Out))variables.tweenService:Create(self.main,growInfo,{Size=self
.size,Position=target}):Play()variables.tweenService:Create(self.windowCorner,
cornerInfo,{CornerRadius=self.theme.CornerRoundness}):Play()task.delay(0.22,
function()self.topbar.Visible=true self.tabList.Visible=true self.elements.
Visible=true variables.tweenService:Create(self.windowShadow,fadeInfo,{
Transparency=0.6}):Play()variables.tweenService:Create(self.windowStroke,
fadeInfo,{Transparency=0.95}):Play()variables.tweenService:Create(self.
bottomFade,fadeInfo,{BackgroundTransparency=0}):Play()if self.topbarIcon then
variables.tweenService:Create(self.topbarIcon,fadeInfo,{ImageTransparency=0}):
Play()end if self.title then variables.tweenService:Create(self.title,fadeInfo,{
TextTransparency=0}):Play()end if self.subtitle then variables.tweenService:
Create(self.subtitle,fadeInfo,{TextTransparency=0.7}):Play()end for _,action in
ipairs(self.actionContainer:GetChildren())do if action:IsA('Frame')then
variables.tweenService:Create(action.ImageLabel,fadeInfo,{ImageTransparency=0.6}
):Play()end end if self.settingsAction and self.selectedTab==self.rfSettings
then variables.tweenService:Create(self.settingsAction.iconLabel,fadeInfo,{
ImageTransparency=0.2}):Play()end for _,tag in self.tags do tag:_setShown(true,
fadeInfo)end for _,tab in pairs(self.tabs)do if not tab.neglectSelector and tab.
topbarItem then tab.topbarItem.Visible=true tab:_applyVisual(if self.selectedTab
==tab then'selected'else'unselected',fadeInfo)end end self:_revealElements(0.035
,0.4)end)task.delay(0.22,function()self.drag.drag.Position=UDim2.new(target.X.
Scale,target.X.Offset,target.Y.Scale,target.Y.Offset+self.size.Y.Offset/2+15)
self.drag.dragCosmetic.Size=UDim2.fromOffset(0,4)self.drag.dragCosmetic.
BackgroundTransparency=1 self.drag.drag.Visible=true variables.tweenService:
Create(self.drag.dragCosmetic,growInfo,{Size=UDim2.fromOffset(100,4),
BackgroundTransparency=0.7}):Play()end)task.delay(0.6,function()self.animating=
false self._revealing=false end)end function Window:_firstShow()self.elements.
Visible=true self.tabList.Visible=true self.drag.drag.Visible=false self.main.
Visible=true variables.tweenService:Create(self.main,TweenInfo.new(1,Enum.
EasingStyle.Exponential,Enum.EasingDirection.InOut),{BackgroundTransparency=0,
Size=self.size}):Play()task.wait(0.85)variables.tweenService:Create(self.
windowShadow,TweenInfo.new(0.6,Enum.EasingStyle.Exponential,Enum.EasingDirection
.Out),{Transparency=0.6}):Play()variables.tweenService:Create(self.windowStroke,
TweenInfo.new(0.6,Enum.EasingStyle.Exponential,Enum.EasingDirection.Out),{
Transparency=0.95}):Play()variables.tweenService:Create(self.bottomFade,
TweenInfo.new(0.6,Enum.EasingStyle.Exponential,Enum.EasingDirection.Out),{
BackgroundTransparency=0}):Play()task.wait(0.3)if self.icon then variables.
tweenService:Create(self.topbarIcon,TweenInfo.new(0.6,Enum.EasingStyle.
Exponential,Enum.EasingDirection.Out),{ImageTransparency=0}):Play()end if self.
title then variables.tweenService:Create(self.title,TweenInfo.new(0.4,Enum.
EasingStyle.Exponential,Enum.EasingDirection.Out),{TextTransparency=0}):Play()
end task.wait(0.1)if self.subtitle then variables.tweenService:Create(self.
subtitle,TweenInfo.new(0.4,Enum.EasingStyle.Exponential,Enum.EasingDirection.Out
),{TextTransparency=0.7}):Play()end for _,action in ipairs(self.actionContainer:
GetChildren())do if action:IsA('Frame')then task.wait(0.02)variables.
tweenService:Create(action.ImageLabel,TweenInfo.new(0.4,Enum.EasingStyle.
Exponential,Enum.EasingDirection.Out),{ImageTransparency=0.6}):Play()end end for
_,tag in self.tags do tag:_setShown(true,TweenInfo.new(0.4,Enum.EasingStyle.
Exponential,Enum.EasingDirection.Out))end task.wait(0.2)task.spawn(function()for
_,tab in pairs(self.tabs)do if not tab.neglectSelector then tab.topbarItem.
Visible=true tab:_applyVisual(if self.selectedTab==tab then'selected'else
'unselected',TweenInfo.new(0.4,Enum.EasingStyle.Quint,Enum.EasingDirection.Out))
tab:_spinGradients()task.wait(0.15)end end end)self:_revealElements(0.03,2)task.
wait(1)self:_syncDragBar()self.drag.drag.Visible=true variables.tweenService:
Create(self.drag.dragCosmetic,TweenInfo.new(0.6,Enum.EasingStyle.Exponential,
Enum.EasingDirection.Out),{BackgroundTransparency=0.7}):Play()variables.
tweenService:Create(self.drag.dragCosmetic,TweenInfo.new(1,Enum.EasingStyle.
Exponential,Enum.EasingDirection.Out),{Size=UDim2.fromOffset(100,4)}):Play()self
.animating=false self._revealing=false local localPlayer=variables.localPlayer
if localPlayer and self.settings.welcomeToast and chrome.isNewUser()then self:
Toast({title=localPlayer.DisplayName,subtitle=locale.resolve('Signed in as'),
subtitleAbove=true,avatar=localPlayer.UserId,minWidth=220})end end function
Window:GetPath()return persistence.getPath(self)end function Window:Save(name)if
name~=nil and(type(name)~='string'or name=='')then return false end return
persistence.save(self,name)end function Window:Load(name)if name~=nil and(type(
name)~='string'or name=='')then return false end return persistence.load(self,
name)end function Window:_applyNamedConfig(name)if not self:Load(name)then
return false end local _,defaultPath=persistence.getPath(self)self.
_loadedConfigPath=defaultPath self:Save()return true end function Window:
ListConfigs()return persistence.list(self)end function Window:DeleteConfig(name)
return persistence.delete(self,name)end function Window:Get(flag)local control=
self.controls[flag]if not control then return nil end if control.__type==
'Dropdown'and control._callbackValue then return control:_callbackValue()end
return control.value end function Window:Set(flag,value)local control=self.
controls[flag]if not control then return false end control:Set(value)return true
end function Window:_jumpTo(page)if page then self.elementsLayout:JumpTo(page)
end end function Window:Navigate(tab)if tab==nil then return end local target
for _,candidate in self.tabs do if candidate==tab or candidate.name==tab or
candidate.tabPage==tab then target=candidate break end end if not target then
return end target:Select()end function Window:Create(className,properties,
themeProperties)assert(typeof(className)=='string',
'Invalid argument #1 (string expected)')local instance=Instance.new(className)if
themeProperties and self.theme then for property,value in themeProperties do
instance[property]=(if typeof(value)=='table'then value[2](self.theme[value[1] ]
)else self.theme[value])end self.themeProperties[instance]=themeProperties end
if properties then for property,value in properties do if locale.isToken(value)
then self:_bindLocale(instance,property,locale.sourceOf(value))else image.
assign(instance,property,value)end end end table.insert(self.instances,instance)
return instance end function Window:_bindLocale(instance,property,source)
instance[property]=locale.resolve(source)local entries=self.localeProperties[
instance]if not entries then entries={}self.localeProperties[instance]=entries
end entries[property]=source end function Window:SetLocale(localeId)locale.
setActive(localeId)for instance,entries in self.localeProperties do for property
,source in entries do instance[property]=locale.resolve(source)end end end
function Window:SetTranslator(translator)locale.translator=translator end
function Window:RegisterTranslations(tables)locale.register(tables)self:
SetLocale(locale.current)end function Window:CreateGlow(parent,color,blur,
transparency)local properties={BlurRadius=UDim.new(0,blur),Transparency=
transparency,ZIndex=-1,Parent=parent}if typeof(color)=='string'then return self:
Create('UIShadow',properties,{Color={color,function(value)return if typeof(value
)=='ColorSequence'then value.Keypoints[1].Value else value end}})end properties.
Color=color return self:Create('UIShadow',properties)end function Window:
_flashResult(element,ok)local box=element.box if not box then return end local
glow=element.glow local stroke=element.boxStroke local fill=ok and constants.
accent.on or self.theme.ErrorColor local edge=ok and constants.accent.onStroke
or self.theme.ErrorStrokeColor local inInfo=TweenInfo.new(0.1,Enum.EasingStyle.
Quint,Enum.EasingDirection.Out)local outInfo=TweenInfo.new(0.45,Enum.EasingStyle
.Quint,Enum.EasingDirection.Out)variables.tweenService:Create(box,inInfo,{
BackgroundColor3=fill}):Play()if stroke then variables.tweenService:Create(
stroke,inInfo,{Color=edge,Transparency=0.4}):Play()end if glow then variables.
tweenService:Create(glow,inInfo,{Color=edge,Transparency=0.6}):Play()end element
._flashToken=(element._flashToken or 0)+1 local token=element._flashToken task.
delay(0.22,function()if element._flashToken~=token then return end variables.
tweenService:Create(box,outInfo,{BackgroundColor3=self.theme.FieldBackground}):
Play()if stroke then variables.tweenService:Create(stroke,outInfo,{Color=self.
theme.SurfaceStroke,Transparency=0.85}):Play()end if glow then variables.
tweenService:Create(glow,outInfo,{Color=self.theme.FieldGlow,Transparency=
element._glowIdle or 1}):Play()end end)end function Window:CreateHoverOverlay(
parent)local overlay=self:Create('Frame',{BackgroundColor3=Color3.fromRGB(255,
255,255),BackgroundTransparency=1,Size=UDim2.fromScale(1,1),BorderSizePixel=0,
ZIndex=1,Parent=parent})self:Create('UICorner',{Parent=overlay},{CornerRadius=
'ElementCornerRadius'})return overlay end function Window:_wireElementHover(
element)local info=TweenInfo.new(0.25,Enum.EasingStyle.Quint,Enum.
EasingDirection.Out)local theme=self.theme self:ConnectFor(element,element.main.
MouseEnter,function()if not self:_interactive()then return end variables.
tweenService:Create(element.stroke,info,{Transparency=theme.
ElementStrokeHoverTransparency,Color=theme.ElementStrokeHover}):Play()variables.
tweenService:Create(element.title,info,{TextColor3=theme.ElementTextHoverColor})
:Play()if element.hoverOverlay then variables.tweenService:Create(element.
hoverOverlay,info,{BackgroundTransparency=0.97}):Play()end end)self:ConnectFor(
element,element.main.MouseLeave,function()variables.tweenService:Create(element.
stroke,info,{Transparency=theme.ElementStrokeTransparency,Color=theme.
ElementStroke}):Play()variables.tweenService:Create(element.title,info,{
TextColor3=theme.ContentColor}):Play()if element.hoverOverlay then variables.
tweenService:Create(element.hoverOverlay,info,{BackgroundTransparency=1}):Play()
end end)end function Window:_runGuarded(element,fn,...)local args=table.pack(...
)task.spawn(function()local ok,err=pcall(function()return fn(table.unpack(args,1
,args.n))end)if ok or element._errored then return end element._errored=true
local flashFrame=element.flashTarget or element.main local quickOut=TweenInfo.
new(0.25,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)variables.tweenService:
Create(flashFrame,quickOut,{BackgroundColor3=self.theme.ErrorColor}):Play()
variables.tweenService:Create(element.stroke,quickOut,{Color=self.theme.
ErrorStrokeColor}):Play()if element.title then element.title.Text=locale.
resolve('Error, log recorded in console.')end log.warn(`Rayfield encountered an error, with the callback for a {
element.__type} component named '{element.name}':`)log.print(err)task.wait(1)if
element.title then element.title.Text=locale.resolve(element.name)end variables.
tweenService:Create(flashFrame,TweenInfo.new(0.4,Enum.EasingStyle.Quint,Enum.
EasingDirection.In),{BackgroundColor3=Color3.fromRGB(255,255,255)}):Play()
variables.tweenService:Create(element.stroke,TweenInfo.new(0.6,Enum.EasingStyle.
Quint,Enum.EasingDirection.Out),{Color=self.theme.ElementStroke}):Play()element.
_errored=false end)end function Window:StyleElementBody(main)self:Create(
'UIGradient',{Rotation=270,Parent=main},{Color='ElementGradient'})self:Create(
'UICorner',{Parent=main},{CornerRadius='ElementCornerRadius'})return self:
Create('UIStroke',{Transparency=1,Parent=main},{Color='ElementStroke',
Transparency='ElementStrokeTransparency'})end function Window:_buildCompactRow(
host,name,interactZIndex)local main=self:Create('Frame',{Name=name,Size=UDim2.
fromOffset(0,compactRowHeight),AutomaticSize=Enum.AutomaticSize.X,
ClipsDescendants=true,BackgroundColor3=Color3.fromRGB(255,255,255),
BorderSizePixel=0,BackgroundTransparency=1,Parent=host.tabPage},{
BackgroundTransparency='ElementTransparency'})local stroke=self:
StyleElementBody(main)self:Create('UIFlexItem',{FlexMode=Enum.UIFlexMode.Fill,
Parent=main})self:Create('UIListLayout',{FillDirection=Enum.FillDirection.
Horizontal,VerticalAlignment=Enum.VerticalAlignment.Center,HorizontalFlex=Enum.
UIFlexAlignment.Fill,Parent=main})local interact=self:Create('TextButton',{Text=
'',BackgroundColor3=Color3.fromRGB(255,255,255),BackgroundTransparency=1,
AutomaticSize=Enum.AutomaticSize.X,Size=UDim2.fromOffset(0,compactRowHeight),
BorderSizePixel=0,TextTransparency=1,ZIndex=interactZIndex or 1,Parent=main})
self:Create('UICorner',{Parent=interact},{CornerRadius='ElementCornerRadius'})
return main,stroke,interact end function Window:StyleElementPanel(frame)self:
Create('UIGradient',{Rotation=270,Parent=frame},{Color='ElementGradient'})self:
Create('UICorner',{Parent=frame},{CornerRadius='ElementCornerRadius'})local
stroke=self:Create('UIStroke',{ApplyStrokeMode=Enum.ApplyStrokeMode.Border,
BorderStrokePosition=Enum.BorderStrokePosition.Inner,LineJoinMode=Enum.
LineJoinMode.Round,Thickness=1,Color=Color3.fromRGB(255,255,255),Transparency=1,
Parent=frame})self:Create('UIGradient',{Rotation=270,Parent=stroke},{Color=
'ElementStrokeGradient'})return stroke end function Window:_reveal(instance,
props,animate,info)if not instance then return end if animate then variables.
tweenService:Create(instance,info or revealInfo,props):Play()else for property,
value in props do instance[property]=value end end end function Window:
_revealCommon(element,animate)self:_reveal(element.stroke,{Transparency=self.
theme.ElementStrokeTransparency},animate)self:_reveal(element.title,{
TextTransparency=0},animate)self:_reveal(element.main,{BackgroundTransparency=
self.theme.ElementTransparency or 0},animate)if element.iconLabel then self:
_reveal(element.iconLabel,{ImageTransparency=0},animate)end if element.
descriptor then self:_reveal(element.descriptor.titleLabel,{TextTransparency=0.7
},animate)end end function Window:_hideCommon(element,animate)self:_reveal(
element.stroke,{Transparency=1},animate)self:_reveal(element.title,{
TextTransparency=1},animate)self:_reveal(element.main,{BackgroundTransparency=1}
,animate)if element.iconLabel then self:_reveal(element.iconLabel,{
ImageTransparency=1},animate)end if element.descriptor then self:_reveal(element
.descriptor.titleLabel,{TextTransparency=1},animate)end end function Window:
_collapsedRect()local size=collapsedSize local home=UDim2.new(collapsedTop.X.
Scale,collapsedTop.X.Offset,collapsedTop.Y.Scale,collapsedTop.Y.Offset+size.Y.
Offset/2)return home,size end function Window:_interactive()return not self.
animating and not self.hidden end function Window:_settled()return not self.
hidden and not self._revealing end function Window:Connect(signal,callback)local
connection=signal:Connect(callback)table.insert(self.connections,connection)
return connection end function Window:ConnectFor(owner,signal,callback)local
connection=self:Connect(signal,callback)owner.connections=owner.connections or{}
table.insert(owner.connections,connection)return connection end function Window:
Disconnect(connection)if not connection then return end local index=table.find(
self.connections,connection)if index then table.remove(self.connections,index)
end connection:Disconnect()end function Window:DestroySubtree(root)if not root
then return end local inSubtree={[root]=true}for _,descendant in root:
GetDescendants()do inSubtree[descendant]=true end for i=#self.instances,1,-1 do
local instance=self.instances[i]if inSubtree[instance]then table.remove(self.
instances,i)self.themeProperties[instance]=nil self.localeProperties[instance]=
nil end end root:Destroy()end function Window:Unload()self.unloaded=true
hapticEngine.teardown()hapticEngine.releaseContainer(self.screenGui)if self.
_liveTween then self._liveTween:Cancel()self._liveTween=nil end for i=#self.
connections,1,-1 do self.connections[i]:Disconnect()end for i=#self.instances,1,
-1 do self.instances[i]:Destroy()end table.clear(self.connections)table.clear(
self.instances)table.clear(self.themeProperties)table.clear(self.
localeProperties)table.clear(self.controls)table.clear(self.tabs)end return
Window end end function __DARKLUA_BUNDLE_MODULES.y():typeof(__modImpl())local v=
__DARKLUA_BUNDLE_MODULES.cache.y if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.y=v end return v.c end end do local function
__modImpl()return function(script,require)local variables=require(script.utility
.variables)local image=require(script.utility.image)local locale=require(script.
utility.locale)local constants=require(script.utility.constants)local types=
require(script.types)local rayfield={}::Rayfield__DARKLUA_TYPE_R local function
createBanner()local ui=Instance.new('ScreenGui')ui.Name=variables.httpService:
GenerateGUID(false)ui.ClipToDeviceSafeArea=false ui.DisplayOrder=constants.
displayOrder.banner ui.IgnoreGuiInset=true ui.ResetOnSpawn=false ui.Enabled=true
ui.SafeAreaCompatibility=Enum.SafeAreaCompatibility.None ui.ScreenInsets=Enum.
ScreenInsets.DeviceSafeInsets ui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling ui.
Parent=variables.guiContainer local banner=Instance.new('ImageLabel')banner.Name
='Banner'banner.AnchorPoint=Vector2.new(0.5,0.5)banner.BackgroundColor3=Color3.
fromRGB(255,255,255)banner.BackgroundTransparency=1 banner.BorderColor3=Color3.
fromRGB(0,0,0)banner.BorderSizePixel=0 banner.Image=image.resolve(constants.
icons.banner)banner.Position=UDim2.fromScale(0.5,0.5)banner.Size=UDim2.
fromOffset(262,60)banner.Parent=ui return ui end function rayfield:CreateWindow(
properties:types.WindowProps):types.Window local banner=createBanner()local
window:types.Window?local queuedNotify:(()->())?if variables.secureMode then
image.preload(function(failed)if failed<=0 then return end local function notify
()if not window or window.unloaded then return end window:Notify({title=locale.
resolve('Secure mode'),content=if failed==1 then locale.resolve(
"An asset couldn't be cached and won't appear.")else locale.resolve(
"Some assets couldn't be cached and won't appear.")})end if window then notify()
else queuedNotify=notify end end)end local made,result=pcall(function()return(
require(script.components.window)::WindowModule__DARKLUA_TYPE_S).new(properties)
end)if not made then banner:Destroy()error(result,0)end local built=result::
types.Window window=built if queuedNotify then task.spawn(queuedNotify)
queuedNotify=nil end if variables.secureMode then task.spawn(function()local
body=variables.fontManager:loadFont(constants.fontAsset,Enum.FontWeight.Medium)
local title=variables.fontManager:loadFont(constants.fontAsset,Enum.FontWeight.
SemiBold)if not built.unloaded and body and title and body~=variables.
fallbackFont and title~=variables.fallbackFont then built:ChangeTheme({Font=body
,TitleFont=title})end end)end task.spawn(function()task.wait(0.5)banner:Destroy(
)task.wait(0.5)while built._pulseLoading and not built.unloaded do task.wait()
end if not built.unloaded then built:Show()end end)return built end return
rayfield end end function __DARKLUA_BUNDLE_MODULES.z():typeof(__modImpl())local
v=__DARKLUA_BUNDLE_MODULES.cache.z if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.z=v end return v.c end end do local function
__modImpl()return function(script,require)return{WindowColor=ColorSequence.new({
ColorSequenceKeypoint.new(0,Color3.fromRGB(22,16,32)),ColorSequenceKeypoint.new(
0.9999,Color3.fromRGB(30,22,46)),ColorSequenceKeypoint.new(1,Color3.fromRGB(38,
28,56))}),ShadowColor=Color3.fromRGB(12,6,22),ElementStroke=Color3.fromRGB(54,42
,74),ElementGradient=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.
fromRGB(32,24,48)),ColorSequenceKeypoint.new(0.9999,Color3.fromRGB(36,28,54)),
ColorSequenceKeypoint.new(1,Color3.fromRGB(36,28,54))}),ElementStrokeGradient=
ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(72,58,104)),
ColorSequenceKeypoint.new(0.9999,Color3.fromRGB(88,72,124)),
ColorSequenceKeypoint.new(1,Color3.fromRGB(72,58,104))}),ElementStrokeHover=
Color3.fromRGB(84,68,118),TabBackground=ColorSequence.new(Color3.fromRGB(54,42,
80),Color3.fromRGB(34,26,52)),TabStroke=ColorSequence.new(Color3.fromRGB(88,70,
128),Color3.fromRGB(54,42,80)),SliderBackground=Color3.fromRGB(46,36,68),
SliderBackgroundHover=Color3.fromRGB(60,48,90),SliderProgress=ColorSequence.new(
Color3.fromRGB(170,112,248),Color3.fromRGB(138,80,224)),AccentColor=Color3.
fromRGB(168,110,246),AccentStroke=Color3.fromRGB(200,154,255),ToggleKnobOff=
Color3.fromRGB(224,214,236),StatBackground=Color3.fromRGB(24,18,38),
DropdownHighlight=Color3.fromRGB(168,110,246),NeutralButton=Color3.fromRGB(46,36
,68),NeutralButtonHover=Color3.fromRGB(60,48,90),NeutralButtonStroke=Color3.
fromRGB(140,116,190)}end end function __DARKLUA_BUNDLE_MODULES.A():typeof(
__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.A if not v then v={c=
__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.A=v end return v.c end end do
local function __modImpl()return function(script,require)return{WindowColor=
ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(12,16,34)),
ColorSequenceKeypoint.new(0.9999,Color3.fromRGB(20,26,50)),ColorSequenceKeypoint
.new(1,Color3.fromRGB(28,36,66))}),ShadowColor=Color3.fromRGB(6,8,20),
ElementStroke=Color3.fromRGB(44,52,82),ElementGradient=ColorSequence.new({
ColorSequenceKeypoint.new(0,Color3.fromRGB(26,32,58)),ColorSequenceKeypoint.new(
0.9999,Color3.fromRGB(30,38,66)),ColorSequenceKeypoint.new(1,Color3.fromRGB(30,
38,66))}),ElementStrokeGradient=ColorSequence.new({ColorSequenceKeypoint.new(0,
Color3.fromRGB(56,66,104)),ColorSequenceKeypoint.new(0.9999,Color3.fromRGB(70,82
,124)),ColorSequenceKeypoint.new(1,Color3.fromRGB(56,66,104))}),
ElementStrokeHover=Color3.fromRGB(64,76,116),TabBackground=ColorSequence.new(
Color3.fromRGB(48,58,92),Color3.fromRGB(30,38,64)),TabStroke=ColorSequence.new(
Color3.fromRGB(78,92,140),Color3.fromRGB(48,58,92)),SliderBackground=Color3.
fromRGB(40,48,78),SliderBackgroundHover=Color3.fromRGB(54,64,100),SliderProgress
=ColorSequence.new(Color3.fromRGB(64,132,248),Color3.fromRGB(42,104,224)),
AccentColor=Color3.fromRGB(48,120,240),AccentStroke=Color3.fromRGB(96,164,255),
ToggleKnobOff=Color3.fromRGB(196,206,232),StatBackground=Color3.fromRGB(20,26,48
),DropdownHighlight=Color3.fromRGB(48,120,240),NeutralButton=Color3.fromRGB(40,
48,78),NeutralButtonHover=Color3.fromRGB(54,64,100),NeutralButtonStroke=Color3.
fromRGB(120,138,195)}end end function __DARKLUA_BUNDLE_MODULES.B():typeof(
__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.B if not v then v={c=
__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.B=v end return v.c end end do
local function __modImpl()return function(script,require)local variables=
require(script.Parent.Parent.utility.variables)return{CornerRoundness=UDim.new(0
,20),WindowColor=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(
10,10,10)),ColorSequenceKeypoint.new(0.9999,Color3.fromRGB(25,25,25)),
ColorSequenceKeypoint.new(1,Color3.fromRGB(35,35,35))}),ShadowColor=Color3.
fromRGB(20,20,20),ElementStroke=Color3.fromRGB(35,35,35),ElementGradient=
ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(30,30,30)),
ColorSequenceKeypoint.new(0.9999,Color3.fromRGB(35,35,35)),ColorSequenceKeypoint
.new(1,Color3.fromRGB(35,35,35))}),ElementStrokeGradient=ColorSequence.new({
ColorSequenceKeypoint.new(0,Color3.fromRGB(48,48,48)),ColorSequenceKeypoint.new(
0.9999,Color3.fromRGB(58,58,58)),ColorSequenceKeypoint.new(1,Color3.fromRGB(48,
48,48))}),TabColor=Color3.fromRGB(255,255,255),TabBackground=ColorSequence.new(
Color3.fromRGB(50,50,50),Color3.fromRGB(35,35,35)),TabStroke=ColorSequence.new(
Color3.fromRGB(95,95,95),Color3.fromRGB(50,50,50)),SliderBackground=Color3.
fromRGB(47,47,47),SliderBackgroundHover=Color3.fromRGB(60,60,60),SliderProgress=
ColorSequence.new(Color3.fromRGB(0,170,127),Color3.fromRGB(0,134,98)),
SliderStroke=Color3.fromRGB(255,255,255),ActionColor=Color3.fromRGB(255,255,255)
,TitleFont=variables.brandFont(Enum.FontWeight.SemiBold),Font=variables.
brandFont(Enum.FontWeight.Medium),ContentColor=Color3.fromRGB(255,255,255),
LiveAnimation=false,DarkToggleOverlay=true,ElementTransparency=0,
ElementStrokeTransparency=0,ElementStrokeHoverTransparency=0,ElementStrokeHover=
Color3.fromRGB(50,50,50),ElementCornerRadius=UDim.new(0,12),
ElementTextHoverColor=Color3.fromRGB(255,255,255),TitlingColor=Color3.fromRGB(
255,255,255),DropdownHighlight=Color3.fromRGB(255,255,255),AccentColor=Color3.
fromRGB(23,153,110),AccentStroke=Color3.fromRGB(32,201,144),AccentGlow=0.4,
StatBackground=Color3.fromRGB(25,25,25),SliderHandle=Color3.fromRGB(255,255,255)
,PillCornerRadius=UDim.new(1,0),ToggleTrack=Color3.fromRGB(0,0,0),
ToggleTrackTransparency=0.9,ToggleKnobOff=Color3.fromRGB(255,255,255),
ToggleKnobOffTransparency=0.8,FieldBackground=Color3.fromRGB(255,255,255),
FieldTransparency=0.9,FieldGlow=Color3.fromRGB(255,255,255),PlaceholderColor=
Color3.fromRGB(178,178,178),SurfaceStroke=Color3.fromRGB(255,255,255),
NeutralButton=Color3.fromRGB(38,38,38),NeutralButtonHover=Color3.fromRGB(54,54,
54),NeutralButtonStroke=Color3.fromRGB(255,255,255),ErrorColor=Color3.fromRGB(
185,50,50),ErrorStrokeColor=Color3.fromRGB(240,75,75)}end end function
__DARKLUA_BUNDLE_MODULES.C():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES
.cache.C if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.C=v end
return v.c end end do local function __modImpl()return function(script,require)
return{WindowColor=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.
fromRGB(22,18,16)),ColorSequenceKeypoint.new(0.9999,Color3.fromRGB(32,27,23)),
ColorSequenceKeypoint.new(1,Color3.fromRGB(40,33,28))}),ShadowColor=Color3.
fromRGB(16,12,8),ElementStroke=Color3.fromRGB(54,46,40),ElementGradient=
ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(32,27,23)),
ColorSequenceKeypoint.new(0.9999,Color3.fromRGB(38,32,27)),ColorSequenceKeypoint
.new(1,Color3.fromRGB(38,32,27))}),ElementStrokeGradient=ColorSequence.new({
ColorSequenceKeypoint.new(0,Color3.fromRGB(72,62,52)),ColorSequenceKeypoint.new(
0.9999,Color3.fromRGB(88,76,64)),ColorSequenceKeypoint.new(1,Color3.fromRGB(72,
62,52))}),ElementStrokeHover=Color3.fromRGB(84,72,60),TabBackground=
ColorSequence.new(Color3.fromRGB(56,47,40),Color3.fromRGB(36,30,26)),TabStroke=
ColorSequence.new(Color3.fromRGB(92,78,66),Color3.fromRGB(56,47,40)),
SliderBackground=Color3.fromRGB(48,40,34),SliderBackgroundHover=Color3.fromRGB(
62,52,44),SliderProgress=ColorSequence.new(Color3.fromRGB(244,152,44),Color3.
fromRGB(220,110,24)),AccentColor=Color3.fromRGB(240,142,40),AccentStroke=Color3.
fromRGB(255,182,92),ToggleKnobOff=Color3.fromRGB(232,224,214),StatBackground=
Color3.fromRGB(26,21,18),DropdownHighlight=Color3.fromRGB(240,142,40),
NeutralButton=Color3.fromRGB(48,40,34),NeutralButtonHover=Color3.fromRGB(64,54,
46),NeutralButtonStroke=Color3.fromRGB(150,128,104)}end end function
__DARKLUA_BUNDLE_MODULES.D():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES
.cache.D if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.D=v end
return v.c end end do local function __modImpl()return function(script,require)
local variables=require(script.Parent.Parent.utility.variables)return{
WindowColor=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(246,
249,251)),ColorSequenceKeypoint.new(1,Color3.fromRGB(236,241,245))}),ShadowColor
=Color3.fromRGB(116,124,132),LiveAnimation=false,ElementTransparency=0,
ElementStroke=Color3.fromRGB(218,224,228),ElementGradient=ColorSequence.new(
Color3.fromRGB(255,255,255)),ElementStrokeGradient=ColorSequence.new(Color3.
fromRGB(224,230,234),Color3.fromRGB(232,238,242)),ElementStrokeTransparency=0.1,
ElementStrokeHoverTransparency=0,ElementStrokeHover=Color3.fromRGB(0,176,208),
DarkToggleOverlay=false,TabColor=Color3.fromRGB(38,42,46),TabBackground=
ColorSequence.new(Color3.fromRGB(0,176,208),Color3.fromRGB(0,150,184)),TabStroke
=ColorSequence.new(Color3.fromRGB(80,206,230),Color3.fromRGB(0,160,196)),
SliderBackground=Color3.fromRGB(224,230,234),SliderBackgroundHover=Color3.
fromRGB(212,220,224),SliderProgress=ColorSequence.new(Color3.fromRGB(0,182,214),
Color3.fromRGB(0,146,182)),SliderStroke=Color3.fromRGB(200,206,210),AccentColor=
Color3.fromRGB(0,176,208),AccentStroke=Color3.fromRGB(96,210,232),AccentGlow=
0.85,StatBackground=Color3.fromRGB(255,255,255),SliderHandle=Color3.fromRGB(60,
66,72),ToggleTrack=Color3.fromRGB(198,204,210),ToggleTrackTransparency=0,
ToggleKnobOffTransparency=0.05,FieldBackground=Color3.fromRGB(224,230,234),
FieldTransparency=0,FieldGlow=Color3.fromRGB(148,154,160),PlaceholderColor=
Color3.fromRGB(138,144,150),SurfaceStroke=Color3.fromRGB(204,210,214),
NeutralButton=Color3.fromRGB(224,230,234),NeutralButtonHover=Color3.fromRGB(212,
220,224),NeutralButtonStroke=Color3.fromRGB(242,246,248),ActionColor=Color3.
fromRGB(68,74,80),TitlingColor=Color3.fromRGB(26,30,34),TitleFont=variables.
brandFont(Enum.FontWeight.SemiBold),Font=variables.brandFont(Enum.FontWeight.
Medium),ContentColor=Color3.fromRGB(42,46,52),ElementTextHoverColor=Color3.
fromRGB(18,22,26),DropdownHighlight=Color3.fromRGB(0,176,208),ErrorColor=Color3.
fromRGB(200,60,55),ErrorStrokeColor=Color3.fromRGB(240,80,70)}end end function
__DARKLUA_BUNDLE_MODULES.E():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES
.cache.E if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.E=v end
return v.c end end do local function __modImpl()return function(script,require)
return{WindowColor=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.
fromRGB(26,18,22)),ColorSequenceKeypoint.new(0.9999,Color3.fromRGB(36,26,31)),
ColorSequenceKeypoint.new(1,Color3.fromRGB(44,32,38))}),ShadowColor=Color3.
fromRGB(18,10,14),ElementStroke=Color3.fromRGB(58,44,50),ElementGradient=
ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(34,25,29)),
ColorSequenceKeypoint.new(0.9999,Color3.fromRGB(40,30,34)),ColorSequenceKeypoint
.new(1,Color3.fromRGB(40,30,34))}),ElementStrokeGradient=ColorSequence.new({
ColorSequenceKeypoint.new(0,Color3.fromRGB(76,58,66)),ColorSequenceKeypoint.new(
0.9999,Color3.fromRGB(92,70,80)),ColorSequenceKeypoint.new(1,Color3.fromRGB(76,
58,66))}),ElementStrokeHover=Color3.fromRGB(88,66,74),TabBackground=
ColorSequence.new(Color3.fromRGB(62,46,53),Color3.fromRGB(38,29,33)),TabStroke=
ColorSequence.new(Color3.fromRGB(102,78,88),Color3.fromRGB(62,46,53)),
SliderBackground=Color3.fromRGB(50,38,44),SliderBackgroundHover=Color3.fromRGB(
64,50,56),SliderProgress=ColorSequence.new(Color3.fromRGB(244,88,140),Color3.
fromRGB(220,60,116)),AccentColor=Color3.fromRGB(240,82,138),AccentStroke=Color3.
fromRGB(255,134,178),ToggleKnobOff=Color3.fromRGB(236,220,226),StatBackground=
Color3.fromRGB(28,20,24),DropdownHighlight=Color3.fromRGB(240,82,138),
NeutralButton=Color3.fromRGB(50,38,44),NeutralButtonHover=Color3.fromRGB(64,50,
56),NeutralButtonStroke=Color3.fromRGB(170,122,140)}end end function
__DARKLUA_BUNDLE_MODULES.F():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES
.cache.F if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.F=v end
return v.c end end do local function __modImpl()return function(script,require)
return{}end end function __DARKLUA_BUNDLE_MODULES.G():typeof(__modImpl())local v
=__DARKLUA_BUNDLE_MODULES.cache.G if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.G=v end return v.c end end do local function
__modImpl()return function(script,require)local variables=require(script.Parent.
variables)local hapticEngine={}hapticEngine.enabled=false local types:
HapticTypes__DARKLUA_TYPE_aA={}local supported,resolvedTypes=pcall(function()
Instance.new('HapticEffect'):Destroy()return{click=Enum.HapticEffectType.UIHover
,notify=Enum.HapticEffectType.UIClick}end)if supported then types=resolvedTypes
end local effects:{[Enum.HapticEffectType]:Instance}={}local container:Instance?
=nil function hapticEngine.setContainer(target:Instance?)container=target end
function hapticEngine.releaseContainer(target:Instance?)if target==nil or
container==target then container=nil end end local function containerFor():
Instance if container and container.Parent then return container end return
variables.guiContainer end local function effectFor(hapticType:Enum.
HapticEffectType):Instance?local effect=effects[hapticType]if effect and effect.
Parent then return effect end local ok,made=pcall(Instance.new,'HapticEffect')if
not ok then return nil end local hapticEffect=made::any hapticEffect.Type=
hapticType local parented=pcall(function()made.Parent=containerFor()end)if not
parented then made:Destroy()return nil end effects[hapticType]=made return made
end local function play(hapticType:Enum.HapticEffectType?)if not hapticType or
not hapticEngine.enabled then return end local effect=effectFor(hapticType)if
effect then local hapticEffect=effect::any pcall(hapticEffect.Play,effect)end
end function hapticEngine.click()play(types.click)end function hapticEngine.
notify()play(types.notify)end function hapticEngine.setEnabled(state:boolean?)
hapticEngine.enabled=state and true or false if not hapticEngine.enabled then
hapticEngine.teardown()end end function hapticEngine.teardown()for hapticType,
effect in effects do pcall(effect.Destroy,effect)effects[hapticType]=nil end end
return hapticEngine end end function __DARKLUA_BUNDLE_MODULES.H():typeof(
__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.H if not v then v={c=
__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.H=v end return v.c end end do
local function __modImpl()return function(script,require)local network=require(
script.Parent.network)local log=require(script.Parent.log)local assetResolver={
Enum={AssetDownloadUrl={RobloxDownloadUrl=
'https://assetdelivery.roblox.com/v1/asset/?id=%d'::
AssetDownloadUrl__DARKLUA_TYPE_aC,RoProxyDownloadUrl=
'https://assetdelivery.roproxy.com/v1/asset?id=%d'::
AssetDownloadUrl__DARKLUA_TYPE_aC}}}assetResolver.__index=assetResolver
assetResolver.__type='assetResolver'local contentCacheLimit=8 function
assetResolver.new(useCache:boolean?,assetContentDownloadUrl:
AssetDownloadUrl__DARKLUA_TYPE_aC?):AssetResolver__DARKLUA_TYPE_aH local
contentCache:{[CacheKey__DARKLUA_TYPE_aD]:string}?=if useCache then{}else nil
local self=setmetatable({contentCache=contentCache,contentCacheOrder=if useCache
then{}::{CacheKey__DARKLUA_TYPE_aD}else nil,contentDownloadUrl=
assetContentDownloadUrl or assetResolver.Enum.AssetDownloadUrl.RobloxDownloadUrl
,pendingRequests={}}::AssetResolverState__DARKLUA_TYPE_aG,assetResolver)::any
return self end function assetResolver.resolve(_self:
AssetResolver__DARKLUA_TYPE_aH,value:unknown):ResolvedAsset__DARKLUA_TYPE_aE?if
type(value)=='number'then return value end if type(value)~='string'then return
nil end if string.sub(value,1,11)=='rbxasset://'or string.sub(value,1,11)==
'rbxthumb://'then return value end local id=tonumber(string.match(value,
'^rbxassetid://(%d+)$'))if id then return id end return nil end local function
isGoodResponse(response:unknown):boolean if type(response)~='table'then return
false end local shaped=response::{Body:unknown,StatusCode:unknown,Success:
unknown}local body=shaped.Body if type(body)~='string'or#body==0 then return
false end if type(shaped.StatusCode)=='number'then local statusCode=shaped.
StatusCode::number return statusCode>=200 and statusCode<300 end if type(shaped.
Success)=='boolean'then return shaped.Success::boolean end return false end
function assetResolver.getAssetContentFromUrl(self:
AssetResolver__DARKLUA_TYPE_aH,url:string,cacheKey:CacheKey__DARKLUA_TYPE_aD?,
forced:boolean?):string?local contentCache=self.contentCache if cacheKey~=nil
and contentCache and not forced then local cachedContent=contentCache[cacheKey]
if cachedContent then return cachedContent end end local pendingRequests=self.
pendingRequests if cacheKey~=nil then local pending=pendingRequests[cacheKey]if
pending then table.insert(pending,coroutine.running())return coroutine.yield()
end pendingRequests[cacheKey]={}end local content:string?=nil local requestFn=
network.getRequestFn()if not requestFn then log.warn(
'No request function available to download asset content.')else local success,
response=pcall(requestFn,{Url=url,Method='GET'}::
AssetRequestPayload__DARKLUA_TYPE_aF)if success and isGoodResponse(response)then
local body=(response::{Body:string}).Body content=body if cacheKey~=nil and
contentCache then local order=self.contentCacheOrder if order and contentCache[
cacheKey]==nil then table.insert(order,cacheKey)local oldest=if#order>
contentCacheLimit then table.remove(order,1)else nil if oldest~=nil then
contentCache[oldest]=nil end end contentCache[cacheKey]=body end elseif not
forced then log.warn('Failed to download asset content for url: '..tostring(url)
)end end if cacheKey~=nil then local waiting=pendingRequests[cacheKey]
pendingRequests[cacheKey]=nil if waiting then for _,thread in waiting do
coroutine.resume(thread,content)end end end return content end function
assetResolver.getAssetContentFromId(self:AssetResolver__DARKLUA_TYPE_aH,id:
AssetId__DARKLUA_TYPE_aB,forced:boolean?):string?local resolvedId=self:resolve(
id)if not resolvedId or type(resolvedId)~='number'then log.warn(
'Invalid asset id: '..tostring(resolvedId))return nil end local downloadUrl=
string.format(self.contentDownloadUrl,resolvedId)return self:
getAssetContentFromUrl(downloadUrl,resolvedId,forced)end return assetResolver
end end function __DARKLUA_BUNDLE_MODULES.I():typeof(__modImpl())local v=
__DARKLUA_BUNDLE_MODULES.cache.I if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.I=v end return v.c end end do local function
__modImpl()return function(script,require)local colors={}function colors.
contrastColor(color:Color3):Color3 local luminance=0.299*color.R+0.587*color.G+
0.114*color.B return if luminance>0.5 then Color3.fromRGB(0,0,0)else Color3.
fromRGB(255,255,255)end function colors.toColorSequence(color:Color3|
ColorSequence):ColorSequence return if typeof(color)=='ColorSequence'then color
else ColorSequence.new(color)end function colors.contrastText(color:Color3):
Color3 local luminance=0.299*color.R+0.587*color.G+0.114*color.B return if
luminance>0.6 then Color3.fromRGB(20,20,20)else Color3.fromRGB(255,255,255)end
return colors end end function __DARKLUA_BUNDLE_MODULES.J():typeof(__modImpl())
local v=__DARKLUA_BUNDLE_MODULES.cache.J if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.J=v end return v.c end end do local function
__modImpl()return function(script,require)local constants={}constants.fontAsset=
'rbxassetid://12187365364'constants.pillResizeInfo=TweenInfo.new(0.4,Enum.
EasingStyle.Exponential,Enum.EasingDirection.Out)constants.icons={close=
83277910885129,minimise=108115485663409,maximise=88738500661569,settings=
129180860773723,search=100604009889706,chevron=88479147175134,check=
125626312718314,dot=91452555903853,colorpicker=91452555903853,banner=
111263549366178,config=125823673784681,rayfield=80387863064905}constants.accent=
{on=Color3.fromRGB(242,112,225),onStroke=Color3.fromRGB(255,190,247)}constants.
statAccents={positive={fill=ColorSequence.new(Color3.fromRGB(242,112,225),Color3
.fromRGB(202,72,185)),stroke=ColorSequence.new(Color3.fromRGB(255,190,247),
Color3.fromRGB(232,127,217))},negative={fill=ColorSequence.new(Color3.fromRGB(
172,47,47),Color3.fromRGB(135,37,37)),stroke=ColorSequence.new(Color3.fromRGB(
255,75,75),Color3.fromRGB(244,67,67))},neutral={fill=ColorSequence.new(Color3.
fromRGB(242,112,225),Color3.fromRGB(202,72,185)),stroke=ColorSequence.new(Color3
.fromRGB(255,190,247),Color3.fromRGB(232,127,217))}}constants.zIndex={bottomFade
=100,notification=1500,drag=1000,toast=2000,toastContent=2001,restoreContent=
100001,restoreInteract=100002}constants.displayOrder={window=99999,banner=100000
,popup=100001}return constants end end function __DARKLUA_BUNDLE_MODULES.K():
typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.K if not v then v={c=
__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.K=v end return v.c end end do
local function __modImpl()return function(script,require)local enums={}function
enums.itemFromValue(enumType,value)local ok,item=pcall(function()return enumType
:FromValue(value)end)if ok and item then return item end local itemsOk,items=
pcall(function()return enumType:GetEnumItems()end)if not itemsOk then return nil
end for _,enumItem in items do if enumItem.Value==value then return enumItem end
end return nil end return enums end end function __DARKLUA_BUNDLE_MODULES.L():
typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.L if not v then v={c=
__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.L=v end return v.c end end do
local function __modImpl()return function(script,require)local services=require(
script.Parent.services)local filesystem={}local isStudio=services.getService(
'RunService'):IsStudio()local hasNativeFS=not isStudio and typeof(writefile)==
'function'and typeof(readfile)=='function'and typeof(isfile)=='function'and
typeof(isfolder)=='function'and typeof(makefolder)=='function'and typeof(
listfiles)=='function'and typeof(delfile)=='function'and typeof(delfolder)==
'function'if hasNativeFS then function filesystem.writefile(path:string,content:
string)writefile(path,content)end function filesystem.readfile(path:string):
string return readfile(path)end if typeof(appendfile)=='function'then function
filesystem.appendfile(path:string,content:string)appendfile(path,content)end end
function filesystem.isfile(path:string):boolean return isfile(path)end function
filesystem.delfile(path:string)delfile(path)end function filesystem.listfiles(
folder:string):{string}return listfiles(folder)end function filesystem.
makefolder(path:string)makefolder(path)end function filesystem.isfolder(path:
string):boolean return isfolder(path)end function filesystem.delfolder(path:
string)delfolder(path)end elseif isStudio then local root=Instance.new('Folder')
root.Name='Filesystem'root.Parent=services.getService('ReplicatedStorage')
local function splitPath(path:string):{string}local parts={}for part in string.
gmatch(path,'[^/]+')do table.insert(parts,part)end return parts end
local function resolveParent(parts:{string},createMissing:boolean):Instance?
local current:Instance=root for i=1,#parts-1 do local child=current:
FindFirstChild(parts[i])if not child then if not createMissing then return nil
end local folder=Instance.new('Folder')folder.Name=parts[i]folder.Parent=current
child=folder end current=child::Instance end return current end local function
fileFromInstance(instance:Instance?):StringValue?if instance and instance:IsA(
'StringValue')then return instance end return nil end function filesystem.
writefile(path:string,content:string)local parts=splitPath(path)assert(#parts>0,
'Invalid path')local parent=resolveParent(parts,true)assert(parent,
'Invalid path')local fileName=parts[#parts]local existing=parent:FindFirstChild(
fileName)local existingFile=fileFromInstance(existing)if existingFile then
existingFile.Value=content else if existing then existing:Destroy()end local
file=Instance.new('StringValue')file.Name=fileName file.Value=content file.
Parent=parent end end function filesystem.readfile(path:string):string local
parts=splitPath(path)assert(#parts>0,'Invalid path')local parent=resolveParent(
parts,false)assert(parent,'File not found: '..path)local file=parent:
FindFirstChild(parts[#parts])local stringFile=fileFromInstance(file)assert(
stringFile,'File not found: '..path)return stringFile.Value end function
filesystem.isfile(path:string):boolean local parts=splitPath(path)if#parts==0
then return false end local parent=resolveParent(parts,false)if not parent then
return false end return fileFromInstance(parent:FindFirstChild(parts[#parts]))~=
nil end function filesystem.listfiles(folder:string):{string}local parts=
splitPath(folder)local current:Instance=root for _,part in parts do local child=
current:FindFirstChild(part)if not child or not child:IsA('Folder')then error(
'Folder not found: '..folder)end current=child end local results:{string}={}for
_,child in current:GetChildren()do table.insert(results,folder..'/'..child.Name)
end return results end function filesystem.delfile(path:string)local parts=
splitPath(path)assert(#parts>0,'Invalid path')local parent=resolveParent(parts,
false)assert(parent,'File not found: '..path)local file=parent:FindFirstChild(
parts[#parts])local stringFile=fileFromInstance(file)assert(stringFile,
'File not found: '..path)stringFile:Destroy()end function filesystem.makefolder(
path:string)local parts=splitPath(path)if#parts==0 then return end local current
:Instance=root for _,part in parts do local child=current:FindFirstChild(part)if
not child then local folder=Instance.new('Folder')folder.Name=part folder.Parent
=current child=folder end current=child::Instance end end function filesystem.
isfolder(path:string):boolean local parts=splitPath(path)if#parts==0 then return
false end local current:Instance=root for _,part in parts do local child=current
:FindFirstChild(part)if not child or not child:IsA('Folder')then return false
end current=child end return true end function filesystem.delfolder(path:string)
local parts=splitPath(path)assert(#parts>0,'Invalid path')local parent=
resolveParent(parts,false)assert(parent,'Folder not found: '..path)local folder=
parent:FindFirstChild(parts[#parts])assert(folder and folder:IsA('Folder'),
'Folder not found: '..path)folder:Destroy()end end if filesystem.writefile and
not filesystem.appendfile then function filesystem.appendfile(path:string,
content:string)local existing=if filesystem.isfile(path)then filesystem.
readfile(path)else nil filesystem.writefile(path,if existing then existing..
content else content)end end function filesystem.ensureFolder(path:string)if not
filesystem.isfolder(path)then filesystem.makefolder(path)end end function
filesystem.ensureDir(dir:string)local built=''for part in string.gmatch(dir,
'[^/]+')do built=if built==''then part else built..'/'..part if not filesystem.
isfolder(built)then filesystem.makefolder(built)end end end return filesystem
end end function __DARKLUA_BUNDLE_MODULES.M():typeof(__modImpl())local v=
__DARKLUA_BUNDLE_MODULES.cache.M if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.M=v end return v.c end end do local function
__modImpl()return function(script,require)local filesystem=require(script.Parent
.filesystem)local path=require(script.Parent.path)local DEFAULT_ROOT_PATH=
'Pulse'local fileSystemManager={}fileSystemManager.__index=fileSystemManager
function fileSystemManager.new(name:string?):FileSystemManager__DARKLUA_TYPE_aI
local root=name or DEFAULT_ROOT_PATH local self=setmetatable({root=root,assets=
root..'/Assets'},fileSystemManager)::any pcall(filesystem.ensureFolder,self.root
)pcall(filesystem.ensureFolder,self.assets)return self end function
fileSystemManager:getPath(subpath:string?):string return path.join(self.root,
subpath)end function fileSystemManager:getAssetsFolder(subfolder:string?):string
if subfolder then local assetPath=path.join(self.assets,subfolder)pcall(
filesystem.ensureFolder,assetPath)return assetPath end return self.assets end
function fileSystemManager:getRootFolder():string return self.root end return
fileSystemManager end end function __DARKLUA_BUNDLE_MODULES.N():typeof(
__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.N if not v then v={c=
__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.N=v end return v.c end end do
local function __modImpl()return function(script,require)local flagNames={}local
offsetBasis=2166136261 local prime=16777619 local function hashName(name:string)
:number local hash=offsetBasis for index=1,#name do hash=bit32.bxor(hash,string.
byte(name,index))local low=hash%65536 local high=(hash-low)/65536 hash=(((high*
prime)%65536)*65536+low*prime)%4294967296 end return hash end function flagNames
.deriveFlagFromName(name:string):string local flag=name:gsub('(%S+)',function(w:
string):string return w:sub(1,1):upper()..w:sub(2,-1)end):gsub('[^%w]','')if
flag==''and name~=''then return string.format('Flag%08x',hashName(name))end
return flag end return flagNames end end function __DARKLUA_BUNDLE_MODULES.O():
typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.O if not v then v={c=
__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.O=v end return v.c end end do
local function __modImpl()return function(script,require)local services=require(
script.Parent.services)local httpService=services.getService('HttpService')local
runService=services.getService('RunService')local fileSystem=require(script.
Parent.filesystem)local assetResolver=require(script.Parent.assetResolver)local
log=require(script.Parent.log)local path=require(script.Parent.path)
local function jsonEncode(data:unknown):string?local success,result=pcall(
function()return httpService:JSONEncode(data)end)if success and type(result)==
'string'then return result else log.warn('Failed to encode JSON:',result)return
nil end end local function jsonDecode(jsonString:string):unknown?local success,
result=pcall(function()return httpService:JSONDecode(jsonString)end)if success
then return result else log.warn('Failed to decode JSON:',result)return nil end
end local fontManager={}fontManager.__type='fontManager'local function
validateManifest(manifest:unknown):FontManifest__DARKLUA_TYPE_aK?local candidate
=manifest::any if type(candidate)~='table'or type(candidate.name)~='string'or
type(candidate.faces)~='table'then return nil end candidate.name=path.
sanitizeFile(candidate.name)if#candidate.name==0 or#candidate.faces==0 then
return nil end for _,face in candidate.faces do if type(face)~='table'or type(
face.name)~='string'or type(face.assetId)~='string'then return nil end face.name
=path.sanitizeFile(face.name)if#face.name==0 then return nil end end return
candidate::FontManifest__DARKLUA_TYPE_aK end local fontSignatures={'\0\1\0\0',
'OTTO','true','ttcf','wOFF','wOF2'}local function isFontBody(body:string):
boolean for _,signature in fontSignatures do if string.sub(body,1,#signature)==
signature then return true end end return false end local env=getfenv()
local function variantKey(fontWeight:Enum.FontWeight,fontStyle:Enum.FontStyle):
string return tostring(fontWeight)..'|'..tostring(fontStyle)end local function
resolveId(id:unknown):number?if type(id)=='number'then return id end if type(id)
=='string'then return tonumber(id)end return nil end function fontManager.
__index(self:FontManagerState__DARKLUA_TYPE_aO,key:unknown):unknown local
classMember=(fontManager::any)[key]if classMember~=nil then return classMember
end local resolvedId=resolveId(key)if not resolvedId then return nil end local
fontCache=self.fontCache if fontCache then local cached=fontCache[resolvedId]if
cached then local regularKey=variantKey(Enum.FontWeight.Regular,Enum.FontStyle.
Normal)local regularFont=cached.variants and cached.variants[regularKey]if
regularFont then return regularFont end for _,font in pairs(cached.variants or{}
)do return font end end end return nil end function fontManager.new(rootFolder:
string,useDebug:boolean?,useCache:boolean?,assetContentDownloadUrl:assetResolver
.AssetDownloadUrl?,defaultOptions:FontResolverOptions__DARKLUA_TYPE_aN?):
FontManager__DARKLUA_TYPE_aP local defaultResolverOptions=defaultOptions or{
saveToDisk=true,skipCache=not useCache or false,fallbackFont=Font.fromEnum(Enum.
Font.SourceSans)}local self=setmetatable({rootFolder=rootFolder,fontCache=if
useCache then{}::FontCache__DARKLUA_TYPE_aM else nil,assetResolver=assetResolver
.new(useCache,assetContentDownloadUrl),defaultOptions=defaultResolverOptions,
_debug=useDebug or runService:IsStudio()or false,_pendingLoads={}}::
FontManagerState__DARKLUA_TYPE_aO,fontManager)::any pcall(fileSystem.
ensureFolder,rootFolder)return self end local function fetchFont(self:
FontManager__DARKLUA_TYPE_aP,resolvedId:number,requestedFontWeight:Enum.
FontWeight,requestedFontStyle:Enum.FontStyle,cacheKey:string):Font?local
manifestPath=self.rootFolder..'/'..resolvedId..'.json'if typeof(fileSystem.
isfile)~='function'then return self.defaultOptions.fallbackFont end local
possibleFontManifest:string?=nil local downloadedManifest=false if runService:
IsStudio()and self._debug then log.warn(
[[Font manifest loading is not supported in Studio. Using default font manifest for testing.]]
)possibleFontManifest=
[[{"name":"Inter","faces":[{"name":"Thin","weight":100,"style":"normal","assetId":"rbxassetid://12187277209"},{"name":"Extra Light","weight":200,"style":"normal","assetId":"rbxassetid://12187293441"},{"name":"Light","weight":300,"style":"normal","assetId":"rbxassetid://12187268450"},{"name":"Regular","weight":400,"style":"normal","assetId":"rbxassetid://12187266066"},{"name":"Medium","weight":500,"style":"normal","assetId":"rbxassetid://12187336822"},{"name":"Semi Bold","weight":600,"style":"normal","assetId":"rbxassetid://12187254443"},{"name":"Bold","weight":700,"style":"normal","assetId":"rbxassetid://12187275575"},{"name":"Extra Bold","weight":800,"style":"normal","assetId":"rbxassetid://12187267750"},{"name":"Black","weight":900,"style":"normal","assetId":"rbxassetid://12187359223"}]}]]
elseif fileSystem.isfile(manifestPath)then local ok,contents=pcall(fileSystem.
readfile,manifestPath)possibleFontManifest=ok and contents or nil else
possibleFontManifest=self.assetResolver:getAssetContentFromId(resolvedId,false)
downloadedManifest=possibleFontManifest~=nil end local fontManifest:
FontManifest__DARKLUA_TYPE_aK?=nil if possibleFontManifest then local ok,
parsedManifest=pcall(jsonDecode,possibleFontManifest)if ok and parsedManifest
then fontManifest=validateManifest(parsedManifest)else if self._debug then log.
warn('Failed to parse font manifest for font id: '..tostring(resolvedId)..
'. Error: '..tostring(parsedManifest))end end else return self.defaultOptions.
fallbackFont end if not fontManifest then if self._debug then log.warn(
'Font manifest is nil for font id: '..tostring(resolvedId))end pcall(fileSystem.
delfile,manifestPath)return self.defaultOptions.fallbackFont end if
downloadedManifest and possibleFontManifest then pcall(fileSystem.writefile,
manifestPath,possibleFontManifest)end local fontDirectory=self.rootFolder..'/'..
fontManifest.name local madeAllFontsLocal=true if not pcall(fileSystem.
ensureFolder,fontDirectory)then return self.defaultOptions.fallbackFont end for
i,face in ipairs(fontManifest.faces)do local fontFacePath=fontDirectory..'/'..
face.name:gsub(' ','-')..'.ttf'if fileSystem.isfile(fontFacePath)then local
readOk,existing=pcall(fileSystem.readfile,fontFacePath)if not readOk or type(
existing)~='string'or not isFontBody(existing)then pcall(fileSystem.delfile,
fontFacePath)end end if not fileSystem.isfile(fontFacePath)then local fontFaceId
=self.assetResolver:resolve(face.assetId)local fontFaceContent=if fontFaceId~=
nil then self.assetResolver:getAssetContentFromId(fontFaceId,false)else nil if
not fontFaceContent or not isFontBody(fontFaceContent)then madeAllFontsLocal=
false if self._debug then log.warn(
'Font face content is missing or not a font for font id: '..tostring(resolvedId)
..', face: '..face.name)end continue end pcall(fileSystem.writefile,fontFacePath
,fontFaceContent)end local ok,uri=pcall(env.getcustomasset,fontFacePath)if ok
and type(uri)=='string'then fontManifest.faces[i].assetId=uri if self._debug
then log.print('Loaded font face for id: '..tostring(resolvedId)..', face: '..
face.name)end else madeAllFontsLocal=false if self._debug then log.warn(
'Failed to load font face for id: '..tostring(resolvedId)..', face: '..face.name
)end end end if not madeAllFontsLocal then return self.defaultOptions.
fallbackFont end local encodedManifest=jsonEncode(fontManifest)if not
encodedManifest or not pcall(fileSystem.writefile,fontDirectory..
'/manifest.json',encodedManifest)then return self.defaultOptions.fallbackFont
end local manifestOk,fontManifestId=pcall(env.getcustomasset,fontDirectory..
'/manifest.json')if not manifestOk or not fontManifestId then if self._debug
then log.warn('Failed to load font manifest for id: '..tostring(resolvedId))end
return self.defaultOptions.fallbackFont end local ok,loadedFont=pcall(Font.new,
fontManifestId::any,requestedFontWeight,requestedFontStyle)if not ok or not
loadedFont then if self._debug then log.warn('Failed to load font for id: '..
tostring(resolvedId))end return self.defaultOptions.fallbackFont end local
fontCache=self.fontCache if fontCache then fontCache[resolvedId]={customId=
fontManifestId,manifest=fontManifest,loadedFromDisk=true,variants={[cacheKey]=
loadedFont}}if self._debug then log.print('Cached font for id: '..tostring(
resolvedId))end end return loadedFont end function fontManager.loadFont(self:
FontManager__DARKLUA_TYPE_aP,id:(number|string)?,fontWeight:Enum.FontWeight?,
fontStyle:Enum.FontStyle?,saveToDisk:boolean?,skipCache:boolean?):Font?if
saveToDisk==nil then saveToDisk=self.defaultOptions.saveToDisk end if skipCache
==nil then skipCache=self.defaultOptions.skipCache end local requestedFontWeight
=fontWeight or Enum.FontWeight.Regular local requestedFontStyle=fontStyle or
Enum.FontStyle.Normal local cacheKey=variantKey(requestedFontWeight,
requestedFontStyle)local rawId=self.assetResolver:resolve(id)local resolvedId=
resolveId(rawId)if not resolvedId then log.warn('Invalid font id: '..tostring(id
))return self.defaultOptions.fallbackFont end local fontCache=self.fontCache if
fontCache and not skipCache then local cachedFont=fontCache[resolvedId]if
cachedFont then local cachedVariant=cachedFont.variants and cachedFont.variants[
cacheKey]if cachedVariant then if self._debug then log.print(
'Loaded font from cache for id: '..tostring(resolvedId))end return cachedVariant
end local ok,loadedFont=pcall(Font.new,cachedFont.customId::any,
requestedFontWeight,requestedFontStyle)if ok and loadedFont then cachedFont.
variants=cachedFont.variants or{}cachedFont.variants[cacheKey]=loadedFont if
self._debug then log.print('Loaded font variant from cache for id: '..tostring(
resolvedId))end return loadedFont else if self._debug then log.warn(
'Failed to load font from cache for id: '..tostring(resolvedId))end fontCache[
resolvedId]=nil return self.defaultOptions.fallbackFont end end end if not
saveToDisk then if self._debug then log.warn(
[[Font loading without saving to disk can be detected by Anti-cheats.]])end
return self.defaultOptions.fallbackFont end local pendingLoads=self.
_pendingLoads local pendingKey=tostring(resolvedId)..'|'..cacheKey local waiting
=pendingLoads[pendingKey]if waiting then table.insert(waiting,coroutine.running(
))return coroutine.yield()end pendingLoads[pendingKey]={}local ok,result=pcall(
fetchFont,self,resolvedId,requestedFontWeight,requestedFontStyle,cacheKey)local
loadedFont=if ok then result else self.defaultOptions.fallbackFont waiting=
pendingLoads[pendingKey]pendingLoads[pendingKey]=nil if waiting then for _,
thread in waiting do coroutine.resume(thread,loadedFont)end end return
loadedFont end function fontManager.resolve(self:FontManager__DARKLUA_TYPE_aP,id
:number|string):Font?local resolvedId=resolveId(id)if not resolvedId then return
nil end local fontCache=self.fontCache if fontCache then local cached=fontCache[
resolvedId]if cached then if self._debug then log.print('Resolved font for id: '
..tostring(resolvedId))end for _,font in pairs(cached.variants or{})do return
font end end end return nil end function fontManager.getFontFromId(self:
FontManager__DARKLUA_TYPE_aP,id:number|string):Font?return self:resolve(id)end
return fontManager end end function __DARKLUA_BUNDLE_MODULES.P():typeof(
__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.P if not v then v={c=
__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.P=v end return v.c end end do
local function __modImpl()return function(script,require)local functions={}local
textMetrics=require(script.Parent.textMetrics)local colors=require(script.Parent
.colors)local flags=require(script.Parent.flagNames)functions.textWidth=
textMetrics.textWidth functions.textHeight=textMetrics.textHeight functions.
deriveFlagFromName=flags.deriveFlagFromName functions.contrastColor=colors.
contrastColor functions.toColorSequence=colors.toColorSequence functions.
contrastText=colors.contrastText return functions end end function
__DARKLUA_BUNDLE_MODULES.Q():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES
.cache.Q if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.Q=v end
return v.c end end do local function __modImpl()return function(script,require)
local imageCache=require(script.Parent.imageCache)local variables=require(script
.Parent.variables)local image={}image.rewrites=imageCache.rewrites image.onBlock
=nil::((unknown)->())?image.pending={}::{[number]:{[Instance]:
PendingProperties__DARKLUA_TYPE_aT}}local settled=false local imageProperties:{[
string]:boolean}={Image=true,HoverImage=true,PressedImage=true}local function
idOf(value:unknown):number?if type(value)=='number'then return value elseif
type(value)=='string'then return tonumber(string.match(value,
'^rbxassetid://(%d+)$'))end return nil end local function blocked(value:unknown)
:string if image.onBlock then image.onBlock(value)end return''end function image
.preload(onSettled:PreloadCallback__DARKLUA_TYPE_aS?):(boolean,number)settled=
false return imageCache.preload(function(failed)settled=true table.clear(image.
pending)if onSettled then onSettled(failed)end end)end function image.avatar(
userId:number,onReady:AvatarCallback__DARKLUA_TYPE_aR?):string if not variables.
secureMode then return`rbxthumb://type=AvatarHeadShot&id={userId}&w=48&h=48`end
return imageCache.avatar(userId,onReady)end function image.assign(instance:
Instance,property:string,value:unknown)local target=instance::any if not
imageProperties[property]then target[property]=value return end target[property]
=image.resolve(value)if variables.secureMode and not settled then local id=idOf(
value)if id and not image.rewrites[id]then local waiting=image.pending[id]if not
waiting then waiting=setmetatable({},{__mode='k'})::any image.pending[id]=
waiting end local properties=waiting[instance]if not properties then properties=
{}waiting[instance]=properties end properties[property]=true end end end
imageCache.onCached=function(id:number)local waiting=image.pending[id]if not
waiting then return end local uri=image.rewrites[id]if uri then for instance,
properties in waiting do if instance.Parent then local target=instance::any for
property in properties do target[property]=uri end end end end image.pending[id]
=nil end function image.resolve(value:unknown):string if value==nil or value==0
or value==''then return''end if type(value)=='string'then if string.sub(value,1,
11)=='rbxasset://'then return value end if string.sub(value,1,11)=='rbxthumb://'
then return if variables.secureMode then blocked(value)else value end end local
id:number?=nil if type(value)=='number'then id=value elseif type(value)==
'string'then id=tonumber(string.match(value,'^rbxassetid://(%d+)$'))end local
rewrite=if id then image.rewrites[id]else nil if rewrite then return rewrite end
if variables.secureMode then return blocked(value)end if type(value)=='number'
then return'rbxassetid://'..value end if type(value)=='string'then return value
end return blocked(value)end return image end end function
__DARKLUA_BUNDLE_MODULES.R():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES
.cache.R if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.R=v end
return v.c end end do local function __modImpl()return function(script,require)
local filesystem=require(script.Parent.filesystem)local path=require(script.
Parent.path)local variables=require(script.Parent.variables)local constants=
require(script.Parent.constants)local imageCache={}local cacheRoot=variables.
fileSystemManager:getRootFolder()local cacheFolder=variables.fileSystemManager:
getAssetsFolder()local assetResolver=variables.assetResolver local assetBase=
[[https://raw.githubusercontent.com/SiriusSoftwareLtd/rayfield-gen2/main/assets/]]
local headshotPx=48 local thumbEndpoint=
[[https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=%d&size=%dx%d&format=Png&isCircular=false]]
local assetThumbEndpoint=
[[https://thumbnails.roblox.com/v1/assets?assetIds=%d&returnPolicy=PlaceHolder&size=420x420&format=Png&isCircular=false]]
local manifest:{[number]:string}={}for _,id in constants.icons do local iconId=
id::number manifest[iconId]=assetBase..tostring(iconId)..'.png'end for _,iconId
in{89158989026598,106574347714310,96658332486428,107298715019611,75430093335522,
98720693575785,90220359116333,124481067103905,122143737056625}do manifest[iconId
]='thumbnail:'..tostring(iconId)end local manifestSize=0 for _ in manifest do
manifestSize+=1 end imageCache.rewrites={}::RewriteMap__DARKLUA_TYPE_aU
imageCache.onCached=nil::OnCachedCallback__DARKLUA_TYPE_aY?local pngMagic=
'\137PNG\r\n\26\n'local function cacheFile(filePath:string,url:string):string?if
type(getfenv().getcustomasset)~='function'or typeof(filesystem.isfile)~=
'function'then return nil end if not filesystem.isfile(filePath)then pcall(
filesystem.ensureFolder,cacheRoot)pcall(filesystem.ensureFolder,cacheFolder)
local body=assetResolver:getAssetContentFromUrl(url,filePath,false)if not body
or string.sub(body,1,8)~=pngMagic then return nil end if not pcall(filesystem.
writefile,filePath,body)then return nil end end local ok,uri=pcall(getfenv().
getcustomasset,filePath)return if ok and type(uri)=='string'then uri else nil
end local function avatarPath(userId:number):string return path.join(cacheFolder
,'avatar_'..tostring(userId)..'.png')end local function decodeThumbnailUrl(body:
string):string?local decodeOk,parsed=pcall(function()return variables.
httpService:JSONDecode(body)end)if not decodeOk or type(parsed)~='table'then
return nil end local data=(parsed::ThumbnailResponse__DARKLUA_TYPE_a_).data if
type(data)~='table'then return nil end local entry=data[1]if type(entry)~=
'table'then return nil end local thumbnail=entry::
ThumbnailEntry__DARKLUA_TYPE_aZ if thumbnail.state=='Completed'and type(
thumbnail.imageUrl)=='string'then return thumbnail.imageUrl end return nil end
local function fetchAssetIcon(assetId:number,filePath:string):string?local
cdnUrl:string?=nil for attempt=1,3 do local body=assetResolver:
getAssetContentFromUrl(string.format(assetThumbEndpoint,assetId),
'asset-thumbnail:'..tostring(assetId),attempt>1)if body then cdnUrl=
decodeThumbnailUrl(body)if cdnUrl then break end end if attempt<3 then task.
wait(0.25)end end return if cdnUrl then cacheFile(filePath,cdnUrl)else nil end
local function fetchAvatar(userId:number):string?local cdnUrl:string?=nil for
attempt=1,4 do local body=assetResolver:getAssetContentFromUrl(string.format(
thumbEndpoint,userId,headshotPx,headshotPx),'avatar:'..tostring(userId),attempt>
1)if body then local imageUrl=decodeThumbnailUrl(body)if imageUrl then cdnUrl=
imageUrl break end end if attempt<4 then task.wait(0.3)end end if not cdnUrl
then return nil end return cacheFile(avatarPath(userId),cdnUrl)end local
pendingAvatars:{[number]:{AvatarCallback__DARKLUA_TYPE_aX}}={}local
failedAvatars:{[number]:boolean}={}function imageCache.preload(onSettled:
PreloadCallback__DARKLUA_TYPE_aW?):(boolean,number)local env=getfenv()if type(
env.getcustomasset)~='function'or typeof(filesystem.isfile)~='function'then if
onSettled then task.defer(onSettled,manifestSize)end return false,manifestSize
end local rewrites=imageCache.rewrites table.clear(rewrites)local function
settle()if not onSettled then return end local failed=0 for id in manifest do if
not rewrites[id]then failed+=1 end end onSettled(failed)end local pending,
missing=0,0 local spawning=true for id,url in manifest do local filePath=path.
join(cacheFolder,tostring(id)..'.png')local uri:string?=nil if filesystem.
isfile(filePath)then local ok,res=pcall(env.getcustomasset,filePath)uri=if ok
and type(res)=='string'then res else nil end if uri then rewrites[id]=uri else
missing+=1 pending+=1 task.spawn(function()local thumbnailId=tonumber(string.
match(url,'^thumbnail:(%d+)$'))local cached=if thumbnailId then fetchAssetIcon(
thumbnailId,filePath)else cacheFile(filePath,url)if cached then rewrites[id]=
cached if imageCache.onCached then pcall(imageCache.onCached,id)end end pending
-=1 if pending==0 and not spawning then settle()end end)end end spawning=false
if pending==0 then settle()end return missing==0,missing end function imageCache
.avatar(userId:unknown,onReady:AvatarCallback__DARKLUA_TYPE_aX?):string if type(
userId)~='number'then return''end if typeof(filesystem.isfile)~='function'then
return''end local filePath=avatarPath(userId)if filesystem.isfile(filePath)then
local ok,uri=pcall(getfenv().getcustomasset,filePath)if ok and type(uri)==
'string'then return uri end end if failedAvatars[userId]then return''end local
waiting=pendingAvatars[userId]if waiting then if onReady then table.insert(
waiting,onReady)end return''end if onReady then pendingAvatars[userId]={onReady}
task.spawn(function()local uri=fetchAvatar(userId)local callbacks=pendingAvatars
[userId]pendingAvatars[userId]=nil if not uri then failedAvatars[userId]=true
return end if callbacks then for _,callback in callbacks do pcall(callback,uri)
end end end)end return''end return imageCache end end function
__DARKLUA_BUNDLE_MODULES.S():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES
.cache.S if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.S=v end
return v.c end end do local function __modImpl()return function(script,require)
local variables=require(script.Parent.variables)local log=require(script.Parent.
log)local locale={}locale.strings={}::TranslationTables__DARKLUA_TYPE_a2 locale.
current='en'locale.translator=nil::Translator__DARKLUA_TYPE_a1?local tokenTag={}
local function languageOf(id:string):string return string.match(id,'^(%a+)')or
id end function locale.t(source:unknown):unknown if type(source)~='string'or
source==''then return source end return{[tokenTag]=source}end function locale.
isToken(value:unknown):boolean return type(value)=='table'and type((value::{[any
]:unknown})[tokenTag])=='string'end function locale.sourceOf(token:
LocaleToken__DARKLUA_TYPE_a0):string return token[tokenTag]end function locale.
resolve(source:unknown):any if type(source)~='string'then return source end if
locale.translator then local ok,translated=pcall(locale.translator,source,locale
.current)if ok and type(translated)=='string'and translated~=''then return
translated end end local exact=locale.strings[locale.current]if exact and exact[
source]then return exact[source]end local language=locale.strings[languageOf(
locale.current)]if language and language[source]then return language[source]end
return source end function locale.register(tables:
TranslationTables__DARKLUA_TYPE_a2?)if type(tables)~='table'then return end for
id,entries in tables do if type(id)=='string'and type(entries)=='table'then id=
string.lower(id)local target=locale.strings[id]if not target then target={}
locale.strings[id]=target end for source,translated in entries do if type(source
)=='string'and type(translated)=='string'then target[source]=translated else log
.warn(`Rayfield: skipping a '{id}' translation, entries must be string to string.`
)end end end end end function locale.setActive(localeId:string?):string locale.
current=if type(localeId)=='string'and localeId~=''then string.lower(localeId)
else'en'return locale.current end function locale.detect():string local id=
variables.localizationService.RobloxLocaleId if type(id)=='string'and id~=''then
return string.lower(id)end return'en'end return locale end end function
__DARKLUA_BUNDLE_MODULES.T():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES
.cache.T if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.T=v end
return v.c end end do local function __modImpl()return function(script,require)
local runtime=require(script.Parent.runtime)local log={}local function
defaultSecureModeSource():boolean return runtime.secureMode end local
secureModeSource:SuppressPredicate__DARKLUA_TYPE_a3=defaultSecureModeSource
local suppressPredicate:SuppressPredicate__DARKLUA_TYPE_a3?=nil function log.
setSecureModeSource(source:SuppressPredicate__DARKLUA_TYPE_a3?)secureModeSource=
if type(source)=='function'then source else defaultSecureModeSource end function
log.setSuppressPredicate(predicate:SuppressPredicate__DARKLUA_TYPE_a3?)
suppressPredicate=if type(predicate)=='function'then predicate else nil end
local function shouldSuppress():boolean if suppressPredicate and
suppressPredicate()then return true end return secureModeSource()end function
log.warn(...)if shouldSuppress()then return end warn(...)end function log.print(
...)if shouldSuppress()then return end print(...)end return log end end function
__DARKLUA_BUNDLE_MODULES.U():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES
.cache.U if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.U=v end
return v.c end end do local function __modImpl()return function(script,require)
local function moveable<T>(class:T):T local target=class::any function target:
MoveTo(index:number)self.tab:_moveElement(self,index)end function target:
MoveToTop()self.tab:_moveElement(self,1)end function target:MoveToBottom()self.
tab:_moveElement(self,#self.tab.elements)end function target:MoveUp()local idx=
table.find(self.tab.elements,self)if idx then self.tab:_moveElement(self,idx-1)
end end function target:MoveDown()local idx=table.find(self.tab.elements,self)if
idx then self.tab:_moveElement(self,idx+1)end end return class end return
moveable end end function __DARKLUA_BUNDLE_MODULES.V():typeof(__modImpl())local
v=__DARKLUA_BUNDLE_MODULES.cache.V if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.V=v end return v.c end end do local function
__modImpl()return function(script,require)local network={}network.__index=
network function network.getRequestFn(env:any?):RequestFn__DARKLUA_TYPE_a4?env=
env or getfenv()return env.request or env.http_request or(env.http and env.http.
request)or(env.syn and env.syn.request)or(env.fluxus and env.fluxus.request)end
return network end end function __DARKLUA_BUNDLE_MODULES.W():typeof(__modImpl())
local v=__DARKLUA_BUNDLE_MODULES.cache.W if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.W=v end return v.c end end do local function
__modImpl()return function(script,require)local variables=require(script.Parent.
variables)local TextService=variables.textService local odometer={}odometer.
__index=odometer local stripLength=20 local function measure(font,size,text)
local params=Instance.new('GetTextBoundsParams')params.Text=text params.Font=
font params.Size=size params.Width=math.huge local ok,bounds=pcall(TextService.
GetTextBoundsAsync,TextService,params)return if ok then bounds else Vector2.new(
size*0.6,size)end local metricsCache={}local function digitMetrics(font,size)
local key=tostring(font.Family)..'|'..tostring(font.Weight)..'|'..tostring(font.
Style)..'|'..tostring(size)local cached=metricsCache[key]if cached then return
cached end local advance,maxWidth={},0 for d=0,9 do local w=math.ceil(measure(
font,size,tostring(d)).X)advance[d]=w if w>maxWidth then maxWidth=w end end
cached={advance=advance,maxWidth=maxWidth}metricsCache[key]=cached return cached
end function odometer.new(window,container,opts)opts=opts or{}local self=
setmetatable({window=window,container=container,textSize=opts.textSize or 16,
transparency=opts.transparency or 1,duration=opts.duration or 0.55,slots={},
length=0},odometer)self.roll=TweenInfo.new(self.duration,Enum.EasingStyle.Quint,
Enum.EasingDirection.Out)self.zIndex=math.max(container.ZIndex+1,6)self.height=
math.ceil(self.textSize)local metrics=digitMetrics(window.theme.Font,self.
textSize)self.advance=metrics.advance self.maxWidth=metrics.maxWidth window:
Create('UIListLayout',{FillDirection=Enum.FillDirection.Horizontal,
VerticalAlignment=Enum.VerticalAlignment.Center,HorizontalAlignment=opts.
alignment or Enum.HorizontalAlignment.Left,SortOrder=Enum.SortOrder.LayoutOrder,
Padding=UDim.new(0,0),Parent=container})return self end function odometer:_reel(
index)local slot=self.slots[index]if slot.reel then return slot.reel end local
cell=self.window:Create('Frame',{Name='Reel',Size=UDim2.fromOffset(self.maxWidth
,self.height),BackgroundTransparency=1,BorderSizePixel=0,ClipsDescendants=true,
ZIndex=self.zIndex,Parent=self.container})local strip=self.window:Create('Frame'
,{Size=UDim2.fromOffset(self.maxWidth,self.height),AnchorPoint=Vector2.new(0.5,0
),Position=UDim2.new(0.5,0,0,0),BackgroundTransparency=1,BorderSizePixel=0,
ZIndex=self.zIndex,Parent=cell})for i=0,stripLength-1 do self.window:Create(
'TextLabel',{Text=tostring(i%10),Position=UDim2.fromOffset(0,i*self.height),Size
=UDim2.fromOffset(self.maxWidth,self.height),BackgroundTransparency=1,
BorderSizePixel=0,TextSize=self.textSize,TextXAlignment=Enum.TextXAlignment.
Center,TextYAlignment=Enum.TextYAlignment.Center,TextTransparency=self.
transparency,ZIndex=self.zIndex,Parent=strip},{TextColor3='ContentColor',
FontFace='Font'})end local reel={cell=cell,strip=strip,digit=0,target=0,
stripTween=nil,sizeTween=nil}slot.reel=reel return reel end function odometer:
_static(index)local slot=self.slots[index]if slot.static then return slot.static
end local label=self.window:Create('TextLabel',{Name='Static',Size=UDim2.
fromOffset(0,self.height),AutomaticSize=Enum.AutomaticSize.X,
BackgroundTransparency=1,BorderSizePixel=0,TextSize=self.textSize,TextXAlignment
=Enum.TextXAlignment.Center,TextYAlignment=Enum.TextYAlignment.Center,
TextTransparency=self.transparency,ZIndex=self.zIndex,Parent=self.container},{
TextColor3='ContentColor',FontFace='Font'})slot.static=label return label end
local function stopReel(reel)if reel.stripTween then reel.stripTween:Cancel()
reel.stripTween=nil end if reel.sizeTween then reel.sizeTween:Cancel()reel.
sizeTween=nil end end function odometer:_reelSnap(reel,digit)stopReel(reel)reel.
cell.Size=UDim2.fromOffset(self.advance[digit],self.height)reel.strip.Position=
UDim2.new(0.5,0,0,-digit*self.height)reel.digit=digit reel.target=digit end
function odometer:_reelRoll(reel,digit,up)if reel.stripTween or reel.sizeTween
then self:_reelSnap(reel,reel.target)end local a=reel.digit if a==digit then
return end local startIndex,targetIndex if up then startIndex=a targetIndex=a+(
digit-a)%10 else startIndex=a+10 targetIndex=startIndex-(a-digit)%10 end reel.
strip.Position=UDim2.new(0.5,0,0,-startIndex*self.height)reel.target=digit local
stripTween=variables.tweenService:Create(reel.strip,self.roll,{Position=UDim2.
new(0.5,0,0,-targetIndex*self.height)})local sizeTween=variables.tweenService:
Create(reel.cell,self.roll,{Size=UDim2.fromOffset(self.advance[digit],self.
height)})reel.stripTween=stripTween reel.sizeTween=sizeTween stripTween.
Completed:Connect(function(state)if state==Enum.PlaybackState.Completed and reel
.stripTween==stripTween then self:_reelSnap(reel,digit)end end)stripTween:Play()
sizeTween:Play()reel.digit=digit end function odometer:_putDigit(index,digit,up,
animate)local reel=self:_reel(index)local wasHidden=not reel.cell.Visible reel.
cell.Visible=true reel.cell.LayoutOrder=-index if self.slots[index].static then
self.slots[index].static.Visible=false end if animate and not wasHidden then
self:_reelRoll(reel,digit,up)else self:_reelSnap(reel,digit)end end function
odometer:_putStatic(index,char)local label=self:_static(index)if not label.
Visible then label.TextTransparency=self.transparency end label.Text=char label.
Visible=true label.LayoutOrder=-index if self.slots[index].reel then self.slots[
index].reel.cell.Visible=false end end function odometer:_hide(index)local slot=
self.slots[index]if not slot then return end if slot.reel then slot.reel.cell.
Visible=false end if slot.static then slot.static.Visible=false end end function
odometer:_render(text,animate,up)text=tostring(text)if text==self._lastText then
return end self._lastText=text local chars={}for _,code in utf8.codes(text)do
table.insert(chars,utf8.char(code))end local n=#chars for i=0,math.max(n,self.
length)-1 do self.slots[i]=self.slots[i]or{}if i<n then local char=chars[n-i]if
char:match('%d')then self:_putDigit(i,tonumber(char),up,animate)else self:
_putStatic(i,char)end else self:_hide(i)end end self.length=n end function
odometer:to(text,up)self:_render(text,true,up)end function odometer:snap(text)
self:_render(text,false,true)end function odometer:reveal(target,animate,info)
self.transparency=target for _,slot in self.slots do if slot.static and slot.
static.Visible then self.window:_reveal(slot.static,{TextTransparency=target},
animate,info)end if slot.reel then for _,lbl in slot.reel.strip:GetChildren()do
if lbl:IsA('TextLabel')then self.window:_reveal(lbl,{TextTransparency=target},
animate,info)end end end end end return odometer end end function
__DARKLUA_BUNDLE_MODULES.X():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES
.cache.X if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.X=v end
return v.c end end do local function __modImpl()return function(script,require)
local function assignOrder(element:OrderedElement__DARKLUA_TYPE_a5,order:number)
element.main.LayoutOrder=order if element.descriptor then element.descriptor.
main.LayoutOrder=order+1 end end return assignOrder end end function
__DARKLUA_BUNDLE_MODULES.Y():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES
.cache.Y if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.Y=v end
return v.c end end do local function __modImpl()return function(script,require)
local path={}function path.join(basePath:string,childPath:string?):string if not
childPath or childPath==''then return basePath end return basePath..'/'..
childPath end local function stripTraversal(text:string):string local previous
repeat previous=text text=text:gsub('%.%.','')until text==previous return text
end function path.sanitizeFolder(value:unknown):string local text=tostring(value
):gsub('\\','/'):gsub('[:<>"|?*%c]','')text=stripTraversal(text):gsub('/+','/')
return(text:gsub('^/+',''))end function path.sanitizeFile(value:unknown):string
local text=tostring(value):gsub('[/\\]',''):gsub('[:<>"|?*%c]','')return
stripTraversal(text)end function path.basename(value:unknown):string return
tostring(value):match('[^/\\]+$')or tostring(value)end function path.
stripExtension(value:unknown,extension:string?):string if extension and
extension~=''then local text=tostring(value)if text:sub(-#extension)==extension
then return text:sub(1,-#extension-1)end return text end local base=tostring(
value):match('^(.+)%.%w+$')return base or tostring(value)end return path end end
function __DARKLUA_BUNDLE_MODULES.Z():typeof(__modImpl())local v=
__DARKLUA_BUNDLE_MODULES.cache.Z if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.Z=v end return v.c end end do local function
__modImpl()return function(script,require)local persistence={}local config=
require(script.Parent.persistenceConfig)local settings=require(script.Parent.
persistenceSettings)persistence.getPath=config.getPath persistence.save=config.
save persistence.load=config.load persistence.applyTo=config.applyTo persistence
.list=config.list persistence.delete=config.delete persistence.getSettingsPath=
settings.getSettingsPath persistence.saveSettings=settings.saveSettings
persistence.loadSettings=settings.loadSettings return persistence end end
function __DARKLUA_BUNDLE_MODULES._():typeof(__modImpl())local v=
__DARKLUA_BUNDLE_MODULES.cache._ if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache._=v end return v.c end end do local function
__modImpl()return function(script,require)local variables=require(script.Parent.
variables)local filesystem=require(script.Parent.filesystem)local log=require(
script.Parent.log)local path=require(script.Parent.path)local paths=require(
script.Parent.persistencePaths)local atomic=require(script.Parent.
persistenceWrite)local persistenceConfig={}function persistenceConfig.getPath(
window:ConfigWindow__DARKLUA_TYPE_a7,name:unknown?):(string?,string?)return
paths.getConfigPath(window,name)end function persistenceConfig.save(window:
ConfigWindow__DARKLUA_TYPE_a7,name:unknown?):boolean local dir,fullPath=
persistenceConfig.getPath(window,name)if not dir or not fullPath then log.warn(
"Rayfield: configuration name '"..tostring(name).."' has no usable characters")
return false end if typeof(filesystem.writefile)~='function'then return false
end local flags:{[string]:unknown}={}for flag,control in window.controls do
local ok,value=pcall(function()local serialize=control._serialize if serialize
then return serialize(control)end return control.value end)if ok then flags[flag
]=value else log.warn("Rayfield: Failed to serialize flag '"..tostring(flag)..
"' - "..tostring(value))end end local loadedConfig=window._loadedConfig if
loadedConfig and window._loadedConfigPath==fullPath then for flag,value in
loadedConfig do if window.controls[flag]==nil then flags[flag]=value end end end
local encodeSuccess,encoded=pcall(variables.httpService.JSONEncode,variables.
httpService,flags)if not encodeSuccess then log.warn(
'Rayfield: Failed to encode configuration - '..tostring(encoded))return false
end local ok,err=pcall(function()atomic.write(dir,fullPath,encoded)end)if not ok
then log.warn('Rayfield: Failed to save configuration - '..tostring(err))return
false end if window._loadedConfigPath==nil or window._loadedConfigPath==fullPath
then window._loadedConfig=flags window._loadedConfigPath=fullPath end return
true end local function decodeFile(fullPath:string):({[string]:unknown}?,string?
)if not filesystem.isfile(fullPath)then return nil,nil end local readOk,contents
=pcall(filesystem.readfile,fullPath)if not readOk or type(contents)~='string'
then log.warn('Rayfield: Failed to read configuration file')return nil,nil end
local decodeOk,parsed=pcall(variables.httpService.JSONDecode,variables.
httpService,contents)if not decodeOk or type(parsed)~='table'then return nil,
contents end return parsed::{[string]:unknown},contents end local function
backupPathFor(fullPath:string):string local stem=path.stripExtension(fullPath,
'.rfld')local candidate=stem..' (Incorrect Format).rfld'local index=2 while
index<=100 and filesystem.isfile(candidate)do candidate=stem..
' (Incorrect Format '..index..').rfld'index+=1 end return candidate end function
persistenceConfig.load(window:ConfigWindow__DARKLUA_TYPE_a7,name:unknown?):
boolean local dir,fullPath=persistenceConfig.getPath(window,name)if not dir or
not fullPath then log.warn("Rayfield: configuration name '"..tostring(name)..
"' has no usable characters")return false end if typeof(filesystem.isfile)~=
'function'then return false end local parsedFlags,raw=decodeFile(fullPath)if not
parsedFlags and filesystem.isfile(fullPath)then local parked,parkedRaw=
decodeFile(atomic.tempPathFor(fullPath))if parked and parkedRaw then parsedFlags
=parked pcall(atomic.write,dir,fullPath,parkedRaw)end end if not parsedFlags
then if raw then log.warn(
[[Rayfield: Configuration file has an invalid format, backing up and resetting]]
)local backupPath=backupPathFor(fullPath)pcall(function()filesystem.ensureDir(
dir)filesystem.writefile(backupPath,raw)filesystem.delfile(fullPath)end)end
return false end local flags=parsedFlags::{[string]:unknown}local wasLoading=
window._loading window._loading=true local applyOk,applyErr=pcall(function()for
flag,control in window.controls do persistenceConfig.applyTo(control,flags[flag]
)end end)window._loading=wasLoading if not applyOk then log.warn(
'Rayfield: Failed to apply configuration - '..tostring(applyErr))end window.
_loadedConfig=flags window._loadedConfigPath=fullPath return true end function
persistenceConfig.applyTo(control:PersistedControl__DARKLUA_TYPE_a6,value:
unknown)if value==nil and not control._canBeNil then return end local ok,err=
pcall(function()local deserialize=control._deserialize if deserialize then
deserialize(control,value)else control:Set(value)end end)if not ok then log.
warn("Rayfield: Failed to restore flag '"..tostring(control.flag).."' - "..
tostring(err))end end function persistenceConfig.list(window:
ConfigWindow__DARKLUA_TYPE_a7):{string}local dir=persistenceConfig.getPath(
window)local names:{string}={}if not dir then return names end local ok,files=
pcall(filesystem.listfiles,dir)if not ok or type(files)~='table'then return
names end for _,filePath in files do local file=path.basename(filePath)if file:
sub(-5)=='.rfld'then local base=path.stripExtension(file,'.rfld')if base and
base~=''and not base:find(' %(Incorrect Format[^%)]*%)$')then table.insert(names
,base)end end end table.sort(names)return names end function persistenceConfig.
delete(window:ConfigWindow__DARKLUA_TYPE_a7,name:unknown):boolean if type(name)
~='string'or name==''then return false end local _,fullPath=persistenceConfig.
getPath(window,name)if not fullPath then return false end if typeof(filesystem.
isfile)~='function'or not filesystem.isfile(fullPath)then return false end
pcall(filesystem.delfile,atomic.tempPathFor(fullPath))return(pcall(filesystem.
delfile,fullPath))end return persistenceConfig end end function
__DARKLUA_BUNDLE_MODULES.aa():typeof(__modImpl())local v=
__DARKLUA_BUNDLE_MODULES.cache.aa if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.aa=v end return v.c end end do local function
__modImpl()return function(script,require)local variables=require(script.Parent.
variables)local path=require(script.Parent.path)local paths={}function paths.
getConfigPath(window:ConfigWindow__DARKLUA_TYPE_a8,name:unknown?):(string?,
string?)local dir=variables.fileSystemManager:getPath('Configurations')if window
.configuration.customFolder then dir=path.join(dir,path.sanitizeFolder(window.
configuration.customFolder))end if name~=nil then local safe=path.sanitizeFile(
name)if safe==''then return nil,nil end return dir,path.join(dir,safe..'.rfld')
end local safe=path.sanitizeFile(window.configuration.fileName or window.name)if
safe==''then safe=path.sanitizeFile(window.name)end if safe==''then safe=
'Configuration'end return dir,path.join(dir,safe..'.rfld')end function paths.
getSettingsPath(window:{name:string}?):(string,string)local dir=variables.
fileSystemManager:getPath('Settings')local name=window and path.sanitizeFile(
window.name)or'pulse'return dir,path.join(dir,(name~=''and name or'pulse')..
'.rfld')end return paths end end function __DARKLUA_BUNDLE_MODULES.ab():typeof(
__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.ab if not v then v={c=
__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.ab=v end return v.c end end do
local function __modImpl()return function(script,require)local variables=
require(script.Parent.variables)local filesystem=require(script.Parent.
filesystem)local paths=require(script.Parent.persistencePaths)local atomic=
require(script.Parent.persistenceWrite)local enums=require(script.Parent.enums)
local persistenceSettings={}function persistenceSettings.getSettingsPath(window:
SettingsWindow__DARKLUA_TYPE_a9):(string,string)return paths.getSettingsPath(
window)end function persistenceSettings.saveSettings(window:
SettingsWindow__DARKLUA_TYPE_a9):boolean local dir,fullPath=persistenceSettings.
getSettingsPath(window)local data:{[string]:unknown}={toggleKeybind={tostring(
window.settings.toggleKeybind.EnumType),window.settings.toggleKeybind.Value}::{
unknown},mouseOverride=window.settings.mouseOverride,keepOnScreen=window.
settings.keepOnScreen,welcomeToast=window.settings.welcomeToast,haptics=window.
settings.haptics,autoLoadConfig=window.settings.autoLoadConfig,selectedConfig=
window.settings.selectedConfig}local ok,encoded=pcall(variables.httpService.
JSONEncode,variables.httpService,data)if not ok then return false end local
writeOk=pcall(atomic.write,dir,fullPath,encoded)if not writeOk then return false
end return true end local function decodeFile(fullPath:string):(
DecodedSettings__DARKLUA_TYPE_ba?,string?)local fileExists=false pcall(function(
)fileExists=filesystem.isfile(fullPath)end)if not fileExists then return nil,nil
end local readOk,contents=pcall(filesystem.readfile,fullPath)if not readOk or
type(contents)~='string'then return nil,nil end local decodeOk,parsed=pcall(
variables.httpService.JSONDecode,variables.httpService,contents)if not decodeOk
or type(parsed)~='table'then return nil,contents end return parsed::
DecodedSettings__DARKLUA_TYPE_ba,contents end function persistenceSettings.
loadSettings(window:SettingsWindow__DARKLUA_TYPE_a9):boolean local dir,fullPath=
persistenceSettings.getSettingsPath(window)local settings=decodeFile(fullPath)if
not settings then local _,legacyPath=paths.getSettingsPath(nil)settings=
decodeFile(legacyPath)end if not settings then local parked,parkedRaw=
decodeFile(atomic.tempPathFor(fullPath))if parked and parkedRaw then settings=
parked pcall(atomic.write,dir,fullPath,parkedRaw)end end if not settings then
return false end if settings.toggleKeybind then pcall(function()local enumName=
tostring(settings.toggleKeybind[1]):gsub('^Enum%.','')local enumType=(Enum::any)
[enumName]if enumType then local enumItem=enums.itemFromValue(enumType,settings.
toggleKeybind[2])if enumItem then window.settings.toggleKeybind=enumItem end end
end)end if type(settings.mouseOverride)=='boolean'then window.settings.
mouseOverride=settings.mouseOverride end if type(settings.keepOnScreen)==
'boolean'then window.settings.keepOnScreen=settings.keepOnScreen end if type(
settings.welcomeToast)=='boolean'then window.settings.welcomeToast=settings.
welcomeToast end if type(settings.haptics)=='boolean'then window.settings.
haptics=settings.haptics end if type(settings.autoLoadConfig)=='boolean'then
window.settings.autoLoadConfig=settings.autoLoadConfig end if type(settings.
selectedConfig)=='string'and settings.selectedConfig~=''then window.settings.
selectedConfig=settings.selectedConfig end return true end return
persistenceSettings end end function __DARKLUA_BUNDLE_MODULES.ac():typeof(
__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.ac if not v then v={c=
__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.ac=v end return v.c end end do
local function __modImpl()return function(script,require)local filesystem=
require(script.Parent.filesystem)local persistenceWrite={}local parkedExtension=
'.saving'function persistenceWrite.tempPathFor(fullPath:string):string return
fullPath..parkedExtension end function persistenceWrite.write(dir:string,
fullPath:string,contents:string)local tempPath=persistenceWrite.tempPathFor(
fullPath)filesystem.ensureDir(dir)filesystem.writefile(tempPath,contents)if
filesystem.readfile(tempPath)~=contents then error(
'parked copy did not write cleanly')end filesystem.writefile(fullPath,contents)
pcall(filesystem.delfile,tempPath)end return persistenceWrite end end function
__DARKLUA_BUNDLE_MODULES.ad():typeof(__modImpl())local v=
__DARKLUA_BUNDLE_MODULES.cache.ad if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.ad=v end return v.c end end do local function
__modImpl()return function(script,require)local services=require(script.Parent.
services)local runtime={}::RuntimeState__DARKLUA_TYPE_bb runtime.secureMode=(
function()if typeof(getgenv)~='function'then return false end local ok,val=
pcall(function()return getgenv().RAYFIELD_SECURE end)return ok and val==true end
)()runtime.coreGui=services.getService('CoreGui')::CoreGui runtime.workspace=
services.getService('Workspace')::Workspace runtime.runService=services.
getService('RunService')::RunService runtime.userInputService=services.
getService('UserInputService')::UserInputService runtime.guiService=services.
getService('GuiService')::GuiService runtime.localPlayer=(services.getService(
'Players')::Players).LocalPlayer runtime.tweenService=services.getService(
'TweenService')::TweenService runtime.httpService=services.getService(
'HttpService')::HttpService runtime.textService=services.getService(
'TextService')::TextService runtime.replicatedStorage=services.getService(
'ReplicatedStorage')::ReplicatedStorage runtime.localizationService=services.
getService('LocalizationService')::LocalizationService runtime.guiContainer=(
function():Instance if runtime.runService:IsStudio()then local player=runtime.
localPlayer if player then return player.PlayerGui end return runtime.coreGui
end if typeof(gethui)=='function'then local ok,container=pcall(gethui)if ok and
container then return container end end return runtime.coreGui end)()return
runtime end end function __DARKLUA_BUNDLE_MODULES.ae():typeof(__modImpl())local
v=__DARKLUA_BUNDLE_MODULES.cache.ae if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.ae=v end return v.c end end do local function
__modImpl()return function(script,require)local services={}function services.
getService(name)local service=game:GetService(name)return if cloneref then
cloneref(service)else service end return services end end function
__DARKLUA_BUNDLE_MODULES.af():typeof(__modImpl())local v=
__DARKLUA_BUNDLE_MODULES.cache.af if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.af=v end return v.c end end do local function
__modImpl()return function(script,require)local variables=require(script.Parent.
variables)local textService=variables.textService local textMetrics={}local
widthCache:{[string]:number}={}local widthCacheCount=0 local widthCacheCap=1024
local function getTextBounds(params:GetTextBoundsParams):unknown local ok,bounds
=pcall(function()return textService:GetTextBoundsAsync(params)end)return if ok
then bounds else nil end local function boundAxis(bounds:unknown,axis:'X'|'Y'):
number?if typeof(bounds)=='Vector2'then return if axis=='X'then bounds.X else
bounds.Y end if type(bounds)=='table'and type((bounds::any)[axis])=='number'then
return(bounds::any)[axis]end return nil end function textMetrics.textWidth(font:
Font,size:number,text:any):number text=tostring(text)local key=tostring(font.
Family)..'|'..tostring(font.Weight)..'|'..tostring(font.Style)..'|'..tostring(
size)..'|'..text local cached=widthCache[key]if cached then return cached end
local params=Instance.new('GetTextBoundsParams')params.Text=text params.Font=
font params.Size=size params.Width=math.huge local measuredWidth=boundAxis(
getTextBounds(params),'X')if not measuredWidth then local length=utf8.len(text)
or#text return math.ceil(size*0.55*length)end local width=math.ceil(
measuredWidth)if widthCacheCount>=widthCacheCap then widthCache={}
widthCacheCount=0 end widthCache[key]=width widthCacheCount+=1 return width end
function textMetrics.textHeight(font:Font,size:number,text:any,width:number):
number local params=Instance.new('GetTextBoundsParams')params.Text=tostring(text
)params.Font=font params.Size=size params.Width=width local measuredHeight=
boundAxis(getTextBounds(params),'Y')return if measuredHeight then math.ceil(
measuredHeight)else size end return textMetrics end end function
__DARKLUA_BUNDLE_MODULES.ag():typeof(__modImpl())local v=
__DARKLUA_BUNDLE_MODULES.cache.ag if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.ag=v end return v.c end end do local function
__modImpl()return function(script,require)local runtime=require(script.Parent.
runtime)local constants=require(script.Parent.constants)local log=require(script
.Parent.log)local fileSystemManager=require(script.Parent.filesystemManager)
local assetResolver=require(script.Parent.assetResolver)local fontManager=
require(script.Parent.fontManager)local variables=table.clone(runtime)::
VariablesState__DARKLUA_TYPE_bg log.setSecureModeSource(function()return
variables.secureMode end)variables.fallbackFont=Font.fromEnum(Enum.Font.
BuilderSans)variables.fileSystemManager=fileSystemManager.new()variables.
assetResolver=assetResolver.new(true,assetResolver.Enum.AssetDownloadUrl.
RoProxyDownloadUrl)::AssetResolver__DARKLUA_TYPE_be variables.fontManager=
fontManager.new(variables.fileSystemManager:getAssetsFolder('fonts'),false,true,
assetResolver.Enum.AssetDownloadUrl.RoProxyDownloadUrl,{saveToDisk=true,
skipCache=false,fallbackFont=variables.fallbackFont})::
FontManager__DARKLUA_TYPE_bf function variables.setFallbackFont(font:Enum.Font|
Font)if typeof(font)=='EnumItem'then font=Font.fromEnum(font)end if typeof(font)
=='Font'then variables.fallbackFont=font variables.fontManager.defaultOptions.
fallbackFont=font end end function variables.brandFont(weight:Enum.FontWeight?):
Font if variables.secureMode then return Font.new(variables.fallbackFont.Family,
weight)end return Font.new(constants.fontAsset,weight)end return variables end
end function __DARKLUA_BUNDLE_MODULES.ah():typeof(__modImpl())local v=
__DARKLUA_BUNDLE_MODULES.cache.ah if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.ah=v end return v.c end end do local function
__modImpl()return function(script,require)local windowSizing={}local defaultSize
=Vector2.new(750,515)local minSize=Vector2.new(440,330)local maxOccupancyX,
maxOccupancyY=0.92,0.86 local marginFloorX,marginFloorY=28,32 local
widthCompensation=96 local maxAspectRatio=2.1 local minPlausibleViewport=200
windowSizing.defaultSize=defaultSize windowSizing.minSize=minSize windowSizing.
chromeHeight=106 function windowSizing.pageHeight(windowHeight:number?):number
local height=if windowHeight and windowHeight>0 then windowHeight else minSize.Y
return math.max(height-windowSizing.chromeHeight,0)end local function
heightDeficit(height:number):number return math.clamp((defaultSize.Y-height)/(
defaultSize.Y-minSize.Y),0,1)end function windowSizing.fit(viewport:Vector2?):
UDim2 if not viewport or viewport.X<minPlausibleViewport or viewport.Y<
minPlausibleViewport then return UDim2.fromOffset(defaultSize.X,defaultSize.Y)
end local availableX=math.min(viewport.X*maxOccupancyX,viewport.X-marginFloorX)
local availableY=math.min(viewport.Y*maxOccupancyY,viewport.Y-marginFloorY)local
height=math.floor(math.min(math.clamp(availableY,minSize.Y,defaultSize.Y),
availableY))local deficit=heightDeficit(height)local width=math.max(defaultSize.
X+widthCompensation*deficit,minSize.X)return UDim2.fromOffset(math.floor(math.
min(width,availableX,height*maxAspectRatio)),height)end return windowSizing end
end function __DARKLUA_BUNDLE_MODULES.ai():typeof(__modImpl())local v=
__DARKLUA_BUNDLE_MODULES.cache.ai if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.ai=v end return v.c end end do local function
__modImpl()local __modules,__nodes,__state,__cache={},{},{},{}local
__nodeMethods={}function __nodeMethods:FindFirstChild(name)return rawget(self,
name)end local __nodeMeta={__index=__nodeMethods}local function __makeNode(name,
parent,id,className)local node=setmetatable({Name=name,Parent=parent,ClassName=
className,__id=id},__nodeMeta)if parent then rawset(parent,name,node)end if id
then __nodes[id]=node end return node end local __root=__makeNode('Pulse',nil,
'init','ModuleScript')local __components=__makeNode('components',__root,nil,
'Folder')local __themes=__makeNode('themes',__root,nil,'Folder')local __utility=
__makeNode('utility',__root,nil,'Folder')__makeNode('action',__components,
'components/action','ModuleScript')__makeNode('button',__components,
'components/button','ModuleScript')__makeNode('chrome',__components,
'components/chrome','ModuleScript')__makeNode('colorpicker',__components,
'components/colorpicker','ModuleScript')__makeNode('descriptor',__components,
'components/descriptor','ModuleScript')__makeNode('divider',__components,
'components/divider','ModuleScript')__makeNode('drag',__components,
'components/drag','ModuleScript')__makeNode('dropdown',__components,
'components/dropdown','ModuleScript')__makeNode('esppreview',__components,
'components/esppreview','ModuleScript')__makeNode('group',__components,
'components/group','ModuleScript')__makeNode('input',__components,
'components/input','ModuleScript')__makeNode('keybind',__components,
'components/keybind','ModuleScript')__makeNode('notification',__components,
'components/notification','ModuleScript')__makeNode('popup',__components,
'components/popup','ModuleScript')__makeNode('search',__components,
'components/search','ModuleScript')__makeNode('section',__components,
'components/section','ModuleScript')__makeNode('slider',__components,
'components/slider','ModuleScript')__makeNode('stat',__components,
'components/stat','ModuleScript')__makeNode('tab',__components,'components/tab',
'ModuleScript')__makeNode('tag',__components,'components/tag','ModuleScript')
__makeNode('text',__components,'components/text','ModuleScript')__makeNode(
'toast',__components,'components/toast','ModuleScript')__makeNode('toggle',
__components,'components/toggle','ModuleScript')__makeNode('window',__components
,'components/window','ModuleScript')__makeNode('amethyst',__themes,
'themes/amethyst','ModuleScript')__makeNode('cobalt',__themes,'themes/cobalt',
'ModuleScript')__makeNode('default',__themes,'themes/default','ModuleScript')
__makeNode('ember',__themes,'themes/ember','ModuleScript')__makeNode('frost',
__themes,'themes/frost','ModuleScript')__makeNode('rose',__themes,'themes/rose',
'ModuleScript')__makeNode('types',__root,'types','ModuleScript')__makeNode(
'HapticEngine',__utility,'utility/HapticEngine','ModuleScript')__makeNode(
'assetResolver',__utility,'utility/assetResolver','ModuleScript')__makeNode(
'colors',__utility,'utility/colors','ModuleScript')__makeNode('constants',
__utility,'utility/constants','ModuleScript')__makeNode('enums',__utility,
'utility/enums','ModuleScript')__makeNode('filesystem',__utility,
'utility/filesystem','ModuleScript')__makeNode('filesystemManager',__utility,
'utility/filesystemManager','ModuleScript')__makeNode('flagNames',__utility,
'utility/flagNames','ModuleScript')__makeNode('fontManager',__utility,
'utility/fontManager','ModuleScript')__makeNode('functions',__utility,
'utility/functions','ModuleScript')__makeNode('image',__utility,'utility/image',
'ModuleScript')__makeNode('imageCache',__utility,'utility/imageCache',
'ModuleScript')__makeNode('locale',__utility,'utility/locale','ModuleScript')
__makeNode('log',__utility,'utility/log','ModuleScript')__makeNode('moveable',
__utility,'utility/moveable','ModuleScript')__makeNode('network',__utility,
'utility/network','ModuleScript')__makeNode('odometer',__utility,
'utility/odometer','ModuleScript')__makeNode('ordering',__utility,
'utility/ordering','ModuleScript')__makeNode('path',__utility,'utility/path',
'ModuleScript')__makeNode('persistence',__utility,'utility/persistence',
'ModuleScript')__makeNode('persistenceConfig',__utility,
'utility/persistenceConfig','ModuleScript')__makeNode('persistencePaths',
__utility,'utility/persistencePaths','ModuleScript')__makeNode(
'persistenceSettings',__utility,'utility/persistenceSettings','ModuleScript')
__makeNode('persistenceWrite',__utility,'utility/persistenceWrite',
'ModuleScript')__makeNode('runtime',__utility,'utility/runtime','ModuleScript')
__makeNode('services',__utility,'utility/services','ModuleScript')__makeNode(
'textMetrics',__utility,'utility/textMetrics','ModuleScript')__makeNode(
'variables',__utility,'utility/variables','ModuleScript')__makeNode(
'windowSizing',__utility,'utility/windowSizing','ModuleScript')__modules[
'components/action']=__DARKLUA_BUNDLE_MODULES.b()__modules['components/button']=
__DARKLUA_BUNDLE_MODULES.c()__modules['components/chrome']=
__DARKLUA_BUNDLE_MODULES.d()__modules['components/colorpicker']=
__DARKLUA_BUNDLE_MODULES.e()__modules['components/descriptor']=
__DARKLUA_BUNDLE_MODULES.f()__modules['components/divider']=
__DARKLUA_BUNDLE_MODULES.g()__modules['components/drag']=
__DARKLUA_BUNDLE_MODULES.h()__modules['components/dropdown']=
__DARKLUA_BUNDLE_MODULES.i()__modules['components/esppreview']=
__DARKLUA_BUNDLE_MODULES.j()__modules['components/group']=
__DARKLUA_BUNDLE_MODULES.k()__modules['components/input']=
__DARKLUA_BUNDLE_MODULES.l()__modules['components/keybind']=
__DARKLUA_BUNDLE_MODULES.m()__modules['components/notification']=
__DARKLUA_BUNDLE_MODULES.n()__modules['components/popup']=
__DARKLUA_BUNDLE_MODULES.o()__modules['components/search']=
__DARKLUA_BUNDLE_MODULES.p()__modules['components/section']=
__DARKLUA_BUNDLE_MODULES.q()__modules['components/slider']=
__DARKLUA_BUNDLE_MODULES.r()__modules['components/stat']=
__DARKLUA_BUNDLE_MODULES.s()__modules['components/tab']=__DARKLUA_BUNDLE_MODULES
.t()__modules['components/tag']=__DARKLUA_BUNDLE_MODULES.u()__modules[
'components/text']=__DARKLUA_BUNDLE_MODULES.v()__modules['components/toast']=
__DARKLUA_BUNDLE_MODULES.w()__modules['components/toggle']=
__DARKLUA_BUNDLE_MODULES.x()__modules['components/window']=
__DARKLUA_BUNDLE_MODULES.y()__modules['init']=__DARKLUA_BUNDLE_MODULES.z()
__modules['themes/amethyst']=__DARKLUA_BUNDLE_MODULES.A()__modules[
'themes/cobalt']=__DARKLUA_BUNDLE_MODULES.B()__modules['themes/default']=
__DARKLUA_BUNDLE_MODULES.C()__modules['themes/ember']=__DARKLUA_BUNDLE_MODULES.
D()__modules['themes/frost']=__DARKLUA_BUNDLE_MODULES.E()__modules['themes/rose'
]=__DARKLUA_BUNDLE_MODULES.F()__modules['types']=__DARKLUA_BUNDLE_MODULES.G()
__modules['utility/HapticEngine']=__DARKLUA_BUNDLE_MODULES.H()__modules[
'utility/assetResolver']=__DARKLUA_BUNDLE_MODULES.I()__modules['utility/colors']
=__DARKLUA_BUNDLE_MODULES.J()__modules['utility/constants']=
__DARKLUA_BUNDLE_MODULES.K()__modules['utility/enums']=__DARKLUA_BUNDLE_MODULES.
L()__modules['utility/filesystem']=__DARKLUA_BUNDLE_MODULES.M()__modules[
'utility/filesystemManager']=__DARKLUA_BUNDLE_MODULES.N()__modules[
'utility/flagNames']=__DARKLUA_BUNDLE_MODULES.O()__modules['utility/fontManager'
]=__DARKLUA_BUNDLE_MODULES.P()__modules['utility/functions']=
__DARKLUA_BUNDLE_MODULES.Q()__modules['utility/image']=__DARKLUA_BUNDLE_MODULES.
R()__modules['utility/imageCache']=__DARKLUA_BUNDLE_MODULES.S()__modules[
'utility/locale']=__DARKLUA_BUNDLE_MODULES.T()__modules['utility/log']=
__DARKLUA_BUNDLE_MODULES.U()__modules['utility/moveable']=
__DARKLUA_BUNDLE_MODULES.V()__modules['utility/network']=
__DARKLUA_BUNDLE_MODULES.W()__modules['utility/odometer']=
__DARKLUA_BUNDLE_MODULES.X()__modules['utility/ordering']=
__DARKLUA_BUNDLE_MODULES.Y()__modules['utility/path']=__DARKLUA_BUNDLE_MODULES.
Z()__modules['utility/persistence']=__DARKLUA_BUNDLE_MODULES._()__modules[
'utility/persistenceConfig']=__DARKLUA_BUNDLE_MODULES.aa()__modules[
'utility/persistencePaths']=__DARKLUA_BUNDLE_MODULES.ab()__modules[
'utility/persistenceSettings']=__DARKLUA_BUNDLE_MODULES.ac()__modules[
'utility/persistenceWrite']=__DARKLUA_BUNDLE_MODULES.ad()__modules[
'utility/runtime']=__DARKLUA_BUNDLE_MODULES.ae()__modules['utility/services']=
__DARKLUA_BUNDLE_MODULES.af()__modules['utility/textMetrics']=
__DARKLUA_BUNDLE_MODULES.ag()__modules['utility/variables']=
__DARKLUA_BUNDLE_MODULES.ah()__modules['utility/windowSizing']=
__DARKLUA_BUNDLE_MODULES.ai()local function __require(node)local id=type(node)==
'table'and rawget(node,'__id')or nil if not id then error(
'Pulse bundle: require expected a module node',2)end if __state[id]=='loaded'
then return __cache[id]end if __state[id]=='loading'then error(
'Pulse bundle: circular require of '..id,2)end local factory=__modules[id]if not
factory then error('Pulse bundle: missing module '..id,2)end __state[id]=
'loading'local ok,result=pcall(factory,node,__require)if not ok then __state[id]
=nil error(('Pulse/%s: %s'):format(id,tostring(result)),0)end __cache[id],
__state[id]=result,'loaded'return result end if type(getgenv)=='function'then
getgenv().RAYFIELD_SECURE=true end local Rayfield=__require(__root)assert(type(
Rayfield)=='table'and type(Rayfield.CreateWindow)=='function',
'Embedded Pulse library did not return a valid library')return{Rayfield=Rayfield
,require=__require,nodes=__nodes}end function __DARKLUA_BUNDLE_MODULES.aj():
typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.aj if not v then v={c=
__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.aj=v end return v.c end end do
local function __modImpl()return function(env)local Rayfield=env.Rayfield if not
LPH_OBFUSCATED then LPH_JIT=function(...)return...end LPH_ENCSTR=function(s)
return s end end local Players=game:GetService('Players')local RunService=game:
GetService('RunService')local HttpService=game:GetService('HttpService')local
TeleportService=game:GetService('TeleportService')local LocalPlayer=Players.
LocalPlayer local LuaprotDiscord=tostring(LP_DISCORD or'unknown')local function
GetDiscordDisplay()if LuaprotDiscord==''or LuaprotDiscord:lower()=='unknown'then
return'Not linked'end return LuaprotDiscord end local Window local function
Notify(text,duration)if Window then Window:Notify({title='Pulse',content=
tostring(text),duration=duration or 3})end end local PulseTheme={CornerRoundness
=UDim.new(0,16),WindowColor=ColorSequence.new({ColorSequenceKeypoint.new(0,
Color3.fromRGB(13,8,15)),ColorSequenceKeypoint.new(0.9999,Color3.fromRGB(23,13,
25)),ColorSequenceKeypoint.new(1,Color3.fromRGB(32,18,34))}),ShadowColor=Color3.
fromRGB(6,2,7),ElementGradient=ColorSequence.new({ColorSequenceKeypoint.new(0,
Color3.fromRGB(26,15,28)),ColorSequenceKeypoint.new(0.9999,Color3.fromRGB(32,19,
34)),ColorSequenceKeypoint.new(1,Color3.fromRGB(32,19,34))}),ElementStroke=
Color3.fromRGB(66,40,63),ElementStrokeGradient=ColorSequence.new(Color3.fromRGB(
78,47,74),Color3.fromRGB(101,60,92)),ElementStrokeHover=Color3.fromRGB(113,67,
102),ElementTransparency=0.04,ElementStrokeTransparency=0.24,
ElementStrokeHoverTransparency=0.04,ElementCornerRadius=UDim.new(0,10),TabColor=
Color3.fromRGB(250,226,239),TabBackground=ColorSequence.new(Color3.fromRGB(76,30
,70),Color3.fromRGB(48,21,47)),TabStroke=ColorSequence.new(Color3.fromRGB(213,91
,196),Color3.fromRGB(119,48,111)),ActionColor=Color3.fromRGB(205,163,199),
ContentColor=Color3.fromRGB(238,220,235),TitlingColor=Color3.fromRGB(255,239,253
),ElementTextHoverColor=Color3.fromRGB(255,245,254),AccentColor=Color3.fromRGB(
242,112,225),AccentStroke=Color3.fromRGB(255,190,247),AccentGlow=0.48,
DropdownHighlight=Color3.fromRGB(242,112,225),SliderBackground=Color3.fromRGB(53
,30,49),SliderBackgroundHover=Color3.fromRGB(69,39,62),SliderProgress=
ColorSequence.new(Color3.fromRGB(255,174,246),Color3.fromRGB(215,79,198)),
SliderHandle=Color3.fromRGB(255,231,252),StatBackground=Color3.fromRGB(20,11,21)
,ToggleTrack=Color3.fromRGB(18,8,17),ToggleTrackTransparency=0.18,ToggleKnobOff=
Color3.fromRGB(184,151,169),ToggleKnobOffTransparency=0.12,FieldBackground=
Color3.fromRGB(19,10,20),FieldTransparency=0.08,FieldGlow=Color3.fromRGB(187,62,
171),PlaceholderColor=Color3.fromRGB(166,128,158),SurfaceStroke=Color3.fromRGB(
112,66,106),NeutralButton=Color3.fromRGB(46,25,42),NeutralButtonHover=Color3.
fromRGB(61,33,55),NeutralButtonStroke=Color3.fromRGB(108,62,103),ErrorColor=
Color3.fromRGB(196,67,91),ErrorStrokeColor=Color3.fromRGB(246,119,138)}Window=
Rayfield:CreateWindow({name='Pulse | YBA',subtitle='Your Bizarre Adventure',
theme=PulseTheme,icon=89158989026598,showName='Pulse',showIcon=89158989026598,
configuration={autoSave=true,autoLoad=false,fileName='yba-main',customFolder=
'YBA'}})Window._pulseLoading=true Window.screenGui.Enabled=false Window:
CreateTag({text='YBA',color=Window.theme.AccentColor})env.Players=Players env.
RunService=RunService env.LocalPlayer=LocalPlayer env.GetDiscordDisplay=
GetDiscordDisplay env.Window=Window env.Notify=Notify end end function
__DARKLUA_BUNDLE_MODULES.ak():typeof(__modImpl())local v=
__DARKLUA_BUNDLE_MODULES.cache.ak if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.ak=v end return v.c end end do local function
__modImpl()return function(env)local Window=env.Window local Molto pcall(
function()Molto=loadstring(game:HttpGet('https://molto.pages.dev/source.lua'))()
Molto.SetProvider('fluent')end)local function FluentIcon(name)local ok,asset=
pcall(function()return Molto and Molto.GetAsset(name)end)if ok and asset and
type(asset.Url)=='string'and asset.Url:sub(1,11)=='rbxasset://'then return asset
end return nil end local function ApplyFluentIcon(label,icon)if label and icon
then label.ImageRectSize=icon.ImageRectSize label.ImageRectOffset=icon.
ImageRectOffset end end local function CreateFluentTab(name,iconName)local icon=
FluentIcon(iconName)local tab=Window:CreateTab({name=name,icon=icon and icon.Url
})ApplyFluentIcon(tab.topbarItemIcon,icon)return tab end local function
FluentNotify(properties,iconName)local icon=iconName and FluentIcon(iconName)if
icon then properties.icon=icon.Url end local notification=Window:Notify(
properties)ApplyFluentIcon(notification and notification.iconLabel,icon)return
notification end env.FluentIcon=FluentIcon env.ApplyFluentIcon=ApplyFluentIcon
env.CreateFluentTab=CreateFluentTab env.FluentNotify=FluentNotify end end
function __DARKLUA_BUNDLE_MODULES.al():typeof(__modImpl())local v=
__DARKLUA_BUNDLE_MODULES.cache.al if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.al=v end return v.c end end do local function
__modImpl()return function(env)local __nodes=env.__nodes local __require=env.
__require local ToggleComponent=__require(__nodes['components/toggle'])local
NotifyToggleState=ToggleComponent._notifyState function ToggleComponent:
_notifyState()if self.tab and self.tab.forgetState then NotifyToggleState(self)
end end local SearchComponent=__require(__nodes['components/search'])local
OpenSearch,CloseSearch=SearchComponent.open,SearchComponent.close function
SearchComponent.open(window)local wasSearching=window._searching OpenSearch(
window)if wasSearching or not window._searching then return end for _,entry in
window._searchUnits do local unit=entry.unit local main=unit.main if main and
unit.tab and unit.tab.compact then local flex=main:FindFirstChildOfClass(
'UIFlexItem')entry.rowSize,entry.rowAutoSize=main.Size,main.AutomaticSize if
flex then entry.rowFlex,entry.rowFlexMode=flex,flex.FlexMode flex.FlexMode=Enum.
UIFlexMode.None end main.AutomaticSize=Enum.AutomaticSize.None main.Size=UDim2.
new(1,-20,main.Size.Y.Scale,main.Size.Y.Offset)end end end function
SearchComponent.close(window,config)if window._searching then for _,entry in
window._searchUnits do local main=entry.unit.main if main and entry.rowSize then
main.Size=UDim2.new(entry.rowSize.X.Scale,entry.rowSize.X.Offset,main.Size.Y.
Scale,main.Size.Y.Offset)main.AutomaticSize=entry.rowAutoSize if entry.rowFlex
then entry.rowFlex.FlexMode=entry.rowFlexMode end end end end return
CloseSearch(window,config)end end end function __DARKLUA_BUNDLE_MODULES.am():
typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.am if not v then v={c=
__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.am=v end return v.c end end do
local function __modImpl()return function(env)local __nodes=env.__nodes local
__require=env.__require local Players=env.Players local RunService=env.
RunService local LocalPlayer=env.LocalPlayer local GetDiscordDisplay=env.
GetDiscordDisplay local Window=env.Window local Notify=env.Notify local
CreateFluentTab=env.CreateFluentTab local TweenService=game:GetService(
'TweenService')local HomeTab=CreateFluentTab('Home','home-24-filled')local
HomePanel=Window:Create('Frame',{Name='Home',Size=UDim2.new(1,0,0,420),
BackgroundTransparency=1,BorderSizePixel=0,LayoutOrder=10,Visible=false,Parent=
HomeTab.tabPage})local HomeIdentity=Window:Create('Frame',{Position=UDim2.
fromOffset(10,10),Size=UDim2.new(0.34,-15,1,-20),BackgroundColor3=Color3.
fromRGB(255,255,255),BorderSizePixel=0,Parent=HomePanel},{BackgroundTransparency
='ElementTransparency'})local HomeIdentityStroke=Window:StyleElementBody(
HomeIdentity)HomeIdentity.BackgroundTransparency=Window.theme.
ElementTransparency or 0 HomeIdentityStroke.Transparency=Window.theme.
ElementStrokeTransparency local HomeChatPane=Window:Create('Frame',{Position=
UDim2.new(0.34,5,0,10),Size=UDim2.new(0.66,-15,1,-20),BackgroundColor3=Color3.
fromRGB(255,255,255),ClipsDescendants=true,BorderSizePixel=0,Parent=HomePanel},{
BackgroundTransparency='ElementTransparency'})local HomeChatPaneStroke=Window:
StyleElementBody(HomeChatPane)HomeChatPane.BackgroundTransparency=Window.theme.
ElementTransparency or 0 HomeChatPaneStroke.Transparency=Window.theme.
ElementStrokeTransparency local HomeBanner=Window:Create('Frame',{Position=UDim2
.fromOffset(10,10),Size=UDim2.new(1,-20,0,124),BackgroundTransparency=1,
BorderSizePixel=0,Parent=HomeIdentity})local function LoadUserThumbnail(target,
userId,thumbnailSize)task.spawn(function()local success,content=pcall(Players.
GetUserThumbnailAsync,Players,tonumber(userId)or 0,Enum.ThumbnailType.HeadShot,
thumbnailSize or Enum.ThumbnailSize.Size150x150)if success and target.Parent
then target.Image=content end end)end local HomeAvatar=Window:Create(
'ImageLabel',{AnchorPoint=Vector2.new(0.5,0),Position=UDim2.new(0.5,0,0,8),Size=
UDim2.fromOffset(70,70),BackgroundTransparency=1,BorderSizePixel=0,Image='',
Parent=HomeBanner})Window:Create('UICorner',{CornerRadius=UDim.new(1,0),Parent=
HomeAvatar})Window:Create('UIStroke',{Thickness=2,Transparency=0.25,Parent=
HomeAvatar},{Color='SurfaceStroke'})LoadUserThumbnail(HomeAvatar,LocalPlayer.
UserId,Enum.ThumbnailSize.Size150x150)local HomeProfileStatus=Window:Create(
'Frame',{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0.5,28,0,72),Size=
UDim2.fromOffset(10,10),BorderSizePixel=0,Parent=HomeBanner},{BackgroundColor3=
'AccentColor'})Window:Create('UICorner',{CornerRadius=UDim.new(1,0),Parent=
HomeProfileStatus})Window:Create('UIStroke',{Thickness=2,Transparency=0.15,
Parent=HomeProfileStatus},{Color='ElementStroke'})local HomeDisplayNameLabel=
Window:Create('TextLabel',{Position=UDim2.fromOffset(8,82),Size=UDim2.new(1,-16,
0,22),BackgroundTransparency=1,Text=LocalPlayer.DisplayName,TextSize=15,
TextXAlignment=Enum.TextXAlignment.Center,TextTruncate=Enum.TextTruncate.AtEnd,
Parent=HomeBanner},{TextColor3='TitlingColor',FontFace='TitleFont'})local
HomeUsernameLabel=Window:Create('TextLabel',{Position=UDim2.fromOffset(8,104),
Size=UDim2.new(1,-16,0,16),BackgroundTransparency=1,Text='@'..LocalPlayer.Name,
TextSize=10,TextTransparency=0.4,TextXAlignment=Enum.TextXAlignment.Center,
TextTruncate=Enum.TextTruncate.AtEnd,Parent=HomeBanner},{TextColor3=
'ContentColor',FontFace='Font'})local function HomeInset(y,height,title)local
pane=Window:Create('Frame',{Position=UDim2.fromOffset(10,y),Size=UDim2.new(1,-20
,0,height),BackgroundTransparency=0.9,BorderSizePixel=0,Parent=HomeIdentity},{
BackgroundColor3='FieldBackground',BackgroundTransparency='FieldTransparency'})
Window:Create('UICorner',{Parent=pane},{CornerRadius='ElementCornerRadius'})
Window:Create('UIStroke',{Transparency=0.86,Parent=pane},{Color='SurfaceStroke'}
)local titleLabel=Window:Create('TextLabel',{Position=UDim2.fromOffset(12,8),
Size=UDim2.new(1,-24,0,13),BackgroundTransparency=1,Text=title,TextSize=8,
TextTransparency=0.5,TextXAlignment=Enum.TextXAlignment.Left,Parent=pane},{
TextColor3='ContentColor',FontFace='Font'})return pane,titleLabel end local
HomeDiscordPane,HomeDiscordTitle=HomeInset(146,58,'DISCORD ACCOUNT')local
HomeDiscordLabel=Window:Create('TextLabel',{Position=UDim2.fromOffset(12,25),
Size=UDim2.new(1,-24,0,22),BackgroundTransparency=1,Text=GetDiscordDisplay(),
TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.
TextTruncate.AtEnd,Parent=HomeDiscordPane},{TextColor3='TitlingColor',FontFace=
'TitleFont'})local HomeSessionPane,HomeSessionTitle=HomeInset(216,110,
'CURRENT SESSION')local HomeRoleLabel=Window:Create('TextLabel',{Position=UDim2.
fromOffset(12,30),Size=UDim2.new(1,-24,0,30),BackgroundTransparency=1,Text=
'Unknown',TextSize=20,TextXAlignment=Enum.TextXAlignment.Left,Parent=
HomeSessionPane},{TextColor3='TitlingColor',FontFace='TitleFont'})local
HomeSessionStats=Window:Create('TextLabel',{Position=UDim2.fromOffset(12,67),
Size=UDim2.new(1,-24,0,24),BackgroundTransparency=1,Text='0 ms  |  0 players',
TextSize=10,TextTransparency=0.3,TextXAlignment=Enum.TextXAlignment.Left,
TextYAlignment=Enum.TextYAlignment.Top,TextWrapped=true,Parent=HomeSessionPane},
{TextColor3='ContentColor',FontFace='Font'})local HomeChatTitle=Window:Create(
'TextLabel',{Position=UDim2.fromOffset(16,13),Size=UDim2.new(1,-32,0,22),
BackgroundTransparency=1,Text='Chat',TextSize=16,TextXAlignment=Enum.
TextXAlignment.Left,Parent=HomeChatPane},{TextColor3='ContentColor',FontFace=
'Font'})Window:Create('Frame',{Position=UDim2.fromOffset(14,43),Size=UDim2.new(1
,-28,0,1),BorderSizePixel=0,BackgroundTransparency=0.88,Parent=HomeChatPane},{
BackgroundColor3='SurfaceStroke'})local HomeChatFeed=Window:Create(
'ScrollingFrame',{Name='MessageFeed',Position=UDim2.fromOffset(12,50),Size=UDim2
.new(1,-24,1,-112),BackgroundTransparency=1,BorderSizePixel=0,Active=true,
AutomaticCanvasSize=Enum.AutomaticSize.Y,CanvasSize=UDim2.new(),
ScrollBarThickness=0,ScrollingDirection=Enum.ScrollingDirection.Y,
VerticalScrollBarInset=Enum.ScrollBarInset.None,Parent=HomeChatPane})Window:
Create('UIListLayout',{Padding=UDim.new(0,5),SortOrder=Enum.SortOrder.
LayoutOrder,HorizontalAlignment=Enum.HorizontalAlignment.Center,Parent=
HomeChatFeed})Window:Create('UIPadding',{PaddingTop=UDim.new(0,3),PaddingBottom=
UDim.new(0,5),PaddingLeft=UDim.new(0,2),PaddingRight=UDim.new(0,4),Parent=
HomeChatFeed})local HomeChatEmpty=Window:Create('TextLabel',{Position=UDim2.
fromOffset(24,62),Size=UDim2.new(1,-48,1,-134),BackgroundTransparency=1,Text=
'Connecting to chat...',TextSize=10,TextTransparency=0.45,TextWrapped=true,
Parent=HomeChatPane},{TextColor3='ContentColor',FontFace='Font'})local HomeChat
local HomeChatComposer HomeChatComposer=__require(__nodes['components/input']).
new(HomeTab,{name='Message',placeholder='Message...',forgetState=true,
submitOnEnterOnly=true,flashOnCommit=false,callback=function(text)if HomeChat
then HomeChatComposer.value=''HomeChat:Send(text)end end})HomeChatComposer.main.
AnchorPoint=Vector2.new(0,1)HomeChatComposer.main.Position=UDim2.new(0,10,1,-10)
HomeChatComposer.main.Size=UDim2.new(1,-20,0,41)HomeChatComposer.main.Parent=
HomeChatPane HomeChatComposer:_setShown(true,false)local HomeChatInput=
HomeChatComposer.input HomeChatInput.TextEditable=false local ChatEnvironment=if
type(getgenv)=='function'then getgenv()else _G local PreviousHomeChat=rawget(
ChatEnvironment,'_pulseHomeChatController')local PreviousHistory=if type(
PreviousHomeChat)=='table'and type(PreviousHomeChat.history)=='table'then table.
clone(PreviousHomeChat.history)else{}local PreviousSeenRows=if type(
PreviousHomeChat)=='table'and type(PreviousHomeChat.seenRows)=='table'then table
.clone(PreviousHomeChat.seenRows)else{}if type(PreviousHomeChat)=='table'and
type(PreviousHomeChat.Destroy)=='function'then pcall(PreviousHomeChat.Destroy,
PreviousHomeChat,true)end HomeChat={alive=true,connected=false,statusKind=
'pending',gaveUp=false,sending=false,failureCount=0,lastFailureAt=0,messageCount
=0,lastSender=nil,lastGroup=nil,connections={},history=PreviousHistory,seenRows=
PreviousSeenRows,messageRows={},pendingOwn={},sendTimes={},userCache={},
discordAvatarCache={}}ChatEnvironment._pulseHomeChatController=HomeChat local
CHAT_CLIENT_URL='https://global.rawth.net/client.lua'local CHAT_MAX_CHARS=200
local CHAT_HISTORY_LIMIT=25 local CHAT_API_TIMEOUT=30 local CHAT_MAX_FAILURES=2
local CHAT_SPAM_LIMIT=5 local CHAT_SPAM_WINDOW=10 local CHAT_FILTER_WORDS={
'nigger','nigga','faggot','fag','retard','chink','spic','kike','wetback',
'tranny','dyke','coon','gook','paki','beaner','discord.gg','discord.com/invite',
'discordapp.com/invite'}function HomeChat:_current()return self.alive and
HomeChatPane.Parent~=nil and ChatEnvironment._pulseHomeChatController==self end
function HomeChat:_bind(signal,callback)local connection=signal:Connect(callback
)table.insert(self.connections,connection)return connection end function
HomeChat:Destroy(disconnectClient)if not self.alive then return end self.alive=
false for _,connection in self.connections do pcall(connection.Disconnect,
connection)end table.clear(self.connections)if disconnectClient then for _,name
in{'chat_disconnect','chat_stop','chat_close','chat_shutdown'}do local fn=
rawget(ChatEnvironment,name)if type(fn)=='function'then pcall(fn)break end end
end end function HomeChat:SetStatus(text,kind)if not self:_current()then return
end self.statusKind=kind or'pending'self.connected=kind=='ready'HomeChatComposer
.placeholder='Message...'HomeChatInput.PlaceholderText='Message...'HomeChatInput
.TextEditable=self.connected and not self.gaveUp end function HomeChat:
_scrollToBottom(force)task.defer(function()if not self:_current()or not
HomeChatFeed.Parent then return end local maximum=math.max(0,HomeChatFeed.
AbsoluteCanvasSize.Y-HomeChatFeed.AbsoluteWindowSize.Y)local nearBottom=maximum-
HomeChatFeed.CanvasPosition.Y<=90 if force or nearBottom then HomeChatFeed.
CanvasPosition=Vector2.new(0,maximum+999)end end)end function HomeChat:
_resolveUser(id,nameCallback,avatarCallback)local key=tostring(id)local cached=
self.userCache[key]if cached then if nameCallback then nameCallback(cached.name)
end if avatarCallback then avatarCallback(cached.avatar)end return end task.
spawn(function()local userId=tonumber(key)local name,avatar=key,''local player=
userId and Players:GetPlayerByUserId(userId)or nil if player then name=player.
DisplayName elseif userId then pcall(function()name=Players:
GetNameFromUserIdAsync(userId)end)end if userId then pcall(function()avatar=
Players:GetUserThumbnailAsync(userId,Enum.ThumbnailType.HeadShot,Enum.
ThumbnailSize.Size48x48)end)end self.userCache[key]={name=name,avatar=avatar}if
not self:_current()then return end if nameCallback then nameCallback(name)end if
avatarCallback then avatarCallback(avatar)end end)end function HomeChat:
_resolveDiscordAvatar(discordId,avatarUrl,callback)avatarUrl=tostring(avatarUrl
or'')if avatarUrl==''then return end if avatarUrl:sub(1,11)=='rbxassetid:'or
avatarUrl:sub(1,11)=='rbxthumb://'then callback(avatarUrl)return end local
normalizedUrl=avatarUrl:lower()if not normalizedUrl:match(
'^https://cdn%.discordapp%.com/')and not normalizedUrl:match(
'^https://media%.discordapp%.net/')then return end local cacheKey=tostring(
discordId)..'\0'..avatarUrl local cached=self.discordAvatarCache[cacheKey]if
type(cached)=='string'then callback(cached)return elseif type(cached)=='table'
then table.insert(cached,callback)return end self.discordAvatarCache[cacheKey]={
callback}task.spawn(function()local resolved=''local env=ChatEnvironment local
assetFunction=rawget(env,'getcustomasset')or rawget(env,'getsynasset')or
getcustomasset or getsynasset local isFileFunction=rawget(env,'isfile')or isfile
local writeFileFunction=rawget(env,'writefile')or writefile local
makeFolderFunction=rawget(env,'makefolder')or makefolder local isFolderFunction=
rawget(env,'isfolder')or isfolder local requestFunction=rawget(env,'request')or
rawget(env,'http_request')local synTable=rawget(env,'syn')local httpTable=
rawget(env,'http')requestFunction=requestFunction or(type(httpTable)=='table'and
httpTable.request)or(type(synTable)=='table'and synTable.request)if type(
assetFunction)=='function'and type(isFileFunction)=='function'and type(
writeFileFunction)=='function'then local cleanUrl=avatarUrl:gsub('%?.*$','')
cleanUrl=cleanUrl:gsub('%.webp$','.png'):gsub('%.gif$','.png'):gsub('%.jpe?g$',
'.png')local fetchUrl=cleanUrl..'?size=64'local avatarHash=cleanUrl:match(
'/avatars/%d+/([^/%.]+)$')or tostring(discordId)avatarHash=avatarHash:gsub(
'[^%w_%-]',''):sub(1,80)if avatarHash==''then avatarHash='avatar'end local
folder='Pulse/chat_avatars'local filePath=folder..'/'..avatarHash..'.png'local
exists=false local checked,fileExists=pcall(isFileFunction,filePath)exists=
checked and fileExists==true if not exists then pcall(function()if type(
isFolderFunction)~='function'or not isFolderFunction('Pulse')then if type(
makeFolderFunction)=='function'then makeFolderFunction('Pulse')end end if type(
isFolderFunction)~='function'or not isFolderFunction(folder)then if type(
makeFolderFunction)=='function'then makeFolderFunction(folder)end end end)local
body if type(requestFunction)=='function'then local ok,response=pcall(
requestFunction,{Url=fetchUrl,Method='GET'})if ok and type(response)=='table'
then local status=tonumber(response.StatusCode or response.Status or 200)or 0 if
status>=200 and status<300 then body=response.Body or response.body end end end
if type(body)~='string'or body:sub(1,8)~='\137PNG\r\n\26\n'then local ok,
response=pcall(game.HttpGet,game,fetchUrl,true)body=ok and response or nil end
if type(body)=='string'and#body<=2*1024*1024 and body:sub(1,8)==
'\137PNG\r\n\26\n'then exists=pcall(writeFileFunction,filePath,body)end end if
exists then local ok,asset=pcall(assetFunction,filePath)if ok and type(asset)==
'string'then resolved=asset end end end if resolved==''then resolved=avatarUrl
end local waiting=self.discordAvatarCache[cacheKey]self.discordAvatarCache[
cacheKey]=resolved if self:_current()and type(waiting)=='table'then for _,ready
in waiting do pcall(ready,resolved)end end end)end local function ChatTime(
utcMilliseconds)local success,formatted=pcall(function()return os.date('!%H:%M',
math.floor((tonumber(utcMilliseconds)or os.time()*1000)/1000))end)return success
and formatted or os.date('%H:%M')end function HomeChat:AddMessage(fromId,message
,utcMilliseconds,metadata,remember)if not self:_current()then return end local
text=tostring(message or''):match('^%s*(.-)%s*$')or''if text==''then return end
local id=tostring(fromId)local isSelf=id==tostring(LocalPlayer.UserId)local meta
=type(metadata)=='table'and metadata or{}local source=tostring(meta.source or'')
:lower()local suppliedName=tostring(meta.display_name or meta.username or'')
local sameSender=self.lastSender==id self.lastSender=id self.messageCount+=1 if
remember~=false then table.insert(self.history,{id=id,text=text,utc=tonumber(
utcMilliseconds)or os.time()*1000,meta=meta})while#self.history>
CHAT_HISTORY_LIMIT do table.remove(self.history,1)end end HomeChatEmpty.Visible=
false local function createMessageLabel(parent)return Window:Create('TextLabel',
{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,
BackgroundTransparency=1,Text=text,TextSize=11,TextWrapped=true,TextTransparency
=remember==false and 0 or 1,TextXAlignment=Enum.TextXAlignment.Left,LayoutOrder=
self.messageCount+1,ZIndex=3,Parent=parent},{TextColor3='ContentColor',FontFace=
'Font'})end local group=sameSender and self.lastGroup or nil if group and group.
id==id and group.row and group.row.Parent and group.content and group.content.
Parent then local followUp=createMessageLabel(group.content)if remember~=false
then task.defer(function()if not self:_current()or not followUp.Parent then
return end TweenService:Create(followUp,TweenInfo.new(0.18,Enum.EasingStyle.
Quint,Enum.EasingDirection.Out),{TextTransparency=0}):Play()end)end self:
_scrollToBottom(false)return end local row=Window:Create('Frame',{Name='Message'
,Size=UDim2.new(1,-4,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundColor3=
Color3.fromRGB(255,255,255),BackgroundTransparency=1,BorderSizePixel=0,
LayoutOrder=self.messageCount,Parent=HomeChatFeed},{BackgroundTransparency=
'ElementTransparency'})local rowStroke=Window:StyleElementBody(row)rowStroke.
Transparency=1 local rowScale=Window:Create('UIScale',{Scale=0.985,Parent=row})
Window:Create('UISizeConstraint',{MinSize=Vector2.new(0,48),Parent=row})table.
insert(self.messageRows,row)if#self.messageRows>CHAT_HISTORY_LIMIT then local
oldest=table.remove(self.messageRows,1)if oldest and oldest.Parent then Window:
DestroySubtree(oldest)end end local avatar=Window:Create('ImageLabel',{Position=
UDim2.fromOffset(11,10),Size=UDim2.fromOffset(26,26),BackgroundTransparency=1,
BorderSizePixel=0,Image='',ZIndex=3,Parent=row})Window:Create('UICorner',{
CornerRadius=UDim.new(1,0),Parent=avatar})Window:Create('UIStroke',{Thickness=1,
Transparency=0.75,Parent=avatar},{Color='SurfaceStroke'})local contentX=45 local
content=Window:Create('Frame',{Position=UDim2.fromOffset(contentX,8),Size=UDim2.
new(1,-(contentX+12),0,0),AutomaticSize=Enum.AutomaticSize.Y,
BackgroundTransparency=1,BorderSizePixel=0,ZIndex=3,Parent=row})Window:Create(
'UIListLayout',{Padding=UDim.new(0,2),SortOrder=Enum.SortOrder.LayoutOrder,
HorizontalAlignment=Enum.HorizontalAlignment.Left,Parent=content})local
nameLabel=Window:Create('TextLabel',{Size=UDim2.new(1,0,0,13),
BackgroundTransparency=1,Text=isSelf and('You at '..ChatTime(utcMilliseconds))or
((suppliedName~=''and suppliedName or'User')..' at '..ChatTime(utcMilliseconds))
,TextSize=10,TextTransparency=remember==false and 0.32 or 1,TextXAlignment=Enum.
TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,LayoutOrder=1,ZIndex=3,
Parent=content},{TextColor3=isSelf and'AccentColor'or'ContentColor',FontFace=
'TitleFont'})local messageLabel=createMessageLabel(content)Window:Create('Frame'
,{Size=UDim2.new(1,0,0,6),BackgroundTransparency=1,BorderSizePixel=0,LayoutOrder
=1000000,Parent=content})self.lastGroup={id=id,row=row,content=content}
local function applyIdentity(name,image)if name and source~='discord'and not
isSelf then nameLabel.Text=tostring(name)..' at '..ChatTime(utcMilliseconds)end
if avatar and image and image~=''then avatar.ImageTransparency=1 avatar.Image=
image TweenService:Create(avatar,TweenInfo.new(0.2,Enum.EasingStyle.Quint),{
ImageTransparency=0}):Play()end end if source=='discord'then applyIdentity(
suppliedName~=''and suppliedName or'Discord User',nil)local discordAvatar=meta.
avatar_url or meta.avatarUrl or meta.discord_avatar or meta.avatar self:
_resolveDiscordAvatar(id,discordAvatar,function(image)applyIdentity(nil,image)
end)else self:_resolveUser(id,function(name)applyIdentity(name,nil)end,function(
image)applyIdentity(nil,image)end)end if remember==false then row.
BackgroundTransparency=Window.theme.ElementTransparency rowStroke.Transparency=
Window.theme.ElementStrokeTransparency nameLabel.TextTransparency=0.32
messageLabel.TextTransparency=0 rowScale.Scale=1 else task.defer(function()if
not self:_current()or not row.Parent then return end local entrance=TweenInfo.
new(0.2,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)TweenService:Create(row,
entrance,{BackgroundTransparency=Window.theme.ElementTransparency}):Play()
TweenService:Create(rowStroke,entrance,{Transparency=Window.theme.
ElementStrokeTransparency}):Play()TweenService:Create(nameLabel,entrance,{
TextTransparency=0.32}):Play()TweenService:Create(messageLabel,entrance,{
TextTransparency=0}):Play()TweenService:Create(rowScale,entrance,{Scale=1}):
Play()end)end self:_scrollToBottom(false)end function HomeChat:_filter(text)
return(text:gsub('%S+',function(token)local lowered=token:lower()for _,blocked
in CHAT_FILTER_WORDS do if lowered:find(blocked,1,true)then return string.rep(
'*',#token)end end return token end))end function HomeChat:Send(submittedText)if
not self:_current()or self.sending then return end if not self.connected then
Notify('Chat is still connecting.',3)return end local text=tostring(
submittedText or HomeChatInput.Text):match('^%s*(.-)%s*$')or''if text==''then
return end if#text>CHAT_MAX_CHARS then text=text:sub(1,CHAT_MAX_CHARS)Notify(
'Chat messages are limited to 200 characters.',3)end local filtered=self:
_filter(text)if filtered~=text then Notify(
'Message filtered - watch your language.',3)end text=filtered local now=os.
clock()local fresh={}for _,sentAt in self.sendTimes do if now-sentAt<
CHAT_SPAM_WINDOW then table.insert(fresh,sentAt)end end self.sendTimes=fresh if#
fresh>=CHAT_SPAM_LIMIT then Notify('Slow down! Try again in '..tostring(math.
ceil(CHAT_SPAM_WINDOW-(now-fresh[1])))..'s.',3)return end local sendFunction=
rawget(ChatEnvironment,'chat_send')if type(sendFunction)~='function'then Notify(
'Chat is not ready yet.',3)return end self.sending=true HomeChatInput.Text=''
HomeChatComposer.value=''table.insert(self.sendTimes,now)self.pendingOwn[text]=(
self.pendingOwn[text]or 0)+1 self:AddMessage(LocalPlayer.UserId,text,os.time()*
1000,nil,true)task.spawn(function()local success=pcall(sendFunction,text)if self
:_current()then self.sending=false if not success then local pending=self.
pendingOwn[text]self.pendingOwn[text]=pending and pending>1 and pending-1 or nil
Notify('Message failed to send.',3)end end end)end HomeChat:_bind(HomeChatInput:
GetPropertyChangedSignal('Text'),function()if#HomeChatInput.Text>CHAT_MAX_CHARS
then HomeChatInput.Text=HomeChatInput.Text:sub(1,CHAT_MAX_CHARS)end end)for _,
item in PreviousHistory do HomeChat:AddMessage(item.id,item.text,item.utc,item.
meta,false)end HomeChatEmpty.Visible=#PreviousHistory==0 if#PreviousHistory>0
then local scrollConn scrollConn=HomeChatFeed:GetPropertyChangedSignal(
'AbsoluteCanvasSize'):Connect(function()if HomeChatFeed.AbsoluteCanvasSize.Y>0
then scrollConn:Disconnect()HomeChat:_scrollToBottom(true)end end)end
local function ChatApi(name)local elapsed=0 repeat local value=rawget(
ChatEnvironment,name)if type(value)=='function'then return value end elapsed+=
task.wait()until elapsed>=CHAT_API_TIMEOUT or not HomeChat:_current()return nil
end local function ChatStatusKind(rawStatus)local status=tostring(rawStatus or''
):lower()if status:find('fail',1,true)or status:find('error',1,true)or status:
find('closed',1,true)or status:find('disconnect',1,true)or status:find(
'not connected',1,true)or status=='no_websocket'then return'error'end if status:
find('connected',1,true)or status:find('ready',1,true)or status:find(
'authenticated',1,true)or status=='open'or status=='online'then return'ready'end
return'pending'end task.spawn(function()HomeChat:SetStatus('Loading API...',
'pending')local APIsReady=type(rawget(ChatEnvironment,'chat_on_message'))==
'function'and type(rawget(ChatEnvironment,'chat_on_status'))=='function'and
type(rawget(ChatEnvironment,'chat_connect'))=='function'and type(rawget(
ChatEnvironment,'chat_send'))=='function'if not APIsReady then local loaded=
false for attempt=1,2 do local fetched,body=pcall(game.HttpGet,game,
CHAT_CLIENT_URL,true)if fetched and type(body)=='string'and body~=''and body:
sub(1,1)~='{'then local compiler=loadstring local compiled,chunk=pcall(compiler,
body)if compiled and type(chunk)=='function'then local ran=pcall(chunk)if ran
then loaded=true break end end end if attempt<2 then task.wait(0.5)end end if
not loaded then HomeChat.gaveUp=true HomeChatEmpty.Text='Chat could not load.'
HomeChat:SetStatus('Connection failed','error')return end end local onMessage=
ChatApi('chat_on_message')local onStatus=ChatApi('chat_on_status')local onNotice
=rawget(ChatEnvironment,'chat_on_notice')if type(onNotice)~='function'then
onNotice=nil end local connectChat=ChatApi('chat_connect')if not(onMessage and
onStatus and connectChat)then HomeChat.gaveUp=true HomeChatEmpty.Text=
'Chat API timed out.'HomeChat:SetStatus('Connection failed','error')return end
task.spawn(onMessage,function(fromId,message,utcMilliseconds,rowId,metadata)if
not HomeChat:_current()then return end if rowId~=nil then local rowKey=tostring(
rowId)if HomeChat.seenRows[rowKey]then return end HomeChat.seenRows[rowKey]=true
end if tostring(fromId)==tostring(LocalPlayer.UserId)then local key=tostring(
message)local pending=HomeChat.pendingOwn[key]if pending and pending>0 then
HomeChat.pendingOwn[key]=pending>1 and pending-1 or nil return end end HomeChat:
AddMessage(fromId,message,utcMilliseconds,metadata,true)end)task.spawn(onStatus,
function(rawStatus)if not HomeChat:_current()or HomeChat.gaveUp then return end
local raw=tostring(rawStatus or'')local kind=ChatStatusKind(raw)local labels={
connecting='Connecting...',reconnecting='Reconnecting...',ready='Connected',
connect_failed='Connection failed',no_websocket='Unsupported',closed=
'Disconnected',stopped='Stopped',booting='Starting...'}local lowered=raw:lower()
HomeChat:SetStatus(labels[lowered]or raw,kind)if kind=='ready'then HomeChat.
failureCount=0 HomeChat.lastFailureAt=0 HomeChatEmpty.Text=
'No messages yet. Say hi.'elseif kind=='error'then local now=os.clock()if now-
HomeChat.lastFailureAt>0.75 then HomeChat.lastFailureAt=now HomeChat.
failureCount+=1 end if HomeChat.failureCount>=CHAT_MAX_FAILURES then HomeChat.
gaveUp=true HomeChat:SetStatus('Connection failed','error')HomeChatEmpty.Text=
'Chat stopped after two failed attempts.'for _,name in{'chat_disconnect',
'chat_stop','chat_close'}do local stop=rawget(ChatEnvironment,name)if type(stop)
=='function'then pcall(stop)break end end end end end)if onNotice then task.
spawn(onNotice,function(_,_,noticeText)if HomeChat:_current()then Notify(
'Chat: '..tostring(noticeText),3)end end)end HomeChat:SetStatus('Connecting...',
'pending')local connected=pcall(connectChat)if not connected and HomeChat:
_current()then HomeChat.failureCount=CHAT_MAX_FAILURES HomeChat.gaveUp=true
HomeChat:SetStatus('Connection failed','error')HomeChatEmpty.Text=
'Chat could not connect.'end end)local HomeIdentityPosition=HomeIdentity.
Position local HomeChatPosition=HomeChatPane.Position local function
CreateHomeRevealMask(parent)local mask=Window:Create('Frame',{Size=UDim2.
fromScale(1,1),BackgroundColor3=Color3.fromRGB(255,255,255),BorderSizePixel=0,
ZIndex=200,Parent=parent})Window:Create('UICorner',{CornerRadius=Window.theme.
ElementCornerRadius,Parent=mask})local gradient=Window:Create('UIGradient',{
Rotation=270,Color=Window.theme.ElementGradient,Parent=mask})return mask,
gradient end local HomeIdentityReveal,HomeIdentityRevealGradient=
CreateHomeRevealMask(HomeIdentity)local HomeChatReveal,HomeChatRevealGradient=
CreateHomeRevealMask(HomeChatPane)local HomeSurface={__type='HomeSurface',
searchable=false,name='Home',tab=HomeTab,window=Window,main=HomePanel,
connections={},_revealToken=0,_tweens={}}local function OffsetHomePosition(
position,y)return UDim2.new(position.X.Scale,position.X.Offset,position.Y.Scale,
position.Y.Offset+y)end function HomeSurface:_cancelTweens()for _,tween in self.
_tweens do tween:Cancel()end table.clear(self._tweens)end function HomeSurface:
_setShown(shown,animate)self._revealToken+=1 local token=self._revealToken self:
_cancelTweens()HomeIdentityReveal.Visible=false HomeChatReveal.Visible=false
local identityTarget=if shown then(Window.theme.ElementTransparency or 0)else 1
local strokeTarget=if shown then Window.theme.ElementStrokeTransparency else 1
local textTarget=if shown then 0 else 1 local imageTarget=if shown then 0 else 1
local insetBgTarget=if shown then(Window.theme.FieldTransparency or 0.9)else 1
local composerMainTarget=if shown then(Window.theme.ElementTransparency or 0)
else 1 local composerBoxTarget=if shown then(Window.theme.FieldTransparency or
0.9)else 1 local composerTextTarget=if shown then 0.6 else 1 if not animate then
HomePanel.Visible=shown HomeIdentity.BackgroundTransparency=identityTarget
HomeChatPane.BackgroundTransparency=identityTarget HomeIdentityStroke.
Transparency=strokeTarget HomeChatPaneStroke.Transparency=strokeTarget
HomeAvatar.ImageTransparency=imageTarget local avatarStroke=HomeAvatar:
FindFirstChildWhichIsA('UIStroke')if avatarStroke then avatarStroke.Transparency
=if shown then 0.25 else 1 end HomeDisplayNameLabel.TextTransparency=textTarget
HomeUsernameLabel.TextTransparency=if shown then 0.4 else 1 HomeProfileStatus.
BackgroundTransparency=imageTarget local statusStroke=HomeProfileStatus:
FindFirstChildWhichIsA('UIStroke')if statusStroke then statusStroke.Transparency
=if shown then 0.15 else 1 end HomeDiscordPane.BackgroundTransparency=
insetBgTarget HomeDiscordTitle.TextTransparency=if shown then 0.5 else 1
HomeDiscordLabel.TextTransparency=textTarget HomeSessionPane.
BackgroundTransparency=insetBgTarget HomeSessionTitle.TextTransparency=if shown
then 0.5 else 1 HomeRoleLabel.TextTransparency=textTarget HomeSessionStats.
TextTransparency=if shown then 0.3 else 1 HomeChatTitle.TextTransparency=
textTarget HomeChatEmpty.TextTransparency=if shown then 0.45 else 1 HomeChatFeed
.BackgroundTransparency=1 local rowBgTarget=if shown then(Window.theme.
ElementTransparency or 0)else 1 local rowStrokeT=if shown then(Window.theme.
ElementStrokeTransparency or 0)else 1 for _,row in ipairs(HomeChat.messageRows)
do if row and row.Parent then row.BackgroundTransparency=rowBgTarget local s=row
:FindFirstChildWhichIsA('UIStroke')if s then s.Transparency=rowStrokeT end local
sc=row:FindFirstChildWhichIsA('UIScale')if sc then sc.Scale=1 end for _,child in
ipairs(row:GetDescendants())do if child:IsA('TextLabel')then child.
TextTransparency=if shown then(child.LayoutOrder==1 and 0.32 or 0)else 1 elseif
child:IsA('ImageLabel')then child.ImageTransparency=if shown then 0 else 1
elseif child:IsA('UIStroke')and child.Parent~=row then child.Transparency=if
shown then 0.75 else 1 end end end end HomeChatComposer.main.
BackgroundTransparency=composerMainTarget HomeChatComposer.stroke.Transparency=
strokeTarget HomeChatComposer.title.TextTransparency=textTarget HomeChatComposer
.box.BackgroundTransparency=composerBoxTarget HomeChatComposer.boxStroke.
Transparency=if shown then 0.85 else 1 HomeChatComposer.input.TextTransparency=
composerTextTarget if HomeChatComposer.iconLabel then HomeChatComposer.iconLabel
.ImageTransparency=imageTarget end HomeChatComposer.hoverOverlay.
BackgroundTransparency=1 return end local fadeInfo=if shown then TweenInfo.new(
0.4,Enum.EasingStyle.Exponential,Enum.EasingDirection.Out)else TweenInfo.new(
0.15,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)if shown then HomePanel.
Visible=true task.defer(function()if token~=self._revealToken then return end
task.defer(function()if token~=self._revealToken then return end HomeChat:
_scrollToBottom(false)end)end)end local function tween(instance,props)local t=
TweenService:Create(instance,fadeInfo,props)table.insert(self._tweens,t)t:Play()
end tween(HomeIdentity,{BackgroundTransparency=identityTarget})tween(
HomeChatPane,{BackgroundTransparency=identityTarget})tween(HomeIdentityStroke,{
Transparency=strokeTarget})tween(HomeChatPaneStroke,{Transparency=strokeTarget})
tween(HomeAvatar,{ImageTransparency=imageTarget})local avatarStroke=HomeAvatar:
FindFirstChildWhichIsA('UIStroke')if avatarStroke then tween(avatarStroke,{
Transparency=if shown then 0.25 else 1})end tween(HomeDisplayNameLabel,{
TextTransparency=textTarget})tween(HomeUsernameLabel,{TextTransparency=if shown
then 0.4 else 1})tween(HomeProfileStatus,{BackgroundTransparency=imageTarget})
local statusStroke=HomeProfileStatus:FindFirstChildWhichIsA('UIStroke')if
statusStroke then tween(statusStroke,{Transparency=if shown then 0.15 else 1})
end tween(HomeDiscordPane,{BackgroundTransparency=insetBgTarget})tween(
HomeDiscordTitle,{TextTransparency=if shown then 0.5 else 1})tween(
HomeDiscordLabel,{TextTransparency=textTarget})tween(HomeSessionPane,{
BackgroundTransparency=insetBgTarget})tween(HomeSessionTitle,{TextTransparency=
if shown then 0.5 else 1})tween(HomeRoleLabel,{TextTransparency=textTarget})
tween(HomeSessionStats,{TextTransparency=if shown then 0.3 else 1})tween(
HomeChatTitle,{TextTransparency=textTarget})tween(HomeChatEmpty,{
TextTransparency=if shown then 0.45 else 1})local rowBgTarget=if shown then(
Window.theme.ElementTransparency or 0)else 1 local rowStrokeT=if shown then(
Window.theme.ElementStrokeTransparency or 0)else 1 for _,row in ipairs(HomeChat.
messageRows)do if row and row.Parent then tween(row,{BackgroundTransparency=
rowBgTarget})local s=row:FindFirstChildWhichIsA('UIStroke')if s then tween(s,{
Transparency=rowStrokeT})end local sc=row:FindFirstChildWhichIsA('UIScale')if sc
then sc.Scale=1 end for _,child in ipairs(row:GetDescendants())do if child:IsA(
'TextLabel')then tween(child,{TextTransparency=if shown then(child.LayoutOrder==
1 and 0.32 or 0)else 1})elseif child:IsA('ImageLabel')then tween(child,{
ImageTransparency=if shown then 0 else 1})elseif child:IsA('UIStroke')and child.
Parent~=row then tween(child,{Transparency=if shown then 0.75 else 1})end end
end end tween(HomeChatComposer.main,{BackgroundTransparency=composerMainTarget})
tween(HomeChatComposer.stroke,{Transparency=strokeTarget})tween(HomeChatComposer
.title,{TextTransparency=textTarget})tween(HomeChatComposer.box,{
BackgroundTransparency=composerBoxTarget})tween(HomeChatComposer.boxStroke,{
Transparency=if shown then 0.85 else 1})tween(HomeChatComposer.input,{
TextTransparency=composerTextTarget})if HomeChatComposer.iconLabel then tween(
HomeChatComposer.iconLabel,{ImageTransparency=imageTarget})end tween(
HomeChatComposer.hoverOverlay,{BackgroundTransparency=1})task.delay(fadeInfo.
Time,function()if token~=self._revealToken then return end table.clear(self.
_tweens)if not shown then HomePanel.Visible=false end end)end function
HomeSurface:_refreshTheme()HomeIdentityRevealGradient.Color=Window.theme.
ElementGradient HomeChatRevealGradient.Color=Window.theme.ElementGradient end
HomeSurface:_setShown(false,false)HomeTab:_register(HomeSurface)local
UnloadWindowWithChat=Window.Unload function Window:Unload(...)HomeChat:Destroy(
true)if ChatEnvironment._pulseHomeChatController==HomeChat then ChatEnvironment.
_pulseHomeChatController=nil end return UnloadWindowWithChat(self,...)end local
_resizePending=false local function ResizeHomeLanding()local viewportHeight=math
.max(0,Window.size.Y.Offset-106)if viewportHeight>0 then local panelHeight=math.
max(140,math.floor(viewportHeight-43))HomePanel.Size=UDim2.new(1,0,0,panelHeight
)local compact=panelHeight<350 if compact then HomeBanner.Position=UDim2.
fromOffset(8,6)HomeBanner.Size=UDim2.new(1,-16,0,50)HomeAvatar.AnchorPoint=
Vector2.zero HomeAvatar.Position=UDim2.fromOffset(2,3)HomeAvatar.Size=UDim2.
fromOffset(44,44)HomeProfileStatus.Position=UDim2.fromOffset(43,41)
HomeProfileStatus.Size=UDim2.fromOffset(8,8)HomeDisplayNameLabel.Position=UDim2.
fromOffset(54,7)HomeDisplayNameLabel.Size=UDim2.new(1,-58,0,19)
HomeDisplayNameLabel.TextXAlignment=Enum.TextXAlignment.Left
HomeDisplayNameLabel.TextSize=13 HomeUsernameLabel.Position=UDim2.fromOffset(54,
27)HomeUsernameLabel.Size=UDim2.new(1,-58,0,15)HomeUsernameLabel.TextXAlignment=
Enum.TextXAlignment.Left HomeDiscordPane.Position=UDim2.fromOffset(8,62)
HomeDiscordPane.Size=UDim2.new(1,-16,0,38)HomeDiscordTitle.Position=UDim2.
fromOffset(10,3)HomeDiscordLabel.Position=UDim2.fromOffset(10,16)
HomeDiscordLabel.Size=UDim2.new(1,-20,0,17)HomeDiscordLabel.TextSize=10
HomeSessionPane.Position=UDim2.fromOffset(8,106)HomeSessionPane.Size=UDim2.new(1
,-16,1,-114)HomeSessionTitle.Position=UDim2.fromOffset(10,3)HomeRoleLabel.
Position=UDim2.new(0,10,0,17)HomeRoleLabel.Size=UDim2.new(0.48,-10,1,-20)
HomeRoleLabel.TextSize=13 HomeSessionStats.AnchorPoint=Vector2.new(1,0)
HomeSessionStats.Position=UDim2.new(1,-10,0,19)HomeSessionStats.Size=UDim2.new(
0.52,-4,1,-22)HomeSessionStats.TextSize=8 HomeSessionStats.TextXAlignment=Enum.
TextXAlignment.Right else HomeBanner.Position=UDim2.fromOffset(10,10)HomeBanner.
Size=UDim2.new(1,-20,0,124)HomeAvatar.AnchorPoint=Vector2.new(0.5,0)HomeAvatar.
Position=UDim2.new(0.5,0,0,8)HomeAvatar.Size=UDim2.fromOffset(70,70)
HomeProfileStatus.Position=UDim2.new(0.5,28,0,72)HomeProfileStatus.Size=UDim2.
fromOffset(10,10)HomeDisplayNameLabel.Position=UDim2.fromOffset(8,82)
HomeDisplayNameLabel.Size=UDim2.new(1,-16,0,22)HomeDisplayNameLabel.
TextXAlignment=Enum.TextXAlignment.Center HomeDisplayNameLabel.TextSize=15
HomeUsernameLabel.Position=UDim2.fromOffset(8,104)HomeUsernameLabel.Size=UDim2.
new(1,-16,0,16)HomeUsernameLabel.TextXAlignment=Enum.TextXAlignment.Center
HomeDiscordPane.Position=UDim2.fromOffset(10,146)HomeDiscordPane.Size=UDim2.new(
1,-20,0,58)HomeDiscordTitle.Position=UDim2.fromOffset(12,8)HomeDiscordLabel.
Position=UDim2.fromOffset(12,25)HomeDiscordLabel.Size=UDim2.new(1,-24,0,22)
HomeDiscordLabel.TextSize=12 HomeSessionPane.Position=UDim2.fromOffset(10,216)
HomeSessionPane.Size=UDim2.new(1,-20,0,110)HomeSessionTitle.Position=UDim2.
fromOffset(12,8)HomeRoleLabel.Position=UDim2.fromOffset(12,30)HomeRoleLabel.Size
=UDim2.new(1,-24,0,30)HomeRoleLabel.TextSize=20 HomeSessionStats.AnchorPoint=
Vector2.zero HomeSessionStats.Position=UDim2.fromOffset(12,67)HomeSessionStats.
Size=UDim2.new(1,-24,0,24)HomeSessionStats.TextSize=10 HomeSessionStats.
TextXAlignment=Enum.TextXAlignment.Left end end end HomeTab.tabPage.
ScrollingEnabled=false HomeTab.tabPage.AutomaticCanvasSize=Enum.AutomaticSize.
None Window:Connect(HomeTab.tabPage:GetPropertyChangedSignal(
'AbsoluteWindowSize'),function()if _resizePending then return end _resizePending
=true task.defer(function()_resizePending=false ResizeHomeLanding()end)end)
ResizeHomeLanding()local pingElapsed=0 Window:Connect(RunService.RenderStepped,
function(dt)pingElapsed+=dt if pingElapsed<2 then return end pingElapsed=0 local
stats=game:GetService('Stats')local ping=math.max(0,math.floor(stats.Network.
ServerStatsItem['Data Ping']:GetValue()+0.5))HomeRoleLabel.Text=LocalPlayer.Name
HomeSessionStats.Text=tostring(ping)..' ms  |  '..tostring(#Players:GetPlayers()
)..' players'end)Window:Navigate('Home')end end function
__DARKLUA_BUNDLE_MODULES.an():typeof(__modImpl())local v=
__DARKLUA_BUNDLE_MODULES.cache.an if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.an=v end return v.c end end do local function
__modImpl()return function(env)local Window=env.Window local _pulseGlobal=(
getgenv and getgenv())or _G if _pulseGlobal then _pulseGlobal.pulseCached=nil
_pulseGlobal.PulseLoadState=_pulseGlobal.PulseLoadState or{}_pulseGlobal.
PulseLoadState.loaded=false _pulseGlobal.PulseLoadState.startedAt=os.clock()
_pulseGlobal.PulseLoadState.finishedAt=nil end if type(shared)=='table'then
shared.PulseLoadState=_pulseGlobal and _pulseGlobal.PulseLoadState or(shared.
PulseLoadState or{})end _G.PulseLoadState=_pulseGlobal and _pulseGlobal.
PulseLoadState or(_G.PulseLoadState or{})local VS={isMobile=false,
autoPrestigeLocked=true,autoQuestLocked=true}local Players=game:GetService(
'Players')local RunService=game:GetService('RunService')local TeleportService=
game:GetService('TeleportService')local MarketplaceService=game:GetService(
'MarketplaceService')local ReplicatedStorage=game:GetService('ReplicatedStorage'
)local HttpService=game:GetService('HttpService')local Stats=game:GetService(
'Stats')local UserInputService=game:GetService('UserInputService')local
PhysicsService=game:GetService('PhysicsService')do local g=(getgenv and getgenv(
))or _G if type(rawget(g,'LPH_NO_VIRTUALIZE'))~='function'then rawset(g,
'LPH_NO_VIRTUALIZE',function(f)return f end)end if type(rawget(g,'LPH_JIT'))~=
'function'then rawset(g,'LPH_JIT',function(f)return f end)end end local function
pulseIsMobile()if VS.isMobile then return true end if rawget(_G,'mobile_ui')then
return true end if type(shared)=='table'and rawget(shared,'mobile_ui')then
return true end if getgenv then local ok,g=pcall(getgenv)if ok and type(g)==
'table'and(rawget(g,'mobile_ui')or rawget(g,'Pulse_Mobile'))then return true end
end return UserInputService.TouchEnabled and not UserInputService.
KeyboardEnabled end VS.isMobile=pulseIsMobile()local _farmNoclipChar,
_farmNoclipDescConn local function farmEnsureNoclip(char)if not char then return
end if _farmNoclipChar==char then return end if _farmNoclipDescConn then pcall(
function()_farmNoclipDescConn:Disconnect()end)_farmNoclipDescConn=nil end
_farmNoclipChar=char for _,v in pairs(char:GetDescendants())do if v:IsA(
'BasePart')then v.CanCollide=false end end _farmNoclipDescConn=char.
DescendantAdded:Connect(LPH_NO_VIRTUALIZE(function(v)if v:IsA('BasePart')then v.
CanCollide=false end end))end local function farmThrottledHeartbeat(fn,fpsMobile
,fpsDesktop)fpsMobile=fpsMobile or 20 fpsDesktop=fpsDesktop or 45 local interval
=1/(pulseIsMobile()and fpsMobile or fpsDesktop)local accum=0 return RunService.
Heartbeat:Connect(LPH_NO_VIRTUALIZE(function(dt)accum=accum+dt if accum<interval
then return end accum=accum-interval fn(dt)end))end local function farmStepWait(
default)default=default or 0 return pulseIsMobile()and math.max(default,0.06)or
default end repeat task.wait()until game:IsLoaded()local livingFolder=workspace:
FindFirstChild('Living')or workspace:WaitForChild('Living',8)local
livingMissingAtLoad=livingFolder==nil if livingMissingAtLoad then warn(
'Pulse: Living folder not found, some tabs will be limited.')end local
LocalPlayer=Players.LocalPlayer local PlayerGui=LocalPlayer.PlayerGui if
setclipboard then setclipboard('https://discord.gg/rpKwSGFa3H')end task.defer(
function()pcall(function()Window:Notify({title='Pulse',content=
'Succesfully loaded.',duration=5})end)end)repeat task.wait()until LocalPlayer.
Character VS.isMobile=pulseIsMobile()pcall(function()game:GetService('CoreGui').
DescendantAdded:Connect(function(obj)if obj.Name=='ErrorPrompt'then local em=obj
:FindFirstChild('ErrorMessage',true)if not em then return end repeat task.wait()
until em.Text~='Label'if em.Text:find('No exploiting')or em.Text:find('rejoin')
then task.wait(0.1)TeleportService:Teleport(game.PlaceId)end end end)end)env.VS=
VS env.Players=Players env.RunService=RunService env.TeleportService=
TeleportService env.MarketplaceService=MarketplaceService env.ReplicatedStorage=
ReplicatedStorage env.HttpService=HttpService env.Stats=Stats env.
UserInputService=UserInputService env.PhysicsService=PhysicsService env.
pulseIsMobile=pulseIsMobile env.farmEnsureNoclip=farmEnsureNoclip env.
farmThrottledHeartbeat=farmThrottledHeartbeat env.farmStepWait=farmStepWait env.
livingMissingAtLoad=livingMissingAtLoad env.LocalPlayer=LocalPlayer env.
PlayerGui=PlayerGui end end function __DARKLUA_BUNDLE_MODULES.ao():typeof(
__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.ao if not v then v={c=
__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.ao=v end return v.c end end do
local function __modImpl()return function(env)local VS=env.VS local
MarketplaceService=env.MarketplaceService local ReplicatedStorage=env.
ReplicatedStorage local HttpService=env.HttpService local Stats=env.Stats local
LocalPlayer=env.LocalPlayer local PlayerGui=env.PlayerGui local PlayerStats=
LocalPlayer:WaitForChild('PlayerStats')local PlayerLevel=PlayerStats:
WaitForChild('Level')local PlayerPity=PlayerStats:WaitForChild('PityCount')local
PlayerStand=PlayerStats:WaitForChild('Stand')local PlayerPrestige=PlayerStats:
WaitForChild('Prestige')local PlayerSpec=PlayerStats:WaitForChild('Spec')local
PlayerMoney=PlayerStats:WaitForChild('Money')VS.Backpack=LocalPlayer.Backpack
local ClientFX=ReplicatedStorage:WaitForChild('ClientFX')local Dialogues=
workspace:WaitForChild('Dialogues')local RIB_NAME=
"Rib Cage of The Saint's Corpse"local PlayerOwns2xInv=false pcall(function()
PlayerOwns2xInv=MarketplaceService:UserOwnsGamePassAsync(LocalPlayer.UserId,
14597778)end)VS.webhookEnabled=false VS.webhookLink=''VS.webhookPing=''
local function sendWebhook(message,pingUser)if not VS.webhookEnabled or VS.
webhookLink==''then return end local content=''if pingUser and VS.webhookPing~=
''then content='<@'..VS.webhookPing..'>'end local body=HttpService:JSONEncode({
content=content,username='Pulse',embeds={{title='Your Bizarre Adventure',color=
tonumber(16744258),footer={text='Pulse ('..os.date('%H:%M')..')'},fields={{name=
'Account',value='||'..LocalPlayer.Name..'||'},{name='Info',value=message}}}}})
pcall(function()request({Url=VS.webhookLink,Body=body,Method='POST',Headers={[
'content-type']='application/json'}})end)end VS.itemCounts={arrows=0,rokas=0,
ribs=0}local function refreshItemCounts()VS.itemCounts.arrows=0 VS.itemCounts.
rokas=0 VS.itemCounts.ribs=0 for _,v in pairs(VS.Backpack:GetChildren())do if v.
Name=='Mysterious Arrow'then VS.itemCounts.arrows+=1 elseif v.Name=='Rokakaka'
then VS.itemCounts.rokas+=1 elseif v.Name==RIB_NAME then VS.itemCounts.ribs+=1
end end end local function onBackpackItemAdded(item)if item.Name==
'Mysterious Arrow'then VS.itemCounts.arrows+=1 elseif item.Name=='Rokakaka'then
VS.itemCounts.rokas+=1 elseif item.Name==RIB_NAME then VS.itemCounts.ribs+=1 end
end local function onBackpackItemRemoved(item)if item.Name=='Mysterious Arrow'
then VS.itemCounts.arrows=math.max(0,VS.itemCounts.arrows-1)elseif item.Name==
'Rokakaka'then VS.itemCounts.rokas=math.max(0,VS.itemCounts.rokas-1)elseif item.
Name==RIB_NAME then VS.itemCounts.ribs=math.max(0,VS.itemCounts.ribs-1)end end
local bpConn1=VS.Backpack.ChildAdded:Connect(onBackpackItemAdded)local bpConn2=
VS.Backpack.ChildRemoved:Connect(onBackpackItemRemoved)LocalPlayer.ChildAdded:
Connect(function(child)if child.Name=='Backpack'then VS.Backpack=child VS.
itemCounts.arrows=0 VS.itemCounts.rokas=0 VS.itemCounts.ribs=0 bpConn1:
Disconnect()bpConn2:Disconnect()bpConn1=VS.Backpack.ChildAdded:Connect(
onBackpackItemAdded)bpConn2=VS.Backpack.ChildRemoved:Connect(
onBackpackItemRemoved)end end)refreshItemCounts()local function getCharacter()if
LocalPlayer.Character and LocalPlayer.Character:FindFirstChild(
'HumanoidRootPart')then return LocalPlayer.Character end return LocalPlayer.
CharacterAdded:Wait()end local function getRootPart()return getCharacter():
WaitForChild('HumanoidRootPart')end local function giveClickTpTool()local
existing=VS.Backpack and VS.Backpack:FindFirstChild('ClickTP')if existing then
existing:Destroy()end local tool=Instance.new('Tool')tool.Name='ClickTP'tool.
RequiresHandle=false tool.CanBeDropped=false tool.ToolTip=
'Teleport to mouse click'local clickTpBusy=false tool.Activated:Connect(function
()if clickTpBusy then return end clickTpBusy=true task.delay(0.08,function()
clickTpBusy=false end)local char=LocalPlayer.Character local hrp=char and char:
FindFirstChild('HumanoidRootPart')if not hrp then return end local mouse=
LocalPlayer:GetMouse()local hit=mouse and mouse.Hit if not hit then return end
hrp.CFrame=CFrame.new(hit.Position+Vector3.new(0,3,0))end)tool.Parent=VS.
Backpack end local function getHumanoid()return getCharacter():
FindFirstChildWhichIsA('Humanoid')end local function getRemoteEvent()return
getCharacter():WaitForChild('RemoteEvent')end local RIB_CAGE_SHOP_ITEM=
"1x Rib Cage of the Saint's Corpse"local function isRibCagePurchaseItem(itemName
)if not itemName then return false end return string.find(string.lower(itemName)
,'rib cage',1,true)~=nil end local function purchaseRibCage()pcall(function()
local living=workspace.Living:FindFirstChild(LocalPlayer.Name)local remote=
living and living:FindFirstChild('RemoteEvent')if remote then remote:FireServer(
'PurchaseShopItem',{ItemName=RIB_CAGE_SHOP_ITEM})end end)end local function
getRemoteFunction()return getCharacter():WaitForChild('RemoteFunction')end
local function unequipAllTools()pcall(function()getHumanoid():UnequipTools()end)
end local function waitUntilNewChar()local newChar=LocalPlayer.CharacterAdded:
Wait()newChar:WaitForChild('HumanoidRootPart')newChar:WaitForChild('Humanoid')
end local function getPing()local ok,v=pcall(function()return Stats.Network.
ServerStatsItem['Data Ping']:GetValue()/100 end)return ok and v or 50 end
local function getQuests()local t={}local ok,questFrame=pcall(function()return
PlayerGui:WaitForChild('HUD'):WaitForChild('Main'):WaitForChild('Frames'):
WaitForChild('Quest'):WaitForChild('Quests')end)if not ok then return t end for
_,v in pairs(questFrame:GetChildren())do if v.Name~='Sample'then t[v.Name]=true
end end return t end local function getPity()return PlayerPity.Value<=0 and 1 or
math.clamp(1+PlayerPity.Value/25,0,10)end local function roundTwo(n)return math.
floor(n*100)/100 end local function fireDialogue(npc,dialogue,option)pcall(
function()getRemoteEvent():FireServer('EndDialogue',{NPC=npc,Dialogue=dialogue,
Option=option})end)end local function finishDialogue(npc)local found=Dialogues:
FindFirstChild(npc)if not found then return end local dlg=found:FindFirstChild(
'Dialogue')local name=dlg and dlg.Value or npc local remote=getRemoteFunction()
for i=1,8 do pcall(function()remote:InvokeServer('EndDialogue',{NPC=name,Option=
'Option1',Dialogue='Dialogue'..tostring(i)})end)end end local function
learnSkill(skill,treeType)pcall(function()getRemoteFunction():InvokeServer(
'LearnSkill',{Skill=skill,SkillTreeType=treeType})end)end local function
getBpItemBackpack(name)VS.Backpack:WaitForChild(name,1)return VS.Backpack:
FindFirstChild(name)end local function getBpItem(name)local b=VS.Backpack:
FindFirstChild(name)if b then return b end local char=LocalPlayer.Character
return char and char:FindFirstChild(name)or nil end local function getBpItems(
name)local t={}for _,v in pairs(VS.Backpack:GetChildren())do if v.Name==name
then table.insert(t,v)end end local char=LocalPlayer.Character if char then for
_,v in pairs(char:GetChildren())do if v.Name==name then table.insert(t,v)end end
end return t end local function getBackpackItems(name)VS.Backpack:WaitForChild(
name,1)local t={}for _,v in pairs(VS.Backpack:GetChildren())do if v.Name==name
then table.insert(t,v)end end return t end local function getItemStackMax(
itemName)local ok,fl=pcall(function()return require(ReplicatedStorage.Modules.
FunctionLibrary)end)if ok and fl and fl.DroppableItems and fl.DroppableItems[
itemName]and fl.DroppableItems[itemName].Max then return fl.DroppableItems[
itemName].Max end return maxLimits[itemName]or 999 end local function hasItem(
name,count)if count then return#getBpItems(name)==count end return getBpItem(
name)~=nil end local function sellItem(itemName,sellAll)pcall(unequipAllTools)
task.wait(0.12)local item=getBpItemBackpack(itemName)if not item then return end
item.Parent=getCharacter()task.wait()if sellAll then fireDialogue('Merchant',
'Dialogue5','Option2')else fireDialogue('Merchant','Dialogue5','Option1')end end
local function sellItems(itemsTable)for name in pairs(itemsTable)do for _,item
in pairs(getBackpackItems(name))do item.Parent=getCharacter()task.wait()
fireDialogue('Merchant','Dialogue5','Option2')task.wait()end end end
local function buyItems(itemsTable)for name in pairs(itemsTable)do pcall(
function()if isRibCagePurchaseItem(name)then purchaseRibCage()else
getRemoteEvent():FireServer('PurchaseShopItem',{ItemName=name})end end)end end
local function getStandMorph()return getCharacter():FindFirstChild('StandMorph')
end local function desummonStand()if getStandMorph()then pcall(function()
getRemoteFunction():InvokeServer('ToggleStand','Toggle')end)task.wait(0.5)end
end local function summonStand()if not getStandMorph()then pcall(function()
getRemoteFunction():InvokeServer('ToggleStand','Toggle')end)task.wait(0.12)end
end local function toggleStand()pcall(function()getRemoteFunction():
InvokeServer('ToggleStand','Toggle')end)end local function standController(
standMorph)if not standMorph then return nil end local hum=standMorph:
FindFirstChildOfClass('Humanoid')if hum then return hum end local ac=standMorph:
FindFirstChildOfClass('AnimationController')or standMorph:FindFirstChild(
'AnimationController')return ac end env.PlayerStats=PlayerStats env.PlayerLevel=
PlayerLevel env.PlayerPity=PlayerPity env.PlayerStand=PlayerStand env.
PlayerPrestige=PlayerPrestige env.PlayerSpec=PlayerSpec env.PlayerMoney=
PlayerMoney env.ClientFX=ClientFX env.Dialogues=Dialogues env.RIB_NAME=RIB_NAME
env.PlayerOwns2xInv=PlayerOwns2xInv env.sendWebhook=sendWebhook env.
refreshItemCounts=refreshItemCounts env.getCharacter=getCharacter env.
getRootPart=getRootPart env.giveClickTpTool=giveClickTpTool env.getHumanoid=
getHumanoid env.getRemoteEvent=getRemoteEvent env.isRibCagePurchaseItem=
isRibCagePurchaseItem env.purchaseRibCage=purchaseRibCage env.getRemoteFunction=
getRemoteFunction env.unequipAllTools=unequipAllTools env.waitUntilNewChar=
waitUntilNewChar env.getPing=getPing env.getQuests=getQuests env.getPity=getPity
env.roundTwo=roundTwo env.fireDialogue=fireDialogue env.finishDialogue=
finishDialogue env.learnSkill=learnSkill env.getBpItem=getBpItem env.getBpItems=
getBpItems env.getItemStackMax=getItemStackMax env.hasItem=hasItem env.sellItem=
sellItem env.sellItems=sellItems env.buyItems=buyItems env.getStandMorph=
getStandMorph env.desummonStand=desummonStand env.summonStand=summonStand env.
toggleStand=toggleStand env.standController=standController end end function
__DARKLUA_BUNDLE_MODULES.ap():typeof(__modImpl())local v=
__DARKLUA_BUNDLE_MODULES.cache.ap if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.ap=v end return v.c end end do local function
__modImpl()return function(env)local VS=env.VS local RunService=env.RunService
local ReplicatedStorage=env.ReplicatedStorage local UserInputService=env.
UserInputService local PhysicsService=env.PhysicsService local LocalPlayer=env.
LocalPlayer local getRemoteFunction=env.getRemoteFunction local getStandMorph=
env.getStandMorph local standController=env.standController local pilotEnabled=
false local flyingPilotEnabled=false VS.pilotSpeed=50 VS.pilotSpeedChanger=false
local pilotConns={}local flyingPilotConns={}local flyAnchors=nil VS.
standAnimController=nil VS.infPilotRangeEnabled=false VS.infPilotRangeConn=nil
local PILOT_DROP=35 local FLY_DROP=35 local FLY_MAX_HEIGHT=30 local function
cleanupPilot()if not pilotEnabled then return end pilotEnabled=false for _,conn
in pairs(pilotConns)do if conn then pcall(function()conn:Disconnect()end)end end
pilotConns={}VS.standAnimController=nil pcall(function()local tempStorage=
ReplicatedStorage:FindFirstChild('TempStoragePilot')if tempStorage then for _,v
in pairs(tempStorage:GetChildren())do if v.Name=="Naples' Sewers"then v.Parent=
workspace.Locations end end tempStorage:Destroy()end end)pcall(function()local
char=LocalPlayer.Character if char then if char:FindFirstChild('FocusCam')then
char.FocusCam:Destroy()end for _,v in pairs(char:GetDescendants())do if v:IsA(
'BasePart')then v.CanCollide=true end end end end)pcall(function()local
standMorph=getStandMorph()if standMorph then local standHRP=standMorph:
FindFirstChild('HumanoidRootPart')local char=LocalPlayer.Character local hrp=
char and char:FindFirstChild('HumanoidRootPart')if standHRP and hrp then hrp.
CFrame=standHRP.CFrame end getRemoteFunction():InvokeServer('ToggleStand',
'Toggle')end end)end local function cleanupFlyingPilot()if not
flyingPilotEnabled then return end flyingPilotEnabled=false for _,conn in pairs(
flyingPilotConns)do if conn then pcall(function()conn:Disconnect()end)end end
flyingPilotConns={}VS.standAnimController=nil pcall(function()local sm=
getStandMorph()if sm and sm.PrimaryPart then local standAttach=sm.PrimaryPart:
FindFirstChild('StandAttach')if standAttach then local ao=standAttach:
FindFirstChild('AlignOrientation')local ap=standAttach:FindFirstChild(
'AlignPosition')if ao then ao.Enabled=true end if ap then ap.Enabled=true end
end end end)pcall(function()if flyAnchors then for part,wasAnchored in pairs(
flyAnchors)do if part and part.Parent then pcall(function()part.Anchored=
wasAnchored end)end end flyAnchors=nil end end)pcall(function()local tempStorage
=ReplicatedStorage:FindFirstChild('TempStorageFlyingPilot')if tempStorage then
for _,v in pairs(tempStorage:GetChildren())do if v.Name=="Naples' Sewers"then v.
Parent=workspace.Locations end end tempStorage:Destroy()end end)pcall(function()
local char=LocalPlayer.Character if char then if char:FindFirstChild('FocusCam')
then char.FocusCam:Destroy()end for _,v in pairs(char:GetDescendants())do if v:
IsA('BasePart')then v.CanCollide=true end end end end)pcall(function()local
standMorph=getStandMorph()if standMorph then local standHRP=standMorph:
FindFirstChild('HumanoidRootPart')local char=LocalPlayer.Character local hrp=
char and char:FindFirstChild('HumanoidRootPart')if standHRP and hrp then hrp.
CFrame=standHRP.CFrame end getRemoteFunction():InvokeServer('ToggleStand',
'Toggle')end end)end local function togglePilot(v)if not v then cleanupPilot()
notify('Pilot','Stand Pilot disabled.','stop')return end if pilotEnabled then
cleanupPilot()notify('Pilot','Stand Pilot disabled.','stop')return end
cleanupFlyingPilot()local char=LocalPlayer.Character if not char then notify(
'Pilot','Character not loaded!','error')return end local hrp=char:
FindFirstChild('HumanoidRootPart')local hum=char:FindFirstChild('Humanoid')local
remoteFunc=char:FindFirstChild('RemoteFunction')if not hrp or not hum or not
remoteFunc then notify('Pilot','Character not ready!','error')return end if not
getStandMorph()then remoteFunc:InvokeServer('ToggleStand','Toggle')local waited=
0 repeat task.wait(0.1)waited+=0.1 until getStandMorph()or waited>5 if not
getStandMorph()then notify('Pilot','Failed to summon stand!','error')return end
end local standMorph=getStandMorph()VS.standAnimController=standController(
standMorph)local standHRP=standMorph:WaitForChild('HumanoidRootPart',3)if not VS
.standAnimController or not standHRP then notify('Pilot',
'Stand not properly loaded!','error')return end if VS.pilotSpeedChanger and VS.
standAnimController then pcall(function()VS.standAnimController.WalkSpeed=VS.
pilotSpeed end)end pilotEnabled=true pcall(function()local old=ReplicatedStorage
:FindFirstChild('TempStoragePilot')if old then old:Destroy()end end)local
tempStorage=Instance.new('Folder')tempStorage.Name='TempStoragePilot'tempStorage
.Parent=ReplicatedStorage pcall(function()for _,child in pairs(workspace.
Locations:GetChildren())do if child.Name=="Naples' Sewers"then child.Parent=
tempStorage end end end)pcall(function()local old=char:FindFirstChild('FocusCam'
)if old then old:Destroy()end end)local focusCam=Instance.new('ObjectValue')
focusCam.Name='FocusCam'focusCam.Value=VS.standAnimController focusCam.Parent=
standMorph.Parent for _,part in pairs(char:GetDescendants())do if part:IsA(
'BasePart')then part.CanCollide=false end end pcall(function()local standAttach=
standMorph.PrimaryPart and standMorph.PrimaryPart:FindFirstChild('StandAttach')
if standAttach then local ao=standAttach:FindFirstChild('AlignOrientation')local
ap=standAttach:FindFirstChild('AlignPosition')if ao then ao.Enabled=false end if
ap then ap.Enabled=false end end end)table.insert(pilotConns,UserInputService.
JumpRequest:Connect(function()if not pilotEnabled or not VS.standAnimController
then return end pcall(function()VS.standAnimController.Jump=true end)end))table.
insert(pilotConns,RunService.Heartbeat:Connect(function()if not pilotEnabled
then return end if not char or not char.Parent then cleanupPilot()return end if
not standMorph or not standMorph.Parent then pcall(function()remoteFunc:
InvokeServer('ToggleStand','Toggle')end)return end local moveDir=workspace.
CurrentCamera.CFrame:VectorToObjectSpace(hum.MoveDirection)if VS.
standAnimController and type(VS.standAnimController.Move)=='function'then VS.
standAnimController:Move(moveDir,true)end if VS.pilotSpeedChanger then pcall(
function()VS.standAnimController.WalkSpeed=VS.pilotSpeed end)end if standHRP and
hrp then pcall(function()hrp.CFrame=standHRP.CFrame-Vector3.new(0,PILOT_DROP,0)
hrp.AssemblyLinearVelocity=Vector3.zero hrp.AssemblyAngularVelocity=Vector3.zero
end)end end))local function setPlayersGroup(inst)if not inst or not inst.Parent
then return end if inst:IsA('BasePart')or inst:IsA('UnionOperation')then pcall(
function()PhysicsService:SetPartCollisionGroup(inst,'Players')end)end end pcall(
function()for _,v in pairs(standMorph.Parent:GetDescendants())do
setPlayersGroup(v)end end)table.insert(pilotConns,char.DescendantAdded:Connect(
function(inst)if not pilotEnabled then return end setPlayersGroup(inst)end))
notify('Pilot','Stand Pilot enabled!','start')end local function
toggleFlyingPilot(v)if not v then cleanupFlyingPilot()notify('Pilot',
'Flying Pilot disabled.','stop')return end if flyingPilotEnabled then
cleanupFlyingPilot()notify('Pilot','Flying Pilot disabled.','stop')return end
cleanupPilot()local char=LocalPlayer.Character if not char then notify('Pilot',
'Character not loaded!','error')return end local hrp=char:FindFirstChild(
'HumanoidRootPart')local hum=char:FindFirstChild('Humanoid')local remoteFunc=
char:FindFirstChild('RemoteFunction')if not hrp or not hum or not remoteFunc
then notify('Pilot','Character not ready!','error')return end if not
getStandMorph()then remoteFunc:InvokeServer('ToggleStand','Toggle')local waited=
0 repeat task.wait(0.1)waited+=0.1 until getStandMorph()or waited>5 if not
getStandMorph()then notify('Pilot','Failed to summon stand!','error')return end
end local standMorph=getStandMorph()VS.standAnimController=standController(
standMorph)local standHRP=standMorph:WaitForChild('HumanoidRootPart',3)if not VS
.standAnimController or not standHRP then notify('Pilot',
'Stand not properly loaded!','error')return end if VS.pilotSpeedChanger and VS.
standAnimController then pcall(function()VS.standAnimController.WalkSpeed=VS.
pilotSpeed end)end flyingPilotEnabled=true pcall(function()local old=
ReplicatedStorage:FindFirstChild('TempStorageFlyingPilot')if old then old:
Destroy()end end)local tempStorage=Instance.new('Folder')tempStorage.Name=
'TempStorageFlyingPilot'tempStorage.Parent=ReplicatedStorage pcall(function()for
_,child in pairs(workspace.Locations:GetChildren())do if child.Name==
"Naples' Sewers"then child.Parent=tempStorage end end end)pcall(function()local
old=char:FindFirstChild('FocusCam')if old then old:Destroy()end end)local
focusCam=Instance.new('ObjectValue')focusCam.Name='FocusCam'focusCam.Value=VS.
standAnimController focusCam.Parent=char for _,part in pairs(char:
GetDescendants())do if part:IsA('BasePart')then part.CanCollide=false end end
pcall(function()local standAttach=standMorph.PrimaryPart and standMorph.
PrimaryPart:FindFirstChild('StandAttach')if standAttach then local ao=
standAttach:FindFirstChild('AlignOrientation')local ap=standAttach:
FindFirstChild('AlignPosition')if ao then ao.Enabled=false end if ap then ap.
Enabled=false end end end)table.insert(flyingPilotConns,UserInputService.
JumpRequest:Connect(function()if not flyingPilotEnabled or not VS.
standAnimController then return end pcall(function()VS.standAnimController.Jump=
true end)end))local flyLastT=os.clock()local standFlyPos=standHRP.Position do
local rp0=RaycastParams.new()rp0.FilterType=Enum.RaycastFilterType.Exclude rp0.
FilterDescendantsInstances={char,standMorph}local h0=workspace:Raycast(
standFlyPos+Vector3.new(0,8,0),Vector3.new(0,-800,0),rp0)if h0 then local mx=h0.
Position.Y+FLY_MAX_HEIGHT if standFlyPos.Y>mx then standFlyPos=Vector3.new(
standFlyPos.X,mx,standFlyPos.Z)end end end table.insert(flyingPilotConns,
RunService.Heartbeat:Connect(function()if not flyingPilotEnabled then return end
if not char or not char.Parent then cleanupFlyingPilot()return end if not
standMorph or not standMorph.Parent then pcall(function()remoteFunc:
InvokeServer('ToggleStand','Toggle')end)return end if VS.pilotSpeedChanger then
pcall(function()VS.standAnimController.WalkSpeed=VS.pilotSpeed end)end local now
=os.clock()local dt=math.clamp(now-flyLastT,1/240,0.1)flyLastT=now local cam=
workspace.CurrentCamera local lv=cam.CFrame.LookVector local moveDir=cam.CFrame:
VectorToObjectSpace(hum.MoveDirection)if VS.standAnimController and type(VS.
standAnimController.Move)=='function'then VS.standAnimController:Move(moveDir,
true)end local fwd=cam.CFrame.LookVector local rgt=cam.CFrame.RightVector local
keyFly=Vector3.zero if UserInputService:IsKeyDown(Enum.KeyCode.W)then keyFly+=
fwd end if UserInputService:IsKeyDown(Enum.KeyCode.S)then keyFly-=fwd end if
UserInputService:IsKeyDown(Enum.KeyCode.D)then keyFly+=rgt end if
UserInputService:IsKeyDown(Enum.KeyCode.A)then keyFly-=rgt end local spd=VS.
pilotSpeedChanger and VS.pilotSpeed or 50 if keyFly.Magnitude>1e-4 then
standFlyPos=standFlyPos+keyFly.Unit*(spd*dt)end do local origin=standFlyPos+
Vector3.new(0,8,0)local rp=RaycastParams.new()rp.FilterType=Enum.
RaycastFilterType.Exclude rp.FilterDescendantsInstances={char,standMorph}local
hit=workspace:Raycast(origin,Vector3.new(0,-1200,0),rp)if hit then local mxY=hit
.Position.Y+FLY_MAX_HEIGHT if standFlyPos.Y>mxY then standFlyPos=Vector3.new(
standFlyPos.X,mxY,standFlyPos.Z)end end end local charPos=standFlyPos-Vector3.
new(0,FLY_DROP,0)local flat=Vector3.new(lv.X,0,lv.Z)pcall(function()if flat.
Magnitude>0.08 then local look=flat.Unit standHRP.CFrame=CFrame.new(standFlyPos,
standFlyPos+look)hrp.CFrame=CFrame.new(charPos,charPos+look)else standHRP.CFrame
=CFrame.new(standFlyPos)hrp.CFrame=CFrame.new(charPos)end standHRP.
AssemblyLinearVelocity=Vector3.zero standHRP.AssemblyAngularVelocity=Vector3.
zero hrp.AssemblyLinearVelocity=Vector3.zero hrp.AssemblyAngularVelocity=Vector3
.zero for _,p in ipairs(standMorph:GetDescendants())do if p:IsA('BasePart')then
p.AssemblyLinearVelocity=Vector3.zero p.AssemblyAngularVelocity=Vector3.zero end
end end)end))pcall(function()for _,inst in pairs(char:GetDescendants())do if
inst:IsA('BasePart')then pcall(function()PhysicsService:SetPartCollisionGroup(
inst,'Players')end)end end end)notify('Pilot',
[[Flying Pilot ON: WASD vs camera (W along look, incl. up/down). Stand max ]]..
tostring(FLY_MAX_HEIGHT)..' studs above ground; you stay '..tostring(FLY_DROP)..
' under the stand.',nil,'start')end env.cleanupPilot=cleanupPilot env.
cleanupFlyingPilot=cleanupFlyingPilot env.togglePilot=togglePilot env.
toggleFlyingPilot=toggleFlyingPilot end end function __DARKLUA_BUNDLE_MODULES.aq
():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.aq if not v then v=
{c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.aq=v end return v.c end end do
local function __modImpl()return function(env)local VS=env.VS local Players=env.
Players local RunService=env.RunService local UserInputService=env.
UserInputService local LocalPlayer=env.LocalPlayer local getStandMorph=env.
getStandMorph local function notify(...)return env.notify(...)end local function
enableNoclip(...)return env.enableNoclip(...)end local function disableNoclip(
...)return env.disableNoclip(...)end VS.stickerEnabled=false VS.
stickerTargetName=''VS.stickerMethod='normal'local activeAligns={}local
curTargetForEntity={}local saCleanupAlignFor=nil local saEnableOrbitCamera=nil
local saDisableOrbitCamera=nil VS.stickerToggleRef=nil VS.viewToggleRef=nil VS.
saViewSettingFromCode=false VS.flyToggleRef=nil VS.invisToggleRef=nil VS.
playerESPToggleRef=nil VS.wsToggleRef=nil VS.suppressConfigLoadNotifications=
false(function()local SA_BACK_DISTANCE=2 local SA_BACK_HEIGHT=0.5 local
SA_PLAYER_HEIGHT=20 local SA_RESP=250 local SA_ALIGN_MAX_FORCE=1e7 local
SA_RESCAN=1 local SA_LERP=0.85 local saScanTimer=0 local saModelCache={}local
saViewing=false local saPrevCamSubject=nil local saPrevCamType=nil local
saViewingStand=nil local saOrbit={yaw=0,pitch=0,radius=8,minRadius=2,maxRadius=
60,sensitivity=0.0035,pitchMin=-math.pi/2+0.1,pitchMax=math.pi/2-0.1,dragging=
false,inputChangedConn=nil,inputBeganConn=nil,inputEndedConn=nil,renderConn=nil}
local function saIsCharacterModel(m)if not m or not m:IsA('Model')then return
false end return m:FindFirstChild('Humanoid')and m:FindFirstChild(
'HumanoidRootPart')end local function saRebuildModelCache()saModelCache={}for _,
child in ipairs(workspace:GetChildren())do if saIsCharacterModel(child)then
table.insert(saModelCache,child)else for _,c2 in ipairs(child:GetChildren())do
if saIsCharacterModel(c2)then table.insert(saModelCache,c2)end end end end for _
,pl in ipairs(Players:GetPlayers())do if pl~=LocalPlayer and pl.Character and
saIsCharacterModel(pl.Character)then table.insert(saModelCache,pl.Character)end
end end saRebuildModelCache()workspace.ChildAdded:Connect(function(c)if
saIsCharacterModel(c)then table.insert(saModelCache,c)else for _,c2 in ipairs(c:
GetChildren())do if saIsCharacterModel(c2)then table.insert(saModelCache,c2)end
end end end)workspace.ChildRemoved:Connect(function(c)for i=#saModelCache,1,-1
do if saModelCache[i]==c then table.remove(saModelCache,i)end end end)Players.
PlayerAdded:Connect(function(pl)pl.CharacterAdded:Connect(function(ch)if
saIsCharacterModel(ch)then table.insert(saModelCache,ch)end end)end)Players.
PlayerRemoving:Connect(function(pl)if pl.Character then for i=#saModelCache,1,-1
do if saModelCache[i]==pl.Character then table.remove(saModelCache,i)end end end
end)local function saFindClosestByName(name)if not name or name==''then return
nil end local root=LocalPlayer.Character and LocalPlayer.Character:
FindFirstChild('HumanoidRootPart')if not root then return nil end local rootPos=
root.Position local lower=name:lower()local closest,minD=nil,math.huge for _,pl
in ipairs(Players:GetPlayers())do if pl~=LocalPlayer and pl.Character and pl.
Character:FindFirstChild('HumanoidRootPart')then local match=pl.Name:lower():
find(lower)or(pl.DisplayName and pl.DisplayName:lower():find(lower))if match
then local hrp=pl.Character:FindFirstChild('HumanoidRootPart')local hum=pl.
Character:FindFirstChild('Humanoid')if hrp and hum and hum.Health>0 then local d
=(hrp.Position-rootPos).Magnitude if d<minD then minD,closest=d,pl.Character end
end end end end for _,model in ipairs(saModelCache)do if model and model.Parent
and model~=LocalPlayer.Character then if model.Name:lower():find(lower)then
local hrp=model:FindFirstChild('HumanoidRootPart')local hum=model:
FindFirstChild('Humanoid')if hrp and hum and hum.Health>0 then local d=(hrp.
Position-rootPos).Magnitude if d<minD then minD,closest=d,model end end end end
end return closest end saCleanupAlignFor=function(entity)if not entity then
return end local hrp=entity:FindFirstChild('HumanoidRootPart')if hrp then for _,
c in ipairs(hrp:GetChildren())do if tostring(c.Name):match('^Stick_')then c:
Destroy()end end end activeAligns[entity]=nil curTargetForEntity[entity]=nil end
local function saCreateAlignsFor(entity,targetHRP,stickMode)if not entity or not
targetHRP then return nil end saCleanupAlignFor(entity)local hrp=entity:
FindFirstChild('HumanoidRootPart')or entity:FindFirstChild('Torso')or entity:
FindFirstChild('UpperTorso')if not hrp then local ok ok,hrp=pcall(function()
return entity:WaitForChild('HumanoidRootPart',0.5)end)if not ok then hrp=nil end
end if not hrp then return nil end local offset=Vector3.new(0,0,0)if stickMode==
'back'then offset=Vector3.new(0,SA_BACK_HEIGHT,-SA_BACK_DISTANCE)end local attA=
Instance.new('Attachment')attA.Name='Stick_AttA'attA.Parent=hrp attA.Position=
Vector3.new(0,0,0)local attB=Instance.new('Attachment')attB.Name='Stick_AttB'
attB.Parent=targetHRP attB.Position=offset local alignPos=Instance.new(
'AlignPosition')alignPos.Name='Stick_AlignPos'alignPos.Attachment0=attA alignPos
.Attachment1=attB alignPos.MaxForce=SA_ALIGN_MAX_FORCE alignPos.Responsiveness=
SA_RESP alignPos.RigidityEnabled=false alignPos.Parent=hrp local alignOri=
Instance.new('AlignOrientation')alignOri.Name='Stick_AlignOri'alignOri.
Attachment0=attA alignOri.Attachment1=attB alignOri.MaxTorque=SA_ALIGN_MAX_FORCE
alignOri.Responsiveness=SA_RESP alignOri.Parent=hrp activeAligns[entity]={attA=
attA,attB=attB,alignPos=alignPos,alignOri=alignOri,stickMode=stickMode}
curTargetForEntity[entity]=targetHRP return activeAligns[entity]end
local function saSmoothFallback(entity,targetHRP,stickMode,isAlive)local hrp=
entity and entity:FindFirstChild('HumanoidRootPart')if not hrp or not targetHRP
then return end local desiredPos if stickMode=='back'then desiredPos=targetHRP.
Position-targetHRP.CFrame.LookVector*SA_BACK_DISTANCE+Vector3.new(0,
SA_BACK_HEIGHT,0)elseif stickMode=='Down'then local h=isAlive and-
SA_PLAYER_HEIGHT or SA_PLAYER_HEIGHT desiredPos=targetHRP.Position+Vector3.new(0
,h,0)elseif stickMode=='Up'then local h=isAlive and SA_PLAYER_HEIGHT or-
SA_PLAYER_HEIGHT desiredPos=targetHRP.Position+Vector3.new(0,h,0)else return end
local look=-Vector3.new(targetHRP.CFrame.LookVector.X,0,targetHRP.CFrame.
LookVector.Z).Unit local yaw=math.atan2(look.X,look.Z)local desiredCFrame=CFrame
.new(desiredPos)*CFrame.Angles(0,yaw,0)hrp.CFrame=hrp.CFrame:Lerp(desiredCFrame,
SA_LERP)end saEnableOrbitCamera=function(stand)if not stand or not stand:
FindFirstChild('HumanoidRootPart')then notify('Stand Attach',
"Can't view: stand missing HRP.",'error')return end saViewingStand=stand local
cam=workspace.CurrentCamera saPrevCamSubject=cam.CameraSubject saPrevCamType=cam
.CameraType local standPos=stand.HumanoidRootPart.Position local toStand=cam.
CFrame.Position-standPos saOrbit.radius=math.clamp(toStand.Magnitude,saOrbit.
minRadius,saOrbit.maxRadius)local dir=toStand.Unit saOrbit.pitch=math.asin(math.
clamp(dir.Y,-1,1))*-1 saOrbit.yaw=math.atan2(dir.X,dir.Z)cam.CameraType=Enum.
CameraType.Scriptable saOrbit.inputBeganConn=UserInputService.InputBegan:
Connect(function(input,processed)if processed then return end if input.
UserInputType==Enum.UserInputType.MouseButton2 then saOrbit.dragging=true
UserInputService.MouseIconEnabled=false end end)saOrbit.inputEndedConn=
UserInputService.InputEnded:Connect(function(input)if input.UserInputType==Enum.
UserInputType.MouseButton2 then saOrbit.dragging=false UserInputService.
MouseIconEnabled=true end end)saOrbit.inputChangedConn=UserInputService.
InputChanged:Connect(function(input,processed)if input.UserInputType==Enum.
UserInputType.MouseMovement and saOrbit.dragging then saOrbit.yaw=saOrbit.yaw-
input.Delta.X*saOrbit.sensitivity saOrbit.pitch=math.clamp(saOrbit.pitch-input.
Delta.Y*saOrbit.sensitivity,saOrbit.pitchMin,saOrbit.pitchMax)elseif input.
UserInputType==Enum.UserInputType.MouseWheel then saOrbit.radius=math.clamp(
saOrbit.radius-input.Position.Z,saOrbit.minRadius,saOrbit.maxRadius)end end)
saOrbit.renderConn=RunService.RenderStepped:Connect(function()if not saViewing
or not saViewingStand or not saViewingStand.Parent then return end local hrp2=
saViewingStand:FindFirstChild('HumanoidRootPart')if not hrp2 then return end
local sp=hrp2.Position local rot=CFrame.Angles(saOrbit.pitch,saOrbit.yaw,0)local
off=rot:VectorToWorldSpace(Vector3.new(0,0,saOrbit.radius))workspace.
CurrentCamera.CFrame=CFrame.new(sp+off,sp)end)notify('Stand Attach',
'Now viewing your stand.','info')saViewing=true end saDisableOrbitCamera=
function()saViewing=false saViewingStand=nil if saOrbit.inputChangedConn then
saOrbit.inputChangedConn:Disconnect()saOrbit.inputChangedConn=nil end if saOrbit
.inputBeganConn then saOrbit.inputBeganConn:Disconnect()saOrbit.inputBeganConn=
nil end if saOrbit.inputEndedConn then saOrbit.inputEndedConn:Disconnect()
saOrbit.inputEndedConn=nil end if saOrbit.renderConn then saOrbit.renderConn:
Disconnect()saOrbit.renderConn=nil end pcall(function()local cam=workspace.
CurrentCamera if saPrevCamSubject then cam.CameraSubject=saPrevCamSubject end if
saPrevCamType then cam.CameraType=saPrevCamType end end)UserInputService.
MouseIconEnabled=true notify('Stand Attach','Camera restored.','info')end
RunService.Heartbeat:Connect(function(dt)saScanTimer=saScanTimer+dt if
saScanTimer>=SA_RESCAN then saRebuildModelCache()saScanTimer=0 end if saViewing
then if not saViewingStand or not saViewingStand.Parent or not saViewingStand:
FindFirstChild('HumanoidRootPart')then saDisableOrbitCamera()if VS.viewToggleRef
then VS.saViewSettingFromCode=true VS.viewToggleRef:Set(false)VS.
saViewSettingFromCode=false end end end if not VS.stickerEnabled then return end
local name=VS.stickerTargetName if not name or name==''then return end local
stand=getStandMorph()if not stand then return end local target=
saFindClosestByName(name)if not target then if next(activeAligns)~=nil then
notify('Stand Attach','No alive target found (died?), turning off.','warn')if VS
.stickerToggleRef then VS.stickerToggleRef:Set(false)end if VS.viewToggleRef
then VS.saViewSettingFromCode=true VS.viewToggleRef:Set(false)VS.
saViewSettingFromCode=false end for entity,_ in pairs(activeAligns)do
saCleanupAlignFor(entity)end end return end local targetHRP=target:
FindFirstChild('HumanoidRootPart')local targetHum=target:FindFirstChild(
'Humanoid')local isAlive=targetHum and targetHum.Health>0 if not targetHRP or
not targetHum then for entity,_ in pairs(activeAligns)do saCleanupAlignFor(
entity)end return end local myChar=LocalPlayer.Character if stand and
curTargetForEntity[stand]~=targetHRP then local ok,res=pcall(saCreateAlignsFor,
stand,targetHRP,'back')if not ok or not res then saCleanupAlignFor(stand)end end
if VS.stickerMethod=='Down'or VS.stickerMethod=='Up'then if myChar and
curTargetForEntity[myChar]~=targetHRP then local ok,res=pcall(saCreateAlignsFor,
myChar,targetHRP,VS.stickerMethod)if not ok or not res then saCleanupAlignFor(
myChar)end end else if myChar then saCleanupAlignFor(myChar)end end for entity,
alignData in pairs(activeAligns)do if alignData and alignData.attB and alignData
.attB.Parent==targetHRP then local desiredWorldPos if alignData.stickMode==
'back'then desiredWorldPos=targetHRP.Position-targetHRP.CFrame.LookVector*
SA_BACK_DISTANCE+Vector3.new(0,SA_BACK_HEIGHT,0)elseif alignData.stickMode==
'Down'then local h=isAlive and-SA_PLAYER_HEIGHT or SA_PLAYER_HEIGHT
desiredWorldPos=targetHRP.Position+Vector3.new(0,h,0)elseif alignData.stickMode
=='Up'then local h=isAlive and SA_PLAYER_HEIGHT or-SA_PLAYER_HEIGHT
desiredWorldPos=targetHRP.Position+Vector3.new(0,h,0)end if desiredWorldPos then
alignData.attB.Position=targetHRP.CFrame:PointToObjectSpace(desiredWorldPos)end
else pcall(saSmoothFallback,entity,targetHRP,alignData.stickMode,isAlive)end end
if(VS.stickerMethod=='Down'or VS.stickerMethod=='Up')and isAlive then
enableNoclip()elseif VS.stickerMethod~='Down'and VS.stickerMethod~='Up'then
disableNoclip()end end)end)()env.activeAligns=activeAligns env.saCleanupAlignFor
=saCleanupAlignFor env.saEnableOrbitCamera=saEnableOrbitCamera env.
saDisableOrbitCamera=saDisableOrbitCamera end end function
__DARKLUA_BUNDLE_MODULES.ar():typeof(__modImpl())local v=
__DARKLUA_BUNDLE_MODULES.cache.ar if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.ar=v end return v.c end end do local function
__modImpl()return function(env)local Window=env.Window local FluentNotify=env.
FluentNotify local VS=env.VS local RunService=env.RunService local LocalPlayer=
env.LocalPlayer local PlayerGui=env.PlayerGui local getCharacter=env.
getCharacter local getRootPart=env.getRootPart local getHumanoid=env.getHumanoid
local learnSkill=env.learnSkill local getBpItem=env.getBpItem local notify=nil
local enableNoclip=nil local disableNoclip=nil local function hasStandSkill(
skillName)local node=LocalPlayer:FindFirstChild('StandSkillTree')if not node
then return false end local skill=node:FindFirstChild(skillName)return skill and
skill.Value or false end local function hasSpecSkill(skillName)local node=
LocalPlayer:FindFirstChild('SpecSkillTree')if not node then return nil end local
skill=node:FindFirstChild(skillName)return skill and skill.Value or nil end
local noclipEnabled=false local noclipConn=nil enableNoclip=function()if
noclipEnabled then return end local NOCLIP_PARTS={'HumanoidRootPart','Head',
'LeftArm','RightArm','LeftLeg','RightLeg','UpperTorso','LowerTorso','Torso'}
noclipConn=RunService.Stepped:Connect(function()local c=LocalPlayer.Character if
not c then return end for _,name in ipairs(NOCLIP_PARTS)do local p=c:
FindFirstChild(name)if p and p:IsA('BasePart')then p.CanCollide=false end end
end)noclipEnabled=true end disableNoclip=function()if noclipConn then noclipConn
:Disconnect()noclipConn=nil end noclipEnabled=false end local flyEnabled=false
VS.flySpeed=50 local flyConn=nil local function toggleFly(v)flyEnabled=v if
flyConn then flyConn:Disconnect()flyConn=nil end if flyEnabled then flyConn=
RunService.RenderStepped:Connect(function()local char=LocalPlayer.Character if
not char then return end local hrp=char:FindFirstChild('HumanoidRootPart')local
hum=char:FindFirstChild('Humanoid')if not hrp or not hum then return end local
bv=hrp:FindFirstChild('PulseFlyBV')if not bv then bv=Instance.new('BodyVelocity'
)bv.Name='PulseFlyBV'bv.MaxForce=Vector3.new(math.huge,math.huge,math.huge)bv.
Velocity=Vector3.zero bv.Parent=hrp end local bg=hrp:FindFirstChild('PulseFlyBG'
)if not bg then bg=Instance.new('BodyGyro')bg.Name='PulseFlyBG'bg.MaxTorque=
Vector3.new(math.huge,math.huge,math.huge)bg.CFrame=hrp.CFrame bg.Parent=hrp end
hrp.Velocity=Vector3.zero local cam=workspace.CurrentCamera if not cam then
return end local md=hum.MoveDirection local mdH=Vector3.new(md.X,0,md.Z)local
mdHMag=mdH.Magnitude local vel=Vector3.zero if mdHMag>0.01 then local look=cam.
CFrame.LookVector local right=cam.CFrame.RightVector local lookH=Vector3.new(
look.X,0,look.Z)local rightH=Vector3.new(right.X,0,right.Z)if lookH.Magnitude>
0.001 then lookH=lookH.Unit else lookH=Vector3.new(0,0,-1)end if rightH.
Magnitude>0.001 then rightH=rightH.Unit else rightH=Vector3.new(1,0,0)end local
mdHN=mdH/mdHMag local forwardAmount=mdHN:Dot(lookH)local strafeAmount=mdHN:Dot(
rightH)local dir=look*forwardAmount+right*strafeAmount if dir.Magnitude>0.001
then vel=dir.Unit*VS.flySpeed*math.clamp(mdHMag,0,1)end end bv.Velocity=vel bg.
CFrame=cam.CFrame end)else pcall(function()local hrp=getRootPart()if hrp:
FindFirstChild('PulseFlyBV')then hrp.PulseFlyBV:Destroy()end if hrp:
FindFirstChild('PulseFlyBG')then hrp.PulseFlyBG:Destroy()end end)end end
local function teleportToRandom()local char=LocalPlayer.Character if not char or
not char:FindFirstChild('HumanoidRootPart')then return end char.HumanoidRootPart
.CFrame=CFrame.new(math.random(-590,590),250,math.random(-520,530))end
local function teleportUp()local hrp=getRootPart()local fallY=workspace.
FallenPartsDestroyHeight local p=hrp.Position if p.Y<fallY+100 then hrp.Position
=Vector3.new(p.X,fallY+180,p.Z)end hrp.Anchored=true hrp.AssemblyLinearVelocity=
Vector3.zero hrp.AssemblyAngularVelocity=Vector3.zero local pad=Instance.new(
'Part')pad.Name=tostring(math.random(1,6764))pad.Anchored=true pad.Size=Vector3.
new(150,1,150)pad.Transparency=1 pad.CFrame=hrp.CFrame*CFrame.new(0,200,0)pad.
Parent=workspace hrp.CFrame=pad.CFrame*CFrame.new(0,6,0)hrp.Anchored=false task.
delay(15,function()pad:Destroy()end)end local function teleportUpTemp()local hrp
=getRootPart()local pad=Instance.new('Part')pad.Name=tostring(math.random(1,100)
)pad.Anchored=true pad.Size=Vector3.new(999,1,999)pad.Transparency=1 pad.CFrame=
hrp.CFrame*CFrame.new(0,210,0)pad.Parent=workspace hrp.CFrame=pad.CFrame*CFrame.
new(0,2,0)task.delay(15,function()pad:Destroy()end)end local function useItem(
itemName)local item=getBpItem(itemName)if not item then Window:Notify({title=
'Pulse',content='No '..itemName..' found!',duration=4})return false end
getHumanoid():EquipTool(item)local inChar=getCharacter():WaitForChild(itemName,3
)if not inChar then return false end repeat pcall(function()inChar:Activate()end
)task.wait()until PlayerGui:FindFirstChild('DialogueGui')local dialogueGui=
PlayerGui:FindFirstChild('DialogueGui')local startTime=tick()while dialogueGui
and dialogueGui.Parent and tick()-startTime<5 do pcall(function()local frame=
dialogueGui:FindFirstChild('Frame')if not frame then return end local
clickContinue=frame:FindFirstChild('ClickContinue')if clickContinue then for _,
conn in pairs(getconnections(clickContinue.MouseButton1Click))do conn:Fire()end
end local options=frame:FindFirstChild('Options')if options then local option1=
options:FindFirstChild('Option1')if option1 then local textButton=option1:
FindFirstChild('TextButton')if textButton then for _,conn in pairs(
getconnections(textButton.MouseButton1Click))do conn:Fire()end end end end end)
task.wait(0.1)dialogueGui=PlayerGui:FindFirstChild('DialogueGui')end return true
end local function clickOption1()local dialogueGui=PlayerGui:FindFirstChild(
'DialogueGui')local startTime=tick()while dialogueGui and dialogueGui.Parent and
tick()-startTime<3 do pcall(function()local frame=dialogueGui:FindFirstChild(
'Frame')if not frame then return end local cc=frame:FindFirstChild(
'ClickContinue')if cc then for _,conn in pairs(getconnections(cc.
MouseButton1Click))do conn:Fire()end end task.wait(0.05)local opts=frame:
FindFirstChild('Options')local opt1=opts and opts:FindFirstChild('Option1')local
btn=opt1 and opt1:FindFirstChild('TextButton')if btn then for _,conn in pairs(
getconnections(btn.MouseButton1Click))do conn:Fire()end end end)task.wait(0.1)
dialogueGui=PlayerGui:FindFirstChild('DialogueGui')end end local function
learnWorthiness()for _,skill in ipairs({'Worthiness','Worthiness II',
'Worthiness III','Worthiness IV','Worthiness V'})do learnSkill(skill,'Character'
)task.wait(0.1)end end VS.registeredItems={}local promptToName={}local
promptConns={}local function unregisterPrompt(prompt)local name=promptToName[
prompt]if not name then return end if promptConns[prompt]then promptConns[prompt
]:Disconnect()promptConns[prompt]=nil end promptToName[prompt]=nil if VS.
registeredItems[name]then local idx=table.find(VS.registeredItems[name],prompt)
if idx then table.remove(VS.registeredItems[name],idx)end if#VS.registeredItems[
name]==0 then VS.registeredItems[name]=nil end end end local function
registerPrompt(obj)if obj.ClassName~='ProximityPrompt'then return end if obj.
Enabled then return end if not obj.Parent:FindFirstChild('PointLight',true)then
return end local mesh=obj.Parent:FindFirstChildWhichIsA('MeshPart')or obj.Parent
:FindFirstChildWhichIsA('Part')if mesh and mesh.Transparency>=1 then return end
local name=obj.ObjectText if not VS.registeredItems[name]then VS.registeredItems
[name]={}end if table.find(VS.registeredItems[name],obj)then return end table.
insert(VS.registeredItems[name],obj)promptToName[obj]=name promptConns[obj]=obj.
AncestryChanged:Connect(function()if not obj:IsDescendantOf(workspace)then
unregisterPrompt(obj)end end)end pcall(function()for _,v in pairs(workspace.
Item_Spawns.Items:GetDescendants())do registerPrompt(v)end workspace.Item_Spawns
.Items.DescendantAdded:Connect(registerPrompt)workspace.Item_Spawns.Items.
DescendantRemoving:Connect(unregisterPrompt)end)notify=function(title,msg,
duration,kindOrOpts)if VS.suppressConfigLoadNotifications then return end local
dur=duration local kind=kindOrOpts if type(duration)=='string'and kind==nil then
kind=duration dur=nil end dur=dur or 5 local payload={title='Pulse'..(title~=''
and(' | '..title)or''),content=msg,duration=dur}local iconName if type(kind)==
'table'then if kind.Icon~=nil then iconName=kind.Icon end if kind.Image~=nil
then payload.icon=kind.Image end if type(kind.Duration)=='number'and kind.
Duration==kind.Duration and kind.Duration>0 then payload.duration=kind.Duration
end elseif type(kind)=='string'then local k=string.lower(kind)if k=='error'or k
=='fail'or k=='failure'then iconName='dismiss-circle-24-filled'elseif k==
'success'or k=='ok'then iconName='checkmark-circle-24-filled'elseif k=='warn'or
k=='warning'then iconName='error-circle-24-filled'elseif k=='info'then iconName=
'info-24-filled'elseif k=='start'or k=='enabled'or k=='on'then iconName=
'checkmark-starburst-24-filled'elseif k=='stop'or k=='disabled'or k=='off'then
iconName='error-circle-24-filled'end end FluentNotify(payload,iconName)end env.
notify=notify env.enableNoclip=enableNoclip env.disableNoclip=disableNoclip env.
hasStandSkill=hasStandSkill env.hasSpecSkill=hasSpecSkill env.toggleFly=
toggleFly env.teleportUp=teleportUp env.teleportUpTemp=teleportUpTemp env.
useItem=useItem env.learnWorthiness=learnWorthiness end end function
__DARKLUA_BUNDLE_MODULES.as():typeof(__modImpl())local v=
__DARKLUA_BUNDLE_MODULES.cache.as if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.as=v end return v.c end end do local function
__modImpl()return function(env)local Window=env.Window local VS=env.VS local
TeleportService=env.TeleportService local pulseIsMobile=env.pulseIsMobile local
farmEnsureNoclip=env.farmEnsureNoclip local farmThrottledHeartbeat=env.
farmThrottledHeartbeat local farmStepWait=env.farmStepWait local LocalPlayer=env
.LocalPlayer local PlayerStand=env.PlayerStand local PlayerOwns2xInv=env.
PlayerOwns2xInv local refreshItemCounts=env.refreshItemCounts local getRootPart=
env.getRootPart local getPing=env.getPing local getBpItems=env.getBpItems local
getItemStackMax=env.getItemStackMax local sellItem=env.sellItem local buyItems=
env.buyItems local desummonStand=env.desummonStand local notify=env.notify local
maxLimits={['Mysterious Arrow']=25,['Rokakaka']=25,['Gold Coin']=45,['Diamond']=
25,['Pure Rokakaka']=999,["Quinton's Glove"]=10,['Steel Ball']=10,[
"Rib Cage of The Saint's Corpse"]=10,["Zeppeli's Headband"]=10,["Zeppeli's Hat"]
=10,["Caesar's Headband"]=10,['Clackers']=10,['Stone Mask']=10,['Ancient Scroll'
]=10,["Dio's Diary"]=10,['Lucky Stone Mask']=999,['Lucky Arrow']=999,[
'Gold Umbrella']=999,['Christmas Present']=999}local items={}local function
updateItems()for item in pairs(maxLimits)do items[item]=0 end local function
countIn(container)if not container then return end for _,v in pairs(container:
GetChildren())do if v and v.Name and maxLimits[v.Name]then items[v.Name]=(items[
v.Name]or 0)+1 end end end countIn(VS.Backpack)if LocalPlayer.Character then
countIn(LocalPlayer.Character)end end local nonSellable={'Blue Candy',
'Red Candy','Green Candy','Yellow Candy','Lucky Arrow','Lucky Stone Mask',
'Christmas Present'}VS.nonSellableSet={}for _,n in ipairs(nonSellable)do VS.
nonSellableSet[n]=true end local worthlessItems={'Gold Coin','Diamond',
"Quinton's Glove","Zeppeli's Hat","Caesar's Headband",'Ancient Scroll'}local
itemOptions={}do local seen={}for item in pairs(maxLimits)do if not seen[item]
then table.insert(itemOptions,item)seen[item]=true end end for _,candy in
ipairs(nonSellable)do if not seen[candy]then table.insert(itemOptions,candy)seen
[candy]=true end end table.sort(itemOptions)end local itemSellOptions={}do local
ns={}for _,v in ipairs(nonSellable)do ns[v]=true end for _,item in ipairs(
itemOptions)do if not ns[item]then table.insert(itemSellOptions,item)end end end
local ITEM_DROPDOWN_EVERY='Every Item'local farmChoices={ITEM_DROPDOWN_EVERY}for
_,n in ipairs(itemOptions)do if n~=ITEM_DROPDOWN_EVERY then table.insert(
farmChoices,n)end end local sellChoices={ITEM_DROPDOWN_EVERY}for _,n in ipairs(
itemSellOptions)do if n~=ITEM_DROPDOWN_EVERY then table.insert(sellChoices,n)end
end VS.itemFarmEnabled=false VS.itemFarmMethod='Normal'local selectedFarmItems={
}local selectedSellItems={}local selectedBuyItems={}VS.sellWhen='Never'local
itemFarmFocusOverride=nil local function activeFarmItems()return
itemFarmFocusOverride or selectedFarmItems end local function beginFarmFocus(
itemSet)local prev=itemFarmFocusOverride itemFarmFocusOverride=itemSet return
prev end local function endFarmFocus(prev)itemFarmFocusOverride=prev end
local function sellsItem(itemName)return selectedSellItems[itemName]==true end
VS.buyItemsEnabled=false VS.hopOnEmpty=false VS.serverHopMinPlayers=2 VS.
serverHopMaxPlayers=12 VS.itemSpawnNotif=false VS.notifyOnlySelected=false VS.
itemSpawnConn=nil VS.autoRefill=false local function syncFarmPicks()local f=
Window and Window.Flags or nil if type(f)~='table'then return end local farmVal=
f['MAIN_ItemsToFarm']if type(farmVal)=='string'then farmVal={farmVal}end if
type(farmVal)=='table'then for k in pairs(selectedFarmItems)do selectedFarmItems
[k]=nil end local every=false for _,n in ipairs(farmVal)do if n==
ITEM_DROPDOWN_EVERY then every=true break end end if every then for _,n in
ipairs(itemOptions)do selectedFarmItems[n]=true end else for _,n in ipairs(
farmVal)do if n~=ITEM_DROPDOWN_EVERY then selectedFarmItems[n]=true end end end
end local sellVal=f['MAIN_ItemsToSellWhileFarming']if type(sellVal)=='string'
then sellVal={sellVal}end if type(sellVal)=='table'then for k in pairs(
selectedSellItems)do selectedSellItems[k]=nil end local every=false for _,n in
ipairs(sellVal)do if n==ITEM_DROPDOWN_EVERY then every=true break end end if
every then for _,n in ipairs(itemSellOptions)do selectedSellItems[n]=true end
else for _,n in ipairs(sellVal)do if n~=ITEM_DROPDOWN_EVERY then
selectedSellItems[n]=true end end end end local whenToSellVal=f[
'MAIN_WhenToSell']if type(whenToSellVal)=='table'then whenToSellVal=
whenToSellVal[1]end if type(whenToSellVal)=='string'and whenToSellVal~=''then VS
.sellWhen=whenToSellVal if VS.sellWhen=='Whenever'then VS.sellWhen='Never'end
end local methodVal=f['MAIN_ItemFarmMethod']if type(methodVal)=='table'then
methodVal=methodVal[1]end if methodVal=='Normal'or methodVal=='Hidden'then VS.
itemFarmMethod=methodVal end VS.buyItemsEnabled=f['MAIN_BuyItemsWhileFarming']==
true VS.hopOnEmpty=f['MAIN_ServerHopOnEmpty']==true VS.itemSpawnNotif=f[
'MAIN_ItemSpawnNotifier']==true VS.notifyOnlySelected=f[
'MAIN_NotifyOnlySelectedItems']==true end local itemFarmTiming={mainLoopSeconds=
0.2,sweepStepSeconds=0.07,pickupBaseSeconds=0.31,pingDivisor=220,
pingDelayMaxSeconds=0.1,emptyRescanSeconds=3,hopOnEmptyWaitSeconds=0.3}if
pulseIsMobile()then itemFarmTiming.mainLoopSeconds=0.35 itemFarmTiming.
sweepStepSeconds=0.14 itemFarmTiming.pickupBaseSeconds=0.42 itemFarmTiming.
emptyRescanSeconds=4 itemFarmTiming.hopOnEmptyWaitSeconds=0.45 end VS.
itemESPEnabled=false local itemESPConn=nil local function addItemESP(v)local
itemPart=v:FindFirstChildOfClass('MeshPart')or v:FindFirstChildOfClass('Part')
local prox=v:FindFirstChild('ProximityPrompt')if not(itemPart and prox and
itemPart.Transparency<1)then return end local itemName=prox.ObjectText~=''and
prox.ObjectText or v.Name if not v:FindFirstChild('ItemESP')then local hl=
Instance.new('Highlight')hl.Name='ItemESP'hl.FillTransparency=0.5 hl.FillColor=
Color3.fromRGB(0,150,230)hl.OutlineTransparency=0 hl.OutlineColor=Color3.
fromRGB(100,210,255)hl.Adornee=v hl.Parent=v end if not v:FindFirstChild(
'ItemESPName')then local bb=Instance.new('BillboardGui')bb.Name='ItemESPName'bb.
Adornee=itemPart bb.Size=UDim2.new(0,220,0,50)bb.StudsOffset=Vector3.new(0,3.5,0
)bb.AlwaysOnTop=true bb.Parent=v local tl=Instance.new('TextLabel')tl.Size=UDim2
.new(1,0,1,0)tl.BackgroundTransparency=1 tl.Text=itemName tl.TextColor3=Color3.
fromRGB(140,225,255)tl.TextSize=18 tl.TextStrokeTransparency=0 tl.
TextStrokeColor3=Color3.fromRGB(0,80,160)tl.Font=Enum.Font.GothamBold tl.Parent=
bb end end local function enableItemESP()for _,v in pairs(workspace.Item_Spawns.
Items:GetChildren())do pcall(addItemESP,v)end itemESPConn=workspace.Item_Spawns.
Items.ChildAdded:Connect(function(v)task.wait(0.1)pcall(addItemESP,v)end)end
local function disableItemESP()if itemESPConn then itemESPConn:Disconnect()
itemESPConn=nil end for _,v in pairs(workspace.Item_Spawns.Items:GetChildren())
do local hl=v:FindFirstChild('ItemESP')if hl then hl:Destroy()end local bb=v:
FindFirstChild('ItemESPName')if bb then bb:Destroy()end end end local function
isFullOfItem(itemName)local count=0 for _,v in pairs(VS.Backpack:GetChildren())
do if v.Name==itemName then count+=1 end end local cap=getItemStackMax(itemName)
*(PlayerOwns2xInv and 2 or 1)return count>=cap end local function anyItemSpawned
()for itemName in pairs(activeFarmItems())do local prompts=VS.registeredItems[
itemName]if prompts and#prompts>0 then return true end end return false end
local itemFarmCoords={Vector3.new(333.283508,-0.039038,-100.840248),Vector3.new(
-57.569302,6.892837,32.625587),Vector3.new(-56.355259,6.892516,121.205681),
Vector3.new(123.860382,-25.754335,526.4505),Vector3.new(269.684052,-26.004833,
318.603943),Vector3.new(328.879852,-0.039038,-27.590733),Vector3.new(446.596497,
30.729956,-283.112396),Vector3.new(148.746017,0.206251,-474.856873),Vector3.new(
-60.727783,0.206253,-682.052002),Vector3.new(-490.79895,10.517332,-771.658875),
Vector3.new(-402.275482,0.24447,-119.126389),Vector3.new(-265.857452,-5.250957,
22.065256),Vector3.new(151.404068,0.427911,-725.128906),Vector3.new(500.335114,
79.717171,-77.421906),Vector3.new(-7.651116,47.461655,-52.410168),Vector3.new(
336.87558,0.206156,-475.353394),Vector3.new(1097.178711,116.668106,-86.763573)}
local function sweepItemFarmCoords()if not getRootPart()then return end repeat
for _,pos in ipairs(itemFarmCoords)do if not VS.itemFarmEnabled then return end
if anyItemSpawned()then return end local char=LocalPlayer.Character if char then
local sweepPos=VS.itemFarmMethod=='Hidden'and Vector3.new(pos.X,-15,pos.Z)or pos
pcall(function()char:PivotTo(CFrame.new(sweepPos))end)local hrp=char:
FindFirstChild('HumanoidRootPart')if hrp and VS.itemFarmMethod=='Hidden'then hrp
.AssemblyLinearVelocity=Vector3.zero hrp.AssemblyAngularVelocity=Vector3.zero
end farmEnsureNoclip(char)end task.wait(itemFarmTiming.sweepStepSeconds)end
until anyItemSpawned()or not VS.itemFarmEnabled end local function runItemFarm()
desummonStand()sweepItemFarmCoords()local currentHiddenTarget=nil local
persistentAnchor=VS.itemFarmMethod=='Hidden'and farmThrottledHeartbeat(function(
)if not currentHiddenTarget then return end if standFarmBusy and PlayerStand.
Value~='None'then return end local hrp=getRootPart()if not hrp then return end
hrp.AssemblyLinearVelocity=Vector3.zero hrp.AssemblyAngularVelocity=Vector3.zero
hrp.CFrame=currentHiddenTarget farmEnsureNoclip(LocalPlayer.Character)end,18,40)
or nil local lastItemFoundTime=os.clock()while VS.itemFarmEnabled do task.wait(
itemFarmTiming.mainLoopSeconds)if standFarmBusy and PlayerStand.Value~='None'
then currentHiddenTarget=nil end if VS.buyItemsEnabled then buyItems(
selectedBuyItems)end local foundAny=false for itemName in pairs(activeFarmItems(
))do if not VS.itemFarmEnabled then break end local prompts=VS.registeredItems[
itemName]if prompts and#prompts>0 then local prompt=prompts[1]local parent=
prompt and prompt.Parent if parent then foundAny=true local shouldCollect=true
if isFullOfItem(itemName)then if VS.sellWhen:find('Sell one')and sellsItem(
itemName)then sellItem(itemName,false)shouldCollect=true elseif VS.sellWhen:
find('Sell all')and sellsItem(itemName)then sellItem(itemName,true)shouldCollect
=true else shouldCollect=false end end if shouldCollect then local targetCFrame=
VS.itemFarmMethod=='Hidden'and(parent:GetModelCFrame()-Vector3.new(0,9,0))or
parent:GetModelCFrame()currentHiddenTarget=VS.itemFarmMethod=='Hidden'and
targetCFrame or nil if VS.itemFarmMethod=='Hidden'then getRootPart().CFrame=
targetCFrame repeat task.wait(farmStepWait())until(getRootPart().Position-parent
:GetModelCFrame().p).Magnitude<=40 or not VS.itemFarmEnabled or not parent.
Parent or(standFarmBusy and PlayerStand.Value~='None')else repeat getRootPart().
CFrame=targetCFrame task.wait(farmStepWait())until(getRootPart().Position-parent
:GetModelCFrame().p).Magnitude<=40 or not VS.itemFarmEnabled or not parent.
Parent or(standFarmBusy and PlayerStand.Value~='None')end if not VS.
itemFarmEnabled then break end if not parent.Parent then continue end if
standFarmBusy and PlayerStand.Value~='None'then currentHiddenTarget=nil continue
end local pingDelay=math.clamp(getPing()/math.max(1,itemFarmTiming.pingDivisor),
0,itemFarmTiming.pingDelayMaxSeconds)task.wait(itemFarmTiming.pickupBaseSeconds+
pingDelay)if not VS.itemFarmEnabled then break end if VS.buyItemsEnabled then
buyItems(selectedBuyItems)end repeat pcall(function()prompt.RemoteEvent:
FireServer()end)task.wait(farmStepWait())until not VS.itemFarmEnabled or not(
parent:FindFirstChild('ProximityPrompt')and activeFarmItems()[itemName])if VS.
buyItemsEnabled then buyItems(selectedBuyItems)end end end end end if foundAny
then lastItemFoundTime=os.clock()else if os.clock()-lastItemFoundTime>=
itemFarmTiming.emptyRescanSeconds then currentHiddenTarget=nil
sweepItemFarmCoords()lastItemFoundTime=os.clock()end if VS.hopOnEmpty then task.
wait(itemFarmTiming.hopOnEmptyWaitSeconds)if persistentAnchor then
persistentAnchor:Disconnect()end getgenv()._pulseRestoreItemFarm=true if
getgenv().__pulseSmartHop then task.spawn(getgenv().__pulseSmartHop,
'No items in this server')else TeleportService:Teleport(game.PlaceId,LocalPlayer
)end return end end end if persistentAnchor then persistentAnchor:Disconnect()
end end VS.embeddedItemFarmUntil=nil local function enableAutoRefill(tag)if VS.
autoRefill then return end VS.autoRefill=true notify(tag or'Farm',
'Out of required items. Auto-grab from map enabled.',5,'info')end do
local function countBpItem(itemName)return#getBpItems(itemName)end
local function stillNeeds(wants)for itemName,minAmt in pairs(wants)do if
countBpItem(itemName)<minAmt then return true end end return false end
local function hasPickupFor(wants)for itemName,minAmt in pairs(wants)do if
countBpItem(itemName)>=minAmt then continue end local prompts=VS.registeredItems
[itemName]if prompts and#prompts>0 then return true end end return false end
local function sweepForNeeds(wants,keepGoing)if not getRootPart()then return end
repeat for _,pos in ipairs(itemFarmCoords)do if not keepGoing()then return end
if not stillNeeds(wants)then return end if hasPickupFor(wants)then return end
local char=LocalPlayer.Character if char then local sweepPos=VS.itemFarmMethod==
'Hidden'and Vector3.new(pos.X,-15,pos.Z)or pos pcall(function()char:PivotTo(
CFrame.new(sweepPos))end)local hrp=char:FindFirstChild('HumanoidRootPart')if hrp
and VS.itemFarmMethod=='Hidden'then hrp.AssemblyLinearVelocity=Vector3.zero hrp.
AssemblyAngularVelocity=Vector3.zero end farmEnsureNoclip(char)end task.wait(
itemFarmTiming.sweepStepSeconds)end until not keepGoing()or not stillNeeds(wants
)or hasPickupFor(wants)end VS.embeddedItemFarmUntil=function(wants,keepGoing,tag
,force)if not force and not VS.autoRefill then return false end if not
keepGoing()then return false end if not stillNeeds(wants)then return true end if
VS.itemFarmEnabled then notify(tag or'Farm',
'Turn off Item Farm to use auto-grab for Stand/Pity.',6,'warn')return false end
notify(tag or'Farm','Scanning item spawns and grabbing required items...',5,
'info')desummonStand()sweepForNeeds(wants,keepGoing)local currentHiddenTarget=
nil local persistentAnchor=VS.itemFarmMethod=='Hidden'and
farmThrottledHeartbeat(function()if not currentHiddenTarget then return end if
standFarmBusy and PlayerStand.Value~='None'then return end local hrp=
getRootPart()if not hrp then return end hrp.AssemblyLinearVelocity=Vector3.zero
hrp.AssemblyAngularVelocity=Vector3.zero hrp.CFrame=currentHiddenTarget
farmEnsureNoclip(LocalPlayer.Character)end,18,40)or nil local lastFound=os.
clock()local nextHopReminder=os.clock()+120 while keepGoing()and stillNeeds(
wants)do task.wait(itemFarmTiming.mainLoopSeconds)if os.clock()>=nextHopReminder
then notify(tag or'Farm','Been farming for a while, try server hopping.',6,
'info')nextHopReminder=os.clock()+120 end if standFarmBusy and PlayerStand.Value
~='None'then currentHiddenTarget=nil end local foundAny=false for itemName,
minAmt in pairs(wants)do if not keepGoing()then break end if countBpItem(
itemName)>=minAmt then continue end if isFullOfItem(itemName)then notify(tag or
'Farm','Inventory full, cannot pick up more '..itemName..'.',7,'warn')if
persistentAnchor then persistentAnchor:Disconnect()end return false end local
prompts=VS.registeredItems[itemName]if prompts and#prompts>0 then local prompt=
prompts[1]local parent=prompt and prompt.Parent if parent then foundAny=true
local targetCFrame=VS.itemFarmMethod=='Hidden'and(parent:GetModelCFrame()-
Vector3.new(0,9,0))or parent:GetModelCFrame()currentHiddenTarget=VS.
itemFarmMethod=='Hidden'and targetCFrame or nil if VS.itemFarmMethod=='Hidden'
then getRootPart().CFrame=targetCFrame repeat task.wait(farmStepWait())until(
getRootPart().Position-parent:GetModelCFrame().p).Magnitude<=40 or not
keepGoing()or not parent.Parent or(standFarmBusy and PlayerStand.Value~='None')
else repeat getRootPart().CFrame=targetCFrame task.wait(farmStepWait())until(
getRootPart().Position-parent:GetModelCFrame().p).Magnitude<=40 or not
keepGoing()or not parent.Parent or(standFarmBusy and PlayerStand.Value~='None')
end if not keepGoing()then break end if not parent.Parent then continue end if
standFarmBusy and PlayerStand.Value~='None'then currentHiddenTarget=nil continue
end local pingDelay=math.clamp(getPing()/math.max(1,itemFarmTiming.pingDivisor),
0,itemFarmTiming.pingDelayMaxSeconds)task.wait(itemFarmTiming.pickupBaseSeconds+
pingDelay)if not keepGoing()then break end repeat pcall(function()prompt.
RemoteEvent:FireServer()end)task.wait(farmStepWait())until not keepGoing()or not
(parent:FindFirstChild('ProximityPrompt')and countBpItem(itemName)<minAmt)end
end end if foundAny then lastFound=os.clock()elseif os.clock()-lastFound>=
itemFarmTiming.emptyRescanSeconds then currentHiddenTarget=nil sweepForNeeds(
wants,keepGoing)lastFound=os.clock()end end if persistentAnchor then
persistentAnchor:Disconnect()end if stillNeeds(wants)then return false end
refreshItemCounts()notify(tag or'Farm','Got required items. Resuming.',4,
'success')return true end end env.itemOptions=itemOptions env.itemSellOptions=
itemSellOptions env.ITEM_DROPDOWN_EVERY=ITEM_DROPDOWN_EVERY env.farmChoices=
farmChoices env.sellChoices=sellChoices env.selectedFarmItems=selectedFarmItems
env.selectedSellItems=selectedSellItems env.beginFarmFocus=beginFarmFocus env.
endFarmFocus=endFarmFocus env.syncFarmPicks=syncFarmPicks env.itemFarmTiming=
itemFarmTiming env.enableItemESP=enableItemESP env.disableItemESP=disableItemESP
env.isFullOfItem=isFullOfItem env.itemFarmCoords=itemFarmCoords env.runItemFarm=
runItemFarm env.enableAutoRefill=enableAutoRefill end end function
__DARKLUA_BUNDLE_MODULES.at():typeof(__modImpl())local v=
__DARKLUA_BUNDLE_MODULES.cache.at if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.at=v end return v.c end end do local function
__modImpl()return function(env)local VS=env.VS local PlayerStats=env.PlayerStats
local PlayerLevel=env.PlayerLevel local PlayerStand=env.PlayerStand local
RIB_NAME=env.RIB_NAME local sendWebhook=env.sendWebhook local refreshItemCounts=
env.refreshItemCounts local getCharacter=env.getCharacter local getRemoteEvent=
env.getRemoteEvent local unequipAllTools=env.unequipAllTools local
waitUntilNewChar=env.waitUntilNewChar local fireDialogue=env.fireDialogue local
learnSkill=env.learnSkill local getStandMorph=env.getStandMorph local
desummonStand=env.desummonStand local summonStand=env.summonStand local
toggleStand=env.toggleStand local notify=env.notify local teleportUp=env.
teleportUp local useItem=env.useItem local enableAutoRefill=env.enableAutoRefill
VS.standFarmEnabled=false local selectedStands={}VS.stopOnShiny=false VS.
swapSlotOnDesired=false local standFarmBusy=false VS.STAND_RETRIES=70 local
STAND_SLOT_MAX=25 local function findEmptyStandSlot()for i=1,STAND_SLOT_MAX do
local slot=PlayerStats:FindFirstChild('Slot'..i)if slot and slot.Value=='None'
then return'Slot'..i end end return nil end local function swapStandSlot(
slotName)if not slotName then return false end local ok=pcall(function()
getRemoteEvent():FireServer('SwapStand',slotName)end)return ok end
local function swapOnHit(tag)if not VS.swapSlotOnDesired then return false end
local emptySlot=findEmptyStandSlot()if not emptySlot then notify(tag or
'Stand Farm','No empty stand slot found (Slot1-'..STAND_SLOT_MAX..').','warn')
return false end unequipAllTools()if getStandMorph()then desummonStand()local
morphDeadline=tick()+1.5 while tick()<morphDeadline and getStandMorph()do task.
wait(0.05)end end if not swapStandSlot(emptySlot)then notify(tag or'Stand Farm',
'Failed to swap to '..emptySlot..'.','warn')return false end local swapDeadline=
tick()+6 while tick()<swapDeadline and PlayerStand.Value~='None'do task.wait(
0.05)end if PlayerStand.Value~='None'then notify(tag or'Stand Farm','Swap to '..
emptySlot.." didn't register. Stopping.",'warn')return false end local ok,hum=
pcall(function()return getCharacter():FindFirstChildWhichIsA('Humanoid')end)if
ok and hum then pcall(function()hum.Health=0 end)waitUntilNewChar()task.wait(0.2
)end teleportUp()notify(tag or'Stand Farm','Swapped to '..emptySlot..
'. Continuing farm...','success')return true end local function notifyShiny()
local sm=getStandMorph()local skin=sm and sm:FindFirstChild('StandSkin')local
msg='Got shiny! '..PlayerStand.Value..' ('..(skin and skin.Value or'?')..')'
notify('Stand Farm',msg,'success')sendWebhook(msg,true)end local function
notifyStand()local msg='Got the stand you wanted: '..PlayerStand.Value notify(
'Stand Farm',msg,'success')sendWebhook(msg,true)end local function checkShiny()
local sm=getStandMorph()if not sm then return''end local skin=sm:FindFirstChild(
'StandSkin')return skin and skin.Value or''end function handleStandSummonBug(
featureName)notify(featureName,'Stand cannot be equipped bug. Respawning...',
'warn')getCharacter().Humanoid.Health=0 waitUntilNewChar()task.wait(0.2)end
function waitForStandState(activeFn,stateFn,timeoutSec,step)local deadline=tick(
)+(timeoutSec or 10)local interval=step or 0.05 while activeFn()and tick()<
deadline do if stateFn()then return true end task.wait(interval)end return
stateFn()end function tryRecoverStandMorph(activeFn,timeoutSec)local retries=VS.
STAND_RETRIES local deadline=tick()+(timeoutSec or 4.5)while activeFn()and
retries>0 and tick()<deadline do if getStandMorph()then return true end task.
wait()retries-=1 toggleStand()end return getStandMorph()~=nil end local function
runStandFarm()local RIB_STANDS={['Soft & Wet']=true,['D4C']=true,[
'The World Alternate Universe']=true,['Scary Monsters']=true,['Tusk ACT 1']=true
}local hasRibStands=false local hasArrowStands=false for name in pairs(
selectedStands)do if RIB_STANDS[name]then hasRibStands=true else hasArrowStands=
true end end summonStand()if selectedStands[PlayerStand.Value]then notify(
'Stand Farm','You already have a selected stand!','warn')VS.standFarmEnabled=
false standFarmBusy=false return end while VS.standFarmEnabled and task.wait()do
if not VS.standFarmEnabled then break end if not getStandMorph()and PlayerStand.
Value~='None'then unequipAllTools()task.wait(0.15)local gotMorph=
tryRecoverStandMorph(function()return VS.standFarmEnabled end,4.5)if not VS.
standFarmEnabled then break end if not gotMorph then handleStandSummonBug(
'Stand Farm')if not VS.standFarmEnabled then break end end end learnSkill(
'Worthiness','Character')if not VS.standFarmEnabled then break end if
PlayerStand.Value=='None'then if hasArrowStands and(VS.itemCounts.arrows>0 or
not hasRibStands)then if not useItem('Mysterious Arrow')then if VS.
standFarmEnabled then enableAutoRefill('Stand Farm')end if VS.autoRefill and VS.
standFarmEnabled then VS.embeddedItemFarmUntil({['Mysterious Arrow']=1,[
'Rokakaka']=1},function()return VS.standFarmEnabled end,'Stand Farm')
refreshItemCounts()end if not useItem('Mysterious Arrow')then notify(
'Stand Farm','No Mysterious Arrows left. Stopping.','warn')VS.standFarmEnabled=
false break end end local gotStand=waitForStandState(function()return VS.
standFarmEnabled end,function()return PlayerStand.Value~='None'end,10,0.05)if
not VS.standFarmEnabled then break end if not gotStand then
handleStandSummonBug('Stand Farm')if not VS.standFarmEnabled then break end
continue end unequipAllTools()task.wait(0.2)elseif hasRibStands then if VS.
itemCounts.ribs==0 then if VS.standFarmEnabled then enableAutoRefill(
'Stand Farm')end if VS.autoRefill and VS.standFarmEnabled then VS.
embeddedItemFarmUntil({[RIB_NAME]=1},function()return VS.standFarmEnabled end,
'Stand Farm')refreshItemCounts()end if VS.itemCounts.ribs==0 then notify(
'Stand Farm','No Rib Cages left. Stopping.','warn')VS.standFarmEnabled=false
break end end fireDialogue(RIB_NAME,'Dialogue2','Option1')local gotStand=
waitForStandState(function()return VS.standFarmEnabled end,function()return
PlayerStand.Value~='None'end,10,0.05)if not VS.standFarmEnabled then break end
if not gotStand then continue end end end if not getStandMorph()then local
gotMorph=tryRecoverStandMorph(function()return VS.standFarmEnabled end,4.5)if
not VS.standFarmEnabled then break end if not gotMorph then
handleStandSummonBug('Stand Farm')if not VS.standFarmEnabled then break end end
end repeat task.wait(0.05)summonStand()until getStandMorph()or not VS.
standFarmEnabled if not VS.standFarmEnabled then break end local sm=
getStandMorph()local skin=sm and sm:WaitForChild('StandSkin')if skin and skin.
Value~=''and VS.stopOnShiny then notifyShiny()if VS.swapSlotOnDesired and
swapOnHit('Stand Farm')then continue end VS.standFarmEnabled=false break end if
selectedStands[PlayerStand.Value]then notifyStand()if VS.swapSlotOnDesired and
swapOnHit('Stand Farm')then continue end VS.standFarmEnabled=false break end if
not VS.standFarmEnabled then break end if hasRibStands and VS.itemCounts.ribs>0
then local oldStand=PlayerStand.Value fireDialogue(RIB_NAME,'Dialogue2',
'Option1')waitForStandState(function()return VS.standFarmEnabled end,function()
return PlayerStand.Value~=oldStand end,10,0.05)if not VS.standFarmEnabled then
break end else if not useItem('Rokakaka')then if VS.standFarmEnabled then
enableAutoRefill('Stand Farm')end if VS.autoRefill and VS.standFarmEnabled then
VS.embeddedItemFarmUntil({['Mysterious Arrow']=1,['Rokakaka']=1},function()
return VS.standFarmEnabled end,'Stand Farm')refreshItemCounts()end if not
useItem('Rokakaka')then notify('Stand Farm','No Rokakaka left. Stopping.','warn'
)VS.standFarmEnabled=false break end end repeat task.wait()until PlayerStand.
Value=='None'or not VS.standFarmEnabled waitUntilNewChar()task.wait(0.5)if not
VS.standFarmEnabled then break end teleportUp()end end end local function
startStandFarm()if standFarmBusy then notify('Stand Farm',
'Already running. Please wait.','warn')return end standFarmBusy=true if
PlayerLevel.Value<3 then notify('Stand Farm',
'Need at least level 3 to get stands.','warn')VS.standFarmEnabled=false
standFarmBusy=false return end teleportUp()if not next(selectedStands)then
notify('Stand Farm','Please select a stand first.','warn')VS.standFarmEnabled=
false standFarmBusy=false return end notify('Stand Farm','Started!','start')
local ok,err=pcall(runStandFarm)if not ok then warn('Pulse: Stand Farm error: '
..tostring(err))end VS.standFarmEnabled=false standFarmBusy=false end env.
selectedStands=selectedStands env.swapOnHit=swapOnHit env.startStandFarm=
startStandFarm end end function __DARKLUA_BUNDLE_MODULES.au():typeof(__modImpl()
)local v=__DARKLUA_BUNDLE_MODULES.cache.au if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.au=v end return v.c end end do local function
__modImpl()return function(env)local VS=env.VS local PlayerLevel=env.PlayerLevel
local PlayerStand=env.PlayerStand local sendWebhook=env.sendWebhook local
unequipAllTools=env.unequipAllTools local waitUntilNewChar=env.waitUntilNewChar
local learnSkill=env.learnSkill local getStandMorph=env.getStandMorph local
summonStand=env.summonStand local notify=env.notify local teleportUp=env.
teleportUp local useItem=env.useItem local swapOnHit=env.swapOnHit local
ShinyFarm={enabled=false,busy=false,target='',any='Any Shiny'}do ShinyFarm.NAMES
={ShinyFarm.any,'Aang','Ace','Action-Figure Platinum',
'Actually Red Hot Chili Pepper','Aerosleigh','Aerosmith Over Heaven',
'All-Starsnake','Anime WR','Anti Umbral','Arlong','Astral Enigma','Asuna',
'Baseball Platinum','Bell Pepper','Biblically Accurate Experience',
'Blade of The Exile','Bloodthirster','Booette','Buggy D. Clown',
'Candy Cane World','Casull','Charged Creeper Queen','Charmy Green',
'Chromo Hando','Comic Venom Spider-Man','Cornsnake','Cracked WORLD','Crazy Idol'
,'Crazy Overseer','Cream Nog','Creeper Queen','Crimson Mist',
'Cursed Aero Platinum','D4She','Dead Experience','Deimos Crimson','Deimos Queen'
,'Deimos Snake','Devil Moon','Devil Pepper','Devil4C','Digital Star Platinum',
'Doodle Bop','Eldritch Green','Elf Pistol','Elizabeth Liones',
'Elucidator & Dark Repulser','Emperor','Female Hando','Festive Free',
'Festive Platinum','Festive World','Forged By Hell','FrostBite','Frozone',
'Fused Zamasu','Ghost Chariot Requiem','Ghost World','Ghostface',
'Glacier Trackstar','Glock - 18 | Fade','Glock-18','Go/Jo','Goku Black',
'Gold Platinum','Golden & Wet','Golden Frieza','Golden Retribution',
'Grim Reaper','Haunted Jack-O-Platinum','Headhunter','Heaven ACT 4',
'Heaven Spirit','Hexed Spirit Requiem','Hidden Leaf Hero','Hierophant Frost',
'Holiday Tangle',"Holly's Sickness",'Horseman of Heaven','Ice Cold Chili Pepper'
,'Jack-o-Platinum','Jade Peace','Jester Crimson',"Joe's Pride",
'Kanshou & Bakuya','Kikoku','Killer Queen: Bites the Ice','Killer Reveal',
'Killua','King Krampus','King Peppermint','King of The End','Korra',
'Light Bringer','Linked Sword','Lord Boros','Luffy Gear 4','MCU Spider-Man',
'Made in Christmas Future','Made in Pibble','Magellan',
"Magician's Red Over Heaven",'Manga Crimson','Manga WR','Megumin',
'Merry & Sweet','Mintsnake','Mirage of Phantoms','Misaka Mikoto',
'Molted Chariot','Moon of Christmas Present','Mr Jukes Angels','Mr. Joestar',
'Mr. Pekin','Mr. Tentacles','Ms. Aerosmith','Muffet',"Nah I'd Win",'Neco Arc',
'Neo WORLD','Neon Ascension Diamond','Nerf Jolt','Nocturne','Nonosama Bo',
'OVA Emperor','OVA Platinum','OVA Silver Chariot','OVA The World',
'Old President','One Above All','Pinky Fingers','Polar President',
'Pumpkin Patch','Pyro','Retro The World Over Heaven','Reverse Monsters',
'Rock Unleashed','Rogue Ninja','SCP-049','STW Alternate','Sailor S&W','Sakara',
'Sasageyo','Scarlet Queen','Scary Monsters: Retro The World',
'Scary Monsters: The World','Scary Monsters: The World Alternate Universe',
'Shadow Killer Queen','Shadow The Waifu','Shadow The World','Shanks',
'Sheared Snow Golem','Shining Ruby','Snake of Christmas Past','Snow Golem',
'Soft & Starry',"Sorcerer's Red",'Spearmint Chariot','Spirit Bomb Sword',
'Spunch Bop','Star Platinum: Stone Ocean','Star Striped Eagle','Star Waifu',
'Star Waifu: The World','Stone Platinum','Stormy','Sukuna','Sumo Platinum',
'Sumo World','TWAU Over Heaven','Tentacle Black','Tentacle Purple',
'Tentacle Yellow','Thanos','The Bunny Devil','The Control Devil','The Gifter',
'The Grinch','The Noob Over Heaven','The Nutcracker','The Other Hand',
'The Plague Doctor','The Waifu','The Waifu Alternate Universe',
'The Waifu Over Heaven','The Waifu v2','The World 2','The World Under Hell',
"The World's Greatest High",'The World: Ultimate','Tomb Crypt Tusk',
'Toy Sticky Fingers','Train To Hell','Triangle Guard','Tsunate',
'Tusk Dark Determination','Tyrant Crimson','T\u{101}koizu Dragon','Uber Spy',
'Undead Flare','Undead Hand','Vanilla Ice Cream','Vela Nova','Venom',
'Vexus Crimson','Vinegar Crimson','Virus Vessel','Volcanic Spirit Requiem',
'Warhammer Titan','Weather Reporter','Weathersnake','Wendigo','Whisper',
'Yuji Itadori','Yuki Tsukumo','Zenitsu','Zeus (GOW)','Zeus (OP)',
'\u{25cf}\u{25cf}|\u{25cf}\u{25cf}\u{25cf}\u{25cf}\u{25cf}|\u{25cf}\u{25cf}|\u{25cf}'
}local function notifyShinyFarmHit(skinValue)local msg='Shiny Farm: got '..
PlayerStand.Value..' ('..(skinValue or'?')..')'notify('Shiny Farm',msg,'success'
)sendWebhook(msg,true)end local function runShinyFarm()if not getStandMorph()and
PlayerStand.Value~='None'then unequipAllTools()task.wait(0.15)local gotMorph=
tryRecoverStandMorph(function()return ShinyFarm.enabled end,4.5)if not ShinyFarm
.enabled then return end if not gotMorph then handleStandSummonBug('Shiny Farm')
if not ShinyFarm.enabled then return end end end while ShinyFarm.enabled and
task.wait()do if not ShinyFarm.enabled then break end if PlayerStand.Value==
'None'then learnSkill('Worthiness','Character')if not ShinyFarm.enabled then
break end if not useItem('Lucky Arrow')then notify('Shiny Farm',
'No Lucky Arrows left. Stopping.','warn')ShinyFarm.enabled=false break end local
gotStand=waitForStandState(function()return ShinyFarm.enabled end,function()
return PlayerStand.Value~='None'end,10,0.05)if not ShinyFarm.enabled then break
end if not gotStand then handleStandSummonBug('Shiny Farm')if not ShinyFarm.
enabled then break end continue end unequipAllTools()task.wait(0.2)end if not
getStandMorph()then local gotMorph=tryRecoverStandMorph(function()return
ShinyFarm.enabled end,4.5)if not ShinyFarm.enabled then break end if not
gotMorph then handleStandSummonBug('Shiny Farm')if not ShinyFarm.enabled then
break end end end repeat task.wait(0.05)summonStand()until getStandMorph()or not
ShinyFarm.enabled if not ShinyFarm.enabled then break end local sm=
getStandMorph()local skin=sm and sm:WaitForChild('StandSkin',5)local val=(skin
and skin.Value)or''local hit=false if val~=''then if ShinyFarm.target==''or
ShinyFarm.target==ShinyFarm.any then hit=true elseif val==ShinyFarm.target then
hit=true end end if hit then notifyShinyFarmHit(val)if VS.swapSlotOnDesired and
swapOnHit('Shiny Farm')then continue end ShinyFarm.enabled=false break end if
not ShinyFarm.enabled then break end if not useItem('Rokakaka')then notify(
'Shiny Farm','No Rokakaka left. Stopping.','warn')ShinyFarm.enabled=false break
end repeat task.wait()until PlayerStand.Value=='None'or not ShinyFarm.enabled
waitUntilNewChar()task.wait(0.5)if not ShinyFarm.enabled then break end
teleportUp()end end ShinyFarm.start=function()if ShinyFarm.busy then notify(
'Shiny Farm','Already running. Please wait.','warn')return end ShinyFarm.busy=
true if PlayerLevel.Value<3 then notify('Shiny Farm',
'Need at least level 3 to use arrows.','warn')ShinyFarm.enabled=false ShinyFarm.
busy=false return end teleportUp()notify('Shiny Farm','Started!','start')local
ok,err=pcall(runShinyFarm)if not ok then warn('Pulse: Shiny Farm error: '..
tostring(err))end ShinyFarm.enabled=false ShinyFarm.busy=false end end env.
ShinyFarm=ShinyFarm end end function __DARKLUA_BUNDLE_MODULES.av():typeof(
__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.av if not v then v={c=
__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.av=v end return v.c end end do
local function __modImpl()return function(env)local VS=env.VS local
farmEnsureNoclip=env.farmEnsureNoclip local LocalPlayer=env.LocalPlayer local
PlayerStand=env.PlayerStand local PlayerMoney=env.PlayerMoney local RIB_NAME=env
.RIB_NAME local PlayerOwns2xInv=env.PlayerOwns2xInv local sendWebhook=env.
sendWebhook local refreshItemCounts=env.refreshItemCounts local getCharacter=env
.getCharacter local getRootPart=env.getRootPart local getRemoteEvent=env.
getRemoteEvent local purchaseRibCage=env.purchaseRibCage local waitUntilNewChar=
env.waitUntilNewChar local getPing=env.getPing local getPity=env.getPity local
roundTwo=env.roundTwo local fireDialogue=env.fireDialogue local learnSkill=env.
learnSkill local getBpItem=env.getBpItem local getBpItems=env.getBpItems local
getItemStackMax=env.getItemStackMax local sellItem=env.sellItem local
getStandMorph=env.getStandMorph local desummonStand=env.desummonStand local
summonStand=env.summonStand local notify=env.notify local teleportUp=env.
teleportUp local useItem=env.useItem local itemSellOptions=env.itemSellOptions
local itemFarmTiming=env.itemFarmTiming local isFullOfItem=env.isFullOfItem
local itemFarmCoords=env.itemFarmCoords local enableAutoRefill=env.
enableAutoRefill VS.pityFarmEnabled=false VS.pityWanted=nil VS.halfPityGoal=nil
VS.pityFarmDone=true VS.pityRollLimit=680 VS.noRibsFlag=false VS.noArrowsFlag=
false VS.noRokasFlag=false VS.dtFarmingFlag=false VS.dtGuardFlag=false VS.
doubleTrouble=false VS.hopModePity=false getgenv()._pulsePityAutoBuy=(function()
local self={enabled=false,buffer=3}local PITY_SHOP_BUYS={[RIB_NAME]={cost=3500,
buy=purchaseRibCage},['Mysterious Arrow']={cost=750,shopItem=
'1x Mysterious Arrow'},['Rokakaka']={cost=2500,shopItem='1x Rokakaka'}}local
pityCashFarmList={}do local skip={[RIB_NAME]=true,['Mysterious Arrow']=true,[
'Rokakaka']=true}for _,name in ipairs(itemSellOptions)do if not skip[name]then
table.insert(pityCashFarmList,name)end end end local function countBpItem(
itemName)return#getBpItems(itemName)end local function shopBuyConsumable(
itemName)local info=PITY_SHOP_BUYS[itemName]if not info then return end pcall(
function()if info.buy then info.buy()else getRemoteEvent():FireServer(
'PurchaseShopItem',{ItemName=info.shopItem})end end)end local function
pityCashSweep(keepGoing)if not getRootPart()then return end for _,pos in ipairs(
itemFarmCoords)do if not keepGoing()then return end local char=LocalPlayer.
Character if char then local sweepPos=VS.itemFarmMethod=='Hidden'and Vector3.
new(pos.X,-15,pos.Z)or pos pcall(function()char:PivotTo(CFrame.new(sweepPos))end
)local hrp=char:FindFirstChild('HumanoidRootPart')if hrp and VS.itemFarmMethod==
'Hidden'then hrp.AssemblyLinearVelocity=Vector3.zero hrp.AssemblyAngularVelocity
=Vector3.zero end farmEnsureNoclip(char)end for _,name in ipairs(
pityCashFarmList)do local prompts=VS.registeredItems[name]if prompts and#prompts
>0 then return end end task.wait(itemFarmTiming.sweepStepSeconds)end end
local function pityEarnCash(targetMoney,keepGoing,tag)if PlayerMoney.Value>=
targetMoney then return true end if VS.itemFarmEnabled then notify(tag,
[[Turn off Item Farm so Auto Pity can farm cash for materials.]],6,'warn')return
false end notify(tag,
[[Low on cash - farming & selling items to afford materials...]],5,'info')
desummonStand()local lastProgressMoney=PlayerMoney.Value local lastProgressAt=os
.clock()while keepGoing()and PlayerMoney.Value<targetMoney do local grabbed=
false for _,name in ipairs(pityCashFarmList)do if not keepGoing()or PlayerMoney.
Value>=targetMoney then break end local prompts=VS.registeredItems[name]if
prompts and#prompts>0 then local prompt=prompts[1]local parent=prompt and prompt
.Parent if parent then grabbed=true local targetCFrame=VS.itemFarmMethod==
'Hidden'and(parent:GetModelCFrame()-Vector3.new(0,9,0))or parent:GetModelCFrame(
)repeat getRootPart().CFrame=targetCFrame task.wait()until(getRootPart().
Position-parent:GetModelCFrame().p).Magnitude<=40 or not keepGoing()or not
parent.Parent if not keepGoing()then break end if parent.Parent then local
pingDelay=math.clamp(getPing()/math.max(1,itemFarmTiming.pingDivisor),0,
itemFarmTiming.pingDelayMaxSeconds)task.wait(itemFarmTiming.pickupBaseSeconds+
pingDelay)repeat pcall(function()prompt.RemoteEvent:FireServer()end)task.wait()
until not keepGoing()or not parent:FindFirstChild('ProximityPrompt')pcall(
function()sellItem(name,true)end)end end end end if PlayerMoney.Value>
lastProgressMoney then lastProgressMoney=PlayerMoney.Value lastProgressAt=os.
clock()end if not grabbed then pityCashSweep(keepGoing)task.wait(itemFarmTiming.
mainLoopSeconds)end if os.clock()-lastProgressAt>=30 then notify(tag,
[[Couldn't earn cash (no sellable items here?). Try server hopping.]],7,'warn')
return false end end return PlayerMoney.Value>=targetMoney end function self.
stockUp(wants,keepGoing,tag)tag=tag or'Pity Farm'for itemName,minAmt in pairs(
wants)do if not keepGoing()then break end local info=PITY_SHOP_BUYS[itemName]if
info then local cap=getItemStackMax(itemName)*(PlayerOwns2xInv and 2 or 1)local
want=math.min(math.max(minAmt,self.buffer),cap)while keepGoing()and countBpItem(
itemName)<want do if isFullOfItem(itemName)then break end if PlayerMoney.Value<
info.cost then local needed=want-countBpItem(itemName)local goal=info.cost*math.
clamp(needed,1,5)if not pityEarnCash(goal,keepGoing,tag)then break end end if
not keepGoing()or PlayerMoney.Value<info.cost then break end local before=
countBpItem(itemName)shopBuyConsumable(itemName)task.wait(0.6)if countBpItem(
itemName)<=before then break end end end end refreshItemCounts()for itemName,
minAmt in pairs(wants)do if countBpItem(itemName)<minAmt then return false end
end notify(tag,'Restocked materials from shop. Resuming.',4,'success')return
true end return self end)()local function pityRefillFromMap(wants)if not VS.
pityFarmEnabled then return false end VS.dtFarmingFlag=true local ok=false if
getgenv()._pulsePityAutoBuy.enabled then ok=getgenv()._pulsePityAutoBuy.stockUp(
wants,function()return VS.pityFarmEnabled end,'Pity Farm')end if not ok then if
not VS.autoRefill then enableAutoRefill('Pity Farm')end if VS.autoRefill then ok
=VS.embeddedItemFarmUntil(wants,function()return VS.pityFarmEnabled end,
'Pity Farm')end end VS.dtFarmingFlag=false if ok then if wants[
'Mysterious Arrow']then VS.noArrowsFlag=false end if wants['Rokakaka']then VS.
noRokasFlag=false end if wants[RIB_NAME]then VS.noRibsFlag=false end end return
ok end local function runPityFarm()if not VS.pityFarmDone then notify(
'Pity Farm','Wait for current tasks to finish first.','warn')return end if not
VS.pityWanted then notify('Pity Farm','Set a Pity Goal first (1-10).','warn')
return end if VS.pityWanted<=getPity()then notify('Pity Farm',
'Goal must be higher than current pity.','warn')VS.pityFarmEnabled=false return
end notify('Pity Farm','Started! Goal: '..(VS.pityWanted or'not set'),'start')
teleportUp()task.wait(1)VS.noRibsFlag=false VS.noArrowsFlag=false VS.noRokasFlag
=false VS.dtFarmingFlag=false VS.dtGuardFlag=false task.spawn(function()while VS
.pityFarmEnabled do task.wait()if not VS.doubleTrouble or VS.dtFarmingFlag then
continue end VS.halfPityGoal=VS.pityWanted/2 if VS.halfPityGoal<=getPity()then
VS.doubleTrouble=false continue end if not getBpItem('Mysterious Arrow')then if
pityRefillFromMap({['Mysterious Arrow']=1,['Rokakaka']=1})then continue end if
not VS.noArrowsFlag then notify('Pity Farm','No Mysterious Arrows!','warn')end
VS.noArrowsFlag=true VS.dtGuardFlag=false continue end if not getBpItem(
'Rokakaka')then if pityRefillFromMap({['Mysterious Arrow']=1,['Rokakaka']=1})
then continue end if not VS.noRokasFlag then notify('Pity Farm','No Rokakaka!',
'warn')end VS.noRokasFlag=true VS.dtGuardFlag=false continue end if VS.
noArrowsFlag or VS.noRokasFlag then continue end repeat task.wait()until VS.
pityFarmDone or not VS.pityFarmEnabled if not VS.pityFarmEnabled then return end
VS.dtGuardFlag=false learnSkill('Worthiness','Character')if PlayerStand.Value~=
'None'then VS.dtGuardFlag=true VS.pityFarmDone=false useItem('Rokakaka')repeat
task.wait()until PlayerStand.Value=='None'or not VS.pityFarmEnabled VS.
dtGuardFlag=false VS.pityFarmDone=true if VS.doubleTrouble and VS.
pityFarmEnabled then waitUntilNewChar()task.wait(0.5)teleportUp()end else VS.
dtGuardFlag=true VS.pityFarmDone=false useItem('Mysterious Arrow')repeat task.
wait()until PlayerStand.Value~='None'or not VS.pityFarmEnabled VS.dtGuardFlag=
false VS.pityFarmDone=true if VS.doubleTrouble and VS.pityFarmEnabled then if
getPity()>=VS.halfPityGoal then else VS.dtGuardFlag=true VS.pityFarmDone=false
useItem('Rokakaka')repeat task.wait()until PlayerStand.Value=='None'or not VS.
pityFarmEnabled VS.dtGuardFlag=false VS.pityFarmDone=true if VS.doubleTrouble
and VS.pityFarmEnabled then waitUntilNewChar()task.wait(0.5)teleportUp()end end
end end end end)task.spawn(function()local summonRetries=VS.pityRollLimit while
VS.pityFarmEnabled do task.wait()local useDouble=VS.doubleTrouble or VS.
dtFarmingFlag if not useDouble and not getBpItem(RIB_NAME)then if
pityRefillFromMap({[RIB_NAME]=1})then VS.pityFarmDone=true continue end if not
VS.noRibsFlag then notify('Pity Farm','No Rib Cages!','warn')end VS.noRibsFlag=
true VS.pityFarmDone=true continue end if not useDouble and VS.dtGuardFlag then
repeat task.wait()until not VS.dtGuardFlag or not VS.pityFarmEnabled or VS.
doubleTrouble VS.pityFarmDone=true continue end local skip=useDouble or(VS.
doubleTrouble)or not VS.pityFarmEnabled if not skip then teleportUp()if not
getBpItem(RIB_NAME)then if pityRefillFromMap({[RIB_NAME]=1})then VS.pityFarmDone
=true continue end if not VS.noRibsFlag then notify('Pity Farm','No Rib Cages!',
'warn')end VS.noRibsFlag=true VS.pityFarmDone=true continue end end if not skip
then VS.pityFarmDone=false repeat task.wait(0.15)learnSkill('Worthiness',
'Character')fireDialogue(RIB_NAME,'Dialogue2','Option1')desummonStand()until not
getStandMorph()or not VS.pityFarmEnabled if not getBpItem(RIB_NAME)then if
pityRefillFromMap({[RIB_NAME]=1})then VS.pityFarmDone=true continue end if not
VS.noRibsFlag then notify('Pity Farm','No Rib Cages!','warn')end VS.noRibsFlag=
true VS.pityFarmDone=true continue end summonRetries=VS.pityRollLimit repeat
task.wait(0.015)task.spawn(summonStand)summonRetries-=1 until getStandMorph()or
summonRetries<=0 or not VS.pityFarmEnabled if not getStandMorph()then notify(
'Pity Farm','Stand summon bug detected. Respawning...','warn')getCharacter().
Humanoid.Health=0 waitUntilNewChar()task.wait(0.5)teleportUp()summonStand()end
VS.pityFarmDone=true end VS.pityFarmDone=true if not VS.doubleTrouble and VS.
pityFarmEnabled and not skip then if VS.pityWanted<=getPity()then notify(
'Pity Farm','Goal reached! Pity: '..roundTwo(getPity()),'success')sendWebhook(
'Pity Farm goal reached! Pity: '..roundTwo(getPity()),true)VS.pityFarmEnabled=
false return end end task.wait(0.02)end end)end env.runPityFarm=runPityFarm end
end function __DARKLUA_BUNDLE_MODULES.aw():typeof(__modImpl())local v=
__DARKLUA_BUNDLE_MODULES.cache.aw if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.aw=v end return v.c end end do local function
__modImpl()return function(env)local VS=env.VS local ReplicatedStorage=env.
ReplicatedStorage local LocalPlayer=env.LocalPlayer local PlayerGui=env.
PlayerGui local PlayerStand=env.PlayerStand local sendWebhook=env.sendWebhook
local getCharacter=env.getCharacter local getRootPart=env.getRootPart local
getRemoteEvent=env.getRemoteEvent local getQuests=env.getQuests local
fireDialogue=env.fireDialogue local getStandMorph=env.getStandMorph local
toggleStand=env.toggleStand local notify=env.notify local teleportUp=env.
teleportUp VS.autoMIHEnabled=false VS.autoMIHRunning=false local runAutoMIH(
function()local function firePucciDialogues()if PlayerStand.Value=='Whitesnake'
and not VS.Backpack:FindFirstChild('Green Baby')then for _,d in ipairs({'Thugs',
'Alpha Thugs','Corrupt Police','Zombie Henchman','Vampire','Green Baby'})do
fireDialogue('Pucci',d,'Option1')end end end local function fireMIHDialogues()
fireDialogue('Green Baby','Dialogue2','Option1')fireDialogue('Pucci','MIH12',
'Option1')fireDialogue('Pucci','MIH6','Option1')if PlayerStand.Value=='C-Moon'
and not VS.Backpack:FindFirstChild("Dio's Bone")then fireDialogue(
'Path to Heaven','Dialogue8','Option1')end fireDialogue(
'Heaven Ascension DEO Quest','Dialogue5','Option1')fireDialogue('Pucci','MIH9',
'Option1')end local function killNPC(npcName,offsetZ,offsetY)local npc=workspace
.Living:FindFirstChild(npcName)if not npc or not npc:FindFirstChild(
'HumanoidRootPart')then return end local npcHRP=npc.HumanoidRootPart local
isHeavyBoss=(npcName=='Heaven Ascension Dio'or npcName=='Jotaro Kujo')local
hitInterval=isHeavyBoss and 0.08 or 0 local lastHitAt=0 getRootPart().CFrame=
npcHRP.CFrame-npcHRP.CFrame.LookVector*(offsetZ or 2)+Vector3.new(0,offsetY or
20,0)task.wait(0.35)local dead=false local respawn=false local xpConn=
LocalPlayer.PlayerStats.Experience:GetPropertyChangedSignal('Value'):Connect(
function()dead=true end)local moneyConn=PlayerGui:WaitForChild('HUD').Main.
DropMoney.Money.ChildAdded:Connect(function()respawn=true if isHeavyBoss then
return end if workspace.Living:FindFirstChild(npcName)then pcall(function()
getRootPart().CFrame=workspace.Living[npcName].HumanoidRootPart.CFrame npc:
Destroy()task.wait(0.35)dead=true if npcName=='Vampire'and npc:FindFirstChild(
'Health')and npc.Health.Value<=0 then getRootPart().CFrame=npc.HumanoidRootPart.
CFrame npc:Destroy()dead=true task.wait(0.25)end end)end end)while not dead and
VS.autoMIHEnabled do task.wait()if not getStandMorph()then repeat task.wait()
toggleStand()until getStandMorph()or not VS.autoMIHEnabled end if not VS.
autoMIHEnabled then break end local now=tick()if hitInterval>0 and now-lastHitAt
<hitInterval then continue end lastHitAt=now pcall(function()local remote=
getRemoteEvent()local standMorph=getStandMorph()remote:FireServer('InputBegan',{
Input=Enum.KeyCode.T})remote:FireServer('InputEnded',{Input=Enum.KeyCode.T})
remote:FireServer('Attack','m1')if standMorph then standMorph.HumanoidRootPart.
CFrame=CFrame.lookAt(npcHRP.Position,npc.Head.Position)end getRootPart().CFrame=
npcHRP.CFrame-npcHRP.CFrame.LookVector*(offsetZ or 2)+Vector3.new(0,offsetY or
20,0)end)end local bufferEnd=tick()+(isHeavyBoss and 0.45 or 1)while VS.
autoMIHEnabled and tick()<bufferEnd do task.wait()npc=workspace.Living:
FindFirstChild(npcName)if npc and npc:FindFirstChild('HumanoidRootPart')then
npcHRP=npc.HumanoidRootPart end if not getStandMorph()then repeat task.wait()
toggleStand()until getStandMorph()or not VS.autoMIHEnabled end if not VS.
autoMIHEnabled then break end local now=tick()if hitInterval>0 and now-lastHitAt
<hitInterval then continue end lastHitAt=now pcall(function()local remote=
getRemoteEvent()local standMorph=getStandMorph()remote:FireServer('InputBegan',{
Input=Enum.KeyCode.T})remote:FireServer('InputEnded',{Input=Enum.KeyCode.T})
remote:FireServer('Attack','m1')if npc and npc:FindFirstChild('HumanoidRootPart'
)and standMorph and npc:FindFirstChild('Head')then standMorph.HumanoidRootPart.
CFrame=CFrame.lookAt(npcHRP.Position,npc.Head.Position)end if npc and npc:
FindFirstChild('HumanoidRootPart')then getRootPart().CFrame=npcHRP.CFrame-npcHRP
.CFrame.LookVector*(offsetZ or 2)+Vector3.new(0,offsetY or 20,0)end end)end
xpConn:Disconnect()moneyConn:Disconnect()end local function doWhitesnakePhase()
if PlayerStand.Value~='Whitesnake'or VS.Backpack:FindFirstChild('Green Baby')
then return end if not getStandMorph()then repeat task.wait()toggleStand()until
getStandMorph()or not VS.autoMIHEnabled end firePucciDialogues()
fireMIHDialogues()PlayerGui:WaitForChild('HUD')local q=getQuests()if q[
"Defeat 30 Thugs (Dio's Plan)"]then repeat task.wait()killNPC('Thug',0,20)until
not getQuests()["Defeat 30 Thugs (Dio's Plan)"]or not VS.autoMIHEnabled if not
VS.autoMIHEnabled then return end task.wait(0.35)doWhitesnakePhase()end if q[
"Defeat 25 Alpha Thugs (Dio's Plan)"]then repeat task.wait()killNPC('Alpha Thug'
,0,20)until not getQuests()["Defeat 25 Alpha Thugs (Dio's Plan)"]or not VS.
autoMIHEnabled if not VS.autoMIHEnabled then return end task.wait(0.35)
doWhitesnakePhase()end if q["Defeat 20 Corrupt Police (Dio's Plan)"]then repeat
task.wait()killNPC('Corrupt Police',0,20)until not getQuests()[
"Defeat 20 Corrupt Police (Dio's Plan)"]or not VS.autoMIHEnabled if not VS.
autoMIHEnabled then return end task.wait(0.4)doWhitesnakePhase()end if q[
"Defeat 15 Zombie Henchman (Dio's Plan)"]then repeat task.wait()killNPC(
'Zombie Henchman',0,13)until not getQuests()[
"Defeat 15 Zombie Henchman (Dio's Plan)"]or not VS.autoMIHEnabled if not VS.
autoMIHEnabled then return end task.wait(0.4)doWhitesnakePhase()task.wait(0.5)
getCharacter().Head:Destroy()end task.wait(2)if q[
"Defeat 10 Vampires (Dio's Plan)"]then repeat task.wait()killNPC('Vampire',0,14)
until not getQuests()["Defeat 10 Vampires (Dio's Plan)"]or not VS.autoMIHEnabled
if not VS.autoMIHEnabled then return end teleportUp()task.wait(0.4)teleportUp()
task.wait(0.4)doWhitesnakePhase()task.wait(0.4)end end local function dioDead()
local d=workspace.Living:FindFirstChild('Heaven Ascension Dio')if not d then
return false end local h=d:FindFirstChild('Health')return h~=nil and h.Value==0
end local function doHeavenAscentionDioPhase()if VS.Backpack:FindFirstChild(
"Dio's Bone")then return end if not VS.autoMIHEnabled then return end repeat
task.wait()until workspace.Living:FindFirstChild('Heaven Ascension Dio')or not
VS.autoMIHEnabled if not VS.autoMIHEnabled then return end while VS.
autoMIHEnabled and not VS.Backpack:FindFirstChild("Dio's Bone")do repeat task.
wait()if not workspace.Living:FindFirstChild('Heaven Ascension Dio')then repeat
task.wait()until workspace.Living:FindFirstChild('Heaven Ascension Dio')or VS.
Backpack:FindFirstChild("Dio's Bone")or not VS.autoMIHEnabled end killNPC(
'Heaven Ascension Dio',2,45)until VS.Backpack:FindFirstChild("Dio's Bone")or
dioDead()or not VS.autoMIHEnabled if not VS.autoMIHEnabled then return end if
dioDead()then teleportUp()local d=workspace.Living:FindFirstChild(
'Heaven Ascension Dio')if d then pcall(function()d:Destroy()end)end toggleStand(
)workspace.Living:WaitForChild('Heaven Ascension Dio')task.wait(0.4)end end if
not VS.autoMIHEnabled then return end if VS.Backpack:FindFirstChild("Dio's Bone"
)then fireMIHDialogues()firePucciDialogues()end end local function jotaroDead()
local j=workspace.Living:FindFirstChild('Jotaro Kujo')if not j then return false
end local h=j:FindFirstChild('Health')return h~=nil and h.Value==0 end
local function doJotaroPhase()if PlayerStand.Value~='C-Moon'then return end if
not VS.Backpack:FindFirstChild("Dio's Bone")then return end if VS.Backpack:
FindFirstChild("Jotaro's Disc")then return end if not VS.autoMIHEnabled then
return end fireMIHDialogues()if not workspace.Living:FindFirstChild(
'Jotaro Kujo')then if not VS.autoMIHEnabled then return end end workspace.Living
:WaitForChild('Jotaro Kujo')repeat task.wait()if not workspace.Living:
FindFirstChild('Jotaro Kujo')then repeat task.wait()until workspace.Living:
FindFirstChild('Jotaro Kujo')or VS.Backpack:FindFirstChild("Jotaro's Disc")or
not VS.autoMIHEnabled end killNPC('Jotaro Kujo',2,45)until VS.Backpack:
FindFirstChild("Jotaro's Disc")or jotaroDead()or not VS.autoMIHEnabled if not VS
.autoMIHEnabled then return end task.wait(0.4)if(not jotaroDead())or VS.Backpack
:FindFirstChild("Jotaro's Disc")then if VS.Backpack:FindFirstChild(
"Jotaro's Disc")then if not VS.autoMIHEnabled then return end task.wait(0.5)
pcall(function()ReplicatedStorage.Sounds.HeavenBass:Destroy()ReplicatedStorage.
Sounds.HeavenBass2:Destroy()end)task.wait(0.4)firePucciDialogues()doJotaroPhase(
)fireMIHDialogues()doHeavenAscentionDioPhase()task.wait(0.4)while PlayerStand.
Value=='C-Moon'do task.wait()if not VS.autoMIHEnabled then break end pcall(
function()getRootPart().CFrame=CFrame.new(-239.357712,370.272675,351.081848,-1,0
,0,0,1,0,0,0,-1)end)task.wait(0.25)if not VS.autoMIHEnabled then break end
pcall(function()ReplicatedStorage.Sounds.HeavenBass3:Play()ReplicatedStorage.
Sounds.HeavenBass3:Play()ReplicatedStorage.Sounds['Double Accel']:Play()end)task
.wait()pcall(function()workspace.Living:WaitForChild(LocalPlayer.Name).
RemoteFunction:InvokeServer('ToggleStand','Toggle')end)if PlayerStand.Value~=
'Made in Heaven'then break end end end else if not VS.autoMIHEnabled then return
end local j=workspace.Living:FindFirstChild('Jotaro Kujo')if j then pcall(
function()j:Destroy()end)end workspace.Living:WaitForChild('Jotaro Kujo')task.
wait(0.4)doJotaroPhase()end end local function learnSkillSafe(skill,tree)pcall(
function()workspace.Living:WaitForChild(LocalPlayer.Name,5).RemoteFunction:
InvokeServer('LearnSkill',{Skill=skill,SkillTreeType=tree})end)end runAutoMIH=
function()if VS.autoMIHRunning then return end VS.autoMIHRunning=true while VS.
autoMIHEnabled do local ok,err=pcall(function()task.wait()doWhitesnakePhase()if
VS.Backpack:FindFirstChild('Green Baby')then learnSkillSafe('Worthiness',
'Character')pcall(function()getCharacter().Humanoid:EquipTool(VS.Backpack[
'Green Baby'])end)task.wait(0.5)pcall(function()getCharacter()['Green Baby']:
Activate()end)pcall(function()local dg=PlayerGui:WaitForChild('DialogueGui')dg:
WaitForChild('Frame'):WaitForChild('ClickContinue').MouseButton1Click:Fire()task
.wait()dg:WaitForChild('Frame'):WaitForChild('Options'):WaitForChild('Option1'):
WaitForChild('TextButton').MouseButton1Click:Fire()end)task.wait(0.1)
doWhitesnakePhase()firePucciDialogues()fireMIHDialogues()learnSkillSafe(
'Vitality X','Character')learnSkillSafe('Sturdiness III','Character')
learnSkillSafe('Uppercut to The Moon','Stand')learnSkillSafe(
'Surface Inversion Punch','Stand')task.wait(0.4)end repeat task.wait()until
PlayerStand.Value=='C-Moon'or not VS.autoMIHEnabled if not VS.autoMIHEnabled
then return end if not VS.Backpack:FindFirstChild("Dio's Bone")then
fireMIHDialogues()doHeavenAscentionDioPhase()end repeat task.wait()until VS.
Backpack:FindFirstChild("Dio's Bone")or not VS.autoMIHEnabled if not VS.
autoMIHEnabled then return end fireMIHDialogues()doJotaroPhase()if PlayerStand.
Value=='Made in Heaven'then notify('Auto MIH','Made in Heaven obtained!',
'success')sendWebhook('Made in Heaven obtained!',true)VS.autoMIHEnabled=false
end end)if not ok and VS.autoMIHEnabled then task.wait(0.5)end end VS.
autoMIHRunning=false end end)()env.runAutoMIH=runAutoMIH end end function
__DARKLUA_BUNDLE_MODULES.ax():typeof(__modImpl())local v=
__DARKLUA_BUNDLE_MODULES.cache.ax if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.ax=v end return v.c end end do local function
__modImpl()return function(env)local VS=env.VS local Players=env.Players local
RunService=env.RunService local LocalPlayer=env.LocalPlayer local ClientFX=env.
ClientFX local getRootPart=env.getRootPart local teleportUpTemp=env.
teleportUpTemp VS.antiTSEnabled=false VS.antiCWEnabled=false local startAntiTS
local startAntiCW(function()local cwConnected=false startAntiTS=function()if VS.
antiTSRunning then return end VS.antiTSRunning=true VS.antiTSConnections=VS.
antiTSConnections or{}local player=Players.LocalPlayer local lighting=game:
GetService('Lighting')local TS_WALKSPEED=16 local TS_JUMPPOWER=50 local function
stopAntiTS()VS.antiTSRunning=false for _,conn in ipairs(VS.antiTSConnections)do
pcall(function()if conn then conn:Disconnect()end end)end VS.antiTSConnections={
}end VS.stopAntiTS=stopAntiTS local function setupCharacter(char)local humanoid=
char:WaitForChild('Humanoid',5)local root=char:WaitForChild('HumanoidRootPart',5
)if not humanoid or not root then return end local conn=RunService.Stepped:
Connect(function()if not VS.antiTSEnabled then return end if not char.Parent
then return end local tsActive=workspace:FindFirstChild('TimeStop')or lighting:
FindFirstChild('TimeStop')if not tsActive then return end humanoid.PlatformStand
=false humanoid.AutoRotate=true humanoid.WalkSpeed=TS_WALKSPEED humanoid.
JumpPower=TS_JUMPPOWER humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,
true)humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,true)humanoid:
SetStateEnabled(Enum.HumanoidStateType.Running,true)humanoid:ChangeState(Enum.
HumanoidStateType.Running)for _,part in ipairs(char:GetDescendants())do if part:
IsA('BasePart')and part.Anchored then part.Anchored=false end end if root.
AssemblyLinearVelocity.Magnitude<0.1 then root.AssemblyLinearVelocity=root.
CFrame.LookVector*0.05 end end)table.insert(VS.antiTSConnections,conn)end if
player.Character then setupCharacter(player.Character)end local charConn=player.
CharacterAdded:Connect(function(char)if not VS.antiTSEnabled then return end
task.wait(0.05)setupCharacter(char)end)table.insert(VS.antiTSConnections,
charConn)end startAntiCW=function()if cwConnected then return end cwConnected=
true ClientFX.OnClientEvent:Connect(function(...)if not VS.antiCWEnabled then
return end local args={...}if not args[2]then return end if not args[2].Sound
then return end if not args[2].Origin then return end if args[2].Sound~=
'Rage Mode'then return end if string.find(tostring(args[2].Origin),LocalPlayer.
Name)then return end local dist=(args[2].Origin.Position-getRootPart().Position)
.Magnitude local standName=args[2].Origin.Parent:FindFirstChild('Stand Name')if
dist<=100 and standName and standName.Value=='Chariot Requiem'then local savedCF
=getRootPart().CFrame teleportUpTemp()task.wait(1.7)getRootPart().CFrame=savedCF
end end)end end)()env.startAntiTS=startAntiTS env.startAntiCW=startAntiCW end
end function __DARKLUA_BUNDLE_MODULES.ay():typeof(__modImpl())local v=
__DARKLUA_BUNDLE_MODULES.cache.ay if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.ay=v end return v.c end end do local function
__modImpl()return function(env)local VS=env.VS local UserInputService=env.
UserInputService local LocalPlayer=env.LocalPlayer local getPity=env.getPity
local roundTwo=env.roundTwo getgenv()._pulseMoveState=getgenv()._pulseMoveState
or{wsEnabled=false,jpEnabled=false,wsSpeed=24,jpPower=24,wsConn=nil,jpConn=nil}
do local old=LocalPlayer.PlayerGui:FindFirstChild('PulsePityShower')if old then
old:Destroy()end old=game.CoreGui:FindFirstChild('PulsePityShower')if old then
old:Destroy()end end getgenv()._pulsePityHudState=getgenv()._pulsePityHudState
or{enabled=false,frame=nil,update=nil}(function()local PITY_PANEL_W=272 local
PITY_PANEL_H=182 local pityGui=Instance.new('ScreenGui')pityGui.Name=
'PulsePityShower'pityGui.ResetOnSpawn=false pityGui.DisplayOrder=998 pityGui.
ZIndexBehavior=Enum.ZIndexBehavior.Sibling pityGui.Parent=LocalPlayer.PlayerGui
local pityHud=getgenv()._pulsePityHudState pityHud.frame=Instance.new('Frame')
pityHud.frame.Name='GlassPanel'pityHud.frame.Size=UDim2.new(0,PITY_PANEL_W,0,
PITY_PANEL_H)pityHud.frame.Position=UDim2.new(0.5,-PITY_PANEL_W/2,0.06,0)pityHud
.frame.BackgroundColor3=Color3.fromRGB(255,255,255)pityHud.frame.
BackgroundTransparency=0.84 pityHud.frame.BorderSizePixel=0 pityHud.frame.
ClipsDescendants=true pityHud.frame.Visible=false pityHud.frame.Parent=pityGui
Instance.new('UICorner',pityHud.frame).CornerRadius=UDim.new(0,18)local
pityStroke=Instance.new('UIStroke')pityStroke.Color=Color3.fromRGB(255,255,255)
pityStroke.Transparency=0.58 pityStroke.Thickness=1 pityStroke.Parent=pityHud.
frame local pityGrad=Instance.new('UIGradient')pityGrad.Color=ColorSequence.new(
{ColorSequenceKeypoint.new(0,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.
new(0.4,Color3.fromRGB(230,238,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(
200,215,255))})pityGrad.Transparency=NumberSequence.new({NumberSequenceKeypoint.
new(0,0),NumberSequenceKeypoint.new(1,0.15)})pityGrad.Rotation=145 pityGrad.
Parent=pityHud.frame local pityDragging,pityDragStart,pityStartPos
local function pityBeginDrag(i)if i.UserInputType==Enum.UserInputType.
MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then pityDragging=true
pityDragStart=i.Position pityStartPos=pityHud.frame.Position end end
local function pityEndDrag(i)if i.UserInputType==Enum.UserInputType.MouseButton1
or i.UserInputType==Enum.UserInputType.Touch then pityDragging=false end end
pityHud.frame.InputBegan:Connect(pityBeginDrag)pityHud.frame.InputEnded:Connect(
pityEndDrag)UserInputService.InputChanged:Connect(function(i)if pityDragging and
pityHud.frame.Visible then if i.UserInputType==Enum.UserInputType.MouseMovement
or i.UserInputType==Enum.UserInputType.Touch then local d=i.Position-
pityDragStart pityHud.frame.Position=UDim2.new(pityStartPos.X.Scale,pityStartPos
.X.Offset+d.X,pityStartPos.Y.Scale,pityStartPos.Y.Offset+d.Y)end end end)
UserInputService.InputBegan:Connect(function(input,gpe)if gpe then return end if
input.KeyCode==Enum.KeyCode.L then if pityGui.Parent and pityHud.enabled then
pityHud.frame.Visible=not pityHud.frame.Visible end end end)local pityHeader=
Instance.new('Frame')pityHeader.Size=UDim2.new(1,0,0,44)pityHeader.
BackgroundColor3=Color3.fromRGB(255,255,255)pityHeader.BackgroundTransparency=
0.9 pityHeader.BorderSizePixel=0 pityHeader.Parent=pityHud.frame Instance.new(
'UICorner',pityHeader).CornerRadius=UDim.new(0,18)local pityHGrad=Instance.new(
'UIGradient')pityHGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,
Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(210,228,
255))})pityHGrad.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,
0.1),NumberSequenceKeypoint.new(1,0.4)})pityHGrad.Rotation=90 pityHGrad.Parent=
pityHeader local pityTitle=Instance.new('TextLabel')pityTitle.Size=UDim2.new(1,-
20,1,0)pityTitle.Position=UDim2.new(0,12,0,0)pityTitle.BackgroundTransparency=1
pityTitle.Font=Enum.Font.GothamBold pityTitle.TextSize=13 pityTitle.TextColor3=
Color3.fromRGB(255,255,255)pityTitle.TextTransparency=0.05 pityTitle.
TextXAlignment=Enum.TextXAlignment.Left pityTitle.Text='\u{25c6}  pity info'
pityTitle.Parent=pityHeader pityHeader.InputBegan:Connect(pityBeginDrag)
pityHeader.InputEnded:Connect(pityEndDrag)pityTitle.InputBegan:Connect(
pityBeginDrag)pityTitle.InputEnded:Connect(pityEndDrag)local pityDivider=
Instance.new('Frame')pityDivider.Size=UDim2.new(1,-24,0,1)pityDivider.Position=
UDim2.new(0,12,0,44)pityDivider.BackgroundColor3=Color3.fromRGB(255,255,255)
pityDivider.BackgroundTransparency=0.72 pityDivider.BorderSizePixel=0
pityDivider.Parent=pityHud.frame local pityLabels={}local pityBodyY0=52 local
pityLineH=22 for i,txt in ipairs({'Pity Wanted: N/A','Current Pity: N/A',
'Half Pity: N/A','Pity Farm: OFF','DTrouble: OFF'})do local lbl=Instance.new(
'TextLabel')lbl.Size=UDim2.new(1,-28,0,pityLineH)lbl.Position=UDim2.new(0,14,0,
pityBodyY0+(i-1)*pityLineH)lbl.BackgroundTransparency=1 lbl.Font=Enum.Font.
GothamMedium lbl.TextSize=12 lbl.TextColor3=Color3.fromRGB(255,255,255)lbl.
TextTransparency=0.1 lbl.TextXAlignment=Enum.TextXAlignment.Left lbl.Text=txt
lbl.Parent=pityHud.frame table.insert(pityLabels,lbl)end pityHud.update=function
()if not pityHud.enabled then return end pityLabels[1].Text='Pity Wanted: '..(VS
.pityWanted and tostring(VS.pityWanted)or'N/A')pityLabels[2].Text=
'Current Pity: '..roundTwo(getPity())pityLabels[3].Text='Half Pity: '..(VS.
halfPityGoal and tostring(VS.halfPityGoal)or'N/A')pityLabels[4].Text=
'Pity Farm: '..(VS.pityFarmEnabled and'ON'or'OFF')pityLabels[5].Text=
'DTrouble: '..(VS.doubleTrouble and'ON'or'OFF')end task.spawn(function()while
true do task.wait(0.5)if pityHud.enabled and type(pityHud.update)=='function'
then pcall(pityHud.update)end end end)end)()end end function
__DARKLUA_BUNDLE_MODULES.az():typeof(__modImpl())local v=
__DARKLUA_BUNDLE_MODULES.cache.az if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.az=v end return v.c end end do local function
__modImpl()return function(env)local Window=env.Window local CreateFluentTab=env
.CreateFluentTab local VS=env.VS local livingMissingAtLoad=env.
livingMissingAtLoad local PlayerStats=env.PlayerStats local PlayerLevel=env.
PlayerLevel local PlayerPity=env.PlayerPity local PlayerPrestige=env.
PlayerPrestige local PlayerMoney=env.PlayerMoney local refreshItemCounts=env.
refreshItemCounts local getPity=env.getPity local roundTwo=env.roundTwo local
notify=env.notify local UI={}do local function grid(tab)local row=tab:
CreateGroup({direction='row'})return row:CreateGroup({direction='column'}),row:
CreateGroup({direction='column'})end local function section(column,name)local
group=column:CreateGroup({direction='column'})group:CreateSection({name=name})
return group end local function stats(tab,list)local row=tab:CreateGroup({
direction='row'})local made={}for _,info in ipairs(list)do table.insert(made,row
:CreateGroup({direction='column'}):CreateStat({name=info[1],prefix=info[2],
compact=false,changeMode='absolute',changeBaseline='initial'}))end return table.
unpack(made)end local farmTab=CreateFluentTab('Farm','backpack-24-filled')local
standsTab=CreateFluentTab('Stands','star-24-filled')local autoTab=
CreateFluentTab('Auto Stands','bot-24-filled')local mobTab=CreateFluentTab(
'Mob Farm','target-24-filled')local combatTab=CreateFluentTab('Combat',
'flash-24-filled')local playerTab=CreateFluentTab('Player','person-24-filled')
local npcTab=CreateFluentTab('NPCs','chat-multiple-24-filled')local miscTab=
CreateFluentTab('Misc','wrench-24-filled')UI.miscTab=miscTab local arrowsStat,
rokasStat,ribsStat,moneyStat=stats(farmTab,{{'Arrows'},{'Rokakakas'},{
'Rib Cages'},{'Money','$'}})local left,right=grid(farmTab)UI.itemFarm=section(
left,'Item Farm')UI.selling=section(right,'Selling')UI.alerts=section(right,
'Alerts')UI.timing=section(farmTab:CreateGroup({direction='column'}),'Timing')UI
.timingRow=UI.timing:CreateGroup({direction='row'})UI.pingRow=UI.timing:
CreateGroup({direction='row'})local levelStat,prestigeStat=stats(standsTab,{{
'Level'},{'Prestige'}})left,right=grid(standsTab)UI.standFarm=section(left,
'Stand Farm')UI.shinyFarm=section(left,'Shiny Farm')UI.ribFarm=section(left,
'Rib Farm')UI.pityFarm=section(right,'Pity Farm')local pityCard=UI.pityFarm:
CreateText({name='Pity',text='-'})UI.retries=section(standsTab:CreateGroup({
direction='column'}),'Retries'):CreateGroup({direction='row'})left,right=grid(
autoTab)UI.autoMIH=section(left,'Auto MIH')UI.autoWR=section(left,'Auto WR')UI.
hamon=section(left,'Hamon Charge')UI.autoTusk=section(right,'Auto Tusk')UI.
autoSTW=section(right,'Auto STW')UI.prestige=section(right,'Auto Prestige')local
questStat,questGoalStat=stats(mobTab,{{'Quest Progress'},{'Quest Goal'}})left,
right=grid(mobTab)UI.questFarm=section(left,'Quest Farm')UI.npcKiller=section(
right,'NPC Killer')left,right=grid(mobTab)UI.playerFarm=section(left,
'Player Farm')UI.farmSettings=section(right,'Settings')left,right=grid(combatTab
)UI.parry=section(left,'Auto Parry')UI.barrage=section(right,'Auto Barrage')UI.
anti=section(right,'Anti')left,right=grid(combatTab)UI.camLock=section(left,
'Camera Lock')UI.aim=section(right,'Aim')UI.stand=section(combatTab:CreateGroup(
{direction='column'}),'Stand')left,right=grid(combatTab)UI.attach=section(left,
'Stand Attach')UI.skills=section(left,'Skills')UI.pilot=section(right,'Pilot')
left,right=grid(playerTab)UI.movement=section(left,'Movement')UI.fly=section(
right,'Fly')UI.dash=section(right,'Dash')left,right=grid(playerTab)UI.esp=
section(left,'ESP')UI.teleport=section(right,'Teleport')left,right=grid(
playerTab)UI.visuals=section(left,'Visuals')UI.tools=section(right,'Tools')left,
right=grid(npcTab)UI.dialogue=section(left,'Dialogue')UI.story=section(right,
'Story')left,right=grid(npcTab)UI.shop=section(left,'Shop')UI.styles=section(
right,'Fighting Styles')left,right=grid(miscTab)UI.world=section(left,'World')UI
.server=section(left,'Server')UI.sticky=section(left,'Sticky Fingers')UI.config=
section(left,'Config')UI.session=section(right,'Session')UI.webhook=section(
right,'Webhook')UI.kidnap=section(right,'Kidnapper')UI.fun=section(right,'Fun')
task.spawn(function()local lastPity while not Window.unloaded do pcall(
refreshItemCounts)local questProgress=PlayerStats:FindFirstChild('QuestProgress'
)local questMax=PlayerStats:FindFirstChild('QuestMaxProgress')for stat,value in
pairs({[arrowsStat]=VS.itemCounts.arrows,[rokasStat]=VS.itemCounts.rokas,[
ribsStat]=VS.itemCounts.ribs,[moneyStat]=PlayerMoney.Value,[levelStat]=
PlayerLevel.Value,[prestigeStat]=PlayerPrestige.Value,[questStat]=questProgress
and questProgress.Value or 0,[questGoalStat]=questMax and questMax.Value or 0})
do if stat.value~=value then pcall(stat.Set,stat,value)end end local pity=
roundTwo(getPity())..'  \u{b7}  raw '..PlayerPity.Value..'  \u{b7}  goal '..(VS.
pityWanted and tostring(VS.pityWanted)or'not set')if pity~=lastPity then
lastPity=pity pityCard:Set(pity)end task.wait(1)end end)end function UI.keybind(
section,flag,target,onChanged)return section:CreateKeybind({name='Keybind',flag=
flag,onChanged=onChanged,callback=function()if type(target)=='function'then
target()elseif target then target:Set(not target.value)end end})end function UI.
lock(element)element.main.Interactable=false local shade=Window:Create('Frame',{
Name='Locked',BackgroundColor3=Color3.fromRGB(10,8,16),BackgroundTransparency=
0.42,Size=UDim2.fromScale(1,1),BorderSizePixel=0,ZIndex=80,Parent=element.main})
Window:Create('UICorner',{Parent=shade},{CornerRadius='ElementCornerRadius'})end
function UI.picker(section,name,flag,entries)local names,actions={},{}for _,
entry in ipairs(entries)do table.insert(names,entry[1])actions[entry[1] ]=entry[
2]end local picked=names[1]section:CreateDropdown({name=name,options=names,value
=names[1],flag=flag,callback=function(v)picked=type(v)=='table'and v[1]or v end}
)section:CreateButton({name='Buy',callback=function()local action=picked and
actions[picked]if action then action()else notify('Dialogues',
'Pick something first.','warn')end end})end if livingMissingAtLoad then task.
defer(function()pcall(function()Window:Navigate(UI.miscTab)end)end)end env.UI=UI
end end function __DARKLUA_BUNDLE_MODULES.aA():typeof(__modImpl())local v=
__DARKLUA_BUNDLE_MODULES.cache.aA if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.aA=v end return v.c end end do local function
__modImpl()return function(env)local VS=env.VS local PlayerMoney=env.PlayerMoney
local getRemoteEvent=env.getRemoteEvent local notify=env.notify local
itemOptions=env.itemOptions local itemSellOptions=env.itemSellOptions local
ITEM_DROPDOWN_EVERY=env.ITEM_DROPDOWN_EVERY local farmChoices=env.farmChoices
local sellChoices=env.sellChoices local selectedFarmItems=env.selectedFarmItems
local selectedSellItems=env.selectedSellItems local itemFarmTiming=env.
itemFarmTiming local enableItemESP=env.enableItemESP local disableItemESP=env.
disableItemESP local runItemFarm=env.runItemFarm local UI=env.UI UI.itemFarm:
CreateDropdown({name='Items',options=farmChoices,value={},flag=
'MAIN_ItemsToFarm',multiSelect=true,callback=function(v)for k in pairs(
selectedFarmItems)do selectedFarmItems[k]=nil end local picked=type(v)=='table'
and v or{v}local every=false for _,n in ipairs(picked)do if n==
ITEM_DROPDOWN_EVERY then every=true break end end if every then for _,n in
ipairs(itemOptions)do selectedFarmItems[n]=true end else for _,n in ipairs(
picked)do if n~=ITEM_DROPDOWN_EVERY then selectedFarmItems[n]=true end end end
end})UI.itemFarm:CreateDropdown({name='Method',options={'Normal','Hidden'},value
={'Normal'},flag='MAIN_ItemFarmMethod',callback=function(v)VS.itemFarmMethod=
type(v)=='table'and(v[1]or'Normal')or(v or'Normal')end})UI.itemFarm:
CreateToggle({name='Enable',value=false,flag='MAIN_EnableItemFarm',callback=
function(v)VS.itemFarmEnabled=v if v then task.spawn(runItemFarm)notify(
'Item Farm','Started!','start')else notify('Item Farm','Stopped.','stop')end end
})UI.itemFarm:CreateToggle({name='Hop When Empty',value=false,flag=
'MAIN_ServerHopOnEmpty',callback=function(v)VS.hopOnEmpty=v end})UI.selling:
CreateDropdown({name='When to Sell',options={'Never',
'Selected item is full in inventory. Sell one',
'Selected item is full in inventory. Sell all'},value={'Never'},flag=
'MAIN_WhenToSell',callback=function(v)VS.sellWhen=type(v)=='table'and(v[1]or
'Never')or(v or'Never')if VS.sellWhen=='Whenever'then VS.sellWhen='Never'end end
})UI.selling:CreateDropdown({name='Items to Sell',options=sellChoices,value={},
flag='MAIN_ItemsToSellWhileFarming',multiSelect=true,callback=function(v)for k
in pairs(selectedSellItems)do selectedSellItems[k]=nil end local picked=type(v)
=='table'and v or{v}local every=false for _,n in ipairs(picked)do if n==
ITEM_DROPDOWN_EVERY then every=true break end end if every then for _,n in
ipairs(itemSellOptions)do selectedSellItems[n]=true end else for _,n in ipairs(
picked)do if n~=ITEM_DROPDOWN_EVERY then selectedSellItems[n]=true end end end
end})UI.selling:CreateToggle({name='Buy While Farming',value=false,flag=
'MAIN_BuyItemsWhileFarming',callback=function(v)VS.buyItemsEnabled=v end})do
getgenv()._pulseAutoBuyLuckyArrowEnabled=false UI.selling:CreateToggle({name=
'Auto Buy Lucky Arrow',value=false,flag='MAIN_AutoBuyLuckyArrow',callback=
function(v)getgenv()._pulseAutoBuyLuckyArrowEnabled=v if v then notify('Farm',
'Auto Buy Lucky Arrow enabled.','start')task.spawn(function()while getgenv().
_pulseAutoBuyLuckyArrowEnabled do pcall(function()if PlayerMoney.Value>=75000
then getRemoteEvent():FireServer('PurchaseShopItem',{['ItemName']=
'1x Lucky Arrow'},1,2)end end)task.wait(3)end end)else notify('Farm',
'Auto Buy Lucky Arrow disabled.','stop')end end})end UI.alerts:CreateToggle({
name='Item ESP',value=false,flag='MAIN_ItemESP',callback=function(v)VS.
itemESPEnabled=v if v then enableItemESP()notify('Item Farm','Item ESP ON.','on'
)else disableItemESP()notify('Item Farm','Item ESP OFF.','off')end end})UI.
alerts:CreateToggle({name='Spawn Alerts',value=false,flag=
'MAIN_ItemSpawnNotifier',callback=function(v)VS.itemSpawnNotif=v if v then VS.
itemSpawnConn=workspace.Item_Spawns.Items.ChildAdded:Connect(function(item)if
not VS.itemSpawnNotif then return end if item:IsA('Model')then local prox=item:
WaitForChild('ProximityPrompt',2)if prox then local itemName=prox.ObjectText if
not VS.notifyOnlySelected or selectedFarmItems[itemName]then notify('Item Farm',
itemName..' has spawned!','info')end end end end)else if VS.itemSpawnConn then
VS.itemSpawnConn:Disconnect()VS.itemSpawnConn=nil end end end})UI.alerts:
CreateToggle({name='Selected Items Only',value=false,flag=
'MAIN_NotifyOnlySelectedItems',callback=function(v)VS.notifyOnlySelected=v end})
UI.pingRow:CreateSlider({name='Ping Divisor',range={50,500},increment=10,value=
220,flag='MAIN_IF_PingDivisor',callback=function(v)itemFarmTiming.pingDivisor=
math.max(1,v)end})UI.timingRow:CreateSlider({name='Loop Tick (s)',range={0.05,
0.6},increment=0.01,value=0.2,flag='MAIN_IF_MainLoopSeconds',callback=function(v
)itemFarmTiming.mainLoopSeconds=v end})UI.timingRow:CreateSlider({name=
'Sweep Step (s)',range={0.02,0.25},increment=0.01,value=0.07,flag=
'MAIN_IF_SweepStepSeconds',callback=function(v)itemFarmTiming.sweepStepSeconds=v
end})UI.timingRow:CreateSlider({name='Pickup Delay (s)',range={0.1,0.6},
increment=0.01,value=0.31,flag='MAIN_IF_PickupBaseSeconds',callback=function(v)
itemFarmTiming.pickupBaseSeconds=v end})UI.pingRow:CreateSlider({name=
'Ping Delay Cap (s)',range={0,0.25},increment=0.01,value=0.1,flag=
'MAIN_IF_PingDelayMaxSeconds',callback=function(v)itemFarmTiming.
pingDelayMaxSeconds=v end})UI.itemFarm:CreateSlider({name='Rescan After (s)',
range={1,12},increment=0.5,value=3,flag='MAIN_IF_EmptyRescanSeconds',callback=
function(v)itemFarmTiming.emptyRescanSeconds=v end})UI.itemFarm:CreateSlider({
name='Hop Delay (s)',range={0.1,2},increment=0.05,value=0.3,flag=
'MAIN_IF_HopOnEmptyWaitSeconds',callback=function(v)itemFarmTiming.
hopOnEmptyWaitSeconds=v end})end end function __DARKLUA_BUNDLE_MODULES.aB():
typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.aB if not v then v={c=
__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.aB=v end return v.c end end do
local function __modImpl()return function(env)local VS=env.VS local notify=env.
notify local teleportUp=env.teleportUp local selectedStands=env.selectedStands
local startStandFarm=env.startStandFarm local ShinyFarm=env.ShinyFarm local
runAutoMIH=env.runAutoMIH local UI=env.UI UI.standFarm:CreateDropdown({name=
'Stands',options={'Whitesnake','White Album','King Crimson','The World',
'Star Platinum','Crazy Diamond','Gold Experience','Killer Queen',
"Magician's Red",'Purple Haze','Sticky Fingers','Mr. President','Aerosmith',
'Cream','Beach Boy','Red Hot Chili Pepper','The Hand','Anubis','Stone Free',
'Six Pistols','Hermit Purple','Hierophant Green','Silver Chariot','Soft & Wet',
'The World Alternate Universe','Scary Monsters','Tusk ACT 1','D4C'},value={},
flag='MAIN_StandsToFarm',multiSelect=true,callback=function(v)for k in pairs(
selectedStands)do selectedStands[k]=nil end for _,n in ipairs(v)do
selectedStands[n]=true end end})UI.standFarm:CreateToggle({name='Stop on Shiny',
value=false,flag='MAIN_StopOnAnyShiny',callback=function(v)VS.stopOnShiny=v end}
)UI.standFarm:CreateToggle({name='Swap Slot on Hit',value=false,flag=
'MAIN_SwapSlotOnDesired',callback=function(v)VS.swapSlotOnDesired=v if v then
notify('Stand Farm','Make sure you have Empty slot(s).','info')end end})UI.
standFarm:CreateToggle({name='Enable',value=false,flag='MAIN_EnableStandFarm',
callback=function(v)VS.standFarmEnabled=v if v then task.spawn(startStandFarm)
else notify('Stand Farm','Stopped.','stop')end end})UI.shinyFarm:CreateDropdown(
{name='Target Shiny',options=ShinyFarm.NAMES,value={ShinyFarm.any},flag=
'MAIN_ShinyTarget',callback=function(v)local sel=type(v)=='table'and(v[1]or
ShinyFarm.any)or(v or ShinyFarm.any)ShinyFarm.target=(sel==ShinyFarm.any)and''or
sel end})UI.shinyFarm:CreateToggle({name='Enable',value=false,flag=
'MAIN_EnableShinyFarm',callback=function(v)ShinyFarm.enabled=v if v then task.
spawn(ShinyFarm.start)else notify('Shiny Farm','Stopped.','stop')end end})UI.
autoMIH:CreateToggle({name='Enable',value=false,flag='MAIN_EnableAutoMIH',
callback=function(v)VS.autoMIHEnabled=v if v then if not VS.autoMIHRunning then
task.spawn(runAutoMIH)end notify('Auto MIH','Started!','start')else pcall(
teleportUp)notify('Auto MIH','Stopped.','stop')end end})end end function
__DARKLUA_BUNDLE_MODULES.aC():typeof(__modImpl())local v=
__DARKLUA_BUNDLE_MODULES.cache.aC if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.aC=v end return v.c end end do local function
__modImpl()return function(env)local VS=env.VS local ReplicatedStorage=env.
ReplicatedStorage local LocalPlayer=env.LocalPlayer local PlayerGui=env.
PlayerGui local PlayerStand=env.PlayerStand local PlayerPrestige=env.
PlayerPrestige local PlayerSpec=env.PlayerSpec local PlayerMoney=env.PlayerMoney
local RIB_NAME=env.RIB_NAME local getCharacter=env.getCharacter local
getRemoteEvent=env.getRemoteEvent local isRibCagePurchaseItem=env.
isRibCagePurchaseItem local purchaseRibCage=env.purchaseRibCage local
unequipAllTools=env.unequipAllTools local waitUntilNewChar=env.waitUntilNewChar
local fireDialogue=env.fireDialogue local learnSkill=env.learnSkill local
getStandMorph=env.getStandMorph local desummonStand=env.desummonStand local
toggleStand=env.toggleStand local notify=env.notify local teleportUp=env.
teleportUp local learnWorthiness=env.learnWorthiness local UI=env.UI;(function()
local autoTA4Enabled=false local autoTA4Busy=false local autoTA4Status='Idle'
local autoTuskStopAt=4 local LEFT_ARM_NAMES={"Left Arm of the Saint's Corpse",
"Left Arm of The Saint's Corpse"}local PELVIS_NAMES={
"Pelvis of The Saint's Corpse","Pelvis of the Saint's Corpse"}local RIB_NAMES={
RIB_NAME}local SHOP_RIB_BUYS={{"1x Rib Cage of the Saint's Corpse",1,12}}local
SHOP_LEFTARM_BUYS={{"1x Left Arm of the Saint's Corpse",1,11},{
"1x Left Arm of The Saint's Corpse",1,11}}local SHOP_PELVIS_BUYS={{
"1x Pelvis of The Saint's Corpse",1,10},{"1x Pelvis of the Saint's Corpse",1,10}
}local function findFirstNamed(parent,names)if not parent then return nil end
for _,n in ipairs(names)do local f=parent:FindFirstChild(n)if f then return f
end end return nil end local function hasItemAnywhere(names)return
findFirstNamed(VS.Backpack,names)or findFirstNamed(LocalPlayer.Character,names)
or nil end local function purchaseLeftArm()local Event=game:GetService('Players'
).LocalPlayer.Character.RemoteEvent Event:FireServer('PurchaseShopItem',{
ItemName="1x Left Arm of the Saint's Corpse"})end local function shopBuy(name,
page,slot)pcall(function()if isRibCagePurchaseItem(name)then purchaseRibCage()
elseif string.find(name,'Left Arm')then purchaseLeftArm()else getRemoteEvent():
FireServer('PurchaseShopItem',{ItemName=name},page,slot)end end)end
local function buyOneOf(buys,neededCost)if PlayerMoney.Value<neededCost then
return false,'money'end for _,b in ipairs(buys)do shopBuy(b[1],b[2],b[3])task.
wait(0.55)local nm=b[1]:gsub('^1x ','')if VS.Backpack:FindFirstChild(nm)then
return true end end return false,'purchase'end local function holdItem(names)
local char=getCharacter()unequipAllTools()task.wait(0.1)local item=
findFirstNamed(VS.Backpack,names)if not item then return nil end item.Parent=
char task.wait(0.15)return item end local function hasWorthinessV()local sk=
LocalPlayer:FindFirstChild('CharacterSkillTree')local w5=sk and sk:
FindFirstChild('Worthiness V')return w5 and w5.Value==true end local function
isSpinSpec()local v=tostring(PlayerSpec.Value or'')return v=='Spin'or v:lower()
=='spin'end local function setStatus(s)autoTA4Status=s end local function
isTuskAct(stand,act)return stand==('Tusk ACT '..act)end local function
alreadyAtOrPast(act)local s=PlayerStand.Value for n=act,4 do if isTuskAct(s,n)
then return true end end return false end local function currentTuskAct()local s
=PlayerStand.Value for n=1,4 do if isTuskAct(s,n)then return n end end return 0
end local function rollRibCageOnce()if getStandMorph()then toggleStand()end task
.wait(0.15)learnSkill('Worthiness ','Character')task.wait(0.05)fireDialogue(
RIB_NAME,'Dialogue2','Option1')local deadline=tick()+4 while autoTA4Enabled and
tick()<deadline and not getStandMorph()do task.wait(0.15)end task.wait(0.4)end
local function useCorpsePartFor(names,label)desummonStand()task.wait(0.15)local
item=holdItem(names)if not item then return false end local heldName=item.Name
pcall(function()item:Activate()end)task.wait(0.2)fireDialogue(heldName,
'Dialogue2','Option1')task.wait(1)unequipAllTools()return true end
local function pushJesusDialogue()local dg=PlayerGui:FindFirstChild(
'DialogueGui')if not dg then return false end local frame=dg:FindFirstChild(
'Frame')local cont=frame and frame:FindFirstChild('ClickContinue')local opts=
frame and frame:FindFirstChild('Options')local opt1=opts and opts:
FindFirstChild('Option1')local btn=opt1 and opt1:FindFirstChild('TextButton')
local function click(sig)if getconnections then for _,c in pairs(getconnections(
sig))do c:Fire()end else sig:Fire()end end pcall(function()if cont and cont.
MouseButton1Click and cont.Visible then click(cont.MouseButton1Click)end if btn
and btn.MouseButton1Click then click(btn.MouseButton1Click)end end)return true
end local function tryJesusEvolve()local deadline=tick()+15 while autoTA4Enabled
and tick()<deadline do pcall(function()getRemoteEvent():FireServer(
'PromptTriggered',ReplicatedStorage.NewDialogue.Jesus)end)pushJesusDialogue()if
isTuskAct(PlayerStand.Value,3)then return true end task.wait(0.25)end return
isTuskAct(PlayerStand.Value,3)end local function runAutoTA4()autoTA4Busy=true
local stopAt=autoTuskStopAt if not isSpinSpec()then notify('Auto Tusk',
'You need the Spin spec equipped first.',7,'warn')setStatus('Spin missing')
autoTA4Enabled=false autoTA4Busy=false return end notify('Auto Tusk','Started.',
'start')if not hasWorthinessV()then setStatus('Learning Worthiness')
learnWorthiness()task.wait(0.6)end if not alreadyAtOrPast(1)then local tries=0
while autoTA4Enabled and not isTuskAct(PlayerStand.Value,1)and tries<80 do tries
=tries+1 setStatus('Phase 1: rolling for Tusk ACT 1 (try '..tries..')')if not
findFirstNamed(VS.Backpack,RIB_NAMES)then local ok,why=buyOneOf(SHOP_RIB_BUYS,
3500)if not ok then notify('Auto Tusk',why=='money'and
'Out of money for Rib Cages.'or'Failed to buy Rib Cage.',7,'warn')setStatus(
'No Rib Cage')autoTA4Enabled=false autoTA4Busy=false return end end
rollRibCageOnce()if alreadyAtOrPast(2)then break end end if autoTA4Enabled and
not isTuskAct(PlayerStand.Value,1)and not alreadyAtOrPast(2)then notify(
'Auto Tusk','Could not roll Tusk ACT 1 within 80 tries.',7,'warn')setStatus(
'Tusk ACT 1 roll failed')autoTA4Enabled=false autoTA4Busy=false return end end
if not autoTA4Enabled then setStatus('Stopped')autoTA4Busy=false return end if
isTuskAct(PlayerStand.Value,1)then if PlayerPrestige.Value<1 then notify(
'Auto Tusk','Need Prestige 1+ to evolve Tusk ACT 1 \u{2192} ACT 2.',7,'warn')
setStatus('Prestige < 1')autoTA4Enabled=false autoTA4Busy=false return end
setStatus('Phase 2: using Left Arm for Tusk ACT 2')if not hasItemAnywhere(
LEFT_ARM_NAMES)then local ok,why=buyOneOf(SHOP_LEFTARM_BUYS,15000)if not ok then
notify('Auto Tusk',why=='money'and
"Out of money for Left Arm of The Saint's Corpse."or'Failed to buy Left Arm.',7,
'warn')setStatus('No Left Arm')autoTA4Enabled=false autoTA4Busy=false return end
end useCorpsePartFor(LEFT_ARM_NAMES,'Left Arm')local deadline=tick()+6 while
autoTA4Enabled and tick()<deadline and not isTuskAct(PlayerStand.Value,2)do task
.wait(0.2)end end if not autoTA4Enabled then setStatus('Stopped')autoTA4Busy=
false return end if stopAt>=3 and isTuskAct(PlayerStand.Value,2)then setStatus(
'Phase 3: Jesus dialogue for Tusk ACT 3')tryJesusEvolve()local deadline=tick()+6
while autoTA4Enabled and tick()<deadline and not isTuskAct(PlayerStand.Value,3)
do task.wait(0.2)end end if not autoTA4Enabled then setStatus('Stopped')
autoTA4Busy=false return end if stopAt>=4 and isTuskAct(PlayerStand.Value,3)then
setStatus('Phase 4: using Pelvis for Tusk ACT 4')if not hasItemAnywhere(
PELVIS_NAMES)then local ok,why=buyOneOf(SHOP_PELVIS_BUYS,45000)if not ok then
notify('Auto Tusk',why=='money'and
"Out of money for Pelvis of The Saint's Corpse."or'Failed to buy Pelvis.',7,
'warn')setStatus('No Pelvis')autoTA4Enabled=false autoTA4Busy=false return end
end setStatus('Phase 4: Resetting before Pelvis...')local char=getCharacter()if
char and char:FindFirstChild('Humanoid')then char.Humanoid.Health=0 end
waitUntilNewChar()task.wait(1.5)useCorpsePartFor(PELVIS_NAMES,'Pelvis')local
deadline=tick()+6 while autoTA4Enabled and tick()<deadline and not isTuskAct(
PlayerStand.Value,4)do task.wait(0.2)end end local reached=currentTuskAct()if
reached>=stopAt then notify('Auto Tusk','Tusk ACT '..tostring(reached)..
' reached!','success')setStatus('Done: Tusk ACT '..tostring(reached))else
setStatus('Stopped at: '..tostring(PlayerStand.Value))end autoTA4Enabled=false
autoTA4Busy=false end local autoTA4Tracker=UI.autoTusk:CreateText({name=
'Progress',text='Idle | Stand: '..tostring(PlayerStand.Value)})task.spawn(
function()while true do task.wait(0.4)if autoTA4Tracker and autoTA4Tracker.Set
then pcall(function()autoTA4Tracker:Set(autoTA4Status..' | Stand: '..tostring(
PlayerStand.Value))end)end end end)UI.autoTusk:CreateDropdown({name='Stop At',
options={'2','3','4'},value={'4'},flag='AS_AutoTuskStopAt',callback=function(v)
local pick=type(v)=='table'and v[1]or v autoTuskStopAt=tonumber(pick)or 4 end})
UI.autoTusk:CreateToggle({name='Enable',value=false,flag='AS_AutoTA4',callback=
function(v)if autoTA4Busy and v then return end autoTA4Enabled=v if v then task.
spawn(runAutoTA4)else pcall(teleportUp)notify('Auto Tusk','Stopped.','stop')
setStatus('Stopped')end end})end)()end end function __DARKLUA_BUNDLE_MODULES.aD(
):typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.aD if not v then v={
c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.aD=v end return v.c end end do
local function __modImpl()return function(env)local LocalPlayer=env.LocalPlayer
local PlayerSpec=env.PlayerSpec local getRemoteEvent=env.getRemoteEvent local
hasSpecSkill=env.hasSpecSkill;(function()local sources={}local rangeStart=50
local rangeEnd=95 local loopAlive=false local G_INPUT={Input=Enum.KeyCode.G}
local function ensureLoop()if loopAlive then return end loopAlive=true task.
spawn(function()while next(sources)do pcall(function()if not string.find(
PlayerSpec.Value or'','Hamon')then return end if not hasSpecSkill(
'Hamon Breathing')then return end local char=LocalPlayer.Character if not char
then return end local hamon=char:FindFirstChild('Hamon')if not hamon then return
end if hamon.Value<=rangeStart then local remote=getRemoteEvent()remote:
FireServer('InputEnded',G_INPUT)local done=false repeat task.wait()if not next(
sources)then done=true break end local c=LocalPlayer.Character local h=c and c:
FindFirstChild('Hamon')if not h then done=true break end remote:FireServer(
'InputBegan',G_INPUT)if h.Value>=rangeEnd then done=true end until done remote:
FireServer('InputEnded',G_INPUT)remote:FireServer('InputEnded',G_INPUT)end end)
task.wait(0.08)end loopAlive=false end)end getgenv().__pulseHamonCharge={set=
function(name,on)if on then sources[name]=true ensureLoop()else sources[name]=
nil end end,setRange=function(s,e)if s then rangeStart=s end if e then rangeEnd=
e end end,getStart=function()return rangeStart end,getEnd=function()return
rangeEnd end}end)()end end function __DARKLUA_BUNDLE_MODULES.aE():typeof(
__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.aE if not v then v={c=
__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.aE=v end return v.c end end do
local function __modImpl()return function(env)local FluentIcon=env.FluentIcon
local ApplyFluentIcon=env.ApplyFluentIcon local VS=env.VS local HttpService=env.
HttpService local LocalPlayer=env.LocalPlayer local PlayerGui=env.PlayerGui
local PlayerStats=env.PlayerStats local PlayerLevel=env.PlayerLevel local
PlayerStand=env.PlayerStand local PlayerPrestige=env.PlayerPrestige local
PlayerSpec=env.PlayerSpec local PlayerMoney=env.PlayerMoney local Dialogues=env.
Dialogues local getCharacter=env.getCharacter local getRootPart=env.getRootPart
local getRemoteEvent=env.getRemoteEvent local getRemoteFunction=env.
getRemoteFunction local getQuests=env.getQuests local fireDialogue=env.
fireDialogue local learnSkill=env.learnSkill local getBpItem=env.getBpItem local
getStandMorph=env.getStandMorph local toggleStand=env.toggleStand local notify=
env.notify local hasStandSkill=env.hasStandSkill local teleportUp=env.teleportUp
local useItem=env.useItem local learnWorthiness=env.learnWorthiness local
beginFarmFocus=env.beginFarmFocus local endFarmFocus=env.endFarmFocus local
runItemFarm=env.runItemFarm local UI=env.UI;(function()local autoPrestigeEnabled
=false local autoPrestigeBusy=false local autoPrestigeStatus='Idle'local
autoPrestigeTracker=nil local questStatus='No active quest'local prestigeHookUrl
=''local overlayOn=true local overlayGui=nil local overlayStatus=nil local
overlayHookBox=nil local function paintTracker()if not autoPrestigeTracker or
not autoPrestigeTracker.Set then return end pcall(function()autoPrestigeTracker:
Set(autoPrestigeStatus..' | Lvl '..tostring(PlayerLevel.Value)..' | Prestige '..
tostring(PlayerPrestige.Value))end)end local function hideOverlay()if overlayGui
then pcall(function()overlayGui:Destroy()end)end overlayGui=nil overlayStatus=
nil overlayHookBox=nil end local function prestigeHook(message)if
prestigeHookUrl==''then return end local body=HttpService:JSONEncode({username=
'Pulse | Auto Prestige',embeds={{title='Auto Prestige Update',color=tonumber(
16744258),fields={{name='Account',value='||'..LocalPlayer.Name..'||'},{name=
'Info',value=tostring(message)}}}}})pcall(function()request({Url=prestigeHookUrl
,Body=body,Method='POST',Headers={['content-type']='application/json'}})end)end
local function showOverlay()if not overlayOn then hideOverlay()return end local
pg=LocalPlayer:FindFirstChildOfClass('PlayerGui')if not pg then return end if
overlayGui and overlayGui.Parent==pg and overlayStatus and overlayHookBox then
return end hideOverlay()local gui=Instance.new('ScreenGui')gui.Name=
'PulseAutoPrestigeOverlay'gui.ResetOnSpawn=false gui.IgnoreGuiInset=true gui.
DisplayOrder=999999 gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling local bg=
Instance.new('Frame')bg.Name='Background'bg.Size=UDim2.fromScale(1,1)bg.Position
=UDim2.fromScale(0,0)bg.BackgroundColor3=Color3.fromRGB(0,0,0)bg.
BackgroundTransparency=0 bg.BorderSizePixel=0 bg.ZIndex=100 bg.Parent=gui local
title=Instance.new('TextLabel')title.Name='Title'title.BackgroundTransparency=1
title.Size=UDim2.new(1,-40,0,58)title.Position=UDim2.new(0,20,0.5,-58)title.Font
=Enum.Font.GothamBold title.TextColor3=Color3.fromRGB(255,255,255)title.
TextScaled=true title.TextWrapped=true title.Text='Pulse Auto Prestige'title.
ZIndex=101 title.Parent=bg local status=Instance.new('TextLabel')status.Name=
'Status'status.BackgroundTransparency=1 status.Size=UDim2.new(1,-40,0,42)status.
Position=UDim2.new(0,20,0.5,6)status.Font=Enum.Font.Gotham status.TextColor3=
Color3.fromRGB(210,210,210)status.TextScaled=true status.TextWrapped=true status
.Text='Level '..tostring(PlayerLevel.Value)..' | Prestige '..tostring(
PlayerPrestige.Value)status.ZIndex=101 status.Parent=bg local webhookHint=
Instance.new('TextLabel')webhookHint.Name='WebhookHint'webhookHint.
BackgroundTransparency=1 webhookHint.Size=UDim2.new(1,-40,0,24)webhookHint.
Position=UDim2.new(0,20,1,-166)webhookHint.Font=Enum.Font.Gotham webhookHint.
TextColor3=Color3.fromRGB(190,190,190)webhookHint.TextScaled=true webhookHint.
TextWrapped=true webhookHint.Text='Discord Webhook for Auto Prestige Updates'
webhookHint.ZIndex=101 webhookHint.Parent=bg local webhookBox=Instance.new(
'TextBox')webhookBox.Name='WebhookInput'webhookBox.ClearTextOnFocus=false
webhookBox.Size=UDim2.new(1,-40,0,34)webhookBox.Position=UDim2.new(0,20,1,-132)
webhookBox.BackgroundColor3=Color3.fromRGB(16,16,16)webhookBox.BorderSizePixel=0
webhookBox.TextXAlignment=Enum.TextXAlignment.Left webhookBox.TextYAlignment=
Enum.TextYAlignment.Center webhookBox.Font=Enum.Font.Code webhookBox.TextColor3=
Color3.fromRGB(235,235,235)webhookBox.PlaceholderColor3=Color3.fromRGB(130,130,
130)webhookBox.PlaceholderText='https://discord.com/api/webhooks/...'webhookBox.
TextScaled=false webhookBox.TextSize=14 webhookBox.Text=prestigeHookUrl
webhookBox.ZIndex=101 webhookBox.Parent=bg webhookBox.FocusLost:Connect(function
(enterPressed)local txt=webhookBox.Text or''txt=string.gsub(txt,'^%s+','')txt=
string.gsub(txt,'%s+$','')prestigeHookUrl=txt if enterPressed and txt~=''then
prestigeHook('Webhook connected. Auto Prestige updates enabled.')end end)gui.
Parent=pg overlayGui=gui overlayStatus=status overlayHookBox=webhookBox end
local function updateOverlay()if not autoPrestigeEnabled then hideOverlay()
return end showOverlay()if overlayStatus then overlayStatus.Text='Level '..
tostring(PlayerLevel.Value)..' | Prestige '..tostring(PlayerPrestige.Value)end
end local function setStatus(s)autoPrestigeStatus=s paintTracker()updateOverlay(
)end local function setQuestStatus(s)questStatus=s updateOverlay()end
local function hasRuntime()local char=LocalPlayer.Character if not char or not
char.Parent then return false end if not char:FindFirstChild('HumanoidRootPart')
then return false end if not char:FindFirstChild('RemoteEvent')then return false
end if not char:FindFirstChild('RemoteFunction')then return false end local hum=
char:FindFirstChildWhichIsA('Humanoid')if not hum or hum.Health<=0 then return
false end return true end local function waitForRuntime(timeoutSec)local
deadline=tick()+(timeoutSec or 8)repeat if hasRuntime()then return true end task
.wait(0.2)until tick()>deadline or not autoPrestigeEnabled return hasRuntime()
end local function waitRespawn(timeoutSec)local current=LocalPlayer.Character
local deadline=tick()+(timeoutSec or 20)while autoPrestigeEnabled and tick()<
deadline do local char=LocalPlayer.Character if char and char~=current and char:
FindFirstChild('HumanoidRootPart')and char:FindFirstChildWhichIsA('Humanoid')and
char:FindFirstChild('RemoteEvent')and char:FindFirstChild('RemoteFunction')then
return true end task.wait(0.2)end return false end local STORY_NPCS={{quest=
'Help Giorno by Defeating Security Guards',npc='Security Guard',offZ=2,offY=20},
{quest='Defeat Leaky Eye Luca',npc='Leaky Eye Luca',offZ=2,offY=20},{quest=
'Defeat Bucciarati',npc='Bucciarati',offZ=2,offY=20},{quest=
'Defeat Fugo And His Purple Haze',npc='Fugo',offZ=2,offY=20},{quest=
'Defeat Pesci',npc='Pesci',offZ=0,offY=20},{quest='Defeat Ghiaccio',npc=
'Ghiaccio',offZ=2,offY=20},{quest='Defeat Diavolo',npc='Diavolo',offZ=2,offY=20}
}local VAMPIRE_QUEST='Take down 3 vampires'local VAMPIRE_OFFZ=0 local
VAMPIRE_OFFY=14 local VAMPIRE_LVL_GATE=25 local HAMON_TRY_LEVEL=10 local
NO_KILL_LIMIT=240 local lastNpcKillAt=tick()local noKillWarned=false local
storySent={}local vampQuestSent=false local lastWebhookLevel=nil local
lastWebhookPrestige=nil local questProgressValue=PlayerStats:FindFirstChild(
'QuestProgress')local questMaxProgressValue=PlayerStats:FindFirstChild(
'QuestMaxProgress')local function questText(quests)quests=quests or getQuests()
local progress=(questProgressValue and questProgressValue.Value)or 0 local
maxProgress=(questMaxProgressValue and questMaxProgressValue.Value)or 0 local
progressText=(maxProgress>0)and(tostring(progress)..'/'..tostring(maxProgress))
or nil if quests[VAMPIRE_QUEST]then if progressText then return'Killed '..
progressText..' vampires'end return'Killed ?/3 vampires'end for _,e in ipairs(
STORY_NPCS)do if quests[e.quest]then if progressText then return tostring(e.npc)
..' ('..progressText..')'end return tostring(e.npc)end end local anyQuest=next(
quests)if anyQuest then if progressText then return tostring(anyQuest)..' ('..
progressText..')'end return tostring(anyQuest)end return progressText and(
'No active quest ('..progressText..')')or'No active quest'end local function
sendQuestDone(previousQuests,currentQuests)previousQuests=previousQuests or{}
currentQuests=currentQuests or{}for _,e in ipairs(STORY_NPCS)do if
previousQuests[e.quest]and not currentQuests[e.quest]and not storySent[e.quest]
then storySent[e.quest]=true prestigeHook('Quest complete: '..tostring(e.quest))
end if currentQuests[e.quest]then storySent[e.quest]=false end end if
previousQuests[VAMPIRE_QUEST]and not currentQuests[VAMPIRE_QUEST]and not
vampQuestSent then vampQuestSent=true prestigeHook(
'Quest complete: Take down 3 vampires')end if currentQuests[VAMPIRE_QUEST]then
vampQuestSent=false end end local function refreshQuestStatus(quests)quests=
quests or getQuests()setQuestStatus(questText(quests))return quests end
local function markNpcKill(npcName)lastNpcKillAt=tick()noKillWarned=false
refreshQuestStatus(getQuests())end local STORYLINE_KEYS={'#1','#1','#1','#2',
'#3','#3','#3','#4','#5','#6','#7','#8','#9','#10','#11','#11','#12','#14'}local
STORYLINE_DLG={'Dialogue2','Dialogue6','Dialogue6','Dialogue3','Dialogue3',
'Dialogue3','Dialogue6','Dialogue3','Dialogue5','Dialogue5','Dialogue5',
'Dialogue4','Dialogue7','Dialogue6','Dialogue8','Dialogue11','Dialogue3',
'Dialogue2'}local function fireStorylineSweep()for i=1,18 do fireDialogue(
'Storyline '..STORYLINE_KEYS[i],STORYLINE_DLG[i],'Option1')end end
local function isCaesarHamon()if string.find(string.lower(PlayerSpec.Value or'')
,'caesar')then return true end local char=getCharacter()if char and char:
FindFirstChild("Caesar's Headband")then return true end if VS.Backpack:
FindFirstChild("Caesar's Headband")then return true end return false end local
SPEC_SKILLS={'Hamon Breathing','Lung Capacity I','Lung Capacity II',
'Lung Capacity III','Lung Capacity IV','Lung Capacity V','Breathing Technique I'
,'Breathing Technique II','Breathing Technique III','Breathing Technique IV',
'Breathing Technique V','Hamon Punch I','Hamon Punch II','Hamon Punch III'}local
CAESAR_SKILLS={'Bubble Launcher','Hamon Breathing','Breathing Technique I',
'Hamon Hypnosis','Hamon Punch I','Hamon Punch II','Hamon Punch III'}
local function learnAllSkills()pcall(function()local sst=LocalPlayer:
FindFirstChild('StandSkillTree')if sst then local standName=PlayerStand.Value if
standName=='King Crimson'or standName=='King Crimson Requiem'or standName==
'King Crimson: Requiem'then local toBuy={}for _,v in pairs(sst:GetChildren())do
local nameLower=string.lower(v.Name)if string.find(nameLower,'destructive power'
)or nameLower=='chop'then table.insert(toBuy,v)end end table.sort(toBuy,function
(a,b)return a.Name<b.Name end)for _,v in ipairs(toBuy)do if not v.Value then
learnSkill(v.Name,'Stand')task.wait(0.05)end end elseif standName==
'Star Platinum: The World'or standName=='Star Platinum The World'then local
toBuy={}for _,v in pairs(sst:GetChildren())do local nameLower=string.lower(v.
Name)if string.find(nameLower,'destructive power')or string.find(nameLower,
'precision')or nameLower=='ora kicks'or nameLower=='bearing shot'or nameLower==
'ora beatdown'then table.insert(toBuy,v)end end table.sort(toBuy,function(a,b)
return a.Name<b.Name end)for _,v in ipairs(toBuy)do if not v.Value then
learnSkill(v.Name,'Stand')task.wait(0.05)end end else for _,v in pairs(sst:
GetChildren())do if not v.Value then learnSkill(v.Name,'Stand')end end end end
if PlayerStand.Value=='Star Platinum'then local info=getRemoteFunction():
InvokeServer('ReturnSkillInfoInTree',{Type='Stand',Skills={[19]='Inhale'}})if
info and info.Inhale and info.Inhale.AssignedKey~='L'then getRemoteFunction():
InvokeServer('AssignSkillKey',{Type='Stand',Key='Enum.KeyCode.L',Skill='Inhale'}
)end elseif PlayerStand.Value=='Star Platinum: The World'or PlayerStand.Value==
'Star Platinum The World'then local info=getRemoteFunction():InvokeServer(
'ReturnSkillInfoInTree',{Type='Stand',Skills={[19]='Ora Beatdown'}})if info and
info['Ora Beatdown']and info['Ora Beatdown'].AssignedKey~='L'then
getRemoteFunction():InvokeServer('AssignSkillKey',{Type='Stand',Key=
'Enum.KeyCode.L',Skill='Ora Beatdown'})end end if isCaesarHamon()then for _,name
in ipairs(CAESAR_SKILLS)do learnSkill(name,'Spec')task.wait(0.05)end else for _,
name in ipairs(SPEC_SKILLS)do learnSkill(name,'Spec')task.wait(0.05)end end end)
end local function learnAllSpecSkills()if isCaesarHamon()then for _,name in
ipairs(CAESAR_SKILLS)do learnSkill(name,'Spec')task.wait(0.05)end else for _,
name in ipairs(SPEC_SKILLS)do learnSkill(name,'Spec')task.wait(0.05)end end end
local function learnHamonSkills()learnAllSpecSkills()end local function
canPrestigeNow()return(PlayerLevel.Value>=35 and PlayerPrestige.Value==0)or(
PlayerLevel.Value>=40 and PlayerPrestige.Value==1)or(PlayerLevel.Value>=45 and
PlayerPrestige.Value==2)end local function hasHamonReady()return string.find(
PlayerSpec.Value or'','Hamon')or(getCharacter()and getCharacter():
FindFirstChild('Hamon'))end local function shouldTryHamonNow()return
PlayerPrestige.Value>=1 and PlayerLevel.Value>=HAMON_TRY_LEVEL end
local function getSkillOnKey(char,keyName)local stack=char and char:
FindFirstChild('StandSkills')if not stack then return nil end local node=stack:
FindFirstChild('Enum.KeyCode.'..keyName)return node and node.Value or nil end
local function isSkillOnCooldown(skillName)if not skillName or skillName==''then
return false end local hud=PlayerGui:FindFirstChild('HUD')if not hud then return
false end local cd=hud:FindFirstChild('Cooldowns')if not cd then return false
end local frame=cd:FindFirstChild('Frame')if not frame then return false end
return frame:FindFirstChild(skillName)~=nil end local KILL_SKILLS={{match=
'finger',hpGate=0.4},{match='kick',hpGate=0.4},{match='rage',hpGate=nil}}local
TP_SETTLE=0.15 local SETTLE_FRAMES=40 local CHAIN_GAP=0.08 local VAMP_GAP=0.5
local PRESTIGE_STAND_KEYS={['Star Platinum']={'H','T','X'},[
'Star Platinum: The World']={'U'},['Star Platinum The World']={'U'},[
'Silver Chariot']={'Y','H','Z','T'},['D4C']={'Y','U'},['King Crimson Requiem']={
},['King Crimson: Requiem']={},['King Crimson']={}}local function
getKillSkillRule(skillName)if not skillName or skillName==''then return nil end
local lower=skillName:lower()for _,p in ipairs(KILL_SKILLS)do if string.find(
lower,p.match,1,true)then return p end end return nil end local function
findAliveNpcByName(npcName)local ok,children=pcall(function()return workspace.
Living:GetChildren()end)if not ok or not children then return nil end for _,c in
ipairs(children)do if c.Name==npcName and c:FindFirstChild('HumanoidRootPart')
and c:FindFirstChild('Health')and c.Health.Value>0 then return c end end return
nil end local function prestigeKillNPC(npcName,offsetZ,offsetY)local npc local
npcWaitDeadline=tick()+12 while autoPrestigeEnabled and tick()<npcWaitDeadline
do local ok,result=pcall(function()return workspace.Living:FindFirstChild(
npcName)end)if ok and result and result:FindFirstChild('HumanoidRootPart')then
npc=result break end setStatus('Waiting for '..npcName..' to spawn')task.wait(
0.5)end if not npc or not npc:FindFirstChild('HumanoidRootPart')then return
false end local npcHRP=npc.HumanoidRootPart local maxHP=(npc:FindFirstChild(
'Health')and npc.Health.Value)or 100 local killedThisRun=false local function
stabilizeRoot(anchoredState)local hrp=getRootPart()if not hrp then return end
hrp.AssemblyLinearVelocity=Vector3.zero hrp.AssemblyAngularVelocity=Vector3.zero
if anchoredState~=nil then hrp.Anchored=anchoredState end end local function
ensureStandSummoned(timeoutSec)local deadline=tick()+(timeoutSec or 1.8)while
autoPrestigeEnabled and tick()<deadline do local stand=getStandMorph()if stand
and stand.Parent then return stand end toggleStand()task.wait(0.25)end return
getStandMorph()end local standCheck=ensureStandSummoned(3.5)if not standCheck
then setStatus('Stand bugged; resetting character')pcall(function()getCharacter(
).Humanoid.Health=0 end)waitRespawn(22)return false end task.spawn(
learnAllSkills)local engagePos=npcHRP.CFrame-npcHRP.CFrame.LookVector*(offsetZ
or 2)+Vector3.new(0,offsetY or 20,0)stabilizeRoot(false)getRootPart().CFrame=
CFrame.lookAt(engagePos.Position,npcHRP.Position)stabilizeRoot(false)task.wait(
TP_SETTLE)local killConfirmed=false local xpConn=LocalPlayer.PlayerStats.
Experience:GetPropertyChangedSignal('Value'):Connect(function()killConfirmed=
true end)local moneyConn pcall(function()moneyConn=PlayerGui:WaitForChild('HUD')
.Main.DropMoney.Money.ChildAdded:Connect(function()killConfirmed=true end)end)
local function settle()local hrp=getRootPart()if not hrp then return end hrp.
AssemblyLinearVelocity=Vector3.zero hrp.AssemblyAngularVelocity=Vector3.zero hrp
.Anchored=true local frames=(npcName=='Vampire')and math.max(18,math.floor(
SETTLE_FRAMES*0.65))or SETTLE_FRAMES while autoPrestigeEnabled and frames>0 and
not killConfirmed do task.wait()frames=frames-1 end local hrp2=getRootPart()if
hrp2 then hrp2.AssemblyLinearVelocity=Vector3.zero hrp2.AssemblyAngularVelocity=
Vector3.zero hrp2.Anchored=false end end while autoPrestigeEnabled do task.wait(
)stabilizeRoot(false)local currentHRP=npc and npc:FindFirstChild(
'HumanoidRootPart')if currentHRP then npcHRP=currentHRP end local stillAlive=npc
and npc.Parent and npc:FindFirstChild('Health')and npc.Health.Value>0 if npcName
=='Security Guard'and not stillAlive and not killConfirmed then local nextTarget
=findAliveNpcByName(npcName)if nextTarget and nextTarget~=npc then npc=
nextTarget npcHRP=nextTarget.HumanoidRootPart maxHP=(nextTarget:FindFirstChild(
'Health')and nextTarget.Health.Value)or maxHP task.wait()continue end end if not
stillAlive or killConfirmed then killedThisRun=true pcall(function()
getRemoteEvent():FireServer('InputEnded',{Input=Enum.KeyCode.E})end)settle()
break end if not getStandMorph()then if not ensureStandSummoned(2)then
stabilizeRoot(false)task.wait(0.1)continue end end pcall(function()local char=
LocalPlayer.Character local remote=getRemoteEvent()if not char or not remote
then return end local hpFrac=(npc:FindFirstChild('Health')and npc.Health.Value
or 0)/maxHP local ragdolled=npc:FindFirstChild('RagdollParts')~=nil local
barraging=char:FindFirstChild('Stand Barraging')~=nil local stand=getStandMorph(
)local standRoot=stand and stand:FindFirstChild('HumanoidRootPart')if standRoot
and npc:FindFirstChild('Head')then standRoot.CFrame=CFrame.lookAt(npc.Head.
Position+Vector3.new(0,3.8,0),npcHRP.Position)end local standName=PlayerStand.
Value local isRequiem=standName=='King Crimson Requiem'or standName==
'King Crimson: Requiem'or standName=='Star Platinum: The World'or standName==
'Star Platinum The World'if not isRequiem then if isSkillOnCooldown(
'Stand Barrage')or ragdolled or hpFrac<=0.45 then remote:FireServer('InputEnded'
,{Input=Enum.KeyCode.E})else remote:FireServer('InputBegan',{Input=Enum.KeyCode.
E})end end if not ragdolled and not barraging then local function tryKey(keyName
)local skill=getSkillOnKey(char,keyName)if not skill or skill==''then return
false end if skill=='Ora Kicks'then return false end if not hasStandSkill(skill)
then return false end if isSkillOnCooldown(skill)then return false end local
activeStand=PlayerStand.Value if activeStand=='Silver Chariot'then local lower=
skill:lower()if string.find(lower,'barrage',1,true)then return false end elseif
activeStand=='D4C'or activeStand=='King Crimson'or activeStand==
'King Crimson Requiem'or activeStand=='King Crimson: Requiem'or activeStand==
'Star Platinum: The World'or activeStand=='Star Platinum The World'then else
local rule=getKillSkillRule(skill)if not rule then return false end if rule.
hpGate and hpFrac<=rule.hpGate then return false end end local kc=Enum.KeyCode[
keyName]if not kc then return false end remote:FireServer('InputBegan',{Input=kc
})remote:FireServer('InputEnded',{Input=kc})end local activeStand=PlayerStand.
Value local keyPlan=PRESTIGE_STAND_KEYS[activeStand]or PRESTIGE_STAND_KEYS[
'Star Platinum']for _,keyName in ipairs(keyPlan)do tryKey(keyName)end end remote
:FireServer('Attack','m1')local followPos=npcHRP.CFrame-npcHRP.CFrame.LookVector
*(offsetZ or 2)+Vector3.new(0,offsetY or 20,0)getRootPart().CFrame=CFrame.
lookAt(followPos.Position,npcHRP.Position)stabilizeRoot(false)end)end if xpConn
then xpConn:Disconnect()end if moneyConn then moneyConn:Disconnect()end
stabilizeRoot(false)return killedThisRun end local HAMON_ITEMS={
"Caesar's Headband","Zeppeli's Hat",'Clackers'}local function findHamonItemIn(
container)if not container then return nil end for _,n in ipairs(HAMON_ITEMS)do
local item=container:FindFirstChild(n)if item then return item end end return
nil end local function hasAnyHamonItem()return findHamonItemIn(VS.Backpack)or
findHamonItemIn(LocalPlayer.Character)end local function farmHamonItem(
timeoutSec)if hasAnyHamonItem()then return true end if not autoPrestigeEnabled
then return false end local deadline=tick()+(timeoutSec or 30)local
hadItemFarmEnabled=VS.itemFarmEnabled local hamonFocus={}for _,itemName in
ipairs(HAMON_ITEMS)do hamonFocus[itemName]=true end local restoreFocus=
beginFarmFocus(hamonFocus)if not hadItemFarmEnabled then VS.itemFarmEnabled=true
task.spawn(runItemFarm)end setStatus('Farming Hamon item')repeat task.wait(0.25)
until hasAnyHamonItem()or tick()>deadline or not autoPrestigeEnabled
endFarmFocus(restoreFocus)if not hadItemFarmEnabled then VS.itemFarmEnabled=
false end return hasAnyHamonItem()end local function clickGuiButton(sig)if not
sig then return end if type(firesignal)=='function'then firesignal(sig)else sig:
Fire()end end local function pushLisaLisaDialogue()local dg=PlayerGui:
FindFirstChild('DialogueGui')if not dg then return false end local frame=dg:
FindFirstChild('Frame')local cont=frame and frame:FindFirstChild('ClickContinue'
)local opts=frame and frame:FindFirstChild('Options')local opt1=opts and opts:
FindFirstChild('Option1')local btn=opt1 and opt1:FindFirstChild('TextButton')if
cont and cont.MouseButton1Click then clickGuiButton(cont.MouseButton1Click)end
if btn and btn.MouseButton1Click then clickGuiButton(btn.MouseButton1Click)end
return true end local function pickupHamonItem()local root=workspace:
FindFirstChild('Item_Spawns')local items=root and root:FindFirstChild('Items')if
not items then return false end local wanted={}for _,n in ipairs(HAMON_ITEMS)do
wanted[n]=true end for _,spawner in pairs(items:GetChildren())do if not
autoPrestigeEnabled then return false end if spawner:IsA('Model')then local
prompt=spawner:FindFirstChild('ProximityPrompt')if prompt and wanted[prompt.
ObjectText]then local visible=false for _,c in pairs(spawner:GetChildren())do if
c:IsA('MeshPart')and c.Transparency~=1 then visible=true break end end if
visible then local itemName=prompt.ObjectText setStatus('Grabbing '..itemName)
local ok,modelCF=pcall(function()return spawner:GetModelCFrame()end)if ok and
modelCF then getRootPart().CFrame=modelCF task.wait(0.25)local deadline=tick()+5
while autoPrestigeEnabled and tick()<deadline do if VS.Backpack:FindFirstChild(
itemName)then break end pcall(function()fireproximityprompt(prompt,1)end)task.
wait(0.15)end if VS.Backpack:FindFirstChild(itemName)then return true end end
end end end end return false end local function acquireHamon()if hasHamonReady()
then return true end if PlayerPrestige.Value<1 then return false end if
PlayerMoney.Value<10000 then setStatus('Need $10,000 for Hamon')return false end
if not hasAnyHamonItem()then if not farmHamonItem(45)then return false end end
setStatus('Acquiring Hamon')pcall(function()teleportUp()getRootPart().CFrame=
CFrame.new(435,9,-285)repeat task.wait(0.05)fireproximityprompt(Dialogues[
'Lisa Lisa']:WaitForChild('ProximityPrompt'))until PlayerGui:FindFirstChild(
'DialogueGui')or not autoPrestigeEnabled end)if not autoPrestigeEnabled then
return false end teleportUp()local hangCFrame pcall(function()hangCFrame=
getRootPart().CFrame end)local function buyFromLisa(seconds)local deadline=tick(
)+seconds repeat task.wait(0.25)pcall(function()local char=getCharacter()if char
and not findHamonItemIn(char)then local bp=findHamonItemIn(VS.Backpack)if bp
then bp.Parent=char end end local hrp=getRootPart()if hangCFrame then hrp.
AssemblyLinearVelocity=Vector3.zero hrp.AssemblyAngularVelocity=Vector3.zero hrp
.CFrame=hangCFrame end local prompt=Dialogues['Lisa Lisa']:WaitForChild(
'ProximityPrompt')for _=1,3 do fireproximityprompt(prompt)task.wait()
pushLisaLisaDialogue()end end)until hasHamonReady()or tick()>deadline or not
autoPrestigeEnabled end buyFromLisa(12)if not autoPrestigeEnabled then return
false end if not hasHamonReady()then pcall(function()getCharacter().Humanoid.
Health=0 end)if not waitRespawn(22)then setStatus('Respawn timeout during Hamon'
)return false end task.wait(6)if not autoPrestigeEnabled then return false end
teleportUp()pcall(function()hangCFrame=getRootPart().CFrame end)buyFromLisa(12)
if not hasHamonReady()then return false end end local char=getCharacter()local
caesar=isCaesarHamon()local equipped=char and findHamonItemIn(char)if equipped
then equipped.Parent=VS.Backpack end if caesar then learnAllSpecSkills()else
learnHamonSkills()end task.wait()pcall(function()getCharacter().Humanoid.Health=
0.1 end)task.wait()pcall(function()getCharacter().Humanoid.Health=0 end)if not
waitRespawn(22)then setStatus('Respawn timeout finishing Hamon')return false end
task.wait(0.5)if caesar then learnAllSpecSkills()else learnHamonSkills()end task
.wait(1)return true end local function firePrestige()setStatus('Firing prestige'
)local prevPrestige=PlayerPrestige.Value fireDialogue('Prestige','Dialogue2',
'Option1')task.wait(0.5)notify('Auto Prestige','Prestiged to '..(prevPrestige+1)
..'.','success')pcall(function()getCharacter().Humanoid.Health=0.1 end)task.
wait()pcall(function()getCharacter().Humanoid.Health=0 end)if not waitRespawn(22
)then setStatus('Respawn timeout after prestige')return false end task.wait(1)
local deadline=tick()+8 repeat task.wait(0.5)fireStorylineSweep()until next(
getQuests())~=nil or tick()>deadline or not autoPrestigeEnabled return true end
local function progressStory()if autoPrestigeEnabled and(PlayerStand.Value==
'King Crimson'or PlayerStand.Value=='Star Platinum')and PlayerPrestige.Value>=1
then local req=getBpItem('Requiem Arrow')if req then local sk=LocalPlayer:
FindFirstChild('CharacterSkillTree')if not(sk and sk:FindFirstChild(
'Worthiness V')and sk['Worthiness V'].Value)then pcall(function()
learnWorthiness()end)task.wait(0.5)end notify('Auto Prestige',
'Found Requiem Arrow! Attempting to use...',5,'info')if useItem('Requiem Arrow')
then setStatus('Used Requiem Arrow on '..PlayerStand.Value..'!')task.wait(6)end
end end local questsBefore=getQuests()local quests=refreshQuestStatus(
questsBefore)for _,e in ipairs(STORY_NPCS)do if not autoPrestigeEnabled then
return false end if quests[e.quest]then setStatus('Killing '..e.npc)while
autoPrestigeEnabled and getQuests()[e.quest]do if prestigeKillNPC(e.npc,e.offZ,e
.offY)then markNpcKill(e.npc)end local questsNow=getQuests()sendQuestDone(
questsBefore,questsNow)questsBefore=questsNow refreshQuestStatus(questsNow)if e.
npc=='Security Guard'then task.wait(0.8)else task.wait(CHAIN_GAP)end end if e.
npc=='Diavolo'and autoPrestigeEnabled then fireStorylineSweep()task.wait(0.5)
fireDialogue('Storyline #14','Dialogue7','Option1')task.wait(0.5)local char=
LocalPlayer.Character if char then local hum=char:FindFirstChildWhichIsA(
'Humanoid')if hum then hum.Health=0 task.wait(3)end end end return true end end
local hasVampireQuest=quests[VAMPIRE_QUEST]~=nil local levelUnlocked=PlayerLevel
.Value>=VAMPIRE_LVL_GATE if not hasVampireQuest and levelUnlocked then
setStatus('Checking for remaining story quests...')fireStorylineSweep()task.
wait(1.5)local freshQuests=getQuests()local gotStoryQuest=false for _,e in
ipairs(STORY_NPCS)do if freshQuests[e.quest]then gotStoryQuest=true break end
end if not gotStoryQuest then if shouldTryHamonNow()and not hasHamonReady()then
acquireHamon()end if autoPrestigeEnabled and not getQuests()[VAMPIRE_QUEST]then
setStatus('Asking William Zeppeli')for _=1,6 do if not autoPrestigeEnabled then
return false end fireDialogue('William Zeppeli','Dialogue4','Option1')task.wait(
0.4)if getQuests()[VAMPIRE_QUEST]then break end end end end end if getQuests()[
VAMPIRE_QUEST]then setStatus('Killing Vampires')while autoPrestigeEnabled and
getQuests()[VAMPIRE_QUEST]do if prestigeKillNPC('Vampire',VAMPIRE_OFFZ,
VAMPIRE_OFFY)then markNpcKill('Vampire')end local questsNow=getQuests()
sendQuestDone(questsBefore,questsNow)questsBefore=questsNow refreshQuestStatus(
questsNow)task.wait(VAMP_GAP)end return true end return false end local function
runAutoPrestige()if autoPrestigeBusy then return end autoPrestigeBusy=true local
runtimeMisses=0 local loopErrors=0 local equippedStand=PlayerStand.Value if not
PRESTIGE_STAND_KEYS[equippedStand]then notify('Auto Prestige',
[[Equip Star Platinum, SPTW, Silver Chariot, D4C, KC, or KCR first.]],7,'warn')
autoPrestigeEnabled=false autoPrestigeBusy=false setStatus(
'Need supported stand')return end if not waitForRuntime(8)then notify(
'Auto Prestige','Character/remotes unavailable. Try again in a moment.',7,'warn'
)autoPrestigeEnabled=false autoPrestigeBusy=false setStatus(
'Runtime unavailable')return end task.spawn(learnAllSkills)lastNpcKillAt=tick()
noKillWarned=false refreshQuestStatus(getQuests())lastWebhookLevel=PlayerLevel.
Value lastWebhookPrestige=PlayerPrestige.Value if getgenv().__pulseHamonCharge
then getgenv().__pulseHamonCharge.set('auto_prestige',true)end while
autoPrestigeEnabled do updateOverlay()if PlayerLevel.Value~=lastWebhookLevel
then local oldLvl=tonumber(lastWebhookLevel)or 0 local newLvl=tonumber(
PlayerLevel.Value)or oldLvl if newLvl>oldLvl then prestigeHook('Level up: '..
tostring(oldLvl)..' -> '..tostring(newLvl))end lastWebhookLevel=PlayerLevel.
Value end if PlayerPrestige.Value~=lastWebhookPrestige then local oldPrest=
tonumber(lastWebhookPrestige)or 0 local newPrest=tonumber(PlayerPrestige.Value)
or oldPrest if newPrest>oldPrest then prestigeHook('Prestige up: '..tostring(
oldPrest)..' -> '..tostring(newPrest))end lastWebhookPrestige=PlayerPrestige.
Value end if tick()-lastNpcKillAt>=NO_KILL_LIMIT and not noKillWarned then
noKillWarned=true notify('Auto Prestige',
'Suspicious activity: no NPC killed within 240 seconds.',8,'warn')setStatus(
'Warning: no NPC kill for 240s')prestigeHook(
'Warning: no NPC killed within 240 seconds.')end if math.floor(tick()*2)%4==0
then refreshQuestStatus(getQuests())end if not hasRuntime()then runtimeMisses=
runtimeMisses+1 setStatus('Recovering runtime ('..tostring(runtimeMisses)..'/3)'
)if not waitForRuntime(6)and runtimeMisses>=3 then notify('Auto Prestige',
'Stopped: runtime unavailable after retries.',7,'warn')autoPrestigeEnabled=false
break end task.wait(0.35)continue end runtimeMisses=0 if not PRESTIGE_STAND_KEYS
[PlayerStand.Value]then notify('Auto Prestige',
[[Stopped. Equip Star Platinum, SPTW, Silver Chariot, D4C, KC, or KCR.]],7,
'warn')autoPrestigeEnabled=false break end if PlayerLevel.Value>=50 then notify(
'Auto Prestige','Max level reached.',7,'info')setStatus('Max level (50)')
autoPrestigeEnabled=false break end local ok,err=pcall(function()if
canPrestigeNow()then if not firePrestige()then error('prestige flow failed')end
if not autoPrestigeEnabled then return end end if shouldTryHamonNow()and not
hasHamonReady()then if not acquireHamon()then farmHamonItem(20)task.wait(0.25)
return end if not autoPrestigeEnabled then return end end local progressed=
progressStory()if not progressed and autoPrestigeEnabled then setStatus(
'Claiming storyline')local sweepAttempts=0 local maxSweepAttempts=15 while
autoPrestigeEnabled and sweepAttempts<maxSweepAttempts do fireStorylineSweep()
task.wait(1)sweepAttempts=sweepAttempts+1 if next(getQuests())~=nil then break
end end if next(getQuests())==nil and autoPrestigeEnabled then setStatus(
'Recovering: no quest assigned')notify('Auto Prestige',
'No quest assigned after storyline sweep. Respawning.',7,'warn')pcall(function()
getCharacter().Humanoid.Health=0 end)waitRespawn(22)task.wait(2)end end end)if
not ok then loopErrors=loopErrors+1 setStatus('Error recovery ('..tostring(
loopErrors)..'/3)')warn('Pulse: Auto Prestige error: '..tostring(err))if
loopErrors>=3 then notify('Auto Prestige',
'Stopped after repeated runtime errors.',7,'warn')autoPrestigeEnabled=false
break end waitForRuntime(6)task.wait(0.75)continue end loopErrors=0 task.wait(
0.3)end if getgenv().__pulseHamonCharge then getgenv().__pulseHamonCharge.set(
'auto_prestige',false)end autoPrestigeBusy=false if autoPrestigeStatus~=
'Max level (50)'then setStatus('Stopped')end hideOverlay()end
autoPrestigeTracker=UI.prestige:CreateText({name='Progress',text='Idle | Lvl '..
tostring(PlayerLevel.Value)..' | Prestige '..tostring(PlayerPrestige.Value)})
PlayerLevel:GetPropertyChangedSignal('Value'):Connect(paintTracker)
PlayerPrestige:GetPropertyChangedSignal('Value'):Connect(paintTracker)local
prestigeLockIcon=VS.autoPrestigeLocked and FluentIcon('lock-closed-24-filled')or
nil local autoPrestigeToggle autoPrestigeToggle=UI.prestige:CreateToggle({name=
'Enable',icon=prestigeLockIcon and prestigeLockIcon.Url,value=false,flag=
'AS_AutoPrestige',callback=function(v)if v and VS.autoPrestigeLocked then
autoPrestigeToggle:Set(false,true)notify('Auto Prestige','Locked for now.',
'warn')return end if autoPrestigeBusy and v then return end autoPrestigeEnabled=
v if v then showOverlay()updateOverlay()notify('Auto Prestige','Started.',
'start')task.spawn(runAutoPrestige)else notify('Auto Prestige','Stopped.','stop'
)if getgenv().__pulseHamonCharge then getgenv().__pulseHamonCharge.set(
'auto_prestige',false)end setStatus('Stopped')hideOverlay()end end})
ApplyFluentIcon(autoPrestigeToggle.iconLabel,prestigeLockIcon)local
blackScreenToggle=UI.prestige:CreateToggle({name='Black Screen',value=true,flag=
'AS_AutoPrestigeOverlay',callback=function(v)overlayOn=v if v then if
autoPrestigeEnabled then showOverlay()updateOverlay()end else hideOverlay()end
end})if VS.autoPrestigeLocked then UI.lock(autoPrestigeToggle)UI.lock(
blackScreenToggle)end end)()end end function __DARKLUA_BUNDLE_MODULES.aF():
typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.aF if not v then v={c=
__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.aF=v end return v.c end end do
local function __modImpl()return function(env)local VS=env.VS local getPity=env.
getPity local roundTwo=env.roundTwo local notify=env.notify local runPityFarm=
env.runPityFarm local UI=env.UI UI.pityFarm:CreateSlider({name='Goal',range={1,
10},increment=0.5,value=2,flag='MAIN_PityGoal',callback=function(v)if v<=
getPity()then notify('Pity Farm','Goal must exceed current pity ('..roundTwo(
getPity())..')!','warn')else VS.pityWanted=v end end})UI.pityFarm:CreateToggle({
name='Double Trouble',value=false,flag='MAIN_DoubleTrouble',callback=function(v)
VS.doubleTrouble=v end})UI.pityFarm:CreateToggle({name='Hop Mode',value=false,
flag='MAIN_HopModePity',callback=function(v)VS.hopModePity=v end})UI.pityFarm:
CreateToggle({name='Buy Materials',value=false,flag='MAIN_PityAutoBuyMaterials',
callback=function(v)getgenv()._pulsePityAutoBuy.enabled=v if v then notify(
'Pity Farm',
[[When materials run low, Auto Pity will farm & sell items for cash, then buy ]]
..'Rib Cages'..(VS.doubleTrouble and' + Arrows & Rokakaka'or'')..
'. Keep Item Farm OFF.',7,'info')else notify('Pity Farm',
'Auto Buy Materials disabled.','stop')end end})UI.pityFarm:CreateToggle({name=
'Pity HUD',value=false,flag='MAIN_DisplayPityHUD',callback=function(v)local
pityHud=getgenv()._pulsePityHudState pityHud.enabled=v if pityHud.frame then
pityHud.frame.Visible=v end if v and type(pityHud.update)=='function'then
pityHud.update()end end})UI.pityFarm:CreateToggle({name='Enable',value=false,
flag='MAIN_EnablePityFarm',callback=function(v)VS.pityFarmEnabled=v if v then
task.spawn(runPityFarm)else notify('Pity Farm','Stopped.','stop')end end})end
end function __DARKLUA_BUNDLE_MODULES.aG():typeof(__modImpl())local v=
__DARKLUA_BUNDLE_MODULES.cache.aG if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.aG=v end return v.c end end do local function
__modImpl()return function(env)local LocalPlayer=env.LocalPlayer local notify=
env.notify local UI=env.UI;(function()local SoundService=game:GetService(
'SoundService')local SFX_ID='rbxassetid://6029007816'local SFX_GAP=0.22 local
busTpSfxLastPlay=0 local busTpSfx=SoundService:FindFirstChild(
'PulseBusTeleportSfx')if busTpSfx and not busTpSfx:IsA('Sound')then busTpSfx:
Destroy()busTpSfx=nil end if not busTpSfx then busTpSfx=Instance.new('Sound')
busTpSfx.Name='PulseBusTeleportSfx'busTpSfx.SoundId=SFX_ID busTpSfx.Volume=0.55
busTpSfx.RollOffMode=Enum.RollOffMode.InverseTapered busTpSfx.Parent=
SoundService end local function playBusTeleportSfx()local now=tick()if now-
busTpSfxLastPlay<SFX_GAP then return end busTpSfxLastPlay=now pcall(function()if
not busTpSfx or not busTpSfx.Parent then busTpSfx=Instance.new('Sound')busTpSfx.
Name='PulseBusTeleportSfx'busTpSfx.Volume=0.55 busTpSfx.RollOffMode=Enum.
RollOffMode.InverseTapered busTpSfx.Parent=SoundService end busTpSfx.SoundId=
SFX_ID busTpSfx:Stop()busTpSfx.TimePosition=0 busTpSfx:Play()end)end local stops
={{'Prison Bridge',Vector3.new(591,0,-179)},{'Parking Lot',Vector3.new(-147,0,-
676)},{'Train Station',Vector3.new(-451,0,-8)},{'Via Dell Oceanio',Vector3.new(
17,-26,588)},{'Merchants Keep',Vector3.new(-620,-26,-465)},{'Via Toledo',Vector3
.new(-130,0,-117)},{'The Greatest Peak',Vector3.new(-243.26487731933594,
284.09710693359375,306.4090270996094)}}local names,spots={},{}for _,row in
ipairs(stops)do table.insert(names,row[1])spots[row[1] ]=row[2]end local picked=
names[1]UI.teleport:CreateDropdown({name='Location',options=names,value=names[1]
,flag='TP_Location',callback=function(v)picked=type(v)=='table'and v[1]or v end}
)UI.teleport:CreateButton({name='Teleport',callback=function()local pos=picked
and spots[picked]if not pos then notify('Teleports','Pick a location first.',
'warn')return end local char=LocalPlayer.Character local hrp=char and char:
FindFirstChild('HumanoidRootPart')if hrp then hrp.CFrame=CFrame.new(pos)
playBusTeleportSfx()notify('Teleports','Teleported to '..picked..'.',4,'success'
)else notify('Teleports','Teleport failed: character not ready.',5,'error')end
end})end)()end end function __DARKLUA_BUNDLE_MODULES.aH():typeof(__modImpl())
local v=__DARKLUA_BUNDLE_MODULES.cache.aH if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.aH=v end return v.c end end do local function
__modImpl()return function(env)local VS=env.VS local RunService=env.RunService
local UserInputService=env.UserInputService local LocalPlayer=env.LocalPlayer
local PlayerGui=env.PlayerGui local PlayerStats=env.PlayerStats local
getCharacter=env.getCharacter local getRootPart=env.getRootPart local
giveClickTpTool=env.giveClickTpTool local getHumanoid=env.getHumanoid local
notify=env.notify local UI=env.UI UI.tools:CreateButton({name='ClickTP',callback
=function()giveClickTpTool()notify('Local','Added ClickTP to backpack.',4,
'success')end})UI.movement:CreateSlider({name='WalkSpeed',range={1,200},
increment=1,value=24,flag='LOCAL_WalkSpeed',callback=function(v)getgenv().
_pulseMoveState.wsSpeed=v end})VS.wsToggleRef=UI.movement:CreateToggle({name=
'Enable WalkSpeed',value=false,flag='LOCAL_EnableWalkSpeed',callback=function(v)
local mv=getgenv()._pulseMoveState mv.wsEnabled=v if v then mv.wsConn=RunService
.RenderStepped:Connect(function()pcall(function()getCharacter().Humanoid.
WalkSpeed=mv.wsSpeed end)end)else if mv.wsConn then mv.wsConn:Disconnect()mv.
wsConn=nil end end end})UI.keybind(UI.movement,'KEYBIND_Walk_Speed',VS.
wsToggleRef);(function()local GF={enabled=false,conn=nil,anim=nil,track=nil}UI.
movement:CreateToggle({name='GER Float',value=false,flag='LOCAL_GERFloat',
callback=function(v)GF.enabled=v local char=getCharacter()local hum=char and
char:FindFirstChildWhichIsA('Humanoid')if v then if hum then GF.anim=Instance.
new('Animation')GF.anim.AnimationId='rbxassetid://4638021147'GF.track=hum:
LoadAnimation(GF.anim)GF.track.Priority=Enum.AnimationPriority.Action GF.track.
Looped=true GF.track:Play()end GF.conn=RunService.RenderStepped:Connect(function
()local c=getCharacter()local rp=c and c:FindFirstChild('HumanoidRootPart')if rp
then local vel=rp.AssemblyLinearVelocity rp.AssemblyLinearVelocity=Vector3.new(
vel.X,0,vel.Z)end end)else if GF.conn then GF.conn:Disconnect()GF.conn=nil end
if GF.track then GF.track:Stop()GF.track=nil end if GF.anim then GF.anim:
Destroy()GF.anim=nil end end end})end)()UI.movement:CreateSlider({name=
'JumpPower',range={1,200},increment=1,value=24,flag='LOCAL_JumpPower',callback=
function(v)getgenv()._pulseMoveState.jpPower=v end})UI.movement:CreateToggle({
name='Enable JumpPower',value=false,flag='LOCAL_EnableJumpPower',callback=
function(v)local mv=getgenv()._pulseMoveState mv.jpEnabled=v if v then mv.jpConn
=RunService.RenderStepped:Connect(function()pcall(function()getCharacter().
Humanoid.JumpPower=mv.jpPower end)end)else if mv.jpConn then mv.jpConn:
Disconnect()mv.jpConn=nil end end end});(function()local autoSprintEnabled=false
local autoSprintConn=nil local function rebindAutoSprint()if autoSprintConn then
autoSprintConn:Disconnect()autoSprintConn=nil end if not autoSprintEnabled then
return end local lastToggleAt=0 autoSprintConn=RunService.Heartbeat:Connect(
function()local char=LocalPlayer.Character if not char then return end if char:
GetAttribute('Sprinting')then return end local now=tick()if now-lastToggleAt<
0.25 then return end local rf=char:FindFirstChild('RemoteFunction')if not rf
then return end lastToggleAt=now pcall(function()rf:InvokeServer(
'ToggleSprinting')end)end)end UI.movement:CreateToggle({name='Auto Sprint',value
=false,flag='LOCAL_AutoSprint',callback=function(v)autoSprintEnabled=v
rebindAutoSprint()end})LocalPlayer.CharacterAdded:Connect(function()task.wait(1)
rebindAutoSprint()end)end)()do getgenv()._pulseInfiniteDashState={debris=game:
GetService('Debris'),folder=Instance.new('Folder',workspace),on=false,conn=nil,
lastTick=tick(),delay=1,power=50}getgenv()._pulseInfiniteDashState.folder.Name=
'DashAnims_'..LocalPlayer.UserId UI.dash:CreateToggle({name='Infinite Dash',
value=false,flag='LOCAL_InfiniteDash',callback=function(v)getgenv().
_pulseInfiniteDashState.on=v if v then getgenv()._pulseInfiniteDashState.conn=
UserInputService.InputBegan:Connect(function(Input,GameProcessed)if
GameProcessed then return end local dashKey=PlayerStats:FindFirstChild('DashKey'
)if not dashKey then return end if Input.KeyCode==Enum.KeyCode[dashKey.Value]and
(tick()-getgenv()._pulseInfiniteDashState.lastTick)>=getgenv().
_pulseInfiniteDashState.delay then getgenv()._pulseInfiniteDashState.lastTick=
tick()local humanoid=getHumanoid()local hrp=getRootPart()if not humanoid or not
hrp then return end local Dir,AnimID=180,'6926086304'if UserInputService:
IsKeyDown(Enum.KeyCode.A)then Dir=90 AnimID='6926086567'elseif UserInputService:
IsKeyDown(Enum.KeyCode.D)then Dir=-90 AnimID='6926086883'elseif UserInputService
:IsKeyDown(Enum.KeyCode.W)then Dir=0 AnimID='6926086032'end local anim=Instance.
new('Animation')anim.AnimationId='rbxassetid://'..AnimID anim.Parent=getgenv().
_pulseInfiniteDashState.folder local track=humanoid:LoadAnimation(anim)track:
Play()local bv=Instance.new('BodyVelocity')bv.Velocity=(hrp.CFrame*CFrame.
Angles(0,math.rad(Dir),0)).lookVector*getgenv()._pulseInfiniteDashState.power bv
.MaxForce=Vector3.new(55555,1000,55555)bv.Parent=hrp getgenv().
_pulseInfiniteDashState.debris:AddItem(bv,0.25)end end)notify('Infinite Dash',
'Infinite Dash enabled.','start')else if getgenv()._pulseInfiniteDashState.conn
then getgenv()._pulseInfiniteDashState.conn:Disconnect()getgenv().
_pulseInfiniteDashState.conn=nil end for _,child in pairs(getgenv().
_pulseInfiniteDashState.folder:GetChildren())do child:Destroy()end notify(
'Infinite Dash','Infinite Dash disabled.','stop')end end})UI.dash:CreateSlider({
name='Power',range={10,500},increment=5,value=50,flag='LOCAL_DashPower',callback
=function(v)getgenv()._pulseInfiniteDashState.power=v end})UI.dash:CreateSlider(
{name='Delay (s)',range={0,3},increment=0.1,value=1,flag='LOCAL_DashDelay',
callback=function(v)getgenv()._pulseInfiniteDashState.delay=v end})end(function(
)local NH={enabled=false,label=nil}UI.visuals:CreateToggle({name='Name Hider',
value=false,flag='LOCAL_NameHider',callback=function(v)NH.enabled=v if v then
task.spawn(function()while NH.enabled do pcall(function()local entry=PlayerGui.
HUD.Playerlist[LocalPlayer.Name]if entry then NH.label=entry.PlayerName NH.label
.Text='Pulse'end end)task.wait()end end)else if NH.label then NH.label.Text=
LocalPlayer.Name end end end})end)()end end function __DARKLUA_BUNDLE_MODULES.aI
():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.aI if not v then v=
{c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.aI=v end return v.c end end do
local function __modImpl()return function(env)local VS=env.VS local
TeleportService=env.TeleportService local LocalPlayer=env.LocalPlayer local
notify=env.notify local UI=env.UI UI.server:CreateSlider({name='Min Players',
range={1,20},increment=1,value=VS.serverHopMinPlayers,flag=
'LOCAL_ServerHopMinPlayers',callback=function(v)VS.serverHopMinPlayers=tonumber(
v)or VS.serverHopMinPlayers if VS.serverHopMinPlayers>VS.serverHopMaxPlayers
then VS.serverHopMaxPlayers=VS.serverHopMinPlayers end end})UI.server:
CreateSlider({name='Max Players',range={1,20},increment=1,value=VS.
serverHopMaxPlayers,flag='LOCAL_ServerHopMaxPlayers',callback=function(v)VS.
serverHopMaxPlayers=tonumber(v)or VS.serverHopMaxPlayers if VS.
serverHopMaxPlayers<VS.serverHopMinPlayers then VS.serverHopMinPlayers=VS.
serverHopMaxPlayers end end})UI.serverRow=UI.server:CreateGroup({direction='row'
})UI.serverRow:CreateButton({name='Server Hop',callback=function()if getgenv().
__pulseSmartHop then task.spawn(getgenv().__pulseSmartHop,'Manual hop')else
notify('Server Hop','Hop engine not ready, rejoining...','warn')getgenv().
_pulseRestoreItemFarm=VS.itemFarmEnabled TeleportService:Teleport(game.PlaceId,
LocalPlayer)end end})end end function __DARKLUA_BUNDLE_MODULES.aJ():typeof(
__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.aJ if not v then v={c=
__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.aJ=v end return v.c end end do
local function __modImpl()return function(env)local Players=env.Players local
UserInputService=env.UserInputService local LocalPlayer=env.LocalPlayer local
notify=env.notify local UI=env.UI;(function()local autoParryTiming=0.05 local
autoParryRange=25 local parryProjBonus=15 local autoParryConfig=nil local
autoParryConns=nil local function getCharacter()return LocalPlayer.Character end
local function getHRP()local char=getCharacter()return char and char:
FindFirstChild('HumanoidRootPart')end local function getPing()return LocalPlayer
:GetNetworkPing()end local function isTimeStop()return workspace:FindFirstChild(
'TimeStop')or game:GetService('Lighting'):FindFirstChild('TimeStop')end
local function isRagdolled(char)return char and char:FindFirstChild(
'RagdollParts')~=nil end local function inRange(pos,range)local hrp=getHRP()if
not hrp then return false end return(hrp.Position-pos).Magnitude<=range end
local function trackConn(conns,c)table.insert(conns,c)return c end
local function genId()return tostring(math.random(100000000,999999999))end
local function logAP(msg)print('Pulse: Auto Parry '..msg)end local function
blockNow(State)local char=getCharacter()if not char then return end local cap=
char:FindFirstChild('Blocking_Capacity')if cap and cap.Value>0 then State.
Blocking=true return end State.Blocking=true local rem=char:FindFirstChild(
'RemoteEvent')if rem then for _=1,3 do rem:FireServer('StartBlocking','pass')
task.wait()end end end local function unblockNow(Config,State,forced,instant)if
not Config.Unblocking and not forced then return end if forced and not Config.
Reblocking and not isRagdolled(getCharacter())then return 42 end local char=
getCharacter()if not char then return end if not(forced or instant)and State.
FKeyHeld and Config.KeepBlock and not isRagdolled(char)then return end local rem
=char:FindFirstChild('RemoteEvent')if rem then for _=1,5 do rem:FireServer(
'StopBlocking','pass')task.wait()end end State.Blocking=false State.BlockActions
=false end local function blocker(Config,State)return function(defense,waitTime,
addWait,isPerfect,priority,isStandAttack,_logReason,_logDist)if not Config.
Enabled then return end if State.BlockActions then local cur=tonumber(State.
BlockActions)or 0 if priority and priority<=cur then return end end State.
BlockActions=priority or true local char=getCharacter()if not char then return
end local rem=char:FindFirstChild('RemoteEvent')if rem then rem:FireServer(
'HoldAttack',{Bool=false,Type='m1'})rem:FireServer('HoldAttack',{Bool=false,Type
='barrage'})rem:FireServer('InputEnded',{Input=Enum.KeyCode.E})end State.
LastBlock=State.LastBlock+1 local current=State.LastBlock local cap=char:
FindFirstChild('Blocking_Capacity')if cap and cap.Value>0 and isPerfect then if
defense<0.2 or not Config.Reblocking then return end if unblockNow(Config,State,
true)==42 then return end end local pingComp=Config.PingCompensation and
getPing()or 0 local actualWait=math.max(0,(Config.ReactionDelay or defense)-
pingComp)if waitTime and waitTime>actualWait then actualWait=waitTime end if
Config.ExtraDelayEnabled then actualWait=actualWait+(Config.ExtraDelayAmount or
0)end if isStandAttack and(Config.StandDelay or 0)>0 then actualWait=actualWait+
Config.StandDelay end task.wait(actualWait)if State.LastBlock~=current then
return end if isTimeStop()then State.BlockActions=false return end blockNow(
State)local pingDelay=math.max(0.02,getPing()*(Config.UnblockPingScale or 0.5))
local unblockDelay=(Config.UnblockBaseDelay or 0.22)+pingDelay+math.max(0,
addWait or 0)task.wait(unblockDelay)if State.LastBlock==current and not
isTimeStop()then State.BlockActions=false unblockNow(Config,State,false)end end
end local function perfectBlocks()return{{'rbxassetid://7217913060',{def=0.2}},{
'rbxassetid://4725629903',{def=0.2}},{'rbxassetid://6032844827',{def=0.2}},{
'rbxassetid://163619849',{def=0.2}},{'rbxassetid://7217914447',{def=0,chckfunc=
function(parent)local stand=parent and parent:FindFirstChild('StandMorph')if
stand then local n=stand:FindFirstChild('Stand Name')return n and n.Value==
'Star Platinum'end return false end}},{'rbxassetid://7217914447',{def=0,chckfunc
=function(parent)local stand=parent and parent:FindFirstChild('StandMorph')if
stand then local n=stand:FindFirstChild('Stand Name')return n and n.Value~=
'Star Platinum'end return false end}}}end local function baseBlocks()return{{
'rbxassetid://6032836072',{def=0.3}},{'rbxassetid://6034138660',{def=0.3}},{
'rbxassetid://10459370874',{def=0.35,addw=-0.35,dist=15}},{
'rbxassetid://12440326715',{addw=-0.1,dist=15}},{'rbxassetid://74034132845527',{
def=0.4}},{'rbxassetid://5074434156',{def=0.3}},{'rbxassetid://6572639359',{def=
0.3}},{'rbxassetid://6570678905',{def=0.3}}}end local function animBlocksA(
Config)return{{'rbxassetid://6048575522',{def=0,chckfunc=function(_,parent)local
s=parent and parent:FindFirstChild('StandMorph')if s then local n=s:
FindFirstChild('Stand Name')return n and n.Value=='Star Platinum'end return
false end}},{'rbxassetid://6048575522',{def=0.3,dist=20,chckfunc=function(_,
parent)local s=parent and parent:FindFirstChild('StandMorph')if s then local n=s
:FindFirstChild('Stand Name')return n and n.Value~='Star Platinum'end return
true end}},{'rbxassetid://4211804997',{def=0.3,dist=20,chckfunc=function(_,
parent)local s=parent and parent:FindFirstChild('StandMorph')if s then local n=s
:FindFirstChild('Stand Name')return n and n.Value~='Tusk ACT 4'end return true
end}},{'rbxassetid://13899360363',{def=0.4,dist=20}},{'rbxassetid://7189005773',
{def=0.3,dist=20}},{'rbxassetid://6835249882',{def=0.4,dist=20}},{
'rbxassetid://11886825775',{def=0.3,dist=20}},{'rbxassetid://4879759800',{def=
0.4,dist=20}},{'rbxassetid://4825999731',{def=0.5,dist=160,chckfunc=function()
return Config.ColiseumMode end}},{'rbxassetid://6704817082',{def=0.35,dist=20}},
{'rbxassetid://6049426097',{def=0.3,dist=20}},{'rbxassetid://6105486059',{def=
0.35,dist=20}},{'rbxassetid://5303743107',{def=0.35,dist=20}},{
'rbxassetid://7250792726',{def=0.4,dist=20}},{'rbxassetid://4812642386',{def=
0.35,dist=20}},{'rbxassetid://6216052429',{def=0,chckfunc=function(anim,_)task.
wait()return anim.Speed>1.39 end}},{'rbxassetid://6216052429',{def=0.35,dist=20}
}}end local function animBlocksB()return{{'rbxassetid://4096014941',{def=0.4,
chckfunc=function(anim)return anim.Speed>1.049 and anim.Speed<1.051 end}},{
'rbxassetid://4096014941',{def=0.4,chckfunc=function(anim)return anim.Speed>
1.074 and anim.Speed<1.076 end}},{'rbxassetid://4096014941',{def=0.4,chckfunc=
function(anim,parent)local s=parent and parent:FindFirstChild('StandMorph')if s
then local n=s:FindFirstChild('Stand Name')if n and n.Value=="Magician's Red"
then return anim.Speed==1 end end return false end}},{'rbxassetid://4096014941',
{def=0.4,chckfunc=function(_,parent)local s=parent and parent:FindFirstChild(
'StandMorph')if s then local n=s:FindFirstChild('Stand Name')return n and n.
Value=='Gold Experience'end return false end}},{'rbxassetid://4096014941',{def=
0.3,dist=75,chckfunc=function(_,parent)local s=parent and parent:FindFirstChild(
'StandMorph')if not s then return false end local n=s:FindFirstChild(
'Stand Name')if not n or n.Value~='The Hand'then return false end task.wait()for
_,c in ipairs(s:GetChildren())do if c:IsA('Sound')and c.SoundId==
'rbxassetid://7217913060'then return false end end return true end}},{
'rbxassetid://4096014941',{def=0.4,chckfunc=function(anim)return anim.Speed>1.09
and anim.Speed<1.11 end}},{'rbxassetid://4096014941',{def=0.4,chckfunc=function(
anim)return anim.Speed>0.84 and anim.Speed<0.86 end}},{
'rbxassetid://12733018380',{def=0.35,dist=15,addw=1.1}},{
'rbxassetid://10443021814',{def=0.35,dist=15,addw=0.15}},{
'rbxassetid://12733022476',{coliseum=true,dist=1000,addw=0.3}},{
'rbxassetid://4608512208',{addw=0.25}},{'rbxassetid://5303988283',{def=0.2,dist=
20}},{'rbxassetid://6780938176',{def=0.2,addw=0.3,dist=20}},{
'rbxassetid://12292886724',{def=0.35,dist=20}},{'rbxassetid://6277192242',{def=
0.2,dist=50,addw=1}},{'rbxassetid://6651725175',{addw=-0.1,dist=40}},{
'rbxassetid://6216058630',{def=0,coliseum=true,dist=60,addw=-0.1}},{
'rbxassetid://10726619714',{def=0.2,addw=0.55,dist=20}},{
'rbxassetid://12293320463',{def=0.3,dist=20}},{'rbxassetid://6869896659',{def=
0.2,addw=0.75,dist=20}},{'rbxassetid://14174878575',{def=0.3,dist=70,addw=-0.1,
coliseum=true}},{'rbxassetid://7189003645',{def=0.3,addw=0.2,dist=20}},{
'rbxassetid://5793968491',{def=0.35,dist=20}},{'rbxassetid://4595562165',{def=0,
addw=0.3}},{'rbxassetid://5227558947',{def=0.35,dist=20}},{
'rbxassetid://4133363765',{def=0.6,dist=20}},{'rbxassetid://5056859332',{def=
0.35,dist=20}},{'rbxassetid://4691787301',{def=0.25,addw=0.75,dist=100,chckfunc=
function(_,parent)task.wait()local me=LocalPlayer.Character local hand=parent
and parent:FindFirstChild('RightHand')local grapple=hand and hand:
FindFirstChild('Grapple')local myHRP=me and me:FindFirstChild('HumanoidRootPart'
)local myAttach=myHRP and myHRP:FindFirstChild('RootRigAttachment')if grapple
and myAttach then return grapple.Attachment1==myAttach end return false end}},{
'rbxassetid://12733016318',{def=0.325,addw=-0.1,dist=15,chckfunc=function(anim)
return anim.Speed<0.75 end}},{'rbxassetid://4096014941',{def=0.35,dist=20}},{
'rbxassetid://6048575522',{def=0.35,dist=20}},{'rbxassetid://4211804997',{def=
0.35,dist=20}},{'rbxassetid://5303743107',{def=0.3,dist=20}},{
'rbxassetid://6105486059',{def=0.3,dist=20}},{'rbxassetid://6049426097',{def=
0.35,dist=20}}}end local function projectileList()return{{'VisionPlunderBubble',
'Core',15},{'SP Bullet',nil,20,function(obj)return obj:FindFirstChild('Victim')
and true or false end},{'Last Shot',nil,20},{'Main',nil,25,function(obj)return
obj:FindFirstChild('BloodTrail')and true or false end},{'HomingShard',nil,20},{
'Bullet',nil,20,function(obj)if obj.Name:find('SP Bullet')or obj.Name:find(
'SPBullet')then return false end return not obj:FindFirstChild('Victim')end},{
'CrossFirePiece',nil,40,function(obj)local sparks=obj:FindFirstChild(
'OnFireSparks')return sparks and sparks.Enabled end,true,true},{'Baseball3',nil,
20}}end local function specialList(requestBlockRef)return{{'GroundIndicator',
function(obj)local s={def=0,wt=0,addw=-0.1}local clone=obj:Clone()local expanded
=15+10 clone.Size=Vector3.new(15+expanded,5,40+expanded)clone.CFrame=clone.
CFrame*CFrame.new(0,0,-12.5)task.wait(0.15)local hrp=LocalPlayer.Character and
LocalPlayer.Character:FindFirstChild('HumanoidRootPart')if hrp then local pos=
hrp.Position local mn=clone.Position-clone.Size/2 local mx=clone.Position+clone.
Size/2 if pos.X>=mn.X and pos.X<=mx.X and pos.Y>=mn.Y and pos.Y<=mx.Y and pos.Z
>=mn.Z and pos.Z<=mx.Z then if requestBlockRef[1]then requestBlockRef[1](s.def,s
.wt,s.addw,false)end end end clone:Destroy()return true end},{'FloorDash',
function(obj)if not inRange(obj.Position,40)then return false end local s={def=0
,wt=0,addw=0.25}task.wait(0.2)if requestBlockRef[1]then requestBlockRef[1](s.def
,s.wt,s.addw,false)end return true end}}end local function blockDb(Config,
requestBlockRef)local animA=animBlocksA(Config)local animB=animBlocksB()local
merged={}for _,v in ipairs(animA)do table.insert(merged,v)end for _,v in ipairs(
animB)do table.insert(merged,v)end return{PerfectBlocks=perfectBlocks(),
BaseBlocks=baseBlocks(),UnblockTriggers={'rbxassetid://11876873350'},
AnimationBlocks=merged,AnimationUnblock={'rbxassetid://12293318922',
'rbxassetid://13819646949','rbxassetid://6780937804','rbxassetid://6780982308',{
'rbxassetid://10443019808',{dist=10}}},Projectiles=projectileList(),
SpecialObjects=specialList(requestBlockRef)}end local function triggerHandler(
Config,State,db,requestBlock)return function(source,parent,secondaryPart)if not
Config.Enabled then return end if isTimeStop()then return end if isRagdolled(
getCharacter())then return end if State.BlockProcsUntil>tick()then return end
local isPerfect=false local defense=0.4 local addWait=0 local priority=0 local
distance=Config.BlockRange local found=false local extraWait=0 local
isStandAttack=false local triggerReason='unknown'local function checkDistance(
maxDist)local hrp=getHRP()if not hrp then return false,0 end local targetPos=
secondaryPart and secondaryPart.Position or parent.Position local dist=(hrp.
Position-targetPos).Magnitude if dist>maxDist then if secondaryPart then dist=(
hrp.Position-parent.Position).Magnitude if dist>maxDist then return false,dist
end else return false,dist end end if dist>maxDist*(Config.DistanceThreshold or
0.7)then extraWait=Config.FarTargetDelay or 0.3 task.wait(extraWait)hrp=getHRP()
if not hrp then return false,dist end dist=(hrp.Position-targetPos).Magnitude if
dist>maxDist then return false,dist end end return true,dist end if source:IsA(
'Sound')then for _,b in ipairs(db.PerfectBlocks)do local id=type(b)=='table'and
b[1]or b local s=type(b)=='table'and b[2]or{}if source.SoundId==id then if s.
chckfunc and not s.chckfunc(parent)then continue end isPerfect=true defense=s.
def or 0.2 distance=s.dist or distance addWait=s.addw or addWait priority=s.prio
or priority triggerReason='PerfectBlock '..id found=true break end end if not
found then for _,b in ipairs(db.BaseBlocks)do local id=type(b)=='table'and b[1]
or b local s=type(b)=='table'and b[2]or{}if source.SoundId==id then isPerfect=
false defense=s.def or 0.3 distance=s.dist or distance addWait=s.addw or addWait
triggerReason='BaseBlock '..id found=true break end end end if not found then
for _,id in ipairs(db.UnblockTriggers)do if source.SoundId==id and State.
LastTarget==parent then State.LastBlock=State.LastBlock+1 State.BlockProcsUntil=
tick()+0.75 State.BlockActions=false unblockNow(Config,State,false)return end
end end end if not found and source:IsA('AnimationTrack')then local animId=
source.Animation and source.Animation.AnimationId if animId then for _,b in
ipairs(db.AnimationUnblock)do local id=type(b)=='table'and b[1]or b local s=
type(b)=='table'and b[2]or{}if animId==id then local maxDist=s.dist or Config.
BlockRange local hrp=getHRP()if hrp and(not parent or(hrp.Position-parent.
Position).Magnitude<=maxDist)then State.LastBlock=State.LastBlock+1 State.
BlockProcsUntil=tick()+0.5 State.BlockActions=false unblockNow(Config,State,
false)end return end end for _,b in ipairs(db.AnimationBlocks)do local id=type(b
)=='table'and b[1]or b local s=type(b)=='table'and b[2]or{}if type(b)=='table'
and s.coliseum and not Config.ColiseumMode then continue end if animId==id then
if s.chckfunc and not s.chckfunc(source,parent)then continue end isPerfect=(s.
def or 0.4)<=0.2 defense=s.def or 0.3 distance=s.dist or distance addWait=s.addw
or addWait priority=s.prio or priority triggerReason='AnimBlock '..id found=true
if id=='rbxassetid://6048575522'or id=='rbxassetid://4096014941'or id==
'rbxassetid://4211804997'or id=='rbxassetid://5303743107'or id==
'rbxassetid://6105486059'or id=='rbxassetid://6049426097'then isStandAttack=true
end break end end end end if found then State.LastTarget=parent local ok,
actualDist=checkDistance(distance)if ok then local pingComp=Config.
PingCompensation and getPing()or 0 local calculatedWait=math.max(0,defense-
pingComp)+extraWait requestBlock(defense,calculatedWait,addWait,isPerfect,
priority,isStandAttack,triggerReason,actualDist)end end end end local function
projectileHandler(Config,State,db)return function(obj)if not Config.Enabled then
return end for _,p in ipairs(db.Projectiles)do local namePattern,childName,range
,validator=unpack(p)if obj.Name:find(namePattern)then local target=childName and
obj:FindFirstChild(childName)or obj if validator and not validator(obj)then
continue end local hrp=getHRP()if not hrp then return end local extendedRange=
range+(Config.ProjectileRangeBonus or 0)local function projInRange()local pos=
target.Position local vel=target.AssemblyLinearVelocity if vel.Magnitude>0.01
then local unit=vel.Unit local predicted=pos+unit*10 local d1=(hrp.Position-pos)
.Magnitude local d2=(hrp.Position-predicted).Magnitude return d1<extendedRange
or d2<extendedRange end return(hrp.Position-pos).Magnitude<extendedRange end
while obj.Parent and obj:IsDescendantOf(workspace)do if projInRange()and(not
State.BlockActions or Config.ProjectilesPriority)then State.BlockActions=true if
Config.ProjectilesPriority then State.BlockActions=42000 end blockNow(State)
local startT=tick()while obj.Parent and(tick()-startT<0.75)do if not
projInRange()then break end task.wait()end if tick()-startT<0.432 then task.
wait(0.432-(tick()-startT))end if not isTimeStop()then unblockNow(Config,State,
false)State.BlockActions=false end return end task.wait()end end end end end
local function specialHandler(Config,db)return function(obj)if not Config.
Enabled then return end for _,sp in ipairs(db.SpecialObjects)do local
namePattern,handler=unpack(sp)if obj.Name:find(namePattern)then handler(obj)
return end end end end local function attachStandAnimators(stand,character,conns
,processBlockTrigger)local list={}local sa=stand:FindFirstChild('Animator',true)
if sa then table.insert(list,sa)end local sh=stand:FindFirstChildOfClass(
'Humanoid')if sh then local sha=sh:FindFirstChild('Animator')if sha then table.
insert(list,sha)end end local ac=stand:FindFirstChildOfClass(
'AnimationController')if ac then local aca=ac:FindFirstChild('Animator')if aca
then table.insert(list,aca)end end for _,anim in ipairs(list)do trackConn(conns,
anim.AnimationPlayed:Connect(function(t)processBlockTrigger(t,character.
PrimaryPart,nil)end))end trackConn(conns,stand.DescendantAdded:Connect(function(
d)if d:IsA('Animator')then task.wait(0.1)trackConn(conns,d.AnimationPlayed:
Connect(function(t)processBlockTrigger(t,character.PrimaryPart,nil)end))end end)
)end local function setupCharacterHooks(character,conns,processBlockTrigger)if
not character then return end local hum=character:WaitForChild('Humanoid',5)
local animator=hum and hum:WaitForChild('Animator',5)if animator then trackConn(
conns,animator.AnimationPlayed:Connect(function(t)processBlockTrigger(t,
character.PrimaryPart,nil)end))end trackConn(conns,character.DescendantAdded:
Connect(function(d)if d:IsA('Sound')then task.wait()processBlockTrigger(d,
character.PrimaryPart,nil)elseif d:IsA('Model')and d.Name=='StandMorph'then task
.wait(0.15)attachStandAnimators(d,character,conns,processBlockTrigger)elseif d:
IsA('Animator')then task.wait(0.1)trackConn(conns,d.AnimationPlayed:Connect(
function(t)processBlockTrigger(t,character.PrimaryPart,nil)end))end end))local
existing=character:FindFirstChild('StandMorph')if existing then task.wait(0.15)
attachStandAnimators(existing,character,conns,processBlockTrigger)end end
local function hookPlayer(player,State,conns,processBlockTrigger)if player==
LocalPlayer then return end if State.HookedPlayers[player.Name]then return end
State.HookedPlayers[player.Name]=true if player.Character then
setupCharacterHooks(player.Character,conns,processBlockTrigger)end trackConn(
conns,player.CharacterAdded:Connect(function(char)setupCharacterHooks(char,conns
,processBlockTrigger)end))logAP('Hooked player: '..player.Name)end
local function stopAutoParry()if autoParryConns then for i=#autoParryConns,1,-1
do pcall(function()autoParryConns[i]:Disconnect()end)autoParryConns[i]=nil end
autoParryConns=nil end if autoParryConfig then autoParryConfig.Enabled=false
autoParryConfig=nil end end local function startAutoParry()stopAutoParry()local
Config={Enabled=true,Reblocking=true,KeepBlock=true,Unblocking=true,
ProjectilesPriority=true,ColiseumMode=false,BlockRange=autoParryRange,
ProjectileRangeBonus=parryProjBonus,ReactionDelay=autoParryTiming,
PingCompensation=true,ExtraDelayEnabled=true,ExtraDelayAmount=0.05,
FarTargetDelay=0.3,DistanceThreshold=0.7,StandDelay=0.02,UnblockBaseDelay=0.22,
UnblockPingScale=0.5}autoParryConfig=Config local conns={}autoParryConns=conns
local State={Blocking=false,LastBlock=0,BlockActions=false,BlockProcsUntil=0,
LastTarget=nil,HookedPlayers={},FKeyHeld=false,IsRagdolled=false}local rbRef={}
local requestBlock=blocker(Config,State)rbRef[1]=requestBlock local db=blockDb(
Config,rbRef)local processBlockTrigger=triggerHandler(Config,State,db,
requestBlock)local handleProjectile=projectileHandler(Config,State,db)local
handleSpecialObject=specialHandler(Config,db)trackConn(conns,UserInputService.
InputBegan:Connect(function(input,processed)if not processed and input.KeyCode==
Enum.KeyCode.F then State.FKeyHeld=true end end))trackConn(conns,
UserInputService.InputEnded:Connect(function(input)if input.KeyCode==Enum.
KeyCode.F then State.FKeyHeld=false end end))trackConn(conns,LocalPlayer.
CharacterAdded:Connect(function(char)trackConn(conns,char.ChildAdded:Connect(
function(c)if c.Name=='RagdollParts'then State.IsRagdolled=true State.LastBlock=
State.LastBlock+1 State.BlockProcsUntil=tick()+0.2 State.BlockActions=false
unblockNow(Config,State,false)end end))trackConn(conns,char.ChildRemoved:
Connect(function(c)if c.Name=='RagdollParts'then State.IsRagdolled=false end end
))end))trackConn(conns,Players.PlayerAdded:Connect(function(plr)hookPlayer(plr,
State,conns,processBlockTrigger)end))for _,plr in ipairs(Players:GetPlayers())do
hookPlayer(plr,State,conns,processBlockTrigger)end trackConn(conns,workspace.
DescendantAdded:Connect(function(desc)if not Config.Enabled then return end
handleProjectile(desc)handleSpecialObject(desc)end))trackConn(conns,workspace.
ChildAdded:Connect(function(child)if Config.Enabled then handleProjectile(child)
handleSpecialObject(child)end end))local ignoreInst=workspace:FindFirstChild(
'IgnoreInstances')if ignoreInst then trackConn(conns,ignoreInst.ChildAdded:
Connect(function(child)if Config.Enabled then handleProjectile(child)
handleSpecialObject(child)end end))end logAP('Initialized. Range='..tostring(
Config.BlockRange))end UI.parry:CreateSlider({name='Timing (ms)',range={20,120},
increment=1,value=50,flag='COMBAT_AutoParryTiming',callback=function(value)
autoParryTiming=(tonumber(value)or 50)/1000 if autoParryConfig then
autoParryConfig.ReactionDelay=autoParryTiming end end})UI.parry:CreateSlider({
name='Distance',range={10,120},increment=1,value=autoParryRange,flag=
'COMBAT_AutoParryDistance',callback=function(value)autoParryRange=tonumber(value
)or 40 if autoParryConfig then autoParryConfig.BlockRange=autoParryRange end end
})UI.parry:CreateSlider({name='Projectile Bonus',range={0,80},increment=1,value=
parryProjBonus,flag='COMBAT_AutoParryProjectileBonus',callback=function(value)
parryProjBonus=tonumber(value)or 25 if autoParryConfig then autoParryConfig.
ProjectileRangeBonus=parryProjBonus end end})UI.parry:CreateToggle({name=
'Enable',value=false,flag='COMBAT_AutoParry',callback=function(value)if value
then startAutoParry()notify('Combat','Auto Parry enabled.','start')else
stopAutoParry()notify('Combat','Auto Parry disabled.','stop')end end})end)()end
end function __DARKLUA_BUNDLE_MODULES.aK():typeof(__modImpl())local v=
__DARKLUA_BUNDLE_MODULES.cache.aK if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.aK=v end return v.c end end do local function
__modImpl()return function(env)local RunService=env.RunService local LocalPlayer
=env.LocalPlayer local PlayerGui=env.PlayerGui local notify=env.notify local UI=
env.UI;(function()local autoBarrageEnabled=false local autoBarrageRadius=15
local autoBarrageConns={}local isBarraging=false local BARRAGE_IDS={[
'99682911857717']=true,['116404734852913']=true,['6572640039']=true,[
'6936653670']=true,['3510355751']=true,['74297051681404']=true,['5248642110']=
true,['4635691288']=true,['3564702007']=true,['375581222']=true,['4264140426']=
true,['6572245980']=true,['6938351900']=true,['13819815645']=true,[
'85525529380684']=true,['12344317921']=true,['10067522910']=true,['4842701605']=
true,['4139483350']=true,['102032545576547']=true,['5227665355']=true,[
'616593932']=true,['5234093084']=true,['76927399049290']=true,['12439757027']=
true,['5778001429']=true}local function isSkillOnCooldown(skillName)if not
skillName or skillName==''then return false end local hud=PlayerGui:
FindFirstChild('HUD')if not hud then return false end local cd=hud:
FindFirstChild('Cooldowns')if not cd then return false end local frame=cd:
FindFirstChild('Frame')if not frame then return false end return frame:
FindFirstChild(skillName)~=nil end local function checkBarragePlaying(char)if
not char then return false end local hum=char:FindFirstChildOfClass('Humanoid')
if hum then local animator=hum:FindFirstChildOfClass('Animator')if animator then
for _,track in ipairs(animator:GetPlayingAnimationTracks())do local animId=track
.Animation and track.Animation.AnimationId if animId then local idStr=tostring(
animId):match('%d+')if idStr and BARRAGE_IDS[idStr]then return true end end end
end end local standMorph=char:FindFirstChild('StandMorph')if standMorph then
local standHum=standMorph:FindFirstChildOfClass('Humanoid')local standAc=
standMorph:FindFirstChildOfClass('AnimationController')local controller=standHum
or standAc if controller then local animator=controller:FindFirstChildOfClass(
'Animator')if animator then for _,track in ipairs(animator:
GetPlayingAnimationTracks())do local animId=track.Animation and track.Animation.
AnimationId if animId then local idStr=tostring(animId):match('%d+')if idStr and
BARRAGE_IDS[idStr]then return true end end end end end end for _,v in pairs(char
:GetDescendants())do if v:IsA('Sound')and(v.Playing or v.IsPlaying or v.
TimePosition>0)then local idStr=tostring(v.SoundId):match('%d+')if idStr and
BARRAGE_IDS[idStr]then return true end end end return false end local function
startAutoBarrage()if#autoBarrageConns>0 then return end table.insert(
autoBarrageConns,RunService.Heartbeat:Connect(function()if not
autoBarrageEnabled then return end local localChar=LocalPlayer.Character if not
localChar then return end local localHrp=localChar:FindFirstChild(
'HumanoidRootPart')local remote=localChar:FindFirstChild('RemoteEvent')if not
localHrp or not remote then return end local localStand=localChar:
FindFirstChild('StandMorph')local barragingTarget=false for _,v in pairs(
workspace.Living:GetChildren())do if v~=localChar and v:FindFirstChild(
'HumanoidRootPart')then if localStand and v==localStand then continue end local
hrp=v.HumanoidRootPart local dist=(hrp.Position-localHrp.Position).Magnitude if
dist<=autoBarrageRadius then if checkBarragePlaying(v)then barragingTarget=true
break end end end end local ragdolled=localChar:FindFirstChild('RagdollParts')~=
nil local onCooldown=isSkillOnCooldown('Stand Barrage')local shouldBarrage=(
barragingTarget or isBarraging)and not ragdolled and not onCooldown if
shouldBarrage then isBarraging=true remote:FireServer('InputBegan',{Input=Enum.
KeyCode.E})else if isBarraging then isBarraging=false remote:FireServer(
'InputEnded',{Input=Enum.KeyCode.E})end end end))end local function
stopAutoBarrage()for _,conn in ipairs(autoBarrageConns)do if conn then conn:
Disconnect()end end autoBarrageConns={}local localChar=LocalPlayer.Character
local remote=localChar and localChar:FindFirstChild('RemoteEvent')if isBarraging
and remote then isBarraging=false remote:FireServer('InputEnded',{Input=Enum.
KeyCode.E})end end UI.barrage:CreateSlider({name='Radius',range={1,50},increment
=1,value=15,flag='COMBAT_AutoBarrageRadius',callback=function(value)
autoBarrageRadius=tonumber(value)or 15 end})UI.barrage:CreateToggle({name=
'Enable',value=false,flag='COMBAT_AutoBarrage',callback=function(value)
autoBarrageEnabled=value if value then startAutoBarrage()notify('Combat',
'Auto Barrage enabled.','start')else stopAutoBarrage()notify('Combat',
'Auto Barrage disabled.','stop')end end})end)()end end function
__DARKLUA_BUNDLE_MODULES.aL():typeof(__modImpl())local v=
__DARKLUA_BUNDLE_MODULES.cache.aL if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.aL=v end return v.c end end do local function
__modImpl()return function(env)local Players=env.Players local RunService=env.
RunService local UserInputService=env.UserInputService local LocalPlayer=env.
LocalPlayer local notify=env.notify local UI=env.UI;(function()local CONFIG={
Enabled=false,HoldKey=Enum.UserInputType.MouseButton2,ToggleKey=Enum.KeyCode.Q,
ToggleKeyName='Q',FOV=90,Smoothing=0.22,TargetPart='Head',DotSize=5,DotColor=
Color3.fromRGB(0,255,80),ShowFovCircle=false,FovColor=Color3.fromRGB(0,255,80),
FovThickness=1,IgnoreFriends=false,MaxDistance=1000,PredictTime=0}local Camera=
workspace.CurrentCamera local cameraChanged=workspace:GetPropertyChangedSignal(
'CurrentCamera'):Connect(function()Camera=workspace.CurrentCamera end)local
locked=false local holding=false local activeTarget=nil local lastSmoothCFrame=
nil local renderConn,inputBeganConn,inputEndedConn local dot,fovCircle
local function buildDrawings()if dot or not Drawing then return end local okDot,
dotObj=pcall(Drawing.new,'Circle')if okDot and dotObj then dot=dotObj dot.
Visible=false dot.Color=CONFIG.DotColor dot.Radius=CONFIG.DotSize dot.Filled=
true dot.Transparency=1 dot.NumSides=24 dot.Thickness=1 dot.ZIndex=5 end local
okFov,fovObj=pcall(Drawing.new,'Circle')if okFov and fovObj then fovCircle=
fovObj fovCircle.Visible=CONFIG.ShowFovCircle fovCircle.Color=CONFIG.FovColor
fovCircle.Radius=CONFIG.FOV fovCircle.Filled=false fovCircle.Transparency=0.7
fovCircle.NumSides=64 fovCircle.Thickness=CONFIG.FovThickness fovCircle.ZIndex=4
end end local function destroyDrawings()if dot then pcall(function()dot:Remove()
end)dot=nil end if fovCircle then pcall(function()fovCircle:Remove()end)
fovCircle=nil end end local function aimOrigin()return UserInputService:
GetMouseLocation()end local function getTargetPart(char)local part=char:
FindFirstChild(CONFIG.TargetPart)if part then return part end return char:
FindFirstChild('HumanoidRootPart')or char:FindFirstChildWhichIsA('BasePart')end
local function isAlive(char)local hum=char and char:FindFirstChildOfClass(
'Humanoid')return hum and hum.Health>0 end local function shouldSkip(plr)if plr
==LocalPlayer then return true end if CONFIG.IgnoreFriends then local ok,
isFriend=pcall(function()return plr:IsFriendsWith(LocalPlayer.UserId)end)if ok
and isFriend then return true end end return false end local function
worldToScreen(pos)local sp,onScreen=Camera:WorldToViewportPoint(pos)return
Vector2.new(sp.X,sp.Y),onScreen,sp.Z end local function findClosestTarget()local
center=aimOrigin()local bestPlr,bestDist for _,plr in ipairs(Players:GetPlayers(
))do if not shouldSkip(plr)then local char=plr.Character if char and isAlive(
char)then local part=getTargetPart(char)if part then local screen,onScreen,depth
=worldToScreen(part.Position)if onScreen and depth>0 and depth<=CONFIG.
MaxDistance then local d=(screen-center).Magnitude if d<=CONFIG.FOV and(not
bestDist or d<bestDist)then bestDist=d bestPlr=plr end end end end end end
return bestPlr end local function clearLockState()locked=false holding=false
activeTarget=nil lastSmoothCFrame=nil if dot then dot.Visible=false end end
local function stopCam()if renderConn then renderConn:Disconnect()renderConn=nil
end if inputBeganConn then inputBeganConn:Disconnect()inputBeganConn=nil end if
inputEndedConn then inputEndedConn:Disconnect()inputEndedConn=nil end
clearLockState()destroyDrawings()end local function startCam()stopCam()
buildDrawings()renderConn=RunService.RenderStepped:Connect(function()if not
CONFIG.Enabled then return end if fovCircle then if CONFIG.ShowFovCircle then
fovCircle.Position=aimOrigin()fovCircle.Radius=CONFIG.FOV fovCircle.Color=CONFIG
.FovColor fovCircle.Thickness=CONFIG.FovThickness fovCircle.Visible=true else
fovCircle.Visible=false end end local engaged=locked or holding if not engaged
then activeTarget=nil lastSmoothCFrame=nil if dot then dot.Visible=false end
return end local valid=activeTarget and activeTarget.Parent and activeTarget.
Character and isAlive(activeTarget.Character)and not shouldSkip(activeTarget)if
not valid then activeTarget=findClosestTarget()lastSmoothCFrame=Camera.CFrame
end if not activeTarget then if dot then dot.Visible=false end return end local
char=activeTarget.Character local part=char and getTargetPart(char)if not part
then if dot then dot.Visible=false end return end local aimPos=part.Position if
CONFIG.PredictTime>0 then aimPos=aimPos+part.AssemblyLinearVelocity*CONFIG.
PredictTime end local desired=CFrame.new(Camera.CFrame.Position,aimPos)local
smooth=(CONFIG.Smoothing>0)and(lastSmoothCFrame or Camera.CFrame):Lerp(desired,1
-CONFIG.Smoothing)or desired lastSmoothCFrame=smooth Camera.CFrame=smooth if dot
then local screen,onScreen=worldToScreen(part.Position)if onScreen then dot.
Position=screen dot.Radius=CONFIG.DotSize dot.Color=CONFIG.DotColor dot.Visible=
true else dot.Visible=false end end end)inputBeganConn=UserInputService.
InputBegan:Connect(function(input,gameProcessed)if gameProcessed then return end
if not CONFIG.Enabled then return end if CONFIG.HoldKey and input.UserInputType
==CONFIG.HoldKey then holding=true elseif CONFIG.ToggleKey and input.KeyCode==
CONFIG.ToggleKey then locked=not locked if not locked and not holding then
activeTarget=nil lastSmoothCFrame=nil if dot then dot.Visible=false end end end
end)inputEndedConn=UserInputService.InputEnded:Connect(function(input)if CONFIG.
HoldKey and input.UserInputType==CONFIG.HoldKey then holding=false if not locked
then activeTarget=nil lastSmoothCFrame=nil if dot then dot.Visible=false end end
end end)end if _G.PulseCamLockUnload then pcall(_G.PulseCamLockUnload)end _G.
PulseCamLockUnload=function()stopCam()if cameraChanged then pcall(function()
cameraChanged:Disconnect()end)end _G.PulseCamLockUnload=nil end local
mouseButtonMap={['None']=nil,['Left']=Enum.UserInputType.MouseButton1,['Right']=
Enum.UserInputType.MouseButton2,['Middle']=Enum.UserInputType.MouseButton3}local
mouseButtonOptions={'None','Left','Right','Middle'}local camToggle=UI.camLock:
CreateToggle({name='Enable',value=false,flag='COMBAT_CamLock_Enabled',callback=
function(v)CONFIG.Enabled=v if v then startCam()notify('Combat',
'Camera Lock enabled.','start')else stopCam()notify('Combat',
'Camera Lock disabled.','stop')end end})local actionKey actionKey=UI.keybind(UI.
camLock,'KEYBIND_Camera_Lock',camToggle,function(key)if key~=Enum.KeyCode.
Unknown and key==CONFIG.ToggleKey then actionKey:Set(Enum.KeyCode.Unknown,true)
notify('Keybinds',"Can't bind Camera Lock to its Lock Key ("..key.Name..
'). Change the Lock Key first.','warn')end end)UI.camLock:CreateDropdown({name=
'Hold Button',options=mouseButtonOptions,value={'Right'},flag=
'COMBAT_CamLock_HoldButton',callback=function(v)local pick=type(v)=='table'and(v
[1]or'None')or(v or'None')CONFIG.HoldKey=mouseButtonMap[pick]holding=false end})
UI.camLock:CreateKeybind({name='Lock Key',value=Enum.KeyCode.Q,flag=
'COMBAT_CamLock_ToggleKey',onChanged=function(key)local bound=key~=Enum.KeyCode.
Unknown and key or nil CONFIG.ToggleKey=bound CONFIG.ToggleKeyName=bound and
bound.Name or'None'locked=false if bound and actionKey.value==bound then
actionKey:Set(Enum.KeyCode.Unknown,true)notify('Keybinds',
'Camera Lock keybind cleared (collided with new Lock Key '..bound.Name..').',
'warn')end end})UI.camLock:CreateDropdown({name='Target Part',options={'Head',
'HumanoidRootPart'},value={'Head'},flag='COMBAT_CamLock_TargetPart',callback=
function(v)CONFIG.TargetPart=type(v)=='table'and(v[1]or'Head')or(v or'Head')end}
)UI.aim:CreateSlider({name='FOV',range={10,600},increment=5,value=90,flag=
'COMBAT_CamLock_FOV',callback=function(v)CONFIG.FOV=tonumber(v)or 90 end})UI.aim
:CreateSlider({name='Smoothing',range={0,0.95},increment=0.01,value=0.22,flag=
'COMBAT_CamLock_Smoothing',callback=function(v)CONFIG.Smoothing=tonumber(v)or
0.22 end})UI.aim:CreateSlider({name='Max Distance',range={50,5000},increment=50,
value=1000,flag='COMBAT_CamLock_MaxDistance',callback=function(v)CONFIG.
MaxDistance=tonumber(v)or 1000 end})UI.aim:CreateSlider({name='Prediction (s)',
range={0,0.3},increment=0.01,value=0,flag='COMBAT_CamLock_Predict',callback=
function(v)CONFIG.PredictTime=tonumber(v)or 0 end})UI.camLock:CreateToggle({name
='Show FOV',value=false,flag='COMBAT_CamLock_ShowFOV',callback=function(v)CONFIG
.ShowFovCircle=v end})UI.camLock:CreateToggle({name='Ignore Friends',value=false
,flag='COMBAT_CamLock_IgnoreFriends',callback=function(v)CONFIG.IgnoreFriends=v
end})end)()end end function __DARKLUA_BUNDLE_MODULES.aM():typeof(__modImpl())
local v=__DARKLUA_BUNDLE_MODULES.cache.aM if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.aM=v end return v.c end end do local function
__modImpl()return function(env)local Window=env.Window local ReplicatedStorage=
env.ReplicatedStorage local PlayerGui=env.PlayerGui local PlayerSpec=env.
PlayerSpec local PlayerMoney=env.PlayerMoney local Dialogues=env.Dialogues local
getCharacter=env.getCharacter local getRemoteEvent=env.getRemoteEvent local
purchaseRibCage=env.purchaseRibCage local fireDialogue=env.fireDialogue local
finishDialogue=env.finishDialogue local getBpItems=env.getBpItems local hasItem=
env.hasItem local desummonStand=env.desummonStand local summonStand=env.
summonStand local notify=env.notify local UI=env.UI do local npcName=''
local function npcNames()local names={}for _,npc in ipairs(Dialogues:
GetChildren())do table.insert(names,npc.Name)end table.sort(names)return names
end local npcDropdown=UI.dialogue:CreateDropdown({name='NPC',options=npcNames(),
value={},flag='DLG_FinishNpc',callback=function(v)npcName=type(v)=='table'and(v[
1]or'')or(v or'')end})UI.npcRow=UI.dialogue:CreateGroup({direction='row'})UI.
npcRow:CreateButton({name='Finish',callback=function()if npcName==''then notify(
'Dialogues','Pick an NPC first.','warn')return end finishDialogue(npcName)
notify('Dialogues','Finished '..npcName.."'s dialogue.",'success')end})UI.npcRow
:CreateButton({name='Refresh',callback=function()npcDropdown:Refresh(npcNames())
notify('Dialogues','NPC list refreshed.','info')end})end UI.storylines=UI.
dialogue:CreateGroup({direction='row'})UI.storylines:CreateButton({name=
'Skip Storylines',callback=function()if _G._pulseDialogueSkipBusy then notify(
'Dialogues','Dialogue skip is already running.','warn')return end local folder=
ReplicatedStorage:FindFirstChild('Dialogue')local char=getCharacter()local
remote=char and(char:FindFirstChild('RemoteEvent')or char:WaitForChild(
'RemoteEvent',3))if not folder or not remote then notify('Dialogues',
[[ReplicatedStorage.Dialogue or Character.RemoteEvent is missing.]],'warn')
return end local storylines={}for _,dialogue in ipairs(folder:GetChildren())do
local number=string.match(dialogue.Name,'^Storyline #(%d+)$')if number then
table.insert(storylines,{number=tonumber(number),dialogue=dialogue})end end
table.sort(storylines,function(a,b)return a.number<b.number end)if#storylines==0
then notify('Dialogues','No Storyline dialogues found.','warn')return end
local function press(button)if typeof(button)~='Instance'then return end local
signal=button.MouseButton1Click if not signal then return end pcall(function()if
type(firesignal)=='function'then firesignal(signal)end end)if type(
getconnections)=='function'then pcall(function()for _,connection in ipairs(
getconnections(signal))do connection:Fire()end end)end end local function reveal
(gui)for _,obj in ipairs(gui:GetDescendants())do if obj:IsA('TextLabel')then
pcall(function()obj.MaxVisibleGraphemes=-1 end)end end end local function
bodyText(frame)local best,size='',0 for _,obj in ipairs(frame:GetDescendants())
do if obj:IsA('TextLabel')and#obj.Text>size then best=obj.Text size=#obj.Text
end end return best end local function advance(frame)reveal(frame.Parent)press(
frame:FindFirstChild('ClickContinue'))local options=frame:FindFirstChild(
'Options')local option=options and options:FindFirstChild('Option1')press(option
and option:FindFirstChild('TextButton'))end _G._pulseDialogueSkipBusy=true
notify('Dialogues','Skipping Storyline #1 through #'..storylines[#storylines].
number..'.','info')task.spawn(function()for _,entry in ipairs(storylines)do
remote:FireServer('PromptTriggered',entry.dialogue)local opened=os.clock()+1
local frame=nil while os.clock()<opened do local gui=PlayerGui:FindFirstChild(
'DialogueGui')frame=gui and gui:FindFirstChild('Frame')if frame then break end
task.wait(0.05)end if frame then local last=''local same=0 for _=1,16 do local
gui=PlayerGui:FindFirstChild('DialogueGui')frame=gui and gui:FindFirstChild(
'Frame')if not frame then break end advance(frame)task.wait(0.06)gui=PlayerGui:
FindFirstChild('DialogueGui')frame=gui and gui:FindFirstChild('Frame')if not
frame then break end advance(frame)local text=bodyText(frame)if text==last then
same+=1 if same>=4 then break end else same=0 last=text end task.wait(0.06)end
end end local gui=PlayerGui:FindFirstChild('DialogueGui')if gui then gui:
Destroy()end _G._pulseDialogueSkipBusy=false notify('Dialogues','Finished '..#
storylines..' storylines.','success')end)end})UI.picker(UI.styles,'Style',
'NPC_Style',{{'Reset Fighting Style (3 Diamonds + $5,000)',function()if#
getBpItems('Diamond')>=3 and PlayerMoney.Value>=5000 then getRemoteEvent():
FireServer('EndDialogue',{NPC='Matt',Option='Option1',Dialogue='Dialogue5'})
notify('Dialogues','Fighting style reset!','success')else notify('Dialogues',
'Need 3 Diamonds and $5,000!','warn')end end},{
[[Hamon (Caesar's Headband / Clackers / Zeppeli's Hat + $10,000)]],function()if
PlayerMoney.Value>=10000 then local chr=getCharacter()if chr:FindFirstChild(
"Caesar's Headband")or chr:FindFirstChild('Clackers')or chr:FindFirstChild(
"Zeppeli's Hat")then getRemoteEvent():FireServer('PromptTriggered',
ReplicatedStorage.NewDialogue['Lisa Lisa'])repeat task.wait()pcall(function()
PlayerGui.DialogueGui.Frame.ClickContinue.MouseButton1Click:Fire()task.wait()
PlayerGui.DialogueGui.Frame.Options.Option1.TextButton.MouseButton1Click:Fire()
end)until PlayerSpec.Value~='None'notify('Dialogues','Hamon style purchased!',
'success')else notify('Dialogues',
"Equip Caesar's Headband, Clackers, or Zeppeli's Hat first!",'warn')end else
notify('Dialogues','Need $10,000!','warn')end end},{
"Boxing (Quinton's Glove + $10,000)",function()if hasItem("Quinton's Glove")and
PlayerMoney.Value>=10000 then fireDialogue('Quinton','Dialogue5','Option1')
notify('Dialogues','Boxing purchased!','success')else notify('Dialogues',
"Need Quinton's Glove and $10,000!",'warn')end end},{
'Boxing Gloves ($1,000, requires Boxing Style)',function()if PlayerMoney.Value>=
1000 then fireDialogue('Boxing Gloves','Dialogue1','Option1')notify('Dialogues',
'Boxing Gloves purchased!','success')else notify('Dialogues','Need $1,000!',
'warn')end end},{'Sword Style (Ancient Scroll + $10,000)',function()if hasItem(
'Ancient Scroll')and PlayerMoney.Value>=10000 then fireDialogue('Uzurashi',
'Dialogue5','Option1')notify('Dialogues','Sword Style purchased!','success')else
notify('Dialogues','Need an Ancient Scroll and $10,000!','warn')end end},{
'Pluck (requires Sword Style)',function()if PlayerSpec.Value=='SwordStyle'then
fireDialogue('Pluck','Dialogue1','Option1')notify('Dialogues','Pluck purchased!'
,'success')else notify('Dialogues','Need the Sword fighting style first!','warn'
)end end},{'Spin (Steel Ball + $10,000)',function()if hasItem('Steel Ball')and
PlayerMoney.Value>=10000 then fireDialogue('Gyro','Dialogue2','Option1')notify(
'Dialogues','Spin purchased!','success')else notify('Dialogues',
'Need a Steel Ball and $10,000!','warn')end end},{
'Vampire (Stone Mask + $10,000)',function()if hasItem('Stone Mask')and
PlayerMoney.Value>=10000 then fireDialogue('Elder Vampire Roomy','Dialogue5',
'Option1')notify('Dialogues','Vampire purchased!','success')else notify(
'Dialogues','Need a Stone Mask and $10,000!','warn')end end}})UI.storyRow=UI.
story:CreateGroup({direction='row'})UI.storyRow:CreateButton({name='Jesus',
callback=function()pcall(function()getRemoteEvent():FireServer('PromptTriggered'
,ReplicatedStorage.NewDialogue.Jesus)end)notify('Dialogues',
'Jesus dialogue triggered.','info')end})UI.storyRow:CreateButton({name=
'Skip Jotaro',callback=function()pcall(function()local d=ReplicatedStorage.
NewDialogue:FindFirstChild('Jotaro.')or ReplicatedStorage.NewDialogue:
FindFirstChild('Jotaro')or ReplicatedStorage.NewDialogue:FindFirstChild(
'Jotaro Kujo')if d then getRemoteEvent():FireServer('PromptTriggered',d)end end)
task.spawn(function()for i=1,40 do pcall(function()if type(firesignal)==
'function'then firesignal(PlayerGui.DialogueGui.Frame.ClickContinue.
MouseButton1Click)firesignal(PlayerGui.DialogueGui.Frame.Options.Option1.
TextButton.MouseButton1Click)else PlayerGui.DialogueGui.Frame.ClickContinue.
MouseButton1Click:Fire()PlayerGui.DialogueGui.Frame.Options.Option1.TextButton.
MouseButton1Click:Fire()end end)task.wait(0.1)end print(
'jotaro saints corpse parts skipped')end)notify('Dialogues',
'Skipping Jotaro Dialogue...','info')end})UI.storyRow:CreateButton({name=
'Halloween',callback=function()pcall(function()getRemoteEvent():FireServer(
'PromptTriggered',ReplicatedStorage.NewDialogue:FindFirstChild('Halloween Event'
))end)notify('Dialogues','Halloween Event opened.','info')end})UI.picker(UI.shop
,'Item','NPC_ShopItem',{{'1x Rokakaka ($2,500)',function()if PlayerMoney.Value>=
2500 then getRemoteEvent():FireServer('PurchaseShopItem',{ItemName='1x Rokakaka'
})notify('Dialogues','Rokakaka purchased!','success')else notify('Dialogues',
'Need $2,500!','warn')end end},{'Mysterious Bow',function()fireDialogue(
'Mysterious Bow Seller','Dialogue4','Option1')notify('Dialogues',
'Mysterious Bow purchased!','success')end},{'1x Pure Rokakaka ($4,000)',function
()if PlayerMoney.Value>=4000 then getRemoteEvent():FireServer('PurchaseShopItem'
,{ItemName='1x Pure Rokakaka'})notify('Dialogues','Pure Rokakaka purchased!',
'success')else notify('Dialogues','Need $4,000!','warn')end end},{
'1x Mysterious Arrow ($750)',function()if PlayerMoney.Value>=750 then
getRemoteEvent():FireServer('PurchaseShopItem',{ItemName='1x Mysterious Arrow'})
notify('Dialogues','Mysterious Arrow purchased!','success')else notify(
'Dialogues','Need $750!','warn')end end},{'1x Lucky Arrow ($75,000)',function()
if PlayerMoney.Value>=75000 then getRemoteEvent():FireServer('PurchaseShopItem',
{ItemName='1x Lucky Arrow'})notify('Dialogues','Lucky Arrow purchased!',
'success')else notify('Dialogues','Need $75,000!','warn')end end},{
"1x DIO's Diary ($20,000)",function()if PlayerMoney.Value>=20000 then
getRemoteEvent():FireServer('PurchaseShopItem',{ItemName="1x DIO's Diary"})
notify('Dialogues',"DIO's Diary purchased!",'success')else notify('Dialogues',
'Need $20,000!','warn')end end},{'1x Rib Cage ($3,500)',function()if PlayerMoney
.Value>=3500 then purchaseRibCage()notify('Dialogues','Rib Cage purchased!',
'success')else notify('Dialogues','Need $3,500!','warn')end end},{
'1x Left Arm ($15,000)',function()if PlayerMoney.Value>=15000 then local Event=
game:GetService('Players').LocalPlayer.Character.RemoteEvent Event:FireServer(
'PurchaseShopItem',{ItemName="1x Left Arm of the Saint's Corpse"})notify(
'Dialogues','Left Arm purchased!','success')else notify('Dialogues',
'Need $15,000!','warn')end end},{'1x Pelvis ($45,000)',function()if PlayerMoney.
Value>=45000 then getRemoteEvent():FireServer('PurchaseShopItem',{ItemName=
"1x Pelvis of The Saint's Corpse"})notify('Dialogues','Pelvis purchased!',
'success')else notify('Dialogues','Need $45,000!','warn')end end},{
'1x Heart ($45,000)',function()if PlayerMoney.Value>=45000 then getRemoteEvent()
:FireServer('PurchaseShopItem',{ItemName="1x Heart of The Saint's Corpse"})
notify('Dialogues','Heart purchased!','success')else notify('Dialogues',
'Need $45,000!','warn')end end},{'Pizza ($50)',function()if PlayerMoney.Value>=
50 then fireDialogue('Pizza','Dialogue2','Option1')notify('Dialogues',
'Pizza purchased!','success')else notify('Dialogues','Need $50!','warn')end end}
,{'Tea ($50)',function()if PlayerMoney.Value>=50 then fireDialogue('Cafe',
'Dialogue2','Option1')notify('Dialogues','Tea purchased!','success')else notify(
'Dialogues','Need $50!','warn')end end}})UI.standRow=UI.stand:CreateGroup({
direction='row'})UI.standRow:CreateButton({name='Desummon',callback=function()
desummonStand()notify('','Stand desummoned.','stop')end})UI.standRow:
CreateButton({name='Summon',callback=function()summonStand()notify('',
'Stand summoned.','start')end})UI.fun:CreateButton({name='Jerk Off',callback=
function()Window:Notify({title='you dirty perv.. -scril',content=
'Check ya inventory !',duration=5})local _LocalPlayer=game.Players.LocalPlayer
local function giveTool()local _Tool=Instance.new('Tool')_Tool.Name=
'Jerk Off R15'_Tool.RequiresHandle=false _Tool.Parent=_LocalPlayer.Backpack
local u4=nil _Tool.Equipped:Connect(function()local _Humanoid=(_LocalPlayer.
Character or _LocalPlayer.CharacterAdded:Wait()):FindFirstChildOfClass(
'Humanoid')if _Humanoid then local _Animation=Instance.new('Animation')
_Animation.AnimationId='rbxassetid://698251653'u4=_Humanoid:LoadAnimation(
_Animation)u4.Looped=false u4:Play()u4.TimePosition=0.58 u4:AdjustSpeed(0.4)task
.spawn(function()while u4 and u4.IsPlaying do if u4.TimePosition>=0.63 then u4.
TimePosition=0.58 end task.wait()end end)end end)_Tool.Unequipped:Connect(
function()if u4 then u4:Stop()u4=nil end end)end giveTool()_LocalPlayer.
CharacterAdded:Connect(function()task.wait(0.5)giveTool()end)end})end end
function __DARKLUA_BUNDLE_MODULES.aN():typeof(__modImpl())local v=
__DARKLUA_BUNDLE_MODULES.cache.aN if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.aN=v end return v.c end end do local function
__modImpl()return function(env)local VS=env.VS local PlayerMoney=env.PlayerMoney
local sendWebhook=env.sendWebhook local getCharacter=env.getCharacter local
getRemoteEvent=env.getRemoteEvent local notify=env.notify local startAntiTS=env.
startAntiTS local startAntiCW=env.startAntiCW local UI=env.UI UI.anti:
CreateButton({name='Anti Vamp Burn',callback=function()spawn(function()repeat
wait()until game:IsLoaded()local plr=game:GetService('Players').LocalPlayer
while wait()do pcall(function()if plr then game:GetService('Players').
LocalPlayer.PlayerStats.Race.Value='Human'end end)end end)notify('Combat',
'Anti Vamp Burn enabled.','start')end});(function()getgenv().
_pulseAutoGambleState=getgenv()._pulseAutoGambleState or{enabled=false,loopToken
=0}local function runAutoGambleWorker(token)task.spawn(function()while getgenv()
._pulseAutoGambleState.enabled and getgenv()._pulseAutoGambleState.loopToken==
token do task.wait(0.5)if not getgenv()._pulseAutoGambleState.enabled or
getgenv()._pulseAutoGambleState.loopToken~=token then break end pcall(function()
local char=getCharacter()local player=game.Players.LocalPlayer local goldItem=
player.Backpack:FindFirstChild('Gold Coin')or(char and char:FindFirstChild(
'Gold Coin'))if goldItem then if goldItem.Parent==player.Backpack then goldItem.
Parent=char end if PlayerMoney.Value>=750 then local remote=getRemoteEvent()if
remote then remote:FireServer('DialogueInteracted',{DialogueName='Item Machine',
Speaker='Item Machine'})remote:FireServer('EndDialogue',{NPC='Item Machine',
Option='Option1',Dialogue='Dialogue1'})end task.wait(3)end end end)end end)end
UI.session:CreateToggle({name='Auto Gamble',value=false,flag='MISC_AutoGamble',
callback=function(value)getgenv()._pulseAutoGambleState.enabled=value getgenv().
_pulseAutoGambleState.loopToken+=1 if value then runAutoGambleWorker(getgenv().
_pulseAutoGambleState.loopToken)end notify('Misc',value and
'Auto Gamble enabled.'or'Auto Gamble disabled.',nil,value and'start'or'stop')end
})end)();(function()getgenv()._pulseLowGfxState=getgenv()._pulseLowGfxState or{
saved=nil}local state=getgenv()._pulseLowGfxState local function getUGS()return
UserSettings():GetService('UserGameSettings')end local function enableLowGfx()
pcall(function()local ugs=getUGS()if state.saved==nil then state.saved=ugs.
SavedQualityLevel end ugs.SavedQualityLevel=Enum.SavedQualitySetting.
QualityLevel1 end)pcall(function()settings().Rendering.QualityLevel=Enum.
QualityLevel.Level01 end)end local function disableLowGfx()pcall(function()if
state.saved~=nil then getUGS().SavedQualityLevel=state.saved state.saved=nil end
end)pcall(function()settings().Rendering.QualityLevel=Enum.QualityLevel.
Automatic end)end UI.world:CreateToggle({name='Low Graphics',value=false,flag=
'MISC_LowGraphics',callback=function(value)if value then enableLowGfx()notify(
'Utilities','Graphics set to lowest.',5,'start')else disableLowGfx()notify(
'Utilities','Graphics restored.',5,'stop')end end})end)();(function()local
Lighting=game:GetService('Lighting')local weatherOriginal={}local function
saveWeatherOriginals()if next(weatherOriginal)then return end weatherOriginal={
Brightness=Lighting.Brightness,Ambient=Lighting.Ambient,OutdoorAmbient=Lighting.
OutdoorAmbient,FogEnd=Lighting.FogEnd,FogColor=Lighting.FogColor,ClockTime=
Lighting.ClockTime,ShadowSoftness=Lighting.ShadowSoftness}local atmo=Lighting:
FindFirstChildWhichIsA('Atmosphere')if atmo then weatherOriginal.atmo={Density=
atmo.Density,Offset=atmo.Offset,Color=atmo.Color,Decay=atmo.Decay,Glare=atmo.
Glare,Haze=atmo.Haze}end end local function applyWeather(preset)
saveWeatherOriginals()local atmo=Lighting:FindFirstChildWhichIsA('Atmosphere')if
not atmo then atmo=Instance.new('Atmosphere')atmo.Parent=Lighting end if preset
=='Default'then Lighting.Brightness=weatherOriginal.Brightness Lighting.Ambient=
weatherOriginal.Ambient Lighting.OutdoorAmbient=weatherOriginal.OutdoorAmbient
Lighting.FogEnd=weatherOriginal.FogEnd Lighting.FogColor=weatherOriginal.
FogColor Lighting.ClockTime=weatherOriginal.ClockTime Lighting.ShadowSoftness=
weatherOriginal.ShadowSoftness if weatherOriginal.atmo then atmo.Density=
weatherOriginal.atmo.Density atmo.Offset=weatherOriginal.atmo.Offset atmo.Color=
weatherOriginal.atmo.Color atmo.Decay=weatherOriginal.atmo.Decay atmo.Glare=
weatherOriginal.atmo.Glare atmo.Haze=weatherOriginal.atmo.Haze end elseif preset
=='Sunny'then Lighting.Brightness=3 Lighting.Ambient=Color3.fromRGB(100,110,120)
Lighting.OutdoorAmbient=Color3.fromRGB(140,140,120)Lighting.FogEnd=100000
Lighting.ClockTime=14 Lighting.ShadowSoftness=0.3 atmo.Density=0.25 atmo.Offset=
0.2 atmo.Color=Color3.fromRGB(199,170,120)atmo.Decay=Color3.fromRGB(90,60,40)
atmo.Glare=0.35 atmo.Haze=0.6 elseif preset=='Night'then Lighting.Brightness=0
Lighting.Ambient=Color3.fromRGB(10,10,30)Lighting.OutdoorAmbient=Color3.fromRGB(
15,15,40)Lighting.FogEnd=800 Lighting.FogColor=Color3.fromRGB(5,5,20)Lighting.
ClockTime=0 Lighting.ShadowSoftness=1 atmo.Density=0.7 atmo.Offset=0.15 atmo.
Color=Color3.fromRGB(10,15,40)atmo.Decay=Color3.fromRGB(5,5,20)atmo.Glare=0 atmo
.Haze=1.5 elseif preset=='Storm'then Lighting.Brightness=0.3 Lighting.Ambient=
Color3.fromRGB(40,40,55)Lighting.OutdoorAmbient=Color3.fromRGB(50,50,65)Lighting
.FogEnd=400 Lighting.FogColor=Color3.fromRGB(60,65,75)Lighting.ClockTime=13
Lighting.ShadowSoftness=1 atmo.Density=0.85 atmo.Offset=0.05 atmo.Color=Color3.
fromRGB(80,85,100)atmo.Decay=Color3.fromRGB(40,40,55)atmo.Glare=0 atmo.Haze=2.5
elseif preset=='Heavy Fog'then Lighting.Brightness=0.8 Lighting.Ambient=Color3.
fromRGB(80,85,90)Lighting.OutdoorAmbient=Color3.fromRGB(90,90,95)Lighting.FogEnd
=120 Lighting.FogColor=Color3.fromRGB(180,185,190)Lighting.ClockTime=9 Lighting.
ShadowSoftness=1 atmo.Density=0.95 atmo.Offset=0 atmo.Color=Color3.fromRGB(170,
175,180)atmo.Decay=Color3.fromRGB(120,120,125)atmo.Glare=0 atmo.Haze=3.5 elseif
preset=='Blood Moon'then Lighting.Brightness=0.1 Lighting.Ambient=Color3.
fromRGB(40,5,5)Lighting.OutdoorAmbient=Color3.fromRGB(60,10,10)Lighting.FogEnd=
500 Lighting.FogColor=Color3.fromRGB(50,5,5)Lighting.ClockTime=0 Lighting.
ShadowSoftness=1 atmo.Density=0.6 atmo.Offset=0.1 atmo.Color=Color3.fromRGB(120,
10,10)atmo.Decay=Color3.fromRGB(60,5,5)atmo.Glare=0.1 atmo.Haze=2 elseif preset
=='Golden Hour'then Lighting.Brightness=2 Lighting.Ambient=Color3.fromRGB(120,80
,40)Lighting.OutdoorAmbient=Color3.fromRGB(150,100,50)Lighting.FogEnd=3000
Lighting.FogColor=Color3.fromRGB(220,140,80)Lighting.ClockTime=6.5 Lighting.
ShadowSoftness=0.6 atmo.Density=0.45 atmo.Offset=0.25 atmo.Color=Color3.fromRGB(
230,150,80)atmo.Decay=Color3.fromRGB(160,80,30)atmo.Glare=0.5 atmo.Haze=1.2 end
notify('Misc','Weather set to: '..preset,'info')end UI.world:CreateDropdown({
name='Weather',options={'Default','Sunny','Night','Storm','Heavy Fog',
'Blood Moon','Golden Hour'},value={'Default'},flag='MISC_WeatherPreset',callback
=function(v)local preset=type(v)=='table'and(v[1]or'Default')or(v or'Default')
pcall(applyWeather,preset)end})UI.world:CreateSlider({name='Time of Day',range={
0,24},increment=0.5,value=14,flag='MISC_TimeOfDay',callback=function(v)Lighting.
ClockTime=v end})UI.world:CreateButton({name='Reset Weather',callback=function()
pcall(applyWeather,'Default')end})end)()UI.anti:CreateToggle({name=
'Anti Timestop',value=false,flag='ANTI_Timestop',callback=function(v)VS.
antiTSEnabled=v if v then task.spawn(startAntiTS)notify('Anti-Stands',
'Anti Timestop ON.','on')else if VS.stopAntiTS then VS.stopAntiTS()VS.stopAntiTS
=nil end notify('Anti-Stands','Anti Timestop OFF.','off')end end})UI.anti:
CreateToggle({name='Anti Chariot Requiem',value=false,flag='ANTI_ChariotRequiem'
,callback=function(v)VS.antiCWEnabled=v if v then startAntiCW()notify(
'Anti-Stands','Anti CW ON.','on')else notify('Anti-Stands','Anti CW OFF.','off')
end end})UI.webhook:CreateToggle({name='Enable',value=false,flag=
'SET_WebhookEnabled',callback=function(v)VS.webhookEnabled=v notify('Settings',
'Webhook '..(v and'enabled.'or'disabled.'),nil,v and'start'or'stop')end})UI.
webhook:CreateInput({name='Webhook URL',placeholder=
'https://discord.com/api/webhooks/...',flag='SET_WebhookURL',callback=function(v
)VS.webhookLink=v end})UI.webhook:CreateInput({name='Ping User ID',placeholder=
'Discord User ID',flag='SET_WebhookPingUserId',callback=function(v)VS.
webhookPing=v end})UI.webhook:CreateButton({name='Test Webhook',callback=
function()if VS.webhookLink==''then notify('Webhook','Set a webhook URL first!',
'warn')return end sendWebhook('Webhook test from Pulse: it works!',false)notify(
'Webhook','Test sent!','success')end})end end function __DARKLUA_BUNDLE_MODULES.
aO():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.aO if not v then
v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.aO=v end return v.c end end do
local function __modImpl()return function(env)local VS=env.VS local UI=env.UI UI
.retries:CreateSlider({name='Pity Rolls',range={100,1000},increment=10,value=680
,flag='SET_PityRollRetryCap',callback=function(v)VS.pityRollLimit=v end})UI.
retries:CreateSlider({name='Stock Buffer',range={1,10},increment=1,value=3,flag=
'SET_PityBuyBuffer',callback=function(v)getgenv()._pulsePityAutoBuy.buffer=v end
})end end function __DARKLUA_BUNDLE_MODULES.aP():typeof(__modImpl())local v=
__DARKLUA_BUNDLE_MODULES.cache.aP if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.aP=v end return v.c end end do local function
__modImpl()return function(env)local Window=env.Window local VS=env.VS local
Players=env.Players local ReplicatedStorage=env.ReplicatedStorage local
pulseIsMobile=env.pulseIsMobile local farmEnsureNoclip=env.farmEnsureNoclip
local farmThrottledHeartbeat=env.farmThrottledHeartbeat local farmStepWait=env.
farmStepWait local PlayerGui=env.PlayerGui local PlayerStand=env.PlayerStand
local getRemoteEvent=env.getRemoteEvent local finishDialogue=env.finishDialogue
local getStandMorph=env.getStandMorph local notify=env.notify local teleportUp=
env.teleportUp local NO_KEEPALIVE={['Beach Boy']=true,['Hermit Purple']=true,[
'Mr. President']=true,['Sex Pistols']=true,['Anubis']=true,['None']=true}local
FarmConfig={KillLoopDelay=0,QuestCheckDelay=1,FarmingMethod='Auto (Detect)',
Distance=-28}local function isHandheldMethod()local m=FarmConfig.FarmingMethod
if type(m)=='table'then m=m[1]end if m=='Handheld/Fist'then return true end if m
=='Auto'or m=='Auto (Detect)'then return NO_KEEPALIVE[PlayerStand.Value]==true
end return false end local FarmState={Active=false,CurrentQuest=nil,
CompletedQuest=false,OriginalCFrame=nil}getgenv().__pulsePlayerFarmActive=
getgenv().__pulsePlayerFarmActive or false VS.noQuestKillEnabled=false VS.
_nqActiveMoneyConn=nil local FarmUtil={}function FarmUtil.GetCharacter()return
Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()end
function FarmUtil.GetHRP()local char=FarmUtil.GetCharacter()return char and char
:FindFirstChild('HumanoidRootPart')end function FarmUtil.HasStand()return
Players.LocalPlayer.PlayerStats.Stand.Value~='None'end local lastStandFail=0
function FarmUtil.EquipStand()local char=FarmUtil.GetCharacter()if
isHandheldMethod()then if NO_KEEPALIVE[PlayerStand.Value]and PlayerStand.Value~=
'None'then if char and char:FindFirstChildWhichIsA('Tool')then return true end
if char and char:FindFirstChild('RemoteFunction')then char.RemoteFunction:
InvokeServer('ToggleStand','Toggle')task.wait(0.25)if char:
FindFirstChildWhichIsA('Tool')then return true end end end return true end local
ss=char and char:FindFirstChild('SummonedStand')if ss and ss.Value then return
true end if char and char:FindFirstChild('RemoteFunction')then char.
RemoteFunction:InvokeServer('ToggleStand','Toggle')task.wait(0.25)local checkSs=
char:FindFirstChild('SummonedStand')if checkSs and checkSs.Value then return
true end end if tick()-lastStandFail>5 then notify('NPC Farm',
"Stand can't be summoned; farming paused.",'error')lastStandFail=tick()if Window
:Get('Farm')then Window:Set('Farm',false)end if Window:Get('AutoBoss')then
Window:Set('AutoBoss',false)end if Window:Get('AutoTA4')then Window:Set(
'AutoTA4',false)end if Window:Get('AutoMIH')then Window:Set('AutoMIH',false)end
if Window:Get('AS_AutoWRFarm')then Window:Set('AS_AutoWRFarm',false)end if
Window:Get('HeavenAscensionDIO')then Window:Set('HeavenAscensionDIO',false)end
end return false end FarmUtil.CurrentEnemy=nil function FarmUtil.UseMove(move)
local char=FarmUtil.GetCharacter()if char and char:FindFirstChild('RemoteEvent')
then char.RemoteEvent:FireServer('Attack',move)end end local function
isQuestEnemy(instName,questEnemy)if instName==questEnemy then return true end if
questEnemy=='Heaven Ascension Dio'then local n=string.lower(instName)if n:find(
'heaven',1,true)and n:find('dio',1,true)then if n:find('ascension',1,true)or n:
find('ascended',1,true)then return true end end end return false end local
KILL_BUFFER=1 local function findAliveQuestEnemy(enemyName)local function
consider(inst)if not isQuestEnemy(inst.Name,enemyName)then return nil end local
h=inst:FindFirstChild('Health')local hrp=inst:FindFirstChild('HumanoidRootPart')
if h and hrp and h.Value>0 then return inst end return nil end local living=
workspace:FindFirstChild('Living')if living then for _,child in ipairs(living:
GetChildren())do local e=consider(child)if e then return e end end for _,child
in ipairs(living:GetDescendants())do if child~=living and child.Parent~=living
then local e=consider(child)if e then return e end end end end local mob2=
workspace:FindFirstChild('Mob_Spawns2')if mob2 then for _,child in ipairs(mob2:
GetDescendants())do local e=consider(child)if e then return e end end end return
nil end function FarmUtil.GetQuest(npc)task.spawn(finishDialogue,npc.Name)end
function FarmUtil.CountItem(itemName)local count=0 for _,v in pairs(Players.
LocalPlayer.Backpack:GetChildren())do if v.Name==itemName then count=count+1 end
end local char=FarmUtil.GetCharacter()if char then local tool=char:
FindFirstChildWhichIsA('Tool')if tool and tool.Name==itemName then count=count+1
end end return count end function FarmUtil.Kill(enemy)local enemyHRP=enemy:
FindFirstChild('HumanoidRootPart')local enemyHealth=enemy:FindFirstChild(
'Health')if not(enemyHRP and enemyHealth and enemyHealth.Value>0)then return end
local hrp=FarmUtil.GetHRP()if not hrp then return end FarmUtil.CurrentEnemy=
enemy local moneyConn=nil local progressConn=nil local okKill=pcall(function()
local handheld=isHandheldMethod()local lp=Players.LocalPlayer local
questProgressStart=lp.PlayerStats.QuestProgress.Value local
questProgressAdvanced=false local moneyDropSeenAt=nil progressConn=lp.
PlayerStats.QuestProgress:GetPropertyChangedSignal('Value'):Connect(function()if
lp.PlayerStats.QuestProgress.Value>questProgressStart then questProgressAdvanced
=true end end)if not handheld then FarmUtil.EquipStand()local standWaitTimeout=
tick()+4 repeat task.wait(0.05)until getStandMorph()or tick()>standWaitTimeout
task.wait(0.1)end local running=true local dropMoney=Players.LocalPlayer.
PlayerGui:WaitForChild('HUD'):WaitForChild('Main'):WaitForChild('DropMoney'):
WaitForChild('Money')moneyConn=dropMoney.ChildAdded:Connect(function(child)if
tonumber(string.match(child.Name,'%d+'))then moneyDropSeenAt=tick()end end)while
running and FarmState.Active and not FarmState.CompletedQuest do if enemy.Parent
==nil or not enemy:FindFirstChild('HumanoidRootPart')then running=false break
end local h=enemy:FindFirstChild('Health')if h and h.Value<=0 then running=false
break end if questProgressAdvanced then running=false break end local char=
Players.LocalPlayer.Character local hum=char and char:FindFirstChildWhichIsA(
'Humanoid')if hum and hum.Health>0 then if handheld or char:FindFirstChild(
'StandMorph')then FarmUtil.UseMove('m1')else task.wait(0.3)end else Players.
LocalPlayer.CharacterAdded:Wait()if not handheld then FarmUtil.EquipStand()end
task.wait(0.3)end local kd=FarmConfig.KillLoopDelay if type(kd)=='number'and kd>
0 then task.wait(math.min(kd,2))else task.wait()end end pcall(function()if
moneyConn then moneyConn:Disconnect()end end)local bufUntil=tick()+KILL_BUFFER
while FarmState.Active and not FarmState.CompletedQuest and tick()<bufUntil do
local char=Players.LocalPlayer.Character local hum=char and char:
FindFirstChildWhichIsA('Humanoid')if hum and hum.Health>0 then if handheld or(
char and char:FindFirstChild('StandMorph'))then FarmUtil.UseMove('m1')else task.
wait(0.3)end end local kd=FarmConfig.KillLoopDelay if type(kd)=='number'and kd>0
then task.wait(math.min(kd,2))else task.wait()end end if running and
moneyDropSeenAt then local confirmUntil=tick()+0.75 while FarmState.Active and
not FarmState.CompletedQuest and tick()<confirmUntil do local h=enemy:
FindFirstChild('Health')if enemy.Parent==nil or(h and h.Value<=0)or lp.
PlayerStats.QuestProgress.Value>questProgressStart then break end FarmUtil.
UseMove('m1')task.wait(0.05)end end local char=Players.LocalPlayer.Character if
char then local fc=char:FindFirstChild('FocusCam')if fc then fc:Destroy()end end
local safeHRP=FarmUtil.GetHRP()if safeHRP then safeHRP.AssemblyLinearVelocity=
Vector3.zero safeHRP.AssemblyAngularVelocity=Vector3.zero safeHRP.Anchored=true
end task.wait(0.12)pcall(teleportUp)task.wait(0.12)pcall(teleportUp)local h2=
FarmUtil.GetHRP()if h2 then h2.AssemblyLinearVelocity=Vector3.zero h2.
AssemblyAngularVelocity=Vector3.zero end end)FarmUtil.CurrentEnemy=nil pcall(
function()if moneyConn then moneyConn:Disconnect()end end)pcall(function()if
progressConn then progressConn:Disconnect()end end)if not okKill then warn(
'Pulse: NPC Farm kill cycle failed, cleared the target.')end end function
FarmUtil.Collect(item)local char=FarmUtil.GetCharacter()local hrp=FarmUtil.
GetHRP()if not(item and item.PrimaryPart and char and hrp)then return end local
oldCF=hrp.CFrame local startTime=tick()farmEnsureNoclip(char)hrp.CFrame=item.
PrimaryPart.CFrame-Vector3.new(0,10,0)task.wait(pulseIsMobile()and 0.4 or 0.3)
while FarmState.Active and item.Parent==workspace.Item_Spawns.Items and tick()-
startTime<3.5 do if not item.PrimaryPart then break end fireproximityprompt(item
:FindFirstChild('ProximityPrompt'))hrp.CFrame=item.PrimaryPart.CFrame-Vector3.
new(0,10,0)task.wait(farmStepWait())end task.wait(pulseIsMobile()and 0.7 or 0.6)
pcall(function()if hrp.Parent then hrp.CFrame=oldCF end end)end local QuestInfo=
{['Officer Sam [Lvl. 1+]']={Enemy='Thug'},['Deputy Bertrude [Lvl. 10+]']={Enemy=
'Corrupt Police'},['Homeless Man Jill [Lvl. 15+]']={Item='Gold Coin',Amount=10},
['Dracula [Lvl. 20+]']={Enemy='Zombie Henchman'},['William Zeppeli [Lvl. 25+]']=
{Enemy='Vampire'},['Doppio [Lvl. 30+]']={Enemy='Dio'},['Dio [Lvl. 35+]']={Enemy=
'Jotaro'},['Jotaro']={Enemy='Heaven Ascension Dio'}}local QuestNames={
'Officer Sam [Lvl. 1+]','Deputy Bertrude [Lvl. 10+]',
'Homeless Man Jill [Lvl. 15+]','Dracula [Lvl. 20+]','William Zeppeli [Lvl. 25+]'
,'Doppio [Lvl. 30+]','Dio [Lvl. 35+]','Jotaro','Auto (Best for Level)'}
local function GetBestQuest()local playerLevel=Players.LocalPlayer.PlayerStats.
Level.Value local bestQuest,highestReq=nil,0 for _,questName in pairs(QuestNames
)do if questName~='Auto (Best for Level)'then local levelReq=tonumber(questName:
match('%d+'))if levelReq and levelReq<=playerLevel and levelReq>=highestReq then
highestReq=levelReq bestQuest=questName end end end return bestQuest end
local function FarmLoop()local connection=Players.LocalPlayer.PlayerGui.HUD.
ChildAdded:Connect(function(child)if child.Name=='QuestCompleted'then FarmState.
CompletedQuest=true end end)task.spawn(function()while FarmState.Active do task.
wait(3)if not FarmState.Active then break end if isHandheldMethod()and not
NO_KEEPALIVE[PlayerStand.Value]then continue end local char=Players.LocalPlayer.
Character if char then local ss=char:FindFirstChild('SummonedStand')if not(ss
and ss.Value)then pcall(FarmUtil.EquipStand)end end end end)local masterConn=
farmThrottledHeartbeat(function()if not FarmState.Active then return end if VS.
noQuestKillEnabled or getgenv().__pulsePlayerFarmActive then return end local
char=Players.LocalPlayer.Character if not char then return end local hHRP=char:
FindFirstChild('HumanoidRootPart')if not hHRP then return end if
isHandheldMethod()then local enemy=FarmUtil.CurrentEnemy if enemy and enemy.
Parent then local eHRP=enemy:FindFirstChild('HumanoidRootPart')if eHRP then hHRP
.CFrame=eHRP.CFrame hHRP.AssemblyLinearVelocity=Vector3.zero end end return end
local sm=char:FindFirstChild('StandMorph')if not sm or not sm.PrimaryPart then
hHRP.AssemblyLinearVelocity=Vector3.zero hHRP.AssemblyAngularVelocity=Vector3.
zero return end local enemy=FarmUtil.CurrentEnemy if enemy and enemy.Parent then
local eHRP=enemy:FindFirstChild('HumanoidRootPart')if eHRP then sm.PrimaryPart.
CFrame=eHRP.CFrame+eHRP.CFrame.LookVector*-1.1 sm.PrimaryPart.
AssemblyLinearVelocity=Vector3.zero sm.PrimaryPart.AssemblyAngularVelocity=
Vector3.zero local hum=char:FindFirstChildWhichIsA('Humanoid')if hum and hum.
Health>0 then hHRP.CFrame=CFrame.new(sm.PrimaryPart.Position+Vector3.new(0,
FarmConfig.Distance,0))end if not char:FindFirstChild('FocusCam')then local fc=
Instance.new('ObjectValue',char)fc.Name='FocusCam'fc.Value=sm.PrimaryPart elseif
char.FocusCam.Value~=sm.PrimaryPart then char.FocusCam.Value=sm.PrimaryPart end
return end end sm.PrimaryPart.CFrame=hHRP.CFrame+Vector3.new(0,2,0)sm.
PrimaryPart.AssemblyLinearVelocity=Vector3.zero sm.PrimaryPart.
AssemblyAngularVelocity=Vector3.zero end,22,45)local setupFailed=false local
questTryStart=0 while FarmState.Active do local questName=FarmState.CurrentQuest
=='Auto (Best for Level)'and GetBestQuest()or FarmState.CurrentQuest if not
questName then warn('Pulse: No quest found for your level.')setupFailed=true
notify('NPC Farm','No quest matches your level. Turn the toggle OFF.',8,'error')
break end local questNPC=workspace.Dialogues:FindFirstChild(questName)if not
questNPC then warn('Pulse: Quest NPC not found:',questName)setupFailed=true
notify('NPC Farm','Quest NPC missing from map. Turn the toggle OFF.',8,'error')
break end local questData=QuestInfo[questName]if not questData then warn(
'Pulse: No quest data for:',questName)setupFailed=true notify('NPC Farm',
'Internal quest data missing. Turn the toggle OFF.',8,'error')break end if
FarmState.CompletedQuest then pcall(function()local hrp=FarmUtil.GetHRP()local
npcPart=questNPC:FindFirstChildWhichIsA('BasePart')or questNPC.PrimaryPart if
hrp and npcPart then hrp.Anchored=true hrp.AssemblyLinearVelocity=Vector3.zero
hrp.CFrame=npcPart.CFrame+Vector3.new(0,3,0)task.wait(0.3)hrp.Anchored=false end
end)FarmUtil.GetQuest(questNPC)FarmState.CompletedQuest=false if questTryStart==
0 then questTryStart=tick()end local lp=Players.LocalPlayer local timeout=(
questName=='Jotaro')and(tick()+10)or(tick()+3.5)while lp.PlayerStats.
QuestMaxProgress.Value<=0 and tick()<timeout and FarmState.Active do task.wait(
0.25)end if questName=='Jotaro'and lp.PlayerStats.QuestMaxProgress.Value<=0 then
pcall(function()local d=ReplicatedStorage.NewDialogue:FindFirstChild('Jotaro.')
if d then getRemoteEvent():FireServer('PromptTriggered',d)end end)task.spawn(
function()for i=1,40 do pcall(function()if type(firesignal)=='function'then
firesignal(PlayerGui.DialogueGui.Frame.ClickContinue.MouseButton1Click)
firesignal(PlayerGui.DialogueGui.Frame.Options.Option1.TextButton.
MouseButton1Click)else PlayerGui.DialogueGui.Frame.ClickContinue.
MouseButton1Click:Fire()PlayerGui.DialogueGui.Frame.Options.Option1.TextButton.
MouseButton1Click:Fire()end end)task.wait(0.1)end print(
'jotaro saints corpse parts skipped')end)task.wait(4.5)FarmUtil.GetQuest(
questNPC)local retryTimeout=tick()+3.5 while lp.PlayerStats.QuestMaxProgress.
Value<=0 and tick()<retryTimeout and FarmState.Active do task.wait(0.25)end end
if lp.PlayerStats.QuestMaxProgress.Value>0 then questTryStart=0 elseif
questTryStart>0 and(tick()-questTryStart)>=12 then notify('NPC Farm',
[[Check your qualifications for this quest , and/or your farming method.]],6,
'warn')questTryStart=tick()end end if questData.Enemy then local lp=Players.
LocalPlayer while lp.PlayerStats.QuestProgress.Value<lp.PlayerStats.
QuestMaxProgress.Value and FarmState.Active do local enemy=findAliveQuestEnemy(
questData.Enemy)if enemy then pcall(function()FarmUtil.Kill(enemy)end)task.wait(
0.25)else task.wait(0.15)end end FarmState.CompletedQuest=true elseif questData.
Item then while FarmUtil.CountItem(questData.Item)<questData.Amount and
FarmState.Active do for _,item in pairs(workspace.Item_Spawns.Items:GetChildren(
))do if item.Name==questData.Item then FarmUtil.Collect(item)break end end task.
wait(0.5)end if FarmUtil.CountItem(questData.Item)>=questData.Amount then
FarmUtil.GetQuest(questNPC)task.wait(1)end FarmState.CompletedQuest=true end
task.wait(FarmConfig.QuestCheckDelay)end FarmUtil.CurrentEnemy=nil pcall(
function()masterConn:Disconnect()end)pcall(function()connection:Disconnect()end)
if setupFailed then FarmState.Active=false FarmState.CurrentQuest=nil FarmState.
CompletedQuest=false if FarmState.OriginalCFrame then local h=FarmUtil.GetHRP()
if h then pcall(function()h.CFrame=FarmState.OriginalCFrame end)end FarmState.
OriginalCFrame=nil end end end VS.selectedQuest='Auto (Best for Level)'env.
NO_KEEPALIVE=NO_KEEPALIVE env.FarmConfig=FarmConfig env.isHandheldMethod=
isHandheldMethod env.FarmState=FarmState env.FarmUtil=FarmUtil env.isQuestEnemy=
isQuestEnemy env.KILL_BUFFER=KILL_BUFFER env.QuestNames=QuestNames env.FarmLoop=
FarmLoop end end function __DARKLUA_BUNDLE_MODULES.aQ():typeof(__modImpl())local
v=__DARKLUA_BUNDLE_MODULES.cache.aQ if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.aQ=v end return v.c end end do local function
__modImpl()return function(env)local VS=env.VS local Players=env.Players local
TeleportService=env.TeleportService local HttpService=env.HttpService local
farmThrottledHeartbeat=env.farmThrottledHeartbeat local LocalPlayer=env.
LocalPlayer local PlayerGui=env.PlayerGui local PlayerStand=env.PlayerStand
local getCharacter=env.getCharacter local unequipAllTools=env.unequipAllTools
local notify=env.notify local UI=env.UI local FarmConfig=env.FarmConfig local
FarmState=env.FarmState local FarmUtil=env.FarmUtil do local autoStwEnabled=
false local autoStwBusy=false local autoStwStatus='Waiting'local
autoStwLastProgress=0 local stwLastTick=tick()getgenv().__pulseAutoStwActive=
false local HAMON_SPECS={['Hamon (Jonathan Joestar)']=true,[
'Hamon (Joseph Joestar)']=true}local JOESTAR_STANDS={['Hermit Purple']=true,[
'Star Platinum']=true,['Gold Experience']=true,['Gold Experience Requiem']=true,
['Stone Free']=true,['Star Platinum The World']=true,['Star Platinum: The World'
]=true,['Tusk ACT 1']=true,['Tusk ACT 2']=true,['Tusk ACT 3']=true,['Tusk ACT 4'
]=true}local function isJoestarStandName(raw)if not raw or raw==''or raw=='None'
then return false end return JOESTAR_STANDS[tostring(raw)]==true end local
PHASE_HAMON='hamon'local PHASE_JOESTAR='joestar'local autoStwPhase=PHASE_HAMON
local PHASE_GOAL={[PHASE_HAMON]=20,[PHASE_JOESTAR]=15}local stwKilled={}local
autoStwTracker=UI.autoSTW:CreateText({name='Progress',text=
'[--------------------] 0/20 | Waiting'})local function getQuestProgress()local
stats=LocalPlayer:FindFirstChild('PlayerStats')if not stats then return 0,20 end
local q=stats:FindFirstChild('QuestProgress')local m=stats:FindFirstChild(
'QuestMaxProgress')return(q and q.Value or 0),(m and m.Value or 20)end
local function hasValidHamonSpec(playerObj)local stats=playerObj and playerObj:
FindFirstChild('PlayerStats')local spec=stats and stats:FindFirstChild('Spec')
return spec and HAMON_SPECS[spec.Value]or false end local function
stwQuestActive()local progress,max=getQuestProgress()if max==20 and progress>=0
and progress<20 then return true end local ok,found=pcall(function()local hud=
PlayerGui:FindFirstChild('HUD')local main=hud and hud:FindFirstChild('Main')if
not main then return false end for _,d in ipairs(main:GetDescendants())do if d:
IsA('TextLabel')or d:IsA('TextButton')then local t=d.Text or''if t:find(
'Jonathan')and t:find('Joseph')and t:find('Hamon')then return true end end end
return false end)return ok and found or false end local function
detectActiveQuest()local progress,max=getQuestProgress()if max==20 then return
'hamon'elseif max==15 then return'joestar'end local detected='none'pcall(
function()local hud=PlayerGui:FindFirstChild('HUD')local main=hud and hud:
FindFirstChild('Main')if not main then return end for _,d in ipairs(main:
GetDescendants())do if d:IsA('TextLabel')or d:IsA('TextButton')then local t=(d.
Text or''):lower()if t==''then elseif t:find('finally done')or t:find(
'stand virus capsule')then detected='complete'return elseif t:find('joestar')and
t:find('bloodline')then detected='joestar'return elseif(t:find('jonathan')and t:
find('joseph')and t:find('hamon'))or(t:find('hamon user')and t:find('kill'))then
detected='hamon'return end end end end)return detected end local function
updateAutoStwTracker(extra)local progress,max=getQuestProgress()local
phaseTarget=PHASE_GOAL[autoStwPhase]or 20 local shownMax=(max and max>0)and max
or phaseTarget if shownMax<phaseTarget then shownMax=phaseTarget end local fill=
math.clamp(math.floor((progress/shownMax)*20+0.5),0,20)local bar=string.rep('#',
fill)..string.rep('-',20-fill)local phaseTag=(autoStwPhase==PHASE_JOESTAR)and
'Joestar'or'Hamon'local suffix=extra and(' | '..extra)or''local text='['..bar..
'] '..tostring(progress)..'/'..tostring(shownMax)..' ('..phaseTag..')'..suffix
pcall(function()autoStwTracker:Set(text)end)end task.spawn(function()while true
do task.wait(0.35)updateAutoStwTracker(autoStwStatus)end end)local function
equipDioHeadband()local char=getCharacter()if not char then return false,
'Character not ready.'end local tool=char:FindFirstChild("DIO's Headband")or
char:FindFirstChild('DIO\u{2019}s Headband')or VS.Backpack:FindFirstChild(
"DIO's Headband")or VS.Backpack:FindFirstChild('DIO\u{2019}s Headband')if not
tool then return false,"DIO's Headband not found in Backpack/Character."end if
tool.Parent~=char then pcall(unequipAllTools)task.wait(0.06)tool.Parent=char
task.wait(0.06)end return true end local function acceptEnyaQuest()local
dialogues=workspace:FindFirstChild('Dialogues')local npc=dialogues and(dialogues
:FindFirstChild('Enya The Hag')or dialogues:FindFirstChild('Enya')or dialogues:
FindFirstChild('Enya the Hag'))if not npc then return false,
'Enya NPC not found.'end pcall(function()local hrp=FarmUtil.GetHRP()local
npcPart=npc:FindFirstChildWhichIsA('BasePart')or npc.PrimaryPart if hrp and
npcPart then hrp.Anchored=true hrp.AssemblyLinearVelocity=Vector3.zero hrp.
CFrame=npcPart.CFrame+Vector3.new(0,3,0)task.wait(0.25)hrp.Anchored=false end
end)FarmUtil.GetQuest(npc)return true end local function stashHeadband()local
char=getCharacter()if not char then return end local tool=char:FindFirstChild(
"DIO's Headband")or char:FindFirstChild('DIO\u{2019}s Headband')if tool then
tool.Parent=VS.Backpack end end local function killedHere(p)return p and
stwKilled[p.Name]==true end local function findHamonTarget()for _,p in ipairs(
Players:GetPlayers())do if p~=LocalPlayer and not killedHere(p)then if
hasValidHamonSpec(p)then local char=p.Character local hum=char and char:
FindFirstChildWhichIsA('Humanoid')local hrp=char and char:FindFirstChild(
'HumanoidRootPart')if hum and hum.Health>0 and hrp then return p end end end end
return nil end local function hasJoestarStand(playerObj)local stats=playerObj
and playerObj:FindFirstChild('PlayerStats')local stand=stats and stats:
FindFirstChild('Stand')if not stand then return false end return
isJoestarStandName(stand.Value)end local function findJoestar()for _,p in
ipairs(Players:GetPlayers())do if p~=LocalPlayer and not killedHere(p)then if
hasJoestarStand(p)then local char=p.Character local hum=char and char:
FindFirstChildWhichIsA('Humanoid')local hrp=char and char:FindFirstChild(
'HumanoidRootPart')if hum and hum.Health>0 and hrp then return p end end end end
return nil end local function randomServer()local candidates={}local cursor=nil
local baseUrl='https://games.roblox.com/v1/games/'..game.PlaceId..
'/servers/Public?sortOrder=Desc&limit=100'local scanned=0 local pages=0 repeat
local resp=request({Url=baseUrl..(cursor and('&cursor='..cursor)or''),Method=
'GET'})if not resp or not resp.Body then break end if resp.Body:find(
'Too many requests')then task.wait(0.4)else local decoded=HttpService:
JSONDecode(resp.Body)if decoded and decoded.data then for _,srv in ipairs(
decoded.data)do scanned+=1 if srv.id and srv.id~=game.JobId and srv.playing and
srv.maxPlayers and srv.playing<srv.maxPlayers then candidates[#candidates+1]=srv
.id end end end cursor=decoded and decoded.nextPageCursor or nil pages+=1 end
task.wait(0.05)until(#candidates>=30)or(not cursor)or(scanned>=400)or(pages>=5)
if#candidates==0 then return nil end return candidates[math.random(1,#candidates
)]end local function hopServer(reason)notify('Auto STW',(reason or
'Server hopping...')..'. Finding a new server.',6,'warn')task.wait(0.15)local ok
=pcall(function()local pickedServerId=randomServer()if pickedServerId and
pickedServerId~=game.JobId then TeleportService:TeleportToPlaceInstance(game.
PlaceId,pickedServerId,LocalPlayer)elseif getgenv().__pulseSmartHop then
getgenv().__pulseSmartHop(reason or'Auto STW hop')else TeleportService:Teleport(
game.PlaceId,LocalPlayer)end end)if not ok then notify('Auto STW',
'Server hop failed, retrying with hop engine...',5,'warn')if getgenv().
__pulseSmartHop then task.spawn(getgenv().__pulseSmartHop,reason or
'Auto STW hop')else pcall(function()TeleportService:Teleport(game.PlaceId,
LocalPlayer)end)end end end local function hopIfNoHamonUsers()local target=
findHamonTarget()if target then notify('Auto STW','Hamon user found: '..target.
Name..'. No hop needed.',5,'info')return end autoStwStatus=
'No Hamon users, hopping'updateAutoStwTracker(autoStwStatus)hopServer(
'No Jonathan/Joseph Hamon users found')end local function killStwTarget(
targetPlayer)local targetChar=targetPlayer and targetPlayer.Character local
targetHum=targetChar and targetChar:FindFirstChildWhichIsA('Humanoid')local
targetHRP=targetChar and targetChar:FindFirstChild('HumanoidRootPart')if not(
targetHum and targetHum.Health>0 and targetHRP)then return end FarmUtil.
EquipStand()task.wait(0.25)local running=true local diedConn=targetHum.Died:
Connect(function()running=false end)local leaveConn=Players.PlayerRemoving:
Connect(function(p)if p==targetPlayer then running=false end end)local hb hb=
farmThrottledHeartbeat(function()if not autoStwEnabled or not running then
return end local char=getCharacter()local hHRP=char and char:FindFirstChild(
'HumanoidRootPart')local hum=char and char:FindFirstChildWhichIsA('Humanoid')
local curHRP=targetPlayer.Character and targetPlayer.Character:FindFirstChild(
'HumanoidRootPart')if not(hHRP and hum and hum.Health>0 and curHRP)then return
end local standMorph=char:FindFirstChild('StandMorph')if standMorph and
standMorph.PrimaryPart then standMorph.PrimaryPart.CFrame=curHRP.CFrame+curHRP.
CFrame.LookVector*-1.1 hHRP.CFrame=CFrame.new(standMorph.PrimaryPart.Position+
Vector3.new(0,FarmConfig.Distance,0))if not char:FindFirstChild('FocusCam')then
local fc=Instance.new('ObjectValue',char)fc.Name='FocusCam'fc.Value=standMorph.
PrimaryPart elseif char.FocusCam.Value~=standMorph.PrimaryPart then char.
FocusCam.Value=standMorph.PrimaryPart end else hHRP.CFrame=CFrame.new(curHRP.
Position+Vector3.new(0,FarmConfig.Distance,0))end hHRP.AssemblyLinearVelocity=
Vector3.zero hHRP.AssemblyAngularVelocity=Vector3.zero end,22,45)while running
and autoStwEnabled do local progress=getQuestProgress()local phaseTarget=
PHASE_GOAL[autoStwPhase]or 20 if progress>=phaseTarget then break end local
stillValid if autoStwPhase==PHASE_JOESTAR then stillValid=hasJoestarStand(
targetPlayer)else stillValid=hasValidHamonSpec(targetPlayer)end if not
stillValid then break end local myChar=getCharacter()local myHum=myChar and
myChar:FindFirstChildWhichIsA('Humanoid')local curHum=targetPlayer.Character and
targetPlayer.Character:FindFirstChildWhichIsA('Humanoid')if not curHum or curHum
.Health<=0 then break end if myHum and myHum.Health>0 then if myChar:
FindFirstChild('StandMorph')then FarmUtil.UseMove('m1')else task.wait(0.25)end
else LocalPlayer.CharacterAdded:Wait()FarmUtil.EquipStand()task.wait(0.25)end
task.wait()end pcall(function()diedConn:Disconnect()end)pcall(function()
leaveConn:Disconnect()end)pcall(function()hb:Disconnect()end)local char=
getCharacter()local fc=char and char:FindFirstChild('FocusCam')if fc then pcall(
function()fc:Destroy()end)end end UI.autoSTW:CreateToggle({name='Enable',value=
false,flag='LF_AutoSTW',callback=function(value)if autoStwBusy then return end
autoStwEnabled=value getgenv().__pulseAutoStwActive=value if not autoStwEnabled
then autoStwStatus='Stopped'updateAutoStwTracker(autoStwStatus)notify('Auto STW'
,'Stopped.','stop')return end if FarmState.Active then autoStwEnabled=false
getgenv().__pulseAutoStwActive=false notify('Auto STW',
'Turn off NPC Farm (quest) first.',7,'warn')return end if VS.noQuestKillEnabled
then autoStwEnabled=false getgenv().__pulseAutoStwActive=false notify('Auto STW'
,'Turn off NPC Killer (No Quest) first.',7,'warn')return end if getgenv().
__pulsePlayerFarmActive then autoStwEnabled=false getgenv().__pulseAutoStwActive
=false notify('Auto STW','Turn off Player Farm first.',7,'warn')return end if
PlayerStand.Value~='The World'then autoStwEnabled=false getgenv().
__pulseAutoStwActive=false notify('Auto STW',
'You need The World equipped to start Auto STW.',7,'warn')return end local
hasHeadband=false do local char=LocalPlayer.Character local function
findHeadband(p)if not p then return nil end return p:FindFirstChild(
"DIO's Headband")or p:FindFirstChild('DIO\u{2019}s Headband')end if
findHeadband(char)or findHeadband(VS.Backpack)then hasHeadband=true end end if
not hasHeadband then autoStwEnabled=false getgenv().__pulseAutoStwActive=false
notify('Auto STW',"You need DIO's Headband in your inventory.",7,'warn')return
end autoStwBusy=true stwKilled={}autoStwPhase=PHASE_HAMON task.spawn(function()
if not stwQuestActive()then local okHeadband,headbandMsg=equipDioHeadband()if
not okHeadband then notify('Auto STW',headbandMsg or'Headband equip failed.',7,
'error')autoStwEnabled=false getgenv().__pulseAutoStwActive=false autoStwBusy=
false autoStwStatus='Headband missing'updateAutoStwTracker(autoStwStatus)return
end local okQuest,questMsg=acceptEnyaQuest()stashHeadband()if not okQuest then
notify('Auto STW',questMsg or'Failed to accept Enya quest.',7,'error')
autoStwEnabled=false getgenv().__pulseAutoStwActive=false autoStwBusy=false
autoStwStatus='Quest accept failed'updateAutoStwTracker(autoStwStatus)return end
else autoStwStatus='Quest already active'updateAutoStwTracker(autoStwStatus)end
notify('Auto STW','Started. Targeting Jonathan/Joseph Hamon users.',6,'start')
autoStwStatus='Running'updateAutoStwTracker(autoStwStatus)autoStwBusy=false
autoStwLastProgress=getQuestProgress()stwLastTick=tick()local function
talkEnyaOnce(reasonLabel)autoStwStatus=reasonLabel or'Talking to Enya'
updateAutoStwTracker(autoStwStatus)local okHb=select(1,equipDioHeadband())if not
okHb then notify('Auto STW',"Need DIO's Headband to talk to Enya.",6,'warn')
return false end local okQ=pcall(acceptEnyaQuest)pcall(stashHeadband)task.wait(
0.5)return okQ end while autoStwEnabled do local progress,maxProgress=
getQuestProgress()local detected=detectActiveQuest()if detected=='complete'and
autoStwPhase==PHASE_JOESTAR then progress=PHASE_GOAL[PHASE_JOESTAR]maxProgress=
PHASE_GOAL[PHASE_JOESTAR]elseif detected=='joestar'and autoStwPhase~=
PHASE_JOESTAR then notify('Auto STW',
'Active quest is Joestar Bloodline. Switching phase.',5,'info')autoStwPhase=
PHASE_JOESTAR stwKilled={}autoStwLastProgress=progress stwLastTick=tick()elseif
detected=='hamon'and autoStwPhase~=PHASE_HAMON then notify('Auto STW',
'Active quest is Hamon. Switching phase.',5,'info')autoStwPhase=PHASE_HAMON
stwKilled={}autoStwLastProgress=progress stwLastTick=tick()end local targetCount
=PHASE_GOAL[autoStwPhase]or 20 if progress>=targetCount then if autoStwPhase==
PHASE_HAMON then autoStwPhase=PHASE_JOESTAR stwKilled={}autoStwLastProgress=0
stwLastTick=tick()autoStwStatus='Phase 1 done: getting Joestar quest'
updateAutoStwTracker(autoStwStatus)notify('Auto STW',
'Phase 1 (20 Hamon) done. Talking to Enya for Joestar quest.',6,'info')
talkEnyaOnce('Accepting Joestar Bloodline quest')task.wait(0.4)elseif
autoStwPhase==PHASE_JOESTAR then autoStwStatus=
'Phase 2 done: closing Enya dialogue'updateAutoStwTracker(autoStwStatus)notify(
'Auto STW','Phase 2 (15 Joestar stands) done. Closing Enya dialogue.',6,'info')
talkEnyaOnce("Closing 'You've finally done it!' dialogue")task.wait(0.4)
autoStwStatus='Auto STW Completed!'updateAutoStwTracker(autoStwStatus)notify(
'Auto STW','Completed: STW unlocked. Stopping.',8,'success')autoStwEnabled=false
getgenv().__pulseAutoStwActive=false break end progress,maxProgress=
getQuestProgress()end if maxProgress<=0 or progress<0 then autoStwStatus=
'Quest desynced, re-syncing with Enya'updateAutoStwTracker(autoStwStatus)pcall(
acceptEnyaQuest)task.wait(0.35)end local myChar=getCharacter()local myHum=myChar
and myChar:FindFirstChildWhichIsA('Humanoid')if not(myHum and myHum.Health>0)
then autoStwStatus='Respawning, recovering'updateAutoStwTracker(autoStwStatus)
LocalPlayer.CharacterAdded:Wait()task.wait(0.25)pcall(FarmUtil.EquipStand)task.
wait(0.2)pcall(equipDioHeadband)task.wait(0.1)end if progress>
autoStwLastProgress then autoStwLastProgress=progress stwLastTick=tick()elseif
tick()-stwLastTick>12 then autoStwStatus='No progress, refreshing quest'
updateAutoStwTracker(autoStwStatus)if not stwQuestActive()and autoStwPhase==
PHASE_HAMON then local okHeadband=select(1,equipDioHeadband())if okHeadband then
pcall(acceptEnyaQuest)pcall(stashHeadband)end end stwLastTick=tick()task.wait(
0.35)end local target local phaseLabel if autoStwPhase==PHASE_JOESTAR then
target=findJoestar()phaseLabel='Joestar stand'else target=findHamonTarget()
phaseLabel='Hamon'end if target then autoStwStatus='['..phaseLabel..'] Target: '
..target.Name updateAutoStwTracker(autoStwStatus)local okKill=pcall(function()
killStwTarget(target)end)stwKilled[target.Name]=true if not okKill then
autoStwStatus='Kill error, retrying'updateAutoStwTracker(autoStwStatus)task.
wait(0.2)end else autoStwStatus='No fresh '..phaseLabel..' targets, hopping.'
updateAutoStwTracker(autoStwStatus)notify('Auto STW','No fresh '..phaseLabel..
' targets in this server. Hopping.',6,'warn')hopServer('No fresh '..phaseLabel..
' targets')task.wait(2)end task.wait(0.05)end end)end})UI.autoSTW:CreateButton({
name='Scan Hamon Users',callback=function()task.spawn(hopIfNoHamonUsers)end})end
end end function __DARKLUA_BUNDLE_MODULES.aR():typeof(__modImpl())local v=
__DARKLUA_BUNDLE_MODULES.cache.aR if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.aR=v end return v.c end end do local function
__modImpl()return function(env)local Window=env.Window local VS=env.VS local
LocalPlayer=env.LocalPlayer local PlayerGui=env.PlayerGui local PlayerStand=env.
PlayerStand local getCharacter=env.getCharacter local getRootPart=env.
getRootPart local getRemoteEvent=env.getRemoteEvent local getRemoteFunction=env.
getRemoteFunction local waitUntilNewChar=env.waitUntilNewChar local
getStandMorph=env.getStandMorph local summonStand=env.summonStand local notify=
env.notify local teleportUp=env.teleportUp local useItem=env.useItem local
learnWorthiness=env.learnWorthiness local UI=env.UI local FarmConfig=env.
FarmConfig do local WR_DISC_NAME="Weather Report's Disc"local WR_DISC_CAP=2
local farmWRDiscEnabled=false local autoUseWRDiscEnabled=false local
autoUseWRDiscDraining=false local autoWRRefillRokas=false local rokaRefillCount=
1 local function countWRDiscs()local count=0 for _,item in ipairs(VS.Backpack:
GetChildren())do if item.Name==WR_DISC_NAME then count+=1 end end pcall(function
()local char=getCharacter()for _,item in ipairs(char:GetChildren())do if item.
Name==WR_DISC_NAME then count+=1 end end end)return count end local function
findAliveWRNPC(npcName)for _,npc in ipairs(workspace.Living:GetChildren())do
local health=npc:FindFirstChild('Health')if npc.Name==npcName and npc:
FindFirstChild('HumanoidRootPart')and(not health or health.Value>0)then return
npc end end return nil end local function waitForAliveWRNPC(npcName,timeoutSec)
local deadline=tick()+(timeoutSec or 8)pcall(teleportUp)while farmWRDiscEnabled
and tick()<deadline do local npc=findAliveWRNPC(npcName)if npc then return npc
end pcall(function()stabilizeWRRoot(true)end)task.wait(0.25)end return nil end
local function stabilizeWRRoot(anchoredState)local hrp=getRootPart()if not hrp
then return end hrp.AssemblyLinearVelocity=Vector3.zero hrp.
AssemblyAngularVelocity=Vector3.zero if anchoredState~=nil then hrp.Anchored=
anchoredState end end local function cleanupWRFocus()local char=LocalPlayer.
Character local fc=char and char:FindFirstChild('FocusCam')if fc then pcall(
function()fc:Destroy()end)end end local function waitForDisc(previousCount,
timeoutSec)local deadline=tick()+(timeoutSec or 1.25)while farmWRDiscEnabled and
tick()<deadline do local count=countWRDiscs()if count>previousCount then return
count end task.wait(0.1)end return countWRDiscs()end local function killWRNPC(
npcName)local npc=waitForAliveWRNPC(npcName,10)if not npc then return false end
local npcHRP=npc:FindFirstChild('HumanoidRootPart')if not npcHRP then return
false end pcall(function()stabilizeWRRoot(false)end)local killConfirmed=false
local xpConn local moneyConn pcall(function()xpConn=LocalPlayer.PlayerStats.
Experience:GetPropertyChangedSignal('Value'):Connect(function()killConfirmed=
true end)end)pcall(function()moneyConn=PlayerGui:WaitForChild('HUD').Main.
DropMoney.Money.ChildAdded:Connect(function()killConfirmed=true end)end)pcall(
summonStand)task.wait(0.25)local deadline=tick()+35 while farmWRDiscEnabled and
not killConfirmed and tick()<deadline do local currentHRP=npc and npc:
FindFirstChild('HumanoidRootPart')if currentHRP then npcHRP=currentHRP end local
health=npc and npc:FindFirstChild('Health')if npc.Parent==nil or not npcHRP or(
health and health.Value<=0)then killConfirmed=true break end local char=
LocalPlayer.Character local hum=char and char:FindFirstChildWhichIsA('Humanoid')
local hHRP=char and char:FindFirstChild('HumanoidRootPart')if not(char and hum
and hum.Health>0 and hHRP)then LocalPlayer.CharacterAdded:Wait()pcall(
summonStand)task.wait(0.25)continue end for _,part in ipairs(char:
GetDescendants())do if part:IsA('BasePart')then part.CanCollide=false end end
local standMorph=char:FindFirstChild('StandMorph')if standMorph and standMorph.
PrimaryPart then standMorph.PrimaryPart.CFrame=npcHRP.CFrame+npcHRP.CFrame.
LookVector*-1.1 hHRP.CFrame=CFrame.new(standMorph.PrimaryPart.Position+Vector3.
new(0,FarmConfig.Distance,0))if not char:FindFirstChild('FocusCam')then local fc
=Instance.new('ObjectValue',char)fc.Name='FocusCam'fc.Value=standMorph.
PrimaryPart elseif char.FocusCam.Value~=standMorph.PrimaryPart then char.
FocusCam.Value=standMorph.PrimaryPart end else pcall(summonStand)hHRP.CFrame=
CFrame.new(npcHRP.Position+Vector3.new(0,FarmConfig.Distance,0))end hHRP.
AssemblyLinearVelocity=Vector3.zero hHRP.AssemblyAngularVelocity=Vector3.zero
pcall(function()getRemoteEvent():FireServer('Attack','m1')end)task.wait()end
pcall(function()if xpConn then xpConn:Disconnect()end end)pcall(function()if
moneyConn then moneyConn:Disconnect()end end)cleanupWRFocus()pcall(function()
stabilizeWRRoot(true)task.wait(0.1)stabilizeWRRoot(false)end)pcall(teleportUp)
return killConfirmed end local function runFarmWRDisc()pcall(function()
learnWorthiness()end)while farmWRDiscEnabled do local discCount=countWRDiscs()if
autoUseWRDiscDraining then repeat task.wait(0.3)until not farmWRDiscEnabled or
not autoUseWRDiscDraining elseif discCount>=WR_DISC_CAP then notify(
'Farm WR Disc','WR Disc slots full ('..tostring(discCount)..'/'..tostring(
WR_DISC_CAP)..').','info')repeat task.wait(0.3)until not farmWRDiscEnabled or
countWRDiscs()<WR_DISC_CAP or autoUseWRDiscDraining else local beforeCount=
discCount local killed=false pcall(function()killed=killWRNPC('Jotaro Kujo')end)
local afterCount=waitForDisc(beforeCount,1.25)if afterCount>beforeCount then
notify('Farm WR Disc','Weather Report Disc dropped! ('..tostring(afterCount)..
'/'..tostring(WR_DISC_CAP)..')','success')elseif killed then notify(
'Farm WR Disc','No disc dropped, retrying...','info')else notify('Farm WR Disc',
'Jotaro Kujo not ready, retrying...','warn')end end task.wait(0.3)end end
local function runAutoUseWRDisc()local upgradedDP=false local function learnDP()
local sst=LocalPlayer:FindFirstChild('StandSkillTree')if not sst then return end
for _,node in pairs(sst:GetChildren())do if string.find(string.lower(node.Name),
'destructive power')then if not node.Value then pcall(function()
getRemoteFunction():InvokeServer('LearnSkill',{Skill=node.Name,SkillTreeType=
'Stand'})end)task.wait(0.05)end end end end while autoUseWRDiscEnabled do task.
wait(0.5)if PlayerStand.Value~='None'then if not getStandMorph()then local
gotMorph=tryRecoverStandMorph(function()return autoUseWRDiscEnabled end,4.5)if
not gotMorph then handleStandSummonBug('Auto Use WR Disc')continue end end
repeat task.wait(0.05)summonStand()until getStandMorph()or not
autoUseWRDiscEnabled if not autoUseWRDiscEnabled then break end local sm=
getStandMorph()local skin=sm and sm:WaitForChild('StandSkin',5)local val=(skin
and skin.Value)or''if val~=''then notify('Auto Use WR Disc',
'Shiny/skin obtained! ('..val..')','success')task.spawn(learnDP)
autoUseWRDiscEnabled=false farmWRDiscEnabled=false autoUseWRDiscDraining=false
if Window:Get('AS_AutoWRFarm')then Window.controls.AS_AutoWRFarm:Set(false,true)
end return end if countWRDiscs()<=0 then if autoUseWRDiscDraining then
autoUseWRDiscDraining=false end if not upgradedDP then notify('Auto Use WR Disc'
,'Destructive power upgraded! Continue farming Jotaro Kujo!','success')task.
spawn(learnDP)upgradedDP=true end task.wait(1)continue end if not
autoUseWRDiscDraining and countWRDiscs()<WR_DISC_CAP then if not upgradedDP then
task.spawn(learnDP)upgradedDP=true end task.wait(1)continue end upgradedDP=false
if not useItem('Rokakaka')then if autoWRRefillRokas then notify(
'Auto Use WR Disc','No Rokakaka left. Starting Item Farm to refill...','info')VS
.embeddedItemFarmUntil({['Rokakaka']=rokaRefillCount},function()return
autoUseWRDiscEnabled end,'Auto Use WR Disc',true)if not autoUseWRDiscEnabled
then break end if not useItem('Rokakaka')then notify('Auto Use WR Disc',
'Failed to use Rokakaka after refill. Stopping.','warn')autoUseWRDiscEnabled=
false farmWRDiscEnabled=false autoUseWRDiscDraining=false if Window:Get(
'AS_AutoWRFarm')then Window.controls.AS_AutoWRFarm:Set(false,true)end break end
else notify('Auto Use WR Disc','No Rokakaka left. Stopping.','warn')
autoUseWRDiscEnabled=false farmWRDiscEnabled=false autoUseWRDiscDraining=false
if Window:Get('AS_AutoWRFarm')then Window.controls.AS_AutoWRFarm:Set(false,true)
end break end end repeat task.wait()until PlayerStand.Value=='None'or not
autoUseWRDiscEnabled if not autoUseWRDiscEnabled then break end
waitUntilNewChar()task.wait(0.5)teleportUp()if autoUseWRDiscDraining and
countWRDiscs()<=0 then autoUseWRDiscDraining=false end continue end local
discCount=countWRDiscs()if farmWRDiscEnabled then autoUseWRDiscDraining=
discCount>0 if discCount<=0 then autoUseWRDiscDraining=false continue end end if
discCount<=0 then continue end local sk=LocalPlayer:FindFirstChild(
'CharacterSkillTree')if not(sk and sk:FindFirstChild('Worthiness V'))then pcall(
function()learnWorthiness()end)task.wait(0.6)end if not autoUseWRDiscEnabled
then break end local used=useItem(WR_DISC_NAME)if not autoUseWRDiscEnabled then
break end if not used then continue end local gotStand=waitForStandState(
function()return autoUseWRDiscEnabled end,function()return PlayerStand.Value==
'Weather Report'end,10,0.1)if not autoUseWRDiscEnabled then break end if not
gotStand then handleStandSummonBug('Auto Use WR Disc')end end end UI.autoWR:
CreateToggle({name='Enable',value=false,flag='AS_AutoWRFarm',callback=function(v
)farmWRDiscEnabled=v autoUseWRDiscEnabled=v if v then task.spawn(runFarmWRDisc)
task.spawn(runAutoUseWRDisc)notify('Auto WR Farm','Started.','start')else
autoUseWRDiscDraining=false pcall(teleportUp)notify('Auto WR Farm','Stopped.',
'stop')end end})UI.autoWR:CreateToggle({name='Refill Rokas',value=false,flag=
'AS_AutoWRRefillRokas',callback=function(v)autoWRRefillRokas=v end})UI.autoWR:
CreateSlider({name='Refill Amount',range={1,25},increment=1,value=1,flag=
'AS_AutoWRRokaAmount',callback=function(value)rokaRefillCount=value end})UI.
autoWR:CreateSlider({name='Discs Before Use',range={0,5},increment=1,value=2,
flag='AS_WRDiscCap',callback=function(value)WR_DISC_CAP=value end})end end end
function __DARKLUA_BUNDLE_MODULES.aS():typeof(__modImpl())local v=
__DARKLUA_BUNDLE_MODULES.cache.aS if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.aS=v end return v.c end end do local function
__modImpl()return function(env)local FluentIcon=env.FluentIcon local
ApplyFluentIcon=env.ApplyFluentIcon local VS=env.VS local Players=env.Players
local farmEnsureNoclip=env.farmEnsureNoclip local LocalPlayer=env.LocalPlayer
local PlayerStand=env.PlayerStand local notify=env.notify local teleportUp=env.
teleportUp local UI=env.UI local NO_KEEPALIVE=env.NO_KEEPALIVE local FarmConfig=
env.FarmConfig local isHandheldMethod=env.isHandheldMethod local FarmState=env.
FarmState local FarmUtil=env.FarmUtil local isQuestEnemy=env.isQuestEnemy local
KILL_BUFFER=env.KILL_BUFFER local QuestNames=env.QuestNames local FarmLoop=env.
FarmLoop local questDropdown=UI.questFarm:CreateDropdown({name='Quest',options=
QuestNames,value={'Auto (Best for Level)'},flag='LF_QuestSelect',multiSelect=
false,callback=function(option)VS.selectedQuest=type(option)=='table'and(option[
1]or'Auto (Best for Level)')or(option or'Auto (Best for Level)')end})local
questLockIcon=VS.autoQuestLocked and FluentIcon('lock-closed-24-filled')or nil
local npcFarmToggle npcFarmToggle=UI.questFarm:CreateToggle({name='Enable',icon=
questLockIcon and questLockIcon.Url,value=false,flag='LF_Toggle',callback=
function(value)if value and VS.autoQuestLocked then npcFarmToggle:Set(false,true
)notify('NPC Farm','Locked for now.','warn')return end if value then if
FarmState.Active then return end if VS.noQuestKillEnabled then notify('NPC Farm'
,
[[Turn off NPC Killer (No Quest) first. Only one combat farm can run at a time.]]
,7,'warn')return end if getgenv().__pulsePlayerFarmActive then notify('NPC Farm'
,'Turn off Player Farm first.',6,'warn')return end local hrp=FarmUtil.GetHRP()
FarmState.OriginalCFrame=hrp and hrp.CFrame FarmState.Active=true FarmState.
CurrentQuest=VS.selectedQuest FarmState.CompletedQuest=true task.spawn(FarmLoop)
notify('NPC Farm','Started farming: '..tostring(VS.selectedQuest),'start')else
FarmState.Active=false FarmState.CurrentQuest=nil FarmState.CompletedQuest=false
if FarmState.OriginalCFrame then local hrp=FarmUtil.GetHRP()if hrp then hrp.
CFrame=FarmState.OriginalCFrame end FarmState.OriginalCFrame=nil end pcall(
teleportUp)notify('NPC Farm','Stopped.','stop')end end})ApplyFluentIcon(
npcFarmToggle.iconLabel,questLockIcon)if VS.autoQuestLocked then UI.lock(
questDropdown)UI.lock(npcFarmToggle)end UI.farmSettings:CreateDropdown({name=
'Method',options={'Auto (Detect)','Humanoid Stand','Handheld/Fist'},value={
'Auto (Detect)'},flag='LF_FarmingMethod',callback=function(value)FarmConfig.
FarmingMethod=value end})UI.farmSettings:CreateSlider({name='Kill Delay (s)',
range={0,2},increment=0.1,value=0,flag='LF_KillDelay',callback=function(value)
FarmConfig.KillLoopDelay=value end})UI.farmSettings:CreateSlider({name=
'Y Offset',range={-40,40},increment=1,value=-28,flag='LF_NPCDistance',callback=
function(value)FarmConfig.Distance=value end})local noQuestKillTarget='Thug'
local function killNPCNoQuest(npcName)if VS._nqActiveMoneyConn then pcall(
function()VS._nqActiveMoneyConn:Disconnect()end)VS._nqActiveMoneyConn=nil end
local enemy=nil local containers={workspace.Living}pcall(function()if workspace:
FindFirstChild('Mob_Spawns2')then table.insert(containers,workspace.Mob_Spawns2)
end end)for _,container in pairs(containers)do for _,child in pairs(container:
GetDescendants())do if child.Name==npcName or isQuestEnemy(child.Name,npcName)
then local h=child:FindFirstChild('Health')local hrp=child:FindFirstChild(
'HumanoidRootPart')if h and h.Value>0 and hrp then enemy=child break end end end
if enemy then break end end if not enemy then return end local enemyHRP=enemy:
FindFirstChild('HumanoidRootPart')if not enemyHRP then return end local handheld
=isHandheldMethod()if not handheld then FarmUtil.EquipStand()task.wait(0.3)end
local running=true local ok,dropMoney=pcall(function()return Players.LocalPlayer
.PlayerGui:WaitForChild('HUD'):WaitForChild('Main'):WaitForChild('DropMoney'):
WaitForChild('Money')end)if not ok then return end VS._nqActiveMoneyConn=
dropMoney.ChildAdded:Connect(function(child)if tonumber(string.match(child.Name,
'%d+'))then running=false end end)while running and VS.noQuestKillEnabled do if
FarmState.Active or getgenv().__pulsePlayerFarmActive then break end if enemy.
Parent==nil then break end local currentHRP=enemy:FindFirstChild(
'HumanoidRootPart')if not currentHRP then break end local h=enemy:
FindFirstChild('Health')if h and h.Value<=0 then break end local char=Players.
LocalPlayer.Character if not char then task.wait()continue end local hHRP=char:
FindFirstChild('HumanoidRootPart')if not hHRP then task.wait()continue end if
isHandheldMethod()then hHRP.CFrame=currentHRP.CFrame hHRP.AssemblyLinearVelocity
=Vector3.zero hHRP.AssemblyAngularVelocity=Vector3.zero FarmUtil.UseMove('m1')
else local hum=char:FindFirstChildWhichIsA('Humanoid')if not(hum and hum.Health>
0)then Players.LocalPlayer.CharacterAdded:Wait()FarmUtil.EquipStand()task.wait(
0.3)continue end farmEnsureNoclip(char)local standMorph=char:FindFirstChild(
'StandMorph')if standMorph and standMorph.PrimaryPart then standMorph.
PrimaryPart.CFrame=currentHRP.CFrame+currentHRP.CFrame.LookVector*-1.1 hHRP.
CFrame=CFrame.new(standMorph.PrimaryPart.Position+Vector3.new(0,FarmConfig.
Distance,0))if not char:FindFirstChild('FocusCam')then local fc=Instance.new(
'ObjectValue',char)fc.Name='FocusCam'fc.Value=standMorph.PrimaryPart elseif char
.FocusCam.Value~=standMorph.PrimaryPart then char.FocusCam.Value=standMorph.
PrimaryPart end FarmUtil.UseMove('m1')else hHRP.CFrame=currentHRP.CFrame*CFrame.
new(0,FarmConfig.Distance,-2.3)end hHRP.AssemblyLinearVelocity=Vector3.zero hHRP
.AssemblyAngularVelocity=Vector3.zero end task.wait()end if VS.
_nqActiveMoneyConn then pcall(function()VS._nqActiveMoneyConn:Disconnect()end)VS
._nqActiveMoneyConn=nil end local bufUntil=tick()+KILL_BUFFER while VS.
noQuestKillEnabled and tick()<bufUntil do local char=Players.LocalPlayer.
Character local hHRP=char and char:FindFirstChild('HumanoidRootPart')if hHRP
then hHRP.AssemblyLinearVelocity=Vector3.zero hHRP.AssemblyAngularVelocity=
Vector3.zero end local hum=char and char:FindFirstChildWhichIsA('Humanoid')if
hum and hum.Health>0 then if char:FindFirstChild('StandMorph')or
isHandheldMethod()then FarmUtil.UseMove('m1')end end task.wait()end local char=
Players.LocalPlayer.Character if char then local fc=char:FindFirstChild(
'FocusCam')if fc then fc:Destroy()end for _,v in pairs(char:GetDescendants())do
if v:IsA('BasePart')then v.CanCollide=true end end end teleportUp()end UI.hamon:
CreateSlider({name='Start At',range={0,100},increment=1,value=50,flag=
'FARM_HamonChargeStart',callback=function(v)local svc=getgenv().
__pulseHamonCharge if not svc then return end local e=svc.getEnd()if v>=e then
svc.setRange(v,math.min(100,v+1))else svc.setRange(v,nil)end end})UI.hamon:
CreateSlider({name='Stop At',range={1,100},increment=1,value=95,flag=
'FARM_HamonChargeEnd',callback=function(v)local svc=getgenv().__pulseHamonCharge
if not svc then return end local s=svc.getStart()if v<=s then svc.setRange(math.
max(0,v-1),v)else svc.setRange(nil,v)end end})UI.hamon:CreateToggle({name=
'Enable',value=false,flag='FARM_AutoHamonCharge',callback=function(v)local svc=
getgenv().__pulseHamonCharge if svc then svc.set('ui_toggle',v)end notify(
'Hamon Charge',v and'Enabled.'or'Disabled.',v and'start'or'stop')end})UI.
npcKiller:CreateDropdown({name='NPC',options={'Thug','Alpha Thug',
'Corrupt Police','Security Guard','Zombie Henchman','Vampire','Dio','Jotaro',
'Jotaro Kujo','Heaven Ascension Dio','Diavolo','Leaky Eye Luca','Bucciarati',
'Fugo','Pesci','Ghiaccio','The Idol'},value={'Thug'},flag='NQ_NPCSelect',
multiSelect=false,callback=function(v)noQuestKillTarget=type(v)=='table'and(v[1]
or'Thug')or(v or'Thug')if noQuestKillTarget=='The Idol'then notify('NPC Farm',
'High damage M1 stands are recommended for The Idol farm.',6,'info')end end})UI.
npcKiller:CreateToggle({name='Enable',value=false,flag='NQ_Toggle',callback=
function(value)VS.noQuestKillEnabled=value if value then if FarmState.Active
then notify('NPC Killer',
[[Turn off NPC Farm (quest) first. Only one combat farm can run at a time.]],7,
'warn')VS.noQuestKillEnabled=false return end if getgenv().
__pulsePlayerFarmActive then notify('NPC Killer','Turn off Player Farm first.',6
,'warn')VS.noQuestKillEnabled=false return end notify('NPC Killer','Killing '..
noQuestKillTarget..' (no quest needed)','start')task.spawn(function()while VS.
noQuestKillEnabled do pcall(function()killNPCNoQuest(noQuestKillTarget)end)task.
wait(0.2)end end)task.spawn(function()while VS.noQuestKillEnabled do task.wait(3
)if not VS.noQuestKillEnabled then break end if isHandheldMethod()and not
NO_KEEPALIVE[PlayerStand.Value]then continue end local char=LocalPlayer.
Character if char then local ss=char:FindFirstChild('SummonedStand')if not(ss
and ss.Value)then pcall(FarmUtil.EquipStand)end end end end)else notify(
'NPC Killer','Stopped.','stop')end end})end end function
__DARKLUA_BUNDLE_MODULES.aT():typeof(__modImpl())local v=
__DARKLUA_BUNDLE_MODULES.cache.aT if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.aT=v end return v.c end end do local function
__modImpl()return function(env)local VS=env.VS local Players=env.Players local
RunService=env.RunService local farmEnsureNoclip=env.farmEnsureNoclip local
farmThrottledHeartbeat=env.farmThrottledHeartbeat local LocalPlayer=env.
LocalPlayer local PlayerStand=env.PlayerStand local notify=env.notify local UI=
env.UI local NO_KEEPALIVE=env.NO_KEEPALIVE local FarmConfig=env.FarmConfig local
FarmState=env.FarmState local FarmUtil=env.FarmUtil;(function()local
playerFarmEnabled=false local playerFarmTarget=''local pfReturnCF=nil local
_pfActiveEventConns={}local function getServerPlayerNames()local names={}for _,p
in ipairs(Players:GetPlayers())do if p~=Players.LocalPlayer then table.insert(
names,p.Name)end end return names end local function killPlayer(targetName)for _
,c in ipairs(_pfActiveEventConns)do pcall(function()c:Disconnect()end)end
_pfActiveEventConns={}local targetPlayer=Players:FindFirstChild(targetName)if
not targetPlayer then return end local targetChar=targetPlayer.Character if not
targetChar then return end local targetHRP=targetChar:FindFirstChild(
'HumanoidRootPart')local targetHum=targetChar:FindFirstChildWhichIsA('Humanoid')
if not targetHRP or not targetHum or targetHum.Health<=0 then return end
FarmUtil.EquipStand()task.wait(0.3)local running=true table.insert(
_pfActiveEventConns,targetHum.Died:Connect(function()running=false end))table.
insert(_pfActiveEventConns,Players.PlayerRemoving:Connect(function(p)if p.Name==
targetName then running=false end end))table.insert(_pfActiveEventConns,
targetPlayer.CharacterRemoving:Connect(function()running=false end))while
running and playerFarmEnabled do if FarmState.Active or VS.noQuestKillEnabled
then break end if targetChar.Parent==nil then break end local currentHRP=
targetChar:FindFirstChild('HumanoidRootPart')if not currentHRP then break end
local currentHum=targetChar:FindFirstChildWhichIsA('Humanoid')if not currentHum
or currentHum.Health<=0 then break end local char=Players.LocalPlayer.Character
if not char then task.wait()continue end local hHRP=char:FindFirstChild(
'HumanoidRootPart')if not hHRP then task.wait()continue end local hum=char:
FindFirstChildWhichIsA('Humanoid')if not(hum and hum.Health>0)then Players.
LocalPlayer.CharacterAdded:Wait()FarmUtil.EquipStand()task.wait(0.3)continue end
farmEnsureNoclip(char)local standMorph=char:FindFirstChild('StandMorph')if
standMorph and standMorph.PrimaryPart then standMorph.PrimaryPart.CFrame=
currentHRP.CFrame+currentHRP.CFrame.LookVector*-1.1 hHRP.CFrame=CFrame.new(
standMorph.PrimaryPart.Position+Vector3.new(0,FarmConfig.Distance,0))if not char
:FindFirstChild('FocusCam')then local fc=Instance.new('ObjectValue',char)fc.Name
='FocusCam'fc.Value=standMorph.PrimaryPart elseif char.FocusCam.Value~=
standMorph.PrimaryPart then char.FocusCam.Value=standMorph.PrimaryPart end
FarmUtil.UseMove('m1')else hHRP.CFrame=currentHRP.CFrame-currentHRP.CFrame.
LookVector*2.3 end hHRP.AssemblyLinearVelocity=Vector3.zero hHRP.
AssemblyAngularVelocity=Vector3.zero task.wait()end for _,c in ipairs(
_pfActiveEventConns)do pcall(function()c:Disconnect()end)end _pfActiveEventConns
={}local char=Players.LocalPlayer.Character if char then local fc=char:
FindFirstChild('FocusCam')if fc then fc:Destroy()end end end local
playerFarmDropdown=UI.playerFarm:CreateDropdown({name='Player',options=
getServerPlayerNames(),value={},flag='PF_PlayerSelect',multiSelect=false,
callback=function(v)playerFarmTarget=type(v)=='table'and(v[1]or'')or(v or'')end}
)UI.playerFarm:CreateButton({name='Refresh List',callback=function()local names=
getServerPlayerNames()playerFarmDropdown:Refresh(names)playerFarmTarget=''pcall(
function()playerFarmDropdown:Set(names[1]or'')end)notify('Player Farm',#names>0
and('Refreshed: '..#names..' player(s) found')or'No other players in server',nil
,#names>0 and'success'or'warn')end})UI.playerFarm:CreateToggle({name='Enable',
value=false,flag='PF_Toggle',callback=function(value)playerFarmEnabled=value
getgenv().__pulsePlayerFarmActive=value if value then if playerFarmTarget==''
then notify('Player Farm','Select a player from the dropdown first!','warn')
playerFarmEnabled=false getgenv().__pulsePlayerFarmActive=false return end if
FarmState.Active then notify('Player Farm','Turn off NPC Farm (quest) first.',7,
'warn')playerFarmEnabled=false getgenv().__pulsePlayerFarmActive=false return
end if VS.noQuestKillEnabled then notify('Player Farm',
'Turn off NPC Killer (No Quest) first.',7,'warn')playerFarmEnabled=false
getgenv().__pulsePlayerFarmActive=false return end local hrp=FarmUtil.GetHRP()
pfReturnCF=hrp and hrp.CFrame notify('Player Farm','Farming '..playerFarmTarget,
'start')task.spawn(function()while playerFarmEnabled do pcall(function()
killPlayer(playerFarmTarget)end)local newHRP=FarmUtil.GetHRP()if newHRP and
pfReturnCF then pcall(function()newHRP.CFrame=pfReturnCF end)end task.wait(0.2)
end end)task.spawn(function()while playerFarmEnabled do task.wait(3)if not
playerFarmEnabled then break end if NO_KEEPALIVE[PlayerStand.Value]then continue
end local char=LocalPlayer.Character if char then local ss=char:FindFirstChild(
'SummonedStand')if not(ss and ss.Value)then pcall(FarmUtil.EquipStand)end end
end end)else getgenv().__pulsePlayerFarmActive=false local newHRP=FarmUtil.
GetHRP()if newHRP and pfReturnCF then pcall(function()newHRP.CFrame=pfReturnCF
end)end pfReturnCF=nil notify('Player Farm','Stopped.','stop')end end})
farmThrottledHeartbeat(function()if not(FarmState.Active or VS.
noQuestKillEnabled or playerFarmEnabled or getgenv().__pulseAutoStwActive)then
return end local char=LocalPlayer.Character if not char then return end
farmEnsureNoclip(char)end,12,30)RunService.Heartbeat:Connect(function()if not(
FarmState.Active or VS.noQuestKillEnabled or playerFarmEnabled or getgenv().
__pulseAutoStwActive)then return end local char=LocalPlayer.Character if not
char then return end local hrp=char:FindFirstChild('HumanoidRootPart')if hrp
then hrp.AssemblyLinearVelocity=Vector3.zero hrp.AssemblyAngularVelocity=Vector3
.zero end end)end)()end end function __DARKLUA_BUNDLE_MODULES.aU():typeof(
__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.aU if not v then v={c=
__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.aU=v end return v.c end end do
local function __modImpl()return function(env)local LocalPlayer=env.LocalPlayer
local sendWebhook=env.sendWebhook local notify=env.notify notify('','Welcome, '
..LocalPlayer.Name..'!','success')notify('','Pulse loaded successfully!',
'success')sendWebhook('Pulse script loaded.',false)end end function
__DARKLUA_BUNDLE_MODULES.aV():typeof(__modImpl())local v=
__DARKLUA_BUNDLE_MODULES.cache.aV if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.aV=v end return v.c end end do local function
__modImpl()return function(env)local VS=env.VS local TeleportService=env.
TeleportService local HttpService=env.HttpService local LocalPlayer=env.
LocalPlayer local notify=env.notify local UI=env.UI;(function()local
HISTORY_FILE='PulseHopHistory.json'local HISTORY_TTL=900 local hopBusy=false
local httpReq=(syn and syn.request)or(http and http.request)or http_request or
request local function readHistory()if not(isfile and readfile and isfile(
HISTORY_FILE))then return{}end local ok,data=pcall(function()return HttpService:
JSONDecode(readfile(HISTORY_FILE))end)if not ok or type(data)~='table'then
return{}end return data end local function pruneHistory(h)local now,out=os.time(
),{}for jobId,ts in pairs(h)do if type(ts)=='number'and(now-ts)<HISTORY_TTL then
out[jobId]=ts end end return out end local function saveHistory(h)if writefile
then pcall(function()writefile(HISTORY_FILE,HttpService:JSONEncode(h))end)end
end local function rememberServer(jobId)if not jobId or jobId==''then return end
local h=pruneHistory(readHistory())h[jobId]=os.time()saveHistory(h)end pcall(
function()rememberServer(game.JobId)end)local function httpGet(url)if httpReq
then local ok,resp=pcall(function()return httpReq({Url=url,Method='GET'})end)if
ok and resp then return resp.Body,resp.StatusCode,resp.Headers end return nil
end local ok,body=pcall(function()return game:HttpGetAsync(url)end)if ok then
return body,200,nil end return nil end local function attemptScan(usePrefs)local
minP=usePrefs and math.max(0,math.floor(tonumber(VS.serverHopMinPlayers)or 0))or
0 local maxP=usePrefs and math.max(minP,math.floor(tonumber(VS.
serverHopMaxPlayers)or 18))or math.huge local history=pruneHistory(readHistory()
)local base='https://games.roblox.com/v1/games/'..game.PlaceId..
[[/servers/Public?limit=100&excludeFullGames=true&sortOrder=Desc]]local cursor,
pages,attempts=nil,0,0 repeat local url=base..(cursor and('&cursor='..cursor)or
'')local body,status,headers=httpGet(url)if not body then task.wait(2)pages+=1
elseif tostring(status)=='429'or(type(body)=='string'and body:find(
'Too many requests'))then local ra=headers and(headers['Retry-After']or headers[
'retry-after'])task.wait(tonumber(ra)or 5)else local ok,decoded=pcall(function()
return HttpService:JSONDecode(body)end)if ok and decoded and decoded.data then
local cands={}for _,s in ipairs(decoded.data)do local id,playing,cap=s.id,s.
playing,s.maxPlayers if id and id~=game.JobId and playing and cap and playing<
cap and playing>=minP and playing<=maxP and not history[id]then cands[#cands+1]=
s end end for i=#cands,2,-1 do local j=math.random(i)cands[i],cands[j]=cands[j],
cands[i]end for _,s in ipairs(cands)do attempts+=1 rememberServer(s.id)getgenv()
._pulseRestoreItemFarm=VS.itemFarmEnabled notify('Server Hop','Joining server ('
..tostring(s.playing)..'/'..tostring(s.maxPlayers)..', ping '..tostring(s.ping
or'?')..')...',5,'success')local dispatched=pcall(function()TeleportService:
TeleportToPlaceInstance(game.PlaceId,s.id,LocalPlayer)end)if dispatched then
return true end end cursor=decoded.nextPageCursor else cursor=nil end pages+=1
task.wait(0.15)end until(cursor==nil)or(pages>=8)or(attempts>=40)return false
end local function smartHop(reason)if hopBusy then return end hopBusy=true
notify('Server Hop',(reason and(reason..' - ')or'')..'finding a fresh server...'
,6,'info')local ok=attemptScan(true)if not ok then notify('Server Hop',
'No server matched your Min/Max players; widening search...',6,'warn')ok=
attemptScan(false)end hopBusy=false if not ok then notify('Server Hop',
'No suitable servers found right now. Try again shortly.',7,'error')end end
getgenv().__pulseSmartHop=smartHop TeleportService.TeleportInitFailed:Connect(
function(_,result)if result==Enum.TeleportResult.Unauthorized then notify(
'Server Hop','Teleport unauthorized; stopping hop retries.',7,'error')return
elseif result==Enum.TeleportResult.Flooded or result==Enum.TeleportResult.
IsTeleporting then task.wait(5+math.random()*5)else task.wait(2)end local rname=
(typeof(result)=='EnumItem'and result.Name)or tostring(result)notify(
'Server Hop','Teleport failed ('..rname..'). Trying a different server...',6,
'warn')task.spawn(function()smartHop('Retry')end)end)UI.serverRow:CreateButton({
name='Clear History',callback=function()if delfile then pcall(function()if
isfile and isfile(HISTORY_FILE)then delfile(HISTORY_FILE)end end)end notify(
'Server Hop','Hop history cleared.','info')end})end)()end end function
__DARKLUA_BUNDLE_MODULES.aW():typeof(__modImpl())local v=
__DARKLUA_BUNDLE_MODULES.cache.aW if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.aW=v end return v.c end end do local function
__modImpl()return function(env)local VS=env.VS local LocalPlayer=env.LocalPlayer
local PlayerGui=env.PlayerGui local PlayerStand=env.PlayerStand local
PlayerPrestige=env.PlayerPrestige local Dialogues=env.Dialogues local
getCharacter=env.getCharacter local getRootPart=env.getRootPart local
getRemoteFunction=env.getRemoteFunction local waitUntilNewChar=env.
waitUntilNewChar local fireDialogue=env.fireDialogue local learnSkill=env.
learnSkill local notify=env.notify local teleportUp=env.teleportUp local UI=env.
UI;(function()local function learnAllStandSkills()pcall(function()local sst=
LocalPlayer:FindFirstChild('StandSkillTree')if sst then for _,v in pairs(sst:
GetChildren())do if not v.Value then learnSkill(v.Name,'Stand')end end end if
PlayerStand.Value=='Star Platinum'then local info=getRemoteFunction():
InvokeServer('ReturnSkillInfoInTree',{Type='Stand',Skills={[19]='Inhale'}})if
info and info.Inhale and info.Inhale.AssignedKey~='L'then getRemoteFunction():
InvokeServer('AssignSkillKey',{Type='Stand',Key='Enum.KeyCode.L',Skill='Inhale'}
)end elseif PlayerStand.Value=='Star Platinum: The World'or PlayerStand.Value==
'Star Platinum The World'then local info=getRemoteFunction():InvokeServer(
'ReturnSkillInfoInTree',{Type='Stand',Skills={[19]='Ora Beatdown'}})if info and
info['Ora Beatdown']and info['Ora Beatdown'].AssignedKey~='L'then
getRemoteFunction():InvokeServer('AssignSkillKey',{Type='Stand',Key=
'Enum.KeyCode.L',Skill='Ora Beatdown'})end end for _,s in ipairs({
'Hamon Breathing','Lung Capacity I','Lung Capacity II','Lung Capacity III',
'Lung Capacity IV','Lung Capacity V','Breathing Technique I',
'Breathing Technique II','Breathing Technique III','Breathing Technique IV',
'Breathing Technique V','Hamon Punch I','Hamon Punch II','Hamon Punch III'})do
learnSkill(s,'Spec')end end)end local function fireStorylines()local storylines=
{'#1','#1','#1','#2','#3','#3','#3','#4','#5','#6','#7','#8','#9','#10','#11',
'#11','#12','#14'}local dialogues={'Dialogue2','Dialogue6','Dialogue6',
'Dialogue3','Dialogue3','Dialogue3','Dialogue6','Dialogue3','Dialogue5',
'Dialogue5','Dialogue5','Dialogue4','Dialogue7','Dialogue6','Dialogue8',
'Dialogue11','Dialogue3','Dialogue2'}for i=1,18 do fireDialogue('Storyline '..
storylines[i],dialogues[i],'Option1')end end local function tryGetHamonFull()if
PlayerPrestige.Value<1 then notify('Hamon','Need at least Prestige 1!','warn')
return end if getCharacter():FindFirstChild('Hamon')then notify('Hamon',
'You already have Hamon!','info')return end notify('Hamon',
'Attempting to get Hamon...','info')task.spawn(function()pcall(function()
teleportUp()getRootPart().CFrame=CFrame.new(435,9,-285)repeat task.wait(0.05)
fireproximityprompt(Dialogues['Lisa Lisa']:WaitForChild('ProximityPrompt'))until
PlayerGui:FindFirstChild('DialogueGui')end)teleportUp()local hangCFrame pcall(
function()hangCFrame=getRootPart().CFrame end)repeat task.wait(0.25)pcall(
function()local char=getCharacter()if VS.Backpack:FindFirstChild(
"Caesar's Headband")and not char:FindFirstChild("Caesar's Headband")then VS.
Backpack["Caesar's Headband"].Parent=char elseif VS.Backpack:FindFirstChild(
"Zeppeli's Hat")and not char:FindFirstChild("Zeppeli's Hat")then VS.Backpack[
"Zeppeli's Hat"].Parent=char end local hrp=getRootPart()if hangCFrame then hrp.
AssemblyLinearVelocity=Vector3.zero hrp.AssemblyAngularVelocity=Vector3.zero hrp
.CFrame=hangCFrame end if type(firesignal)=='function'then firesignal(PlayerGui.
DialogueGui.Frame.ClickContinue.MouseButton1Click)firesignal(PlayerGui.
DialogueGui.Frame.Options.Option1.TextButton.MouseButton1Click)else PlayerGui.
DialogueGui.Frame.ClickContinue.MouseButton1Click:Fire()PlayerGui.DialogueGui.
Frame.Options.Option1.TextButton.MouseButton1Click:Fire()end task.wait()
fireproximityprompt(Dialogues['Lisa Lisa']:WaitForChild('ProximityPrompt'))if
type(firesignal)=='function'then firesignal(PlayerGui.DialogueGui.Frame.
ClickContinue.MouseButton1Click)firesignal(PlayerGui.DialogueGui.Frame.Options.
Option1.TextButton.MouseButton1Click)else PlayerGui.DialogueGui.Frame.
ClickContinue.MouseButton1Click:Fire()PlayerGui.DialogueGui.Frame.Options.
Option1.TextButton.MouseButton1Click:Fire()end end)until getCharacter():
FindFirstChild('Hamon')if getCharacter():FindFirstChild("Caesar's Headband")then
getCharacter()["Caesar's Headband"].Parent=VS.Backpack elseif getCharacter():
FindFirstChild("Zeppeli's Hat")then getCharacter()["Zeppeli's Hat"].Parent=VS.
Backpack end for _,s in ipairs({'Hamon Breathing','Lung Capacity I',
'Lung Capacity II','Lung Capacity III','Lung Capacity IV','Lung Capacity V',
'Breathing Technique I','Breathing Technique II','Breathing Technique III',
'Breathing Technique IV','Breathing Technique V','Hamon Punch I',
'Hamon Punch II','Hamon Punch III'})do learnSkill(s,'Spec')end task.wait()
getCharacter().Humanoid.Health=0.1 task.wait()getCharacter().Humanoid.Health=0
waitUntilNewChar()for _,s in ipairs({'Hamon Breathing','Lung Capacity I',
'Lung Capacity II','Lung Capacity III','Lung Capacity IV','Lung Capacity V',
'Breathing Technique I','Breathing Technique II','Breathing Technique III',
'Breathing Technique IV','Breathing Technique V','Hamon Punch I',
'Hamon Punch II','Hamon Punch III'})do learnSkill(s,'Spec')end task.wait(1)
teleportUp()notify('Hamon','Hamon obtained!','success')end)end UI.storylines:
CreateButton({name='Fire Storylines',callback=function()fireStorylines()notify(
'Dialogues','Storyline dialogues fired.','info')end})UI.skillTree=UI.skills:
CreateGroup({direction='row'})UI.skillTree:CreateButton({name='Stand Skills',
callback=function()task.spawn(function()learnAllStandSkills()notify('Dialogues',
'All stand skills learned.','success')end)end})UI.skillTree:CreateButton({name=
'Max DP',callback=function()local sst=LocalPlayer:FindFirstChild(
'StandSkillTree')if not sst then notify('Destructive Power',
'Stand Skill Tree not found. Do you have a stand?','error')return end local
dpNodes={}for _,node in pairs(sst:GetChildren())do if string.find(string.lower(
node.Name),'destructive power')then table.insert(dpNodes,node)end end if#dpNodes
==0 then notify('Destructive Power',
'This stand does not have destructive power.','warn')return end table.sort(
dpNodes,function(a,b)return a.Name<b.Name end)local boughtAny=false task.spawn(
function()for _,node in ipairs(dpNodes)do if not node.Value then pcall(function(
)getRemoteFunction():InvokeServer('LearnSkill',{Skill=node.Name,SkillTreeType=
'Stand'})end)boughtAny=true task.wait(0.05)end end if boughtAny then notify(
'Destructive Power','Maxed out Destructive Power!','success')else notify(
'Destructive Power','Destructive Power is already maxed!','info')end end)end})UI
.styles:CreateButton({name='Get Hamon (Prestige 1+)',callback=function()
tryGetHamonFull()end})UI.mihRow=UI.story:CreateGroup({direction='row'})UI.mihRow
:CreateButton({name='Pucci (MIH)',callback=function()firePucciDialogues()notify(
'Dialogues','Pucci dialogues fired.','info')end})UI.mihRow:CreateButton({name=
'MIH Dialogues',callback=function()fireMIHDialogues()notify('Dialogues',
'MIH dialogues fired.','info')end})end)()end end function
__DARKLUA_BUNDLE_MODULES.aX():typeof(__modImpl())local v=
__DARKLUA_BUNDLE_MODULES.cache.aX if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.aX=v end return v.c end end do local function
__modImpl()return function(env)local VS=env.VS local ReplicatedStorage=env.
ReplicatedStorage local LocalPlayer=env.LocalPlayer local getCharacter=env.
getCharacter local unequipAllTools=env.unequipAllTools local fireDialogue=env.
fireDialogue local sellItems=env.sellItems local notify=env.notify local UI=env.
UI UI.sellRow=UI.shop:CreateGroup({direction='row'})UI.sellRow:CreateButton({
name='Sell Gold Coins',callback=function()task.spawn(function()sellItems({[
'Gold Coin']=true})notify('Dialogues','Gold Coins sold.','success')end)end})UI.
sellRow:CreateButton({name='Sell Inventory',callback=function()task.spawn(
function()local sellableSet={}local ok,fl=pcall(function()return require(
ReplicatedStorage.Modules.FunctionLibrary)end)if ok and fl and fl.SellableItems
then for itemName in pairs(fl.SellableItems)do sellableSet[itemName]=true end
sellableSet['Candy']=true end local function sellableTools()local items={}
local function collectFrom(container)if not container then return end for _,item
in pairs(container:GetChildren())do if item:IsA('Tool')and sellableSet[item.Name
]and not VS.nonSellableSet[item.Name]then table.insert(items,item)end end end
collectFrom(VS.Backpack)collectFrom(LocalPlayer.Character)return items end local
soldByName={}local totalSold=0 pcall(unequipAllTools)task.wait(0.12)local
sellQueue=sellableTools()for _,item in ipairs(sellQueue)do if item and item.
Parent and item:IsA('Tool')then local name=item.Name local char=getCharacter()if
item.Parent~=char then item.Parent=char task.wait()end if item.Parent==char then
fireDialogue('Merchant','Dialogue5','Option2')task.wait()soldByName[name]=(
soldByName[name]or 0)+1 totalSold=totalSold+1 end end end if totalSold==0 then
notify('Sell All','No sellable items found.','info')return end for name,n in
pairs(soldByName)do notify('Sell All','Sold '..n..'x '..name,'success')end
notify('Sell All','Total items sold: '..totalSold,'success')end)end})end end
function __DARKLUA_BUNDLE_MODULES.aY():typeof(__modImpl())local v=
__DARKLUA_BUNDLE_MODULES.cache.aY if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.aY=v end return v.c end end do local function
__modImpl()return function(env)local VS=env.VS local UI=env.UI UI.retries:
CreateSlider({name='Stand Retries',range={10,200},increment=5,value=70,flag=
'SET_StandToggleRetryCap',callback=function(v)VS.STAND_RETRIES=v end})end end
function __DARKLUA_BUNDLE_MODULES.aZ():typeof(__modImpl())local v=
__DARKLUA_BUNDLE_MODULES.cache.aZ if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.aZ=v end return v.c end end do local function
__modImpl()return function(env)local VS=env.VS local RunService=env.RunService
local LocalPlayer=env.LocalPlayer local sendWebhook=env.sendWebhook local
refreshItemCounts=env.refreshItemCounts local getCharacter=env.getCharacter
local getStandMorph=env.getStandMorph local cleanupPilot=env.cleanupPilot local
cleanupFlyingPilot=env.cleanupFlyingPilot local notify=env.notify LocalPlayer.
CharacterAdded:Connect(function()task.wait(1)cleanupPilot()cleanupFlyingPilot()
refreshItemCounts()local mv=getgenv()._pulseMoveState if mv.wsEnabled and mv.
wsConn then mv.wsConn:Disconnect()mv.wsConn=nil end if mv.jpEnabled and mv.
jpConn then mv.jpConn:Disconnect()mv.jpConn=nil end if mv.wsEnabled then mv.
wsConn=RunService.RenderStepped:Connect(function()pcall(function()getCharacter()
.Humanoid.WalkSpeed=mv.wsSpeed end)end)end if mv.jpEnabled then mv.jpConn=
RunService.RenderStepped:Connect(function()pcall(function()getCharacter().
Humanoid.JumpPower=mv.jpPower end)end)end if VS.infPilotRangeEnabled then if VS.
infPilotRangeConn then VS.infPilotRangeConn:Disconnect()VS.infPilotRangeConn=nil
end task.wait(1)VS.infPilotRangeConn=RunService.Heartbeat:Connect(function()
pcall(function()local sm=getStandMorph()if sm then local isPiloting=sm:
FindFirstChild('IsPiloting')if isPiloting then isPiloting.Value=999999 end end
end)end)end end)print('Pulse: YBA script loaded.')notify('',
'Pulse | made by scrilisk','info')sendWebhook(
'Pulse script loaded successfully on '..LocalPlayer.Name..'.',false)end end
function __DARKLUA_BUNDLE_MODULES.a_():typeof(__modImpl())local v=
__DARKLUA_BUNDLE_MODULES.cache.a_ if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.a_=v end return v.c end end do local function
__modImpl()return function(env)local VS=env.VS local LocalPlayer=env.LocalPlayer
local RIB_NAME=env.RIB_NAME local getCharacter=env.getCharacter local
unequipAllTools=env.unequipAllTools local fireDialogue=env.fireDialogue local
desummonStand=env.desummonStand local notify=env.notify local enableNoclip=env.
enableNoclip local disableNoclip=env.disableNoclip local teleportUp=env.
teleportUp local teleportUpTemp=env.teleportUpTemp local UI=env.UI;(function()
local RIB={running=false}function RIB.count()local total=0 for _,item in pairs(
VS.Backpack:GetChildren())do if item.Name==RIB_NAME then total+=1 end end local
c=LocalPlayer.Character if c then for _,item in pairs(c:GetChildren())do if item
.Name==RIB_NAME then total+=1 end end end return total end function RIB.holdOne(
)local chr=getCharacter()unequipAllTools()task.wait(0.1)local equipped=nil for _
,item in pairs(VS.Backpack:GetChildren())do if item.Name==RIB_NAME and item:IsA(
'Tool')and not equipped then item.Parent=chr equipped=item end end task.wait(0.1
)for _,item in pairs(chr:GetChildren())do if item.Name==RIB_NAME and item:IsA(
'Tool')and item~=equipped then item.Parent=VS.Backpack end end return equipped
or chr:FindFirstChild(RIB_NAME)end function RIB.acceptDialogue()fireDialogue(
RIB_NAME,'Dialogue2','Option1')end function RIB.useOne()local before=RIB.count()
desummonStand()local rib=RIB.holdOne()if not rib then return false end pcall(
function()rib:Activate()end)task.wait(0.15)RIB.acceptDialogue()local t0=tick()
repeat task.wait(0.2)until RIB.count()<before or tick()-t0>3 unequipAllTools()
task.wait(0.2)desummonStand()return true end function RIB.run()local
worthinessVal=LocalPlayer:FindFirstChild('CharacterSkillTree')and LocalPlayer.
CharacterSkillTree:FindFirstChild('Worthiness')if worthinessVal and not
worthinessVal.Value then local rf=getCharacter():FindFirstChild('RemoteFunction'
)if rf then pcall(function()rf:InvokeServer('LearnSkill',{Skill='Worthiness',
SkillTreeType='Character'})end)end task.wait(0.35)end while RIB.running do task.
wait(0.2)if RIB.count()<=0 then notify('Rib Farm','No Rib Cages left. Stopping.'
,'warn')RIB.running=false break end if not RIB.useOne()then notify('Rib Farm',
'Failed to use Rib Cage. Stopping.','error')RIB.running=false break end task.
wait(0.3)if RIB.count()<=0 then task.wait(0.5)unequipAllTools()desummonStand()
notify('Rib Farm','All Rib Cages used!','success')RIB.running=false break end
end end UI.ribFarm:CreateToggle({name='Enable',value=false,flag=
'MAIN_EnableRibFarm',callback=function(v)RIB.running=v if v then task.spawn(RIB.
run)if RIB.count()>0 then notify('Rib Farm','Started!','start')end else notify(
'Rib Farm','Stopped.','stop')end end})end)()UI.pityFarm:CreateButton({name=
'Reset Flags',callback=function()VS.pityFarmEnabled=false VS.pityFarmDone=true
VS.noRibsFlag=false VS.noArrowsFlag=false VS.noRokasFlag=false VS.dtFarmingFlag=
false VS.dtGuardFlag=false notify('Pity Farm','All pity farm flags reset.',
'info')end})UI.movement:CreateToggle({name='Noclip',value=false,flag=
'LOCAL_Noclip',callback=function(v)if v then enableNoclip()notify('LocalPlayer',
'Noclip ON.','on')else disableNoclip()notify('LocalPlayer','Noclip OFF.','off')
end end})UI.teleport:CreateButton({name='Safe Zone',callback=function()
teleportUp()notify('LocalPlayer','Teleported to safe zone.','success')end})UI.
keybind(UI.teleport,'KEYBIND_Teleport_to_Safe_Zone',teleportUp)UI.teleport:
CreateButton({name='Teleport Up',callback=function()teleportUpTemp()notify(
'LocalPlayer','Teleported up (temp).','info')end})VS.invisToggleRef=UI.visuals:
CreateToggle({name='Invisibility',value=false,flag='AdvancedInvis',callback=
function(state)local Players=game:GetService('Players')local RunService=game:
GetService('RunService')local lp=Players.LocalPlayer local function cleanup()
getgenv().InvisEnabled=false if getgenv().InvisRenderConn then pcall(function()
getgenv().InvisRenderConn:Disconnect()end)getgenv().InvisRenderConn=nil end if
getgenv().InvisCharConn then pcall(function()getgenv().InvisCharConn:Disconnect(
)end)getgenv().InvisCharConn=nil end if getgenv().HoloModel then pcall(function(
)getgenv().HoloModel:Destroy()end)getgenv().HoloModel=nil end local seat=
workspace:FindFirstChild('pulseInvisChair')if seat then pcall(function()seat:
Destroy()end)end local chr=lp.Character if chr then for _,part in pairs(chr:
GetDescendants())do if part:IsA('BasePart')and part.Name~='HumanoidRootPart'then
part.Transparency=0 end end end getgenv().InvisInitialized=false end if not
state then cleanup()return end if getgenv().InvisInitialized then getgenv().
InvisEnabled=true return end local function setup()local chr=lp.Character or lp.
CharacterAdded:Wait()local hrp=chr:WaitForChild('HumanoidRootPart')local hum=chr
:WaitForChild('Humanoid')getgenv().InvisEnabled=true local savedCFrame=hrp.
CFrame for _,part in pairs(chr:GetDescendants())do if part:IsA('BasePart')and
part.Name~='HumanoidRootPart'then part.Transparency=1 end end local seatPos=
Vector3.new(0,10000,0)local torso=chr:FindFirstChild('UpperTorso')or chr:
FindFirstChild('Torso')if torso then local success=false local attempts=0 local
maxAttempts=5 while not success and attempts<maxAttempts do attempts+=1 local
old=workspace:FindFirstChild('pulseInvisChair')if old then pcall(function()old:
Destroy()end)end pcall(function()chr:MoveTo(seatPos)end)task.wait(0.06)if hrp.
Position.Y<-50 then pcall(function()hrp.CFrame=savedCFrame end)break end local
seat=Instance.new('Seat')seat.Name='pulseInvisChair'seat.Anchored=false seat.
CanCollide=false seat.Transparency=1 seat.Position=seatPos seat.Parent=workspace
local weld=Instance.new('Weld')weld.Part0=seat weld.Part1=torso weld.Parent=seat
task.wait(0.1)pcall(function()seat.CFrame=savedCFrame end)task.wait(0.1)local
dist=(hrp.Position-savedCFrame.Position).Magnitude if dist<10 then success=true
else warn('Pulse: Invis seat weld failed (attempt '..attempts..'), retrying')
task.wait(0.05)end end if not success then warn(
'Pulse: Invis seat failed after '..maxAttempts..' attempts')local failedSeat=
workspace:FindFirstChild('pulseInvisChair')if failedSeat then pcall(function()
failedSeat:Destroy()end)end pcall(function()hrp.CFrame=savedCFrame end)for _,
part in pairs(chr:GetDescendants())do if part:IsA('BasePart')and part.Name~=
'HumanoidRootPart'then part.Transparency=0 end end getgenv().InvisEnabled=false
getgenv().InvisInitialized=false return end end if getgenv().HoloModel then
pcall(function()getgenv().HoloModel:Destroy()end)end local holoModel=Instance.
new('Model')holoModel.Name='PulseHolo'holoModel.Parent=workspace local holoParts
={}for _,part in pairs(chr:GetDescendants())do if part:IsA('BasePart')and part.
Name~='HumanoidRootPart'then local clone=Instance.new('Part')clone.Size=part.
Size clone.CFrame=part.CFrame clone.Anchored=true clone.CanCollide=false clone.
CastShadow=false clone.Transparency=0.35 clone.Color=Color3.fromRGB(100,190,255)
clone.Material=Enum.Material.Neon clone.Parent=holoModel local mesh=part:
FindFirstChildWhichIsA('SpecialMesh')if mesh then mesh:Clone().Parent=clone end
holoParts[part]=clone end end getgenv().HoloModel=holoModel if getgenv().
InvisRenderConn then pcall(function()getgenv().InvisRenderConn:Disconnect()end)
end getgenv().InvisRenderConn=RunService.RenderStepped:Connect(function()if not
getgenv().InvisEnabled then return end for _,part in pairs(chr:GetDescendants())
do if part:IsA('BasePart')and part.Name~='HumanoidRootPart'then part.
Transparency=1 end end for realPart,holoPart in pairs(holoParts)do if realPart
and realPart.Parent and holoPart and holoPart.Parent then holoPart.CFrame=
realPart.CFrame end end end)end setup()getgenv().InvisCharConn=lp.CharacterAdded
:Connect(function()getgenv().InvisEnabled=false local seat=workspace:
FindFirstChild('pulseInvisChair')if seat then pcall(function()seat:Destroy()end)
end task.wait(1)if state then setup()end end)getgenv().InvisInitialized=true end
})UI.keybind(UI.visuals,'KEYBIND_Invisibility',VS.invisToggleRef)end end
function __DARKLUA_BUNDLE_MODULES.a0():typeof(__modImpl())local v=
__DARKLUA_BUNDLE_MODULES.cache.a0 if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.a0=v end return v.c end end do local function
__modImpl()return function(env)local Window=env.Window local VS=env.VS local
Players=env.Players local RunService=env.RunService local LocalPlayer=env.
LocalPlayer local notify=env.notify local UI=env.UI;(function()local CoreGui=
game:GetService('CoreGui')local TextService=game:GetService('TextService')local
FONT='rbxasset://fonts/families/Montserrat.json'local HEALTH_HIGH=Color3.
fromRGB(78,229,154)local HEALTH_MID=Color3.fromRGB(255,170,64)local HEALTH_LOW=
Color3.fromRGB(255,92,92)local function createInstance(className,properties)
local object=Instance.new(className)local parent=properties and properties.
Parent for key,value in properties or{}do if key~='Parent'then object[key]=value
end end if parent then object.Parent=parent end return object end local esp={
enabled=false,style='ESP',hitboxes=false,tracers=false,entries={},conns={},
widths={}}local tracerLayer local function rootOf(char)return char and(char:
FindFirstChild('HumanoidRootPart')or char:FindFirstChild('UpperTorso')or char:
FindFirstChild('Torso'))end local function headOf(char)return char and(char:
FindFirstChild('Head')or rootOf(char))end local function readStandSpec(plr)local
stats=plr and plr:FindFirstChild('PlayerStats')local standObj=stats and stats:
FindFirstChild('Stand')local specObj=stats and stats:FindFirstChild('Spec')local
stand=standObj and standObj.Value or''local spec=specObj and specObj.Value or''
if stand==''or stand=='None'then stand='No stand'end if spec==''or spec=='None'
then spec='No spec'end return stand,spec end local function textWidth(text,
weight,size)local key=weight.Name..size..text local cached=esp.widths[key]if
cached then return cached end esp.widths[key]=0 task.spawn(function()local
params=Instance.new('GetTextBoundsParams')params.Text=text params.Font=Font.new(
FONT,weight)params.Size=size params.Width=1000 local ok,bounds=pcall(TextService
.GetTextBoundsAsync,TextService,params)esp.widths[key]=ok and bounds.X or 120
end)return 0 end local function destroy(entry,key)if entry[key]then pcall(
function()entry[key]:Destroy()end)entry[key]=nil end end local function
removeEntry(plr)local entry=esp.entries[plr]if not entry then return end
destroy(entry,'hl')destroy(entry,'bb')destroy(entry,'box')destroy(entry,'line')
esp.entries[plr]=nil end local function makeLabel(entry,plr,head)if entry.bb
then entry.bb.Adornee=head return end entry.bb=createInstance('BillboardGui',{
Name='PulseESP_'..plr.UserId,AlwaysOnTop=true,LightInfluence=0,Size=UDim2.
fromOffset(300,50),StudsOffsetWorldSpace=Vector3.new(0,4.2,0),Adornee=head,
Parent=CoreGui})entry.pill=createInstance('Frame',{Name='Pill',AnchorPoint=
Vector2.new(0.5,1),Position=UDim2.new(0.5,0,1,-2),Size=UDim2.fromOffset(150,44),
BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=0.12,BorderSizePixel=0
,Parent=entry.bb})createInstance('UICorner',{CornerRadius=UDim.new(1,0),Parent=
entry.pill})createInstance('UIGradient',{Rotation=90,Color=ColorSequence.new(
Color3.fromRGB(8,8,9),Color3.fromRGB(26,26,28)),Parent=entry.pill})entry.rim=
createInstance('UIStroke',{Color=Color3.new(1,1,1),Thickness=1,Transparency=0.86
,Parent=entry.pill})entry.scale=createInstance('UIScale',{Parent=entry.pill})
entry.avatar=createInstance('ImageLabel',{Name='Avatar',AnchorPoint=Vector2.new(
0,0.5),Position=UDim2.new(0,5,0.5,0),Size=UDim2.fromOffset(30,30),
BackgroundColor3=Color3.fromRGB(40,40,44),BorderSizePixel=0,Image=
'rbxthumb://type=AvatarHeadShot&id='..plr.UserId..'&w=48&h=48',Parent=entry.pill
})createInstance('UICorner',{CornerRadius=UDim.new(1,0),Parent=entry.avatar})
entry.ring=createInstance('UIStroke',{Thickness=1.25,Parent=entry.avatar})entry.
name=createInstance('TextLabel',{Name='Name',BackgroundTransparency=1,Position=
UDim2.fromOffset(43,5),Size=UDim2.new(1,-107,0,16),FontFace=Font.new(FONT,Enum.
FontWeight.Bold),TextSize=13,TextColor3=Color3.fromRGB(242,242,244),
TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,
Parent=entry.pill})entry.dist=createInstance('TextLabel',{Name='Distance',
BackgroundTransparency=1,AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-14,0
,7),Size=UDim2.fromOffset(56,13),FontFace=Font.new(FONT,Enum.FontWeight.Medium),
TextSize=10,TextColor3=Color3.fromRGB(154,154,162),TextXAlignment=Enum.
TextXAlignment.Right,Parent=entry.pill})entry.info=createInstance('TextLabel',{
Name='Info',BackgroundTransparency=1,Position=UDim2.fromOffset(43,20),Size=UDim2
.new(1,-55,0,13),FontFace=Font.new(FONT,Enum.FontWeight.Medium),TextSize=11,
TextColor3=Color3.fromRGB(154,154,162),TextXAlignment=Enum.TextXAlignment.Left,
TextTruncate=Enum.TextTruncate.AtEnd,Parent=entry.pill})entry.track=
createInstance('Frame',{Name='Health',Position=UDim2.fromOffset(43,35),Size=
UDim2.new(1,-57,0,2),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=
0.86,BorderSizePixel=0,Parent=entry.pill})createInstance('UICorner',{
CornerRadius=UDim.new(1,0),Parent=entry.track})entry.fill=createInstance('Frame'
,{Size=UDim2.fromScale(1,1),BackgroundColor3=HEALTH_HIGH,BorderSizePixel=0,
Parent=entry.track})createInstance('UICorner',{CornerRadius=UDim.new(1,0),Parent
=entry.fill})end local function paintLabel(entry,plr,char,dist,col)local hum=
char:FindFirstChildOfClass('Humanoid')local hp=1 if hum and hum.MaxHealth>0 then
hp=math.clamp(hum.Health/hum.MaxHealth,0,1)end local stand,spec=readStandSpec(
plr)local info=stand..'  \u{b7}  '..spec entry.name.Text=plr.DisplayName entry.
info.Text=info entry.dist.Text=dist>0 and(dist..' studs')or'nearby'local
nameWidth=textWidth(plr.DisplayName,Enum.FontWeight.Bold,13)local infoWidth=
textWidth(info,Enum.FontWeight.Medium,11)local width=math.max(nameWidth+64,
infoWidth,62)entry.pill.Size=UDim2.fromOffset(math.min(290,math.ceil(width*1.08)
+57),44)entry.ring.Color=col entry.fill.Size=UDim2.fromScale(hp,1)entry.fill.
BackgroundColor3=hp>0.6 and HEALTH_HIGH or hp>0.3 and HEALTH_MID or HEALTH_LOW
entry.scale.Scale=math.clamp(1-(dist-40)/400,0.62,1)local fade=math.clamp((dist-
80)/500,0,0.45)entry.pill.BackgroundTransparency=0.12+fade entry.rim.
Transparency=0.86+fade*0.3 entry.name.TextTransparency=fade entry.info.
TextTransparency=fade entry.dist.TextTransparency=fade entry.avatar.
ImageTransparency=fade entry.avatar.BackgroundTransparency=fade entry.ring.
Transparency=fade entry.track.BackgroundTransparency=0.86+fade*0.2 entry.fill.
BackgroundTransparency=fade end local function ensure(plr)if plr==LocalPlayer
then return end local char=plr.Character local root,head=rootOf(char),headOf(
char)if not(char and root and head)then removeEntry(plr)return end local entry=
esp.entries[plr]if not entry then entry={}esp.entries[plr]=entry end local col=
Window.theme.AccentColor if esp.enabled then if not entry.hl then entry.hl=
createInstance('Highlight',{Name='PulseESPHighlight_'..plr.UserId,DepthMode=Enum
.HighlightDepthMode.AlwaysOnTop,Parent=CoreGui})end entry.hl.Adornee=char entry.
hl.FillColor=col if esp.style=='Chams'then entry.hl.OutlineColor=col:Lerp(Color3
.new(1,1,1),0.55)entry.hl.FillTransparency=0.68 entry.hl.OutlineTransparency=0
else entry.hl.OutlineColor=col entry.hl.FillTransparency=0.92 entry.hl.
OutlineTransparency=0.3 end else destroy(entry,'hl')end if esp.enabled and esp.
style=='ESP'then makeLabel(entry,plr,head)local myRoot=rootOf(LocalPlayer.
Character)local dist=myRoot and math.floor((myRoot.Position-root.Position).
Magnitude+0.5)or 0 pcall(paintLabel,entry,plr,char,dist,col)else destroy(entry,
'bb')end if esp.hitboxes then if not entry.box then entry.box=createInstance(
'BoxHandleAdornment',{Name='PulseHitbox_'..plr.UserId,AlwaysOnTop=true,ZIndex=10
,Transparency=0.52,Parent=CoreGui})end entry.box.Adornee=root entry.box.Color3=
col entry.box.Size=Vector3.new(4.5,6.5,3.2)entry.box.CFrame=CFrame.new()else
destroy(entry,'box')end end local function refresh()local alive={}for _,plr in
ipairs(Players:GetPlayers())do if plr~=LocalPlayer then alive[plr]=true ensure(
plr)end end for plr in pairs(esp.entries)do if not alive[plr]then removeEntry(
plr)end end end local function drawTracers()local cam=workspace.CurrentCamera if
not cam then return end if not(tracerLayer and tracerLayer.Parent)then
tracerLayer=createInstance('ScreenGui',{Name='PulseTracers',IgnoreGuiInset=true,
ResetOnSpawn=false,DisplayOrder=1,ZIndexBehavior=Enum.ZIndexBehavior.Sibling,
Parent=CoreGui})end local viewport=cam.ViewportSize local origin=Vector2.new(
viewport.X/2,viewport.Y-6)for plr,entry in pairs(esp.entries)do local root=
rootOf(plr.Character)if not(entry.line and entry.line.Parent)then entry.line=
createInstance('Frame',{Name='Tracer',AnchorPoint=Vector2.new(0.5,0.5),
BorderSizePixel=0,BackgroundTransparency=0.3,Parent=tracerLayer})end local show=
false if root then local point,onScreen=cam:WorldToViewportPoint(root.Position)
if onScreen and point.Z>0 then local delta=Vector2.new(point.X,point.Y)-origin
local length=delta.Magnitude if length>2 then show=true local mid=origin+delta/2
entry.line.Position=UDim2.fromOffset(mid.X,mid.Y)entry.line.Size=UDim2.
fromOffset(length,1.5)entry.line.Rotation=math.deg(math.atan2(delta.Y,delta.X))
entry.line.BackgroundColor3=Window.theme.AccentColor end end end entry.line.
Visible=show end end local function sync()if not(esp.enabled or esp.hitboxes or
esp.tracers)then for _,conn in pairs(esp.conns)do pcall(function()conn:
Disconnect()end)end esp.conns={}for plr in pairs(esp.entries)do removeEntry(plr)
end if tracerLayer then pcall(function()tracerLayer:Destroy()end)tracerLayer=nil
end return end if not esp.conns.heartbeat then esp.conns.removing=Players.
PlayerRemoving:Connect(removeEntry)local acc=0 esp.conns.heartbeat=RunService.
Heartbeat:Connect(function(dt)acc+=dt if acc<0.18 then return end acc=0 refresh(
)end)end if esp.tracers and not esp.conns.tracers then esp.conns.tracers=
RunService.RenderStepped:Connect(function()pcall(drawTracers)end)elseif not esp.
tracers and esp.conns.tracers then esp.conns.tracers:Disconnect()esp.conns.
tracers=nil for _,entry in pairs(esp.entries)do destroy(entry,'line')end end
refresh()end VS.playerESPToggleRef=UI.esp:CreateToggle({name='Player ESP',value=
false,flag='LOCAL_PlayerESP',callback=function(v)esp.enabled=v sync()if v then
notify('LocalPlayer','Player ESP ON \u{b7} stand & spec visible.','on')else
notify('LocalPlayer','Player ESP OFF.','off')end end})UI.keybind(UI.esp,
'KEYBIND_Player_ESP',VS.playerESPToggleRef)UI.esp:CreateDropdown({name='Style',
options={'ESP','Chams'},value='ESP',flag='LOCAL_ESPStyle',callback=function(v)
esp.style=(type(v)=='table'and v[1]or v)or'ESP'sync()end})UI.esp:CreateToggle({
name='Hitboxes',value=false,flag='LOCAL_ESPHitboxes',callback=function(v)esp.
hitboxes=v sync()end})UI.esp:CreateToggle({name='Tracers',value=false,flag=
'LOCAL_ESPTracers',callback=function(v)esp.tracers=v sync()end})end)()end end
function __DARKLUA_BUNDLE_MODULES.a1():typeof(__modImpl())local v=
__DARKLUA_BUNDLE_MODULES.cache.a1 if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.a1=v end return v.c end end do local function
__modImpl()return function(env)local learnSkill=env.learnSkill local toggleStand
=env.toggleStand local notify=env.notify local learnWorthiness=env.
learnWorthiness local UI=env.UI local antiAfkConn=nil UI.session:CreateToggle({
name='Anti-AFK',value=false,flag='AntiAFK',callback=function(state)if state then
local VirtualUser=game:GetService('VirtualUser')antiAfkConn=game:GetService(
'Players').LocalPlayer.Idled:Connect(function()VirtualUser:Button2Down(Vector2.
new(0,0),workspace.CurrentCamera.CFrame)task.wait(1)VirtualUser:Button2Up(
Vector2.new(0,0),workspace.CurrentCamera.CFrame)end)notify('Anti-AFK',
'Anti-AFK enabled.','start')else if antiAfkConn then antiAfkConn:Disconnect()
antiAfkConn=nil end notify('Anti-AFK','Anti-AFK disabled.','stop')end end})UI.
learnRow=UI.skills:CreateGroup({direction='row'})UI.learnRow:CreateButton({name=
'Worthiness',callback=function()learnWorthiness()notify('Combat',
'Worthiness I-V learned.','success')end})UI.learnRow:CreateButton({name=
'Hamon Breathing',callback=function()learnSkill('Hamon Breathing','Spec')notify(
'Combat','Hamon Breathing learned.','success')end})UI.learnRow:CreateButton({
name='Sprinting',callback=function()learnSkill('Sprinting','Character')notify(
'Combat','Sprinting learned.','success')end})UI.standRow:CreateButton({name=
'Toggle',callback=function()toggleStand()end})end end function
__DARKLUA_BUNDLE_MODULES.a2():typeof(__modImpl())local v=
__DARKLUA_BUNDLE_MODULES.cache.a2 if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.a2=v end return v.c end end do local function
__modImpl()return function(env)local VS=env.VS local RunService=env.RunService
local getStandMorph=env.getStandMorph local togglePilot=env.togglePilot local
toggleFlyingPilot=env.toggleFlyingPilot local activeAligns=env.activeAligns
local saCleanupAlignFor=env.saCleanupAlignFor local saEnableOrbitCamera=env.
saEnableOrbitCamera local saDisableOrbitCamera=env.saDisableOrbitCamera local
notify=env.notify local enableNoclip=env.enableNoclip local disableNoclip=env.
disableNoclip local teleportUp=env.teleportUp local UI=env.UI local
standPilotToggleRef=UI.pilot:CreateToggle({name='Stand Pilot',value=false,flag=
'COMBAT_StandPilot',callback=function(v)local ok,err=pcall(togglePilot,v)if not
ok then notify('Pilot','Stand Pilot error: '..tostring(err),'error')end end})UI.
keybind(UI.pilot,'KEYBIND_Stand_Pilot',standPilotToggleRef)local
flyingPilotToggleRef=UI.pilot:CreateToggle({name='Flying Pilot',value=false,flag
='COMBAT_FlyingPilot',callback=function(v)local ok,err=pcall(toggleFlyingPilot,v
)if not ok then notify('Pilot','Flying Pilot error: '..tostring(err),'error')end
end})UI.keybind(UI.pilot,'KEYBIND_Flying_Pilot',flyingPilotToggleRef)UI.pilot:
CreateToggle({name='Speed Changer',value=false,flag='COMBAT_PilotSpeedChanger',
callback=function(v)VS.pilotSpeedChanger=v if v and VS.standAnimController and
VS.standAnimController.Parent then pcall(function()VS.standAnimController.
WalkSpeed=VS.pilotSpeed end)end notify('Pilot','Speed changer '..(v and'enabled'
or'disabled')..'.',nil,v and'start'or'stop')end})UI.pilot:CreateSlider({name=
'Speed',range={0,200},increment=1,value=50,flag='COMBAT_PilotSpeed',callback=
function(v)VS.pilotSpeed=v if VS.pilotSpeedChanger and VS.standAnimController
and VS.standAnimController.Parent then pcall(function()VS.standAnimController.
WalkSpeed=v end)end end})UI.pilot:CreateToggle({name='Infinite Range',value=
false,flag='COMBAT_InfPilotRange',callback=function(v)VS.infPilotRangeEnabled=v
if v then notify('Pilot','Infinite Pilot Range enabled.','start')VS.
infPilotRangeConn=RunService.Heartbeat:Connect(function()pcall(function()local
sm=getStandMorph()if sm then local isPiloting=sm:FindFirstChild('IsPiloting')if
isPiloting then isPiloting.Value=999999 end end end)end)else notify('Pilot',
'Infinite Pilot Range disabled.','stop')if VS.infPilotRangeConn then VS.
infPilotRangeConn:Disconnect()VS.infPilotRangeConn=nil end end end})UI.attach:
CreateInput({name='Target',value='',placeholder='Player or NPC name...',flag=
'SA_TargetName',callback=function(value)VS.stickerTargetName=value end})VS.
stickerToggleRef=UI.attach:CreateToggle({name='Enable',value=false,flag=
'SA_StandAttach',callback=function(value)VS.stickerEnabled=value if value then
notify('Stand Attach','Enabled for: '..(VS.stickerTargetName~=''and VS.
stickerTargetName or'<empty>'),'start')if VS.stickerMethod=='Up'or VS.
stickerMethod=='Down'then enableNoclip()end else notify('Stand Attach',
'Disabled.','stop')for entity,_ in pairs(activeAligns)do saCleanupAlignFor(
entity)end disableNoclip()end end})UI.keybind(UI.attach,'KEYBIND_Stand_Attach',
VS.stickerToggleRef)VS.viewToggleRef=UI.attach:CreateToggle({name='View Stand',
value=false,flag='SA_ViewStand',callback=function(value)if VS.
saViewSettingFromCode then return end if value then local stand=getStandMorph()
if not stand then notify('Stand Attach','Equip your stand first.','warn')VS.
saViewSettingFromCode=true VS.viewToggleRef:Set(false)VS.saViewSettingFromCode=
false return end saEnableOrbitCamera(stand)else saDisableOrbitCamera()end end})
UI.attach:CreateDropdown({name='Method',options={'normal','Down','Up'},value={
'normal'},flag='SA_Method',callback=function(v)local option=type(v)=='table'and(
v[1]or'normal')or(v or'normal')VS.stickerMethod=option notify('Stand Attach',
'Method: '..option,'info')if VS.stickerEnabled then for entity,_ in pairs(
activeAligns)do saCleanupAlignFor(entity)end end if VS.stickerMethod~='Down'and
VS.stickerMethod~='Up'then disableNoclip()teleportUp()end end})end end function
__DARKLUA_BUNDLE_MODULES.a3():typeof(__modImpl())local v=
__DARKLUA_BUNDLE_MODULES.cache.a3 if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.a3=v end return v.c end end do local function
__modImpl()return function(env)local Players=env.Players local RunService=env.
RunService local LocalPlayer=env.LocalPlayer local PlayerStand=env.PlayerStand
local getRemoteEvent=env.getRemoteEvent local getStandMorph=env.getStandMorph
local summonStand=env.summonStand local notify=env.notify local enableNoclip=env
.enableNoclip local disableNoclip=env.disableNoclip local teleportUp=env.
teleportUp local UI=env.UI do local sfKillEnabled=false local sfTargets={}local
sfKillConn=nil local function getSFPlayerNames()local names={}for _,p in ipairs(
Players:GetPlayers())do if p~=LocalPlayer then table.insert(names,p.Name)end end
return names end local sfDropdown=UI.sticky:CreateDropdown({name='Players',
options=getSFPlayerNames(),value={},flag='COMBAT_SF_PlayerSelect',multiSelect=
true,callback=function(v)for k in pairs(sfTargets)do sfTargets[k]=nil end for _,
n in ipairs(v)do sfTargets[n]=true end end})UI.stickyRow=UI.sticky:CreateGroup({
direction='row'})UI.stickyRow:CreateButton({name='Select All',callback=function(
)local names=getSFPlayerNames()for k in pairs(sfTargets)do sfTargets[k]=nil end
for _,n in ipairs(names)do sfTargets[n]=true end pcall(function()sfDropdown:
Refresh(names)sfDropdown:Set(names)end)notify('Sticky Fingers',#names>0 and(
'All '..#names..' player(s) selected.')or'No other players in server.',nil,#
names>0 and'success'or'warn')end})UI.stickyRow:CreateButton({name='Refresh',
callback=function()local names=getSFPlayerNames()sfDropdown:Refresh(names)for k
in pairs(sfTargets)do sfTargets[k]=nil end pcall(function()sfDropdown:Set({})end
)notify('Sticky Fingers','Player list refreshed.','info')end})UI.sticky:
CreateToggle({name='Enable',value=false,flag='COMBAT_SF_KillEnabled',callback=
function(v)if v and PlayerStand.Value~='Sticky Fingers'then notify(
'Sticky Fingers','You must have Sticky Fingers equipped!','error')sfKillEnabled=
false return end sfKillEnabled=v if v then notify('Sticky Fingers',
'Use Sticky Fingers Moveset!','start')sfKillConn=RunService.Heartbeat:Connect(
function()if not sfKillEnabled then return end local myChar=LocalPlayer.
Character local myHRP=myChar and myChar:FindFirstChild('HumanoidRootPart')if not
myHRP then return end for name in pairs(sfTargets)do local plr=Players:
FindFirstChild(name)if plr and plr.Character then local tHRP=plr.Character:
FindFirstChild('HumanoidRootPart')if tHRP then pcall(function()tHRP.CFrame=myHRP
.CFrame*CFrame.new(0,0,-5)end)end end end end)else if sfKillConn then sfKillConn
:Disconnect()sfKillConn=nil end notify('Sticky Fingers',
'Sticky Fingers Kill disabled.','stop')end end})local kidnapTargets={}local
kidnapEnabled=false local kidnapShuffle=false local kidnapManualName=''local
kidnapLoopID=0 local function getKidnapPlayerNames()local names={}for _,p in
ipairs(Players:GetPlayers())do if p~=LocalPlayer then table.insert(names,p.Name)
end end return names end local kidnapDropdown=UI.kidnap:CreateDropdown({name=
'Player',options=getKidnapPlayerNames(),value='',flag=
'TROLL_Kidnap_PlayerSelect',multiSelect=false,callback=function(v)for k in
pairs(kidnapTargets)do kidnapTargets[k]=nil end if v and v~=''then kidnapTargets
[v]=true end end})UI.kidnap:CreateButton({name='Refresh List',callback=function(
)local names=getKidnapPlayerNames()for k in pairs(kidnapTargets)do kidnapTargets
[k]=nil end pcall(function()kidnapDropdown:Refresh(names)kidnapDropdown:Set('')
end)notify('Kidnapper','Player list refreshed.','info')end})UI.kidnap:
CreateToggle({name='Shuffle Targets',value=false,flag='TROLL_Kidnap_Shuffle',
callback=function(v)kidnapShuffle=v end})UI.kidnap:CreateInput({name=
'Manual Target',placeholder='Player Name Here...',flag='TROLL_Kidnap_Manual',
callback=function(v)kidnapManualName=v end})UI.kidnap:CreateToggle({name=
'Enable',value=false,flag='TROLL_Kidnap_Enabled',callback=function(v)if v and
PlayerStand.Value~='Mr. President'then notify('Kidnapper',
'You must have Mr. President equipped!','error')kidnapEnabled=false return end
kidnapEnabled=v if v then notify('Kidnapper','Starting Mr. President Kidnapper!'
,'start')kidnapLoopID=kidnapLoopID+1 local myLoopID=kidnapLoopID local function
isSkillOnCooldown(skillName)local hud=LocalPlayer:FindFirstChild('PlayerGui')and
LocalPlayer.PlayerGui:FindFirstChild('HUD')if not hud then return false end
local cd=hud:FindFirstChild('Cooldowns')if not cd then return false end local s=
cd:FindFirstChild(skillName)if s and s:IsA('Frame')and s.Visible then return
true end return false end task.spawn(function()local lastKidnapTime=0 while
kidnapEnabled and kidnapLoopID==myLoopID do task.wait(0.1)if not kidnapEnabled
or kidnapLoopID~=myLoopID then break end if tick()-lastKidnapTime<14 then
continue end local myChar=LocalPlayer.Character local myHRP=myChar and myChar:
FindFirstChild('HumanoidRootPart')local remote=getRemoteEvent()if not myHRP or
not remote then continue end if not getStandMorph()then local deadline=tick()+2
while tick()<deadline and not getStandMorph()and kidnapEnabled do pcall(
summonStand)task.wait(0.3)end if not getStandMorph()then continue end end if
isSkillOnCooldown('Kidnap')or isSkillOnCooldown('KIDNAP')then continue end local
targetPlayer=nil if kidnapManualName~=''then for _,p in ipairs(Players:
GetPlayers())do if p~=LocalPlayer and string.sub(string.lower(p.Name),1,#
kidnapManualName)==string.lower(kidnapManualName)then targetPlayer=p break end
end elseif kidnapShuffle then local others=getKidnapPlayerNames()if#others>0
then local rName=others[math.random(1,#others)]targetPlayer=Players:
FindFirstChild(rName)end else for tName in pairs(kidnapTargets)do targetPlayer=
Players:FindFirstChild(tName)if targetPlayer then break end end end if
targetPlayer and targetPlayer.Character then local targetHRP=targetPlayer.
Character:FindFirstChild('HumanoidRootPart')if targetHRP then lastKidnapTime=
tick()pcall(function()local pos=(targetHRP.CFrame*CFrame.new(0,0,-1)).Position
myHRP.CFrame=CFrame.lookAt(pos,targetHRP.Position)end)task.wait(0.05)pcall(
function()myHRP.Anchored=true end)remote:FireServer('InputBegan',{Input=Enum.
KeyCode.E})local grabStart=tick()while tick()-grabStart<0.8 do if targetHRP and
targetHRP.Parent then pcall(function()local pos=(targetHRP.CFrame*CFrame.new(0,0
,-1)).Position myHRP.CFrame=CFrame.lookAt(pos,targetHRP.Position)end)end task.
wait()end remote:FireServer('InputEnded',{Input=Enum.KeyCode.E})task.wait(0.2)
pcall(enableNoclip)local undergroundPos=CFrame.new(-480.5379943847656,-
135.09373474121094,-2050.510986328125)pcall(function()myHRP.CFrame=
undergroundPos end)task.wait(0.1)remote:FireServer('InputBegan',{Input=Enum.
KeyCode.Z})task.wait(0.1)remote:FireServer('InputEnded',{Input=Enum.KeyCode.Z})
task.wait(1.5)pcall(disableNoclip)pcall(function()myHRP.Anchored=false end)
pcall(teleportUp)task.wait(0.5)pcall(teleportUp)end end end end)else pcall(
disableNoclip)notify('Kidnapper','Kidnapper disabled.','stop')end end})end end
end function __DARKLUA_BUNDLE_MODULES.a4():typeof(__modImpl())local v=
__DARKLUA_BUNDLE_MODULES.cache.a4 if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.a4=v end return v.c end end do local function
__modImpl()return function(env)local VS=env.VS local getCharacter=env.
getCharacter local unequipAllTools=env.unequipAllTools local notify=env.notify
local toggleFly=env.toggleFly local UI=env.UI VS.flyToggleRef=UI.fly:
CreateToggle({name='Enable',value=false,flag='LOCAL_FlyToggle',callback=function
(v)toggleFly(v)end})UI.keybind(UI.fly,'KEYBIND_Fly_Toggle',VS.flyToggleRef)UI.
fly:CreateSlider({name='Speed',range={10,500},increment=10,value=50,flag=
'LOCAL_FlySpeed',callback=function(v)VS.flySpeed=v end})UI.tools:CreateButton({
name='Unequip',callback=function()unequipAllTools()notify('Player',
'All tools unequipped.','info')end})UI.tools:CreateButton({name='Respawn',
callback=function()getCharacter().Humanoid.Health=0 notify('Player',
'Character killed. Respawning.','warn')end})end end function
__DARKLUA_BUNDLE_MODULES.a5():typeof(__modImpl())local v=
__DARKLUA_BUNDLE_MODULES.cache.a5 if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.a5=v end return v.c end end do local function
__modImpl()return function(env)local Window=env.Window local FluentNotify=env.
FluentNotify local VS=env.VS local HttpService=env.HttpService local LocalPlayer
=env.LocalPlayer local notify=env.notify local syncFarmPicks=env.syncFarmPicks
local runItemFarm=env.runItemFarm local UI=env.UI local CONFIG_BOOT_FOLDER=
'Pulse/YBA'local CONFIG_BOOT_FILE=CONFIG_BOOT_FOLDER..'/yba-autoload-state.json'
local activeConfigName='yba-main'local autoLoadConfigEnabled=false local
autoLoadToggle=nil local autoLoadConfigSyncing=false local function
saveConfigBootstrap()pcall(function()if makefolder and isfolder and not
isfolder(CONFIG_BOOT_FOLDER)then makefolder(CONFIG_BOOT_FOLDER)end if writefile
then writefile(CONFIG_BOOT_FILE,HttpService:JSONEncode({name=activeConfigName,
autoload=autoLoadConfigEnabled}))end end)end pcall(function()if isfile and
isfile(CONFIG_BOOT_FILE)then local raw=readfile(CONFIG_BOOT_FILE)local decoded=
HttpService:JSONDecode(raw)if type(decoded)=='table'then local savedName=
tostring(decoded.name or''):gsub('[^%w%-%_%.]','_')if savedName~=''then
activeConfigName=savedName end autoLoadConfigEnabled=decoded.autoload==true end
elseif getgenv then autoLoadConfigEnabled=getgenv().__pulseAutoLoadConfig==true
end end)local function setConfigName(name)local cleaned=tostring(name or''):
gsub('[^%w%-%_%.]','_')if cleaned==''then cleaned='yba-main'end activeConfigName
=cleaned saveConfigBootstrap()pcall(function()if Window and Window.configuration
then Window.configuration.fileName=cleaned end end)end setConfigName(
activeConfigName)pcall(syncFarmPicks)local function loadActiveConfig(showNotify)
local preservedAutoLoad=autoLoadConfigEnabled if Window and Window.Load then VS.
suppressConfigLoadNotifications=true local called,loaded=pcall(Window.Load,
Window,activeConfigName)local ok=called and loaded==true pcall(syncFarmPicks)
autoLoadConfigSyncing=true if autoLoadToggle then pcall(function()autoLoadToggle
:Set(preservedAutoLoad)end)else autoLoadConfigEnabled=preservedAutoLoad
saveConfigBootstrap()end autoLoadConfigSyncing=false if showNotify then
FluentNotify({title='Pulse | Settings',content=ok and'Config loaded.'or
'Config load failed.',duration=3},ok and'checkmark-circle-24-filled'or
'error-circle-24-filled')end task.delay(1,function()VS.
suppressConfigLoadNotifications=false end)return ok else if showNotify then
notify('Settings','Config API unavailable.',nil,'warn')end return false end end
UI.config:CreateInput({name='Config Name',placeholder='yba-main',value=
activeConfigName,flag='SET_ConfigName',callback=function(v)setConfigName(v)end})
UI.configRow=UI.config:CreateGroup({direction='row'})UI.configRow:CreateButton({
name='Save',callback=function()if Window and Window.Save then local called,saved
=pcall(Window.Save,Window,activeConfigName)local ok=called and saved==true
notify('Settings',ok and'Config saved.'or'Config save failed.',nil,ok and
'success'or'warn')else notify('Settings','Config API unavailable.',nil,'warn')
end end})autoLoadToggle=UI.config:CreateToggle({name='Auto Load',value=
autoLoadConfigEnabled,flag='SET_AutoLoadConfig',callback=function(v)
autoLoadConfigEnabled=v pcall(function()if getgenv then getgenv().
__pulseAutoLoadConfig=v end end)saveConfigBootstrap()if autoLoadConfigSyncing
then return end notify('Settings',v and'Auto config load enabled.'or
'Auto config load disabled.',v and'start'or'stop')end})UI.configRow:
CreateButton({name='Load',callback=function()loadActiveConfig(true)end})if
autoLoadConfigEnabled then task.spawn(function()task.wait(1.2)local loaded=false
for _=1,3 do if loadActiveConfig(false)then loaded=true break end task.wait(0.9)
end if loaded then FluentNotify({title='Pulse | Settings',content=
'Config auto-loaded.',duration=3},'checkmark-circle-24-filled')else
FluentNotify({title='Pulse | Settings',content='Config auto-load failed.',
duration=3},'error-circle-24-filled')end end)end UI.fun:CreateButton({name=
'Do Not Press',callback=function()LocalPlayer:Kick(
'You have been banned for:\nExploiting.')end})if getgenv()._pulseRestoreItemFarm
then getgenv()._pulseRestoreItemFarm=nil task.delay(2.5,function()if not VS.
itemFarmEnabled then VS.itemFarmEnabled=true task.spawn(runItemFarm)notify(
'Item Farm','Auto-restored after server hop!','success')end end)end UI.session:
CreateButton({name='Open SBR',callback=function()loadstring(game:HttpGet(
[[https://raw.githubusercontent.com/scary666-eng/dontudare/refs/heads/main/sbr]]
))()end})end end function __DARKLUA_BUNDLE_MODULES.a6():typeof(__modImpl())local
v=__DARKLUA_BUNDLE_MODULES.cache.a6 if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.a6=v end return v.c end end do local function
__modImpl()return function(env)local function pulsePrint(text)print(
'<font color="rgb(249, 8, 124)">'..tostring(text)..'</font>')end(function()local
coreGui=game:GetService('CoreGui')local devConsoleDescConn local
consoleParentConn local function clearDevConsoleHooks()if devConsoleDescConn
then devConsoleDescConn:Disconnect()devConsoleDescConn=nil end if
consoleParentConn then consoleParentConn:Disconnect()consoleParentConn=nil end
end local function richTextConsole(consoleRoot)if not consoleRoot then return
end for _,v in pairs(consoleRoot:GetDescendants())do if v:IsA('TextLabel')then v
.RichText=true end end end local function hookConsole(consoleRoot)
clearDevConsoleHooks()richTextConsole(consoleRoot)devConsoleDescConn=consoleRoot
.DescendantAdded:Connect(function(v)if v:IsA('TextLabel')then v.RichText=true
end end)consoleParentConn=consoleRoot.AncestryChanged:Connect(function(_,parent)
if not parent then clearDevConsoleHooks()end end)end local existingConsole=
coreGui:FindFirstChild('DevConsoleMaster')if existingConsole then hookConsole(
existingConsole)end coreGui.ChildAdded:Connect(function(child)if child.Name==
'DevConsoleMaster'then hookConsole(child)end end)coreGui.ChildRemoved:Connect(
function(child)if child.Name=='DevConsoleMaster'then clearDevConsoleHooks()end
end)end)()pulsePrint(
'  \u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}'
)pulsePrint('')pulsePrint('             |             ')pulsePrint(
' __ \\  |   | |  __|   _ \\ ')pulsePrint(' |   | |   | |\\__ \\   __/ ')
pulsePrint(' .__/ \\__,_|_|____/ \\___| ')pulsePrint(
'_|                         ')pulsePrint('')do local gv=(getgenv and getgenv())
or _G local st=gv and gv.PulseLoadState if st then st.loaded=true st.finishedAt=
os.clock()end if type(shared)=='table'then shared.PulseLoadState=st or shared.
PulseLoadState end _G.PulseLoadState=st or _G.PulseLoadState end pulsePrint(
'  Pulse  |  all features live')pulsePrint(
'  \u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}\u{2501}'
)end end function __DARKLUA_BUNDLE_MODULES.a7():typeof(__modImpl())local v=
__DARKLUA_BUNDLE_MODULES.cache.a7 if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.a7=v end return v.c end end end
__DARKLUA_BUNDLE_MODULES.a()()local library=__DARKLUA_BUNDLE_MODULES.aj()local
env={Rayfield=library.Rayfield,__require=library.require,__nodes=library.nodes}
__DARKLUA_BUNDLE_MODULES.ak()(env)__DARKLUA_BUNDLE_MODULES.al()(env)
__DARKLUA_BUNDLE_MODULES.am()(env)__DARKLUA_BUNDLE_MODULES.an()(env)
local function runPulse()__DARKLUA_BUNDLE_MODULES.ao()(env)
__DARKLUA_BUNDLE_MODULES.ap()(env)__DARKLUA_BUNDLE_MODULES.aq()(env)
__DARKLUA_BUNDLE_MODULES.ar()(env)__DARKLUA_BUNDLE_MODULES.as()(env)
__DARKLUA_BUNDLE_MODULES.at()(env)__DARKLUA_BUNDLE_MODULES.au()(env)
__DARKLUA_BUNDLE_MODULES.av()(env)__DARKLUA_BUNDLE_MODULES.aw()(env)
__DARKLUA_BUNDLE_MODULES.ax()(env)__DARKLUA_BUNDLE_MODULES.ay()(env)
__DARKLUA_BUNDLE_MODULES.az()(env)__DARKLUA_BUNDLE_MODULES.aA()(env)
__DARKLUA_BUNDLE_MODULES.aB()(env)__DARKLUA_BUNDLE_MODULES.aC()(env)
__DARKLUA_BUNDLE_MODULES.aD()(env)__DARKLUA_BUNDLE_MODULES.aE()(env)
__DARKLUA_BUNDLE_MODULES.aF()(env)__DARKLUA_BUNDLE_MODULES.aG()(env)
__DARKLUA_BUNDLE_MODULES.aH()(env)__DARKLUA_BUNDLE_MODULES.aI()(env)
__DARKLUA_BUNDLE_MODULES.aJ()(env)__DARKLUA_BUNDLE_MODULES.aK()(env)
__DARKLUA_BUNDLE_MODULES.aL()(env)__DARKLUA_BUNDLE_MODULES.aM()(env)
__DARKLUA_BUNDLE_MODULES.aN()(env)__DARKLUA_BUNDLE_MODULES.aO()(env)
__DARKLUA_BUNDLE_MODULES.aP()(env)__DARKLUA_BUNDLE_MODULES.aQ()(env)
__DARKLUA_BUNDLE_MODULES.aR()(env)__DARKLUA_BUNDLE_MODULES.aS()(env)
__DARKLUA_BUNDLE_MODULES.aT()(env)__DARKLUA_BUNDLE_MODULES.aU()(env)
__DARKLUA_BUNDLE_MODULES.aV()(env)__DARKLUA_BUNDLE_MODULES.aW()(env)
__DARKLUA_BUNDLE_MODULES.aX()(env)__DARKLUA_BUNDLE_MODULES.aY()(env)
__DARKLUA_BUNDLE_MODULES.aZ()(env)__DARKLUA_BUNDLE_MODULES.a_()(env)
__DARKLUA_BUNDLE_MODULES.a0()(env)__DARKLUA_BUNDLE_MODULES.a1()(env)
__DARKLUA_BUNDLE_MODULES.a2()(env)__DARKLUA_BUNDLE_MODULES.a3()(env)
__DARKLUA_BUNDLE_MODULES.a4()(env)__DARKLUA_BUNDLE_MODULES.a5()(env)
__DARKLUA_BUNDLE_MODULES.a6()(env)__DARKLUA_BUNDLE_MODULES.a7()(env)end local
Rayfield=env.Rayfield local Window=env.Window local pulseLoaded,pulseError=
pcall(runPulse)if not pulseLoaded then warn('Pulse: '..tostring(pulseError))end
Window._pulseLoading=false Window.screenGui.Enabled=true task.spawn(function()
repeat task.wait()until Window.unloaded or(Window.hasShownOnce and not Window.
animating)if Window.unloaded then return end Window:Popup({title=
'Key system coming',subtitle='YBA',content=
[[Pulse will be entering a simple key system at the end of October.]]})end)
return Rayfield