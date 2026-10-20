require "spec_helper"
require "fileutils"

logoloc = File.expand_path(File.join(File.dirname(__FILE__), "..", "..",
                                     "lib", "isodoc", "m3aawg", "html"))

RSpec.describe IsoDoc::M3AAWG do
  it "processes default metadata" do
    csdc = IsoDoc::M3AAWG::HtmlConvert.new({})
    docxml, = csdc.convert_init(<<~"INPUT", "test", true)
      <m3d-standard xmlns="https://open.ribose.com/standards/m3d">
      <bibdata type="something">
        <title language="en" format="plain">Main Title</title>
        <uri>http://www.m3aawg.org/BlocklistHelp</uri>
        <docidentifier>1000(wd)</docidentifier>
        <docnumber>1000</docnumber>
        <edition>2</edition>
        <version>
        <revision-date>2000-01-01</revision-date>
        <draft>3.4</draft>
      </version>
        <contributor>
          <role type="author"/>
          <organization>
            <name>Ribose</name>
          </organization>
        </contributor>
        <contributor>
          <role type="publisher"/>
          <organization>
            <name>Ribose</name>
          </organization>
        </contributor>
        <language>en</language>
        <script>Latn</script>
        <status><stage>working-draft</stage></status>
        <copyright>
          <from>2001</from>
          <owner>
            <organization>
              <name>Ribose</name>
            </organization>
          </owner>
        </copyright>
        <ext>
        <doctype>standard</doctype>
        <editorialgroup>
          <technical-committee type="A">TC</technical-committee>
        </editorialgroup>
        </ext>
      </bibdata>
      <sections/>
      </m3d-standard>
    INPUT
    expect(htmlencode(metadata(csdc.info(docxml, nil)).to_s)
      .gsub(/, :/, ",\n:"))
      .to be_equivalent_to (<<~"OUTPUT")
{accesseddate: "XXX", adapteddate: "XXX", agency: "Ribose", announceddate: "XXX", bibdata: {id: "1000wd", schema_version: "v1.5.6", type: "something", title: [{language: "en", content: "Main Title", format: "plain"}], source: [{content: "http://www.m3aawg.org/BlocklistHelp"}], docidentifier: [{content: "1000(wd)"}], docnumber: "1000", contributor: [{role: [{type: "author"}], organization: {name: [{content: "Ribose"}]}}, {role: [{type: "publisher"}], organization: {name: [{content: "Ribose"}]}}], edition: {content: "2"}, version: [{content: "[\\"\\\\n  \\", \\"\\\\n  \\", \\"\\\\n\\"]"}], language: ["en"], script: ["Latn"], status: {stage: {content: "working-draft"}}, copyright: [{from: "2001", owner: [{organization: {name: [{content: "Ribose"}]}}]}], ext: {doctype: {content: "standard"}, editorialgroup: {technical_committee: {type: "A", content: "TC"}}}}, circulateddate: "XXX", confirmeddate: "XXX", copieddate: "XXX", correcteddate: "XXX", createddate: "XXX", docnumber: "1000(wd)", docnumeric: "1000", doctitle: "Main Title", doctype: "Standard", doctype_display: "Standard", docyear: "2001", draft: "3.4", draftinfo: " (draft 3.4, 2000-01-01)", edition: "2", implementeddate: "XXX", issueddate: "XXX", lang: "en", logo_html: "/Users/mulgogi/src/mn/wt-ci-rake-m3aawg/lib/isodoc/m3aawg/html/m3-logo.png", logo_word: "/Users/mulgogi/src/mn/wt-ci-rake-m3aawg/lib/isodoc/m3aawg/html/logo.jpg", metadata_extensions: {"doctype" => "standard", "editorialgroup" => {"technical-committee_type" => "A", "technical-committee" => "TC"}}, obsoleteddate: "XXX", publisheddate: "XXX", publisher: "Ribose", receiveddate: "XXX", revdate: "2000-01-01", revdate_monthyear: "January 2000", script: "Latn", stable_untildate: "XXX", stage: "Working Draft", stage_display: "Working Draft", transmitteddate: "XXX", unchangeddate: "XXX", unpublished: false, updateddate: "XXX", url: "http://www.m3aawg.org/BlocklistHelp", vote_endeddate: "XXX", vote_starteddate: "XXX"}
      OUTPUT
  end

  it "processes pre" do
    input = <<~INPUT
      <m3d-standard xmlns="https://open.ribose.com/standards/m3d">
      <preface><foreword>
      <pre>ABC</pre>
      </foreword></preface>
      </m3d-standard>
    INPUT
    output = <<~OUTPUT
