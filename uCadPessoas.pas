unit uCadPessoas;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  IOUtils,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  FMX.Edit,
  FMX.Objects,
  FMX.ListBox,
  System.Actions,
  FMX.ActnList,
  FMX.StdActns,
  FMX.MediaLibrary.Actions,
  uADStanIntf,
  uADStanOption,
  uADStanError,
  uADGUIxIntf,
  uADPhysIntf,
  uADStanDef,
  uADStanPool,
  uADStanAsync,
  uADPhysManager,
  uADStanExprFuncs,
  uADPhysSQLite,
  Data.DB,
  uADCompClient,
  uADStanParam,
  uADDatSManager,
  uADDAptIntf,
  uADDAptManager,
  uADCompDataSet,
  uADGUIxFMXWait,
  uADCompGUIx;

type
  TForm2 = class(TForm)
    sbrodape: TStatusBar;
    sbtitulo: TStatusBar;
    lblTitulo: TLabel;
    Label1: TLabel;
    edtDocumento: TEdit;
    Label2: TLabel;
    edtNome: TEdit;
    imgFoto: TImage;
    lblRua: TLabel;
    edtRua: TEdit;
    lblCidade: TLabel;
    edtCidade: TEdit;
    cbUF: TComboBox;
    lblUF: TLabel;
    lblCEP: TLabel;
    edtCEP: TEdit;
    ActionList1: TActionList;
    btnPesquisa: TSpeedButton;
    TakePhotoFromCameraAction1: TTakePhotoFromCameraAction;
    TakePhotoFromLibraryAction1: TTakePhotoFromLibraryAction;
    btnFoto: TSpeedButton;
    btnSalvar: TSpeedButton;
    ADConnection1: TADConnection;
    ADPhysSQLiteDriverLink1: TADPhysSQLiteDriverLink;
    lblStatus: TLabel;
    ADQuery1: TADQuery;
    ADGUIxWaitCursor1: TADGUIxWaitCursor;
    procedure btnPesquisaClick(Sender: TObject);
    procedure ADConnection1BeforeConnect(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure TakePhotoFromCameraAction1DidFinishTaking(Image: TBitmap);
  private
    lNovo: Boolean;

    { Private declarations }
    procedure CarregaDados;
    procedure LimpaDados;

  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}

procedure TForm2.ADConnection1BeforeConnect(Sender: TObject);
begin
  // lblStatus.Text := IncludeTrailingPathDelimiter(gethomepath) + 'CADPESSOA.DB';
{$IFDEF IOS}
  ADConnection1.Params.Values['Database'] := IncludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(gethomepath) + 'Documents') + 'CADPESSOA.DB';
{$ENDIF}
end;

procedure TForm2.btnPesquisaClick(Sender: TObject);
begin
  try
    ADConnection1.Connected := true;
    lblStatus.Text := 'Conectado...';

    ADQuery1.Active := false;
    ADQuery1.SQL.Clear;
    ADQuery1.SQL.Add('select * from PESSOA where documento=' + QuotedStr(edtDocumento.Text));
    ADQuery1.Active := true;
    if not ADQuery1.Eof then
    begin
      CarregaDados;
      lNovo := false;
    end
    else
    begin
      LimpaDados;
      lNovo := true;
    end;
    ADQuery1.Active := false;
  except
    on e: exception do
      lblStatus.Text := e.Message;
  end;

end;

procedure TForm2.btnSalvarClick(Sender: TObject);
begin
  ADQuery1.Active := false;
  ADQuery1.SQL.Clear;
  if lNovo then
  begin
    ADQuery1.SQL.Add('insert into PESSOA (documento,nome,rua,cidade,cep,uf) values (');
    ADQuery1.SQL.Add(QuotedStr(edtDocumento.Text) + ',');
    ADQuery1.SQL.Add(QuotedStr(edtNome.Text) + ',');
    ADQuery1.SQL.Add(QuotedStr(edtRua.Text) + ',');
    ADQuery1.SQL.Add(QuotedStr(edtCidade.Text) + ',');
    ADQuery1.SQL.Add(QuotedStr(edtCEP.Text) + ',');
    ADQuery1.SQL.Add(QuotedStr(cbUF.Items.Text) + ')');
  end
  else
  begin
    ADQuery1.SQL.Add('update PESSOA set ');
    ADQuery1.SQL.Add('nome=' + QuotedStr(edtNome.Text) + ',');
    ADQuery1.SQL.Add('rua=' + QuotedStr(edtRua.Text) + ',');
    ADQuery1.SQL.Add('cidade=' + QuotedStr(edtCidade.Text) + ',');
    ADQuery1.SQL.Add('cep=' + QuotedStr(edtCEP.Text) + ',');
    ADQuery1.SQL.Add('uf=' + QuotedStr(cbUF.Items.Text));
    ADQuery1.SQL.Add('where documento=' + QuotedStr(edtDocumento.Text));
  end;

  ADQuery1.ExecSQL;

  LimpaDados;

  edtDocumento.Enabled := true;
  edtDocumento.Text := EmptyStr;
  edtDocumento.SetFocus;

end;

procedure TForm2.CarregaDados;
begin
  edtDocumento.Enabled := false;
  edtNome.Text := ADQuery1.FieldByName('nome').AsString;
  edtRua.Text := ADQuery1.FieldByName('rua').AsString;
  edtCidade.Text := ADQuery1.FieldByName('cidade').AsString;
  edtCEP.Text := ADQuery1.FieldByName('cep').AsString;
  cbUF.ItemIndex := cbUF.Items.IndexOf(ADQuery1.FieldByName('uf').AsString);
  edtNome.SetFocus;
end;

procedure TForm2.LimpaDados;
var
  oImage: TBitmap;
begin
  edtNome.Text := EmptyStr;
  edtRua.Text := EmptyStr;
  edtCidade.Text := EmptyStr;
  edtCEP.Text := EmptyStr;
  cbUF.ItemIndex := -1;
  edtNome.SetFocus;

  oImage := TBitmap.Create(10, 10);
  imgFoto.Bitmap.Assign(oImage);

end;

procedure TForm2.TakePhotoFromCameraAction1DidFinishTaking(Image: TBitmap);
begin
  imgFoto.Bitmap.Assign(Image);
end;

end.
