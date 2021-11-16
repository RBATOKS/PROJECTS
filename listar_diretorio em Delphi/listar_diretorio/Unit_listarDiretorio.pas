unit Unit_listarDiretorio;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    edtDiretorio: TEdit;
    chkSub: TCheckBox;
    memLista: TMemo;
    Button1: TButton;
    Label2: TLabel;
    Edit1: TEdit;
    Label3: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    tamanhoTotal: Integer;

    procedure ListarArquivos(Diretorio: string; Sub:Boolean);
    function TemAtributo(Attr, Val: Integer): Boolean;
    procedure tamanhoArquivo(Arq: String);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  tamanhoTotal := 0;
  memLista.Lines.Clear;
  ListarArquivos(edtDiretorio.Text, chkSub.Checked);
  Edit1.Text := IntToStr( tamanhoTotal );
end;

procedure TForm1.ListarArquivos(Diretorio: string; Sub:Boolean);
var
  F: TSearchRec;
  Ret: Integer;
  TempNome: string;
begin
  Ret := FindFirst(Diretorio+'\*.*', faAnyFile, F);
  try
    while Ret = 0 do
      begin
        if TemAtributo(F.Attr, faDirectory) then
          begin
            if (F.Name <> '.') And (F.Name <> '..') then
              if Sub = True then
                begin
                  TempNome := Diretorio+'\' + F.Name;
                  ListarArquivos(TempNome, True);
                end;
          end
        else
          begin
            memLista.Lines.Add(Diretorio+'\'+F.Name);
            tamanhoArquivo( Diretorio+'\'+F.Name );
          end;
        //
        Ret := FindNext(F);
      end;
  finally
    begin
      FindClose(F);
    end;
  end;
end;

function TForm1.TemAtributo(Attr, Val: Integer): Boolean;
begin
  Result := Attr and Val = Val;
end;

procedure TForm1.tamanhoArquivo(Arq: String);
var
  SR: TSearchRec;
  I: integer;
begin
  I := FindFirst(arq, faArchive, SR);
  try
    if I = 0 then
      tamanhoTotal := tamanhoTotal + ( SR.Size );
  finally
    FindClose(SR);
  end;
end;

end.