<?xml version="1.0" encoding="UTF-8"?>
<body lang="EN-US" link="blue" vlink="#954F72" xml:lang="EN-US" class="container">
  <div class="title-section">
    <p> </p>
  </div>
  <br/>
  <div class="prefatory-section">
    <p> </p>
  </div>
  <br/>
  <div class="main-section"/>
</body>
    OUTPUT
    expect(xmlpp(IsoDoc::M3AAWG::HtmlConvert.new({})
      .convert("test", input, true)
      .gsub(%r{^.*<body}m, "<body")
      .gsub(%r{</body>.*}m, "</body>")))
      .to be_equivalent_to xmlpp(output)
  end

  it "processes keyword" do
    input = <<~INPUT
      <m3d-standard xmlns="https://open.ribose.com/standards/m3d">
      <bibdata>
      <copyright>
          <from>2001</from>
          <owner>
            <organization>
              <name>Ribose</name>
            </organization>
          </owner>
        </copyright>
      </bibdata>
      <preface><foreword>
      <keyword>ABC</keyword>
      </foreword></preface>
      </m3d-standard>
    INPUT
    output = <<~OUTPUT
<?xml version="1.0" encoding="UTF-8"?>
<body lang="EN-US" link="blue" vlink="#954F72" xml:lang="EN-US" class="container">
  <div class="title-section">
    <p> </p>
  </div>
  <br/>
  <div class="prefatory-section">
    <p> </p>
  </div>
  <br/>
  <div class="main-section"/>
</body>
    OUTPUT
    expect(xmlpp(IsoDoc::M3AAWG::HtmlConvert.new({})
      .convert("test", input, true)
      .gsub(%r{^.*<body}m, "<body")
      .gsub(%r{</body>.*}m, "</body>")))
      .to be_equivalent_to xmlpp(output)
  end

  it "processes section names" do
    input = <<~INPUT
      <m3d-standard xmlns="http://riboseinc.com/isoxml">
      <preface>
      <foreword obligation="informative">
         <title>Foreword</title>
         <p id="A">This is a preamble</p>
       </foreword>
        <introduction id="B" obligation="informative"><title>Introduction</title><clause id="C" inline-header="false" obligation="informative">
         <title>Introduction Subsection</title>
       </clause>
       </introduction></preface><sections>
       <clause id="D" obligation="normative">
         <title>Scope</title>
         <p id="E">Text</p>
       </clause>

       <clause id="H" obligation="normative"><title>Terms, definitions, symbols and abbreviated terms</title><terms id="I" obligation="normative">
         <title>Normal Terms</title>
         <term id="J">
         <preferred>Term2</preferred>
       </term>
       </terms>
       <definitions id="K">
         <dl>
         <dt>Symbol</dt>
         <dd>Definition</dd>
         </dl>
       </definitions>
       </clause>
       <definitions id="L">
         <dl>
         <dt>Symbol</dt>
         <dd>Definition</dd>
         </dl>
       </definitions>
       <clause id="M" inline-header="false" obligation="normative"><title>Clause 4</title><clause id="N" inline-header="false" obligation="normative">
         <title>Introduction</title>
       </clause>
       <clause id="O" inline-header="false" obligation="normative">
         <title>Clause 4.2</title>
       </clause></clause>

       </sections><annex id="P" inline-header="false" obligation="normative">
         <title>Annex</title>
         <clause id="Q" inline-header="false" obligation="normative">
         <title>Annex A.1</title>
         <clause id="Q1" inline-header="false" obligation="normative">
         <title>Annex A.1a</title>
         </clause>
       </clause>
       </annex><bibliography><references id="R" obligation="informative" normative="true">
         <title>Normative References</title>
       </references><clause id="S" obligation="informative">
         <title>Bibliography</title>
         <references id="T" obligation="informative" normative="false">
         <title>Bibliography Subsection</title>
       </references>
       </clause>
       </bibliography>
       </m3d-standard>
    INPUT
    output = <<~OUTPUT
