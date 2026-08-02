require "stringio"

RSpec.shared_examples "画像バリデーション" do |factory_name|
  it "画像を添付しなくても有効なこと" do
    record = build(factory_name)

    expect(record).to be_valid
  end

  {
    "JPEG" => ["test.jpg", "image/jpeg"],
    "PNG"  => ["test.png", "image/png"],
    "WebP" => ["test.webp", "image/webp"]
  }.each do |format_name, (filename, content_type)|
    it "#{format_name}形式の画像なら有効なこと" do
      record = build(factory_name)

      record.image.attach(
        io: StringIO.new("画像データ"),
        filename: filename,
        content_type: content_type
      )

      expect(record).to be_valid
    end
  end

  it "画像以外のファイルなら無効なこと" do
    record = build(factory_name)

    record.image.attach(
      io: StringIO.new("PDFデータ"),
      filename: "test.pdf",
      content_type: "application/pdf"
    )

    expect(record).not_to be_valid
    expect(record.errors[:image]).to include(
      "はJPEG、PNG、WebP形式にしてください"
    )
  end

  it "5MB以下の画像なら有効なこと" do
    record = build(factory_name)

    record.image.attach(
      io: StringIO.new("a" * 5.megabytes),
      filename: "test.jpg",
      content_type: "image/jpeg"
    )

    expect(record).to be_valid
  end

  it "5MBを超える画像なら無効なこと" do
    record = build(factory_name)

    record.image.attach(
      io: StringIO.new("a" * (5.megabytes + 1)),
      filename: "test.jpg",
      content_type: "image/jpeg"
    )

    expect(record).not_to be_valid
    expect(record.errors[:image]).to include(
      "は5MB以下にしてください"
    )
  end
end