<?xml version="1.0" encoding="UTF-8"?>
<m3d-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
  <preface>
    <clause type="toc" id="_a7d017b4-3644-d3ae-36fd-39d4c02b30e0" displayorder="1">
      <fmt-title depth="1" id="_85ad1418-867e-15df-3a2c-6140fa74607c">Table of contents</fmt-title>
    </clause>
    <foreword obligation="informative" id="_35c07d65-3cc8-2506-4e2d-1659a39ee2d6" displayorder="2">
      <title id="_4e4a024a-e93a-eada-2827-b1117b302e42">Foreword</title>
      <fmt-title depth="1" id="_6aae53af-8a01-f2af-41e8-e6d0f6df9ce0">
        <semx element="title" source="_4e4a024a-e93a-eada-2827-b1117b302e42">Foreword</semx>
      </fmt-title>
      <p id="A" semx-id="A">This is a preamble</p>
    </foreword>
    <introduction id="B" obligation="informative" semx-id="B" displayorder="3">
      <title id="_42a5d857-dc1a-62df-06c2-bef772e15765">Introduction</title>
      <fmt-title depth="1" id="_8e66a6a4-ab45-6be2-29d4-c94085bf60d4">
        <semx element="title" source="_42a5d857-dc1a-62df-06c2-bef772e15765">Introduction</semx>
      </fmt-title>
      <clause id="C" inline-header="false" obligation="informative" semx-id="C">
        <title id="_5d18cd62-11ea-d328-7934-0f50e458e99c">Introduction Subsection</title>
        <fmt-title depth="2" id="_a14e8110-f767-c43d-8613-de9dcce28b8d">
          <semx element="title" source="_5d18cd62-11ea-d328-7934-0f50e458e99c">Introduction Subsection</semx>
        </fmt-title>
      </clause>
    </introduction>
  </preface>
  <sections>
    <clause id="D" obligation="normative" semx-id="D" displayorder="7">
      <title id="_82f1c297-c673-5b3c-cbcb-92d5375c065b">Scope</title>
      <fmt-title depth="1" id="_f0ef6551-9648-da28-7079-0f2736485765">
        <span class="fmt-caption-label">
          <semx element="autonum" source="D">4</semx>
          <span class="fmt-clause-delim">.</span>
        </span>
        <span class="fmt-caption-delim">
          <tab/>
        </span>
        <semx element="title" source="_82f1c297-c673-5b3c-cbcb-92d5375c065b">Scope</semx>
      </fmt-title>
      <fmt-xref-label>
        <span class="fmt-element-name">Clause</span>
        <semx element="autonum" source="D">4</semx>
      </fmt-xref-label>
      <p id="E" semx-id="E">Text</p>
    </clause>
    <clause id="H" obligation="normative" semx-id="H" displayorder="5">
      <title id="_2cefb601-c5e5-95f3-e9da-78b13fdc9222">Terms, definitions, symbols and abbreviated terms</title>
      <fmt-title depth="1" id="_8cdf6915-2d95-bddd-45a0-b85f1482d0b7">
        <span class="fmt-caption-label">
          <semx element="autonum" source="H">2</semx>
          <span class="fmt-clause-delim">.</span>
        </span>
        <span class="fmt-caption-delim">
          <tab/>
        </span>
        <semx element="title" source="_2cefb601-c5e5-95f3-e9da-78b13fdc9222">Terms, definitions, symbols and abbreviated terms</semx>
      </fmt-title>
      <fmt-xref-label>
        <span class="fmt-element-name">Clause</span>
        <semx element="autonum" source="H">2</semx>
      </fmt-xref-label>
      <terms id="I" obligation="normative" semx-id="I">
        <title id="_d744df6d-c6f6-1bfd-9188-97d4abf7f60b">Normal Terms</title>
        <fmt-title depth="2" id="_c77efcd3-8740-de4e-0c22-ae5ac2bea197">
          <span class="fmt-caption-label">
            <semx element="autonum" source="H">2</semx>
            <span class="fmt-autonum-delim">.</span>
            <semx element="autonum" source="I">1</semx>
            <span class="fmt-clause-delim">.</span>
          </span>
          <span class="fmt-caption-delim">
            <tab/>
          </span>
          <semx element="title" source="_d744df6d-c6f6-1bfd-9188-97d4abf7f60b">Normal Terms</semx>
        </fmt-title>
        <fmt-xref-label>
          <span class="fmt-element-name">Clause</span>
          <semx element="autonum" source="H">2</semx>
          <span class="fmt-autonum-delim">.</span>
          <semx element="autonum" source="I">1</semx>
        </fmt-xref-label>
        <term id="J" semx-id="J">
          <fmt-name id="_0d2c995e-09b0-0126-8428-8918e413da67">
            <span class="fmt-caption-label">
              <semx element="autonum" source="H">2</semx>
              <span class="fmt-autonum-delim">.</span>
              <semx element="autonum" source="I">1</semx>
              <span class="fmt-autonum-delim">.</span>
              <semx element="autonum" source="J">1</semx>
              <span class="fmt-clause-delim">.</span>
            </span>
          </fmt-name>
          <fmt-xref-label>
            <span class="fmt-element-name">Clause</span>
            <semx element="autonum" source="H">2</semx>
            <span class="fmt-autonum-delim">.</span>
            <semx element="autonum" source="I">1</semx>
            <span class="fmt-autonum-delim">.</span>
            <semx element="autonum" source="J">1</semx>
          </fmt-xref-label>
          <preferred id="_137dfbb4-f18d-fd6f-4756-6c8dd65ba4cb">Term2</preferred>
        </term>
      </terms>
      <definitions id="K" semx-id="K">
        <title id="_7ec652b1-0267-340d-8110-b50812f8c182">Symbols</title>
        <fmt-title depth="2" id="_ceb6d62d-8c92-9dff-08fa-6791e03e4e1f">
          <span class="fmt-caption-label">
            <semx element="autonum" source="H">2</semx>
            <span class="fmt-autonum-delim">.</span>
            <semx element="autonum" source="K">2</semx>
            <span class="fmt-clause-delim">.</span>
          </span>
          <span class="fmt-caption-delim">
            <tab/>
          </span>
          <semx element="title" source="_7ec652b1-0267-340d-8110-b50812f8c182">Symbols</semx>
        </fmt-title>
        <fmt-xref-label>
          <span class="fmt-element-name">Clause</span>
          <semx element="autonum" source="H">2</semx>
          <span class="fmt-autonum-delim">.</span>
          <semx element="autonum" source="K">2</semx>
        </fmt-xref-label>
        <dl>
          <dt>Symbol</dt>
          <dd>Definition</dd>
        </dl>
      </definitions>
    </clause>
    <definitions id="L" semx-id="L" displayorder="6">
      <title id="_c9d323f1-975d-b3bd-14c5-5993ce00d69b">Symbols</title>
      <fmt-title depth="1" id="_e1764959-b7f7-3cbf-2963-651f4c35adde">
        <span class="fmt-caption-label">
          <semx element="autonum" source="L">3</semx>
          <span class="fmt-clause-delim">.</span>
        </span>
        <span class="fmt-caption-delim">
          <tab/>
        </span>
        <semx element="title" source="_c9d323f1-975d-b3bd-14c5-5993ce00d69b">Symbols</semx>
      </fmt-title>
      <fmt-xref-label>
        <span class="fmt-element-name">Clause</span>
        <semx element="autonum" source="L">3</semx>
      </fmt-xref-label>
      <dl>
        <dt>Symbol</dt>
        <dd>Definition</dd>
      </dl>
    </definitions>
    <clause id="M" inline-header="false" obligation="normative" semx-id="M" displayorder="8">
      <title id="_08104549-dc2f-950f-d21b-dddb4d565a62">Clause 4</title>
      <fmt-title depth="1" id="_fe1d5987-c15c-0bc3-467b-1ed36e1ef749">
        <span class="fmt-caption-label">
          <semx element="autonum" source="M">5</semx>
          <span class="fmt-clause-delim">.</span>
        </span>
        <span class="fmt-caption-delim">
          <tab/>
        </span>
        <semx element="title" source="_08104549-dc2f-950f-d21b-dddb4d565a62">Clause 4</semx>
      </fmt-title>
      <fmt-xref-label>
        <span class="fmt-element-name">Clause</span>
        <semx element="autonum" source="M">5</semx>
      </fmt-xref-label>
      <clause id="N" inline-header="false" obligation="normative" semx-id="N">
        <title id="_e8ef36f5-ae17-6da3-fe3b-5167c38129f7">Introduction</title>
        <fmt-title depth="2" id="_2b2f2fc4-9472-733d-4145-7fde40d72a81">
          <span class="fmt-caption-label">
            <semx element="autonum" source="M">5</semx>
            <span class="fmt-autonum-delim">.</span>
            <semx element="autonum" source="N">1</semx>
            <span class="fmt-clause-delim">.</span>
          </span>
          <span class="fmt-caption-delim">
            <tab/>
          </span>
          <semx element="title" source="_e8ef36f5-ae17-6da3-fe3b-5167c38129f7">Introduction</semx>
        </fmt-title>
        <fmt-xref-label>
          <span class="fmt-element-name">Clause</span>
          <semx element="autonum" source="M">5</semx>
          <span class="fmt-autonum-delim">.</span>
          <semx element="autonum" source="N">1</semx>
        </fmt-xref-label>
      </clause>
      <clause id="O" inline-header="false" obligation="normative" semx-id="O">
        <title id="_7456052c-1b28-fa3e-1c77-850c6cc9f35f">Clause 4.2</title>
        <fmt-title depth="2" id="_fcce538d-71be-7936-75a1-02b8861a1669">
          <span class="fmt-caption-label">
            <semx element="autonum" source="M">5</semx>
            <span class="fmt-autonum-delim">.</span>
            <semx element="autonum" source="O">2</semx>
            <span class="fmt-clause-delim">.</span>
          </span>
          <span class="fmt-caption-delim">
            <tab/>
          </span>
          <semx element="title" source="_7456052c-1b28-fa3e-1c77-850c6cc9f35f">Clause 4.2</semx>
        </fmt-title>
        <fmt-xref-label>
          <span class="fmt-element-name">Clause</span>
          <semx element="autonum" source="M">5</semx>
          <span class="fmt-autonum-delim">.</span>
          <semx element="autonum" source="O">2</semx>
        </fmt-xref-label>
      </clause>
    </clause>
    <references id="R" obligation="informative" normative="true" semx-id="R" displayorder="4">
      <title id="_29bceec2-75bb-7bc8-7ab6-99c994a5f6f5">Normative References</title>
      <fmt-title depth="1" id="_ced1701c-7ce4-a42e-0b2a-0e5faed5dc69">
        <span class="fmt-caption-label">
          <semx element="autonum" source="R">1</semx>
          <span class="fmt-clause-delim">.</span>
        </span>
        <span class="fmt-caption-delim">
          <tab/>
        </span>
        <semx element="title" source="_29bceec2-75bb-7bc8-7ab6-99c994a5f6f5">Normative References</semx>
      </fmt-title>
      <fmt-xref-label>
        <span class="fmt-element-name">Clause</span>
        <semx element="autonum" source="R">1</semx>
      </fmt-xref-label>
    </references>
  </sections>
  <annex id="P" inline-header="false" obligation="normative" semx-id="P" autonum="A" displayorder="9">
    <title id="_3b5d8f55-29e9-88f2-ccd3-e8c15b128dd5">Annex</title>
    <fmt-title id="_6af1383f-9c9a-2437-3fd0-9f8cd9f00716">
      <strong>
        <span class="fmt-caption-label">
          <span class="fmt-element-name">Appendix</span>
          <semx element="autonum" source="P">A</semx>
        </span>
      </strong>
      <br/>
      <span class="fmt-obligation">(normative)</span>
      <span class="fmt-caption-delim">
        <br/>
      </span>
      <semx element="title" source="_3b5d8f55-29e9-88f2-ccd3-e8c15b128dd5">
        <strong>Annex</strong>
      </semx>
    </fmt-title>
    <fmt-xref-label>
      <span class="fmt-element-name">Appendix</span>
      <semx element="autonum" source="P">A</semx>
    </fmt-xref-label>
    <variant-title type="toc">
      <span class="fmt-caption-label">
        <span class="fmt-element-name">Appendix</span>
        <semx element="autonum" source="P">A</semx>
      </span>
      <span class="fmt-caption-delim">
        <tab/>
      </span>
      <semx element="title" source="_3b5d8f55-29e9-88f2-ccd3-e8c15b128dd5">Annex</semx>
    </variant-title>
    <clause id="Q" inline-header="false" obligation="normative" semx-id="Q" autonum="A.1">
      <title id="_82bd75ff-a1d9-11ab-2dd1-35a0a48a8604">Annex A.1</title>
      <fmt-title depth="2" id="_85a391ea-7f60-6f66-896b-4d8c721a3ad2">
        <span class="fmt-caption-label">
          <semx element="autonum" source="P">A</semx>
          <span class="fmt-autonum-delim">.</span>
          <semx element="autonum" source="Q">1</semx>
          <span class="fmt-clause-delim">.</span>
        </span>
        <span class="fmt-caption-delim">
          <tab/>
        </span>
        <semx element="title" source="_82bd75ff-a1d9-11ab-2dd1-35a0a48a8604">Annex A.1</semx>
      </fmt-title>
      <fmt-xref-label>
        <span class="fmt-element-name">Appendix</span>
        <semx element="autonum" source="P">A</semx>
        <span class="fmt-autonum-delim">.</span>
        <semx element="autonum" source="Q">1</semx>
      </fmt-xref-label>
      <clause id="Q1" inline-header="false" obligation="normative" semx-id="Q1" autonum="A.1.1">
        <title id="_65fc6fe1-4280-7c60-ec3e-c018c9648948">Annex A.1a</title>
        <fmt-title depth="3" id="_af591fca-f87d-9e4b-1831-bf328e873b02">
          <span class="fmt-caption-label">
            <semx element="autonum" source="P">A</semx>
            <span class="fmt-autonum-delim">.</span>
            <semx element="autonum" source="Q">1</semx>
            <span class="fmt-autonum-delim">.</span>
            <semx element="autonum" source="Q1">1</semx>
            <span class="fmt-clause-delim">.</span>
          </span>
          <span class="fmt-caption-delim">
            <tab/>
          </span>
          <semx element="title" source="_65fc6fe1-4280-7c60-ec3e-c018c9648948">Annex A.1a</semx>
        </fmt-title>
        <fmt-xref-label>
          <span class="fmt-element-name">Appendix</span>
          <semx element="autonum" source="P">A</semx>
          <span class="fmt-autonum-delim">.</span>
          <semx element="autonum" source="Q">1</semx>
          <span class="fmt-autonum-delim">.</span>
          <semx element="autonum" source="Q1">1</semx>
        </fmt-xref-label>
      </clause>
    </clause>
  </annex>
  <bibliography>
    <clause id="S" obligation="informative" semx-id="S" displayorder="10">
      <title id="_a4a5211b-2b76-1f2a-1828-5371874e68d6">Bibliography</title>
      <fmt-title depth="1" id="_ea0427c6-ff2b-92ef-8e49-9dd74e16d270">
        <semx element="title" source="_a4a5211b-2b76-1f2a-1828-5371874e68d6">Bibliography</semx>
      </fmt-title>
      <references id="T" obligation="informative" normative="false" semx-id="T">
        <title id="_ea5fe8e1-a766-30f7-ee10-3601e79d3080">Bibliography Subsection</title>
        <fmt-title depth="2" id="_4dd8640f-ed80-b4a6-ca94-3e5d5e99bf70">
          <semx element="title" source="_ea5fe8e1-a766-30f7-ee10-3601e79d3080">Bibliography Subsection</semx>
        </fmt-title>
      </references>
    </clause>
  </bibliography>
</m3d-standard>
    OUTPUT
    expect(xmlpp(IsoDoc::M3AAWG::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)
      .gsub(%r{^.*<body}m, "<body")
      .gsub(%r{</body>.*}m, "</body>")))
      .to be_equivalent_to xmlpp(output)
  end
end
