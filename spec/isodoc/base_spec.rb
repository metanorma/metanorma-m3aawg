require "spec_helper"
require "fileutils"

logoloc = File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "lib", "isodoc", "m3aawg", "html"))

RSpec.describe IsoDoc::M3AAWG do
  it "processes default metadata" do
        csdc = IsoDoc::M3AAWG::HtmlConvert.new({})
    docxml, filename, dir = csdc.convert_init(<<~"INPUT", "test", true)
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
    expect(htmlencode(metadata(csdc.info(docxml, nil)).to_s).gsub(/, :/, ",\n:")).to be_equivalent_to (<<~"OUTPUT")
{:accesseddate=>"XXX",
:agency=>"Ribose",
:circulateddate=>"XXX",
:confirmeddate=>"XXX",
:copieddate=>"XXX",
:createddate=>"XXX",
:docnumber=>"1000(wd)",
:docnumeric=>"1000",
:doctitle=>"Main Title",
:doctype=>"Standard",
:doctype_display=>"Standard",
:docyear=>"2001",
:draft=>"3.4",
:draftinfo=>" (draft 3.4, 2000-01-01)",
:edition=>"2",
:implementeddate=>"XXX",
:issueddate=>"XXX",
:lang=>"en",
:logo_html=>"#{File.join(logoloc, "m3-logo.png")}",
:logo_word=>"#{File.join(logoloc, "logo.jpg")}",
:obsoleteddate=>"XXX",
:publisheddate=>"XXX",
:publisher=>"Ribose",
:receiveddate=>"XXX",
:revdate=>"2000-01-01",
:revdate_monthyear=>"January 2000",
:script=>"Latn",
:stage=>"Working Draft",
:stage_display=>"Working Draft",
:stageabbr=>"wd",
:transmitteddate=>"XXX",
:unchangeddate=>"XXX",
:unpublished=>true,
:updateddate=>"XXX",
:url=>"http://www.m3aawg.org/BlocklistHelp",
:vote_endeddate=>"XXX",
:vote_starteddate=>"XXX"}
    OUTPUT
  end

  it "processes pre" do
    expect(xmlpp(IsoDoc::M3AAWG::HtmlConvert.new({}).convert("test", <<~"INPUT", true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(<<~"OUTPUT")
<m3d-standard xmlns="https://open.ribose.com/standards/m3d">
<preface><foreword>
<pre>ABC</pre>
</foreword></preface>
</m3d-standard>
    INPUT
    #{HTML_HDR}
             <br/>
             <div>
               <h1 class="ForewordTitle">Foreword</h1>
               <pre>ABC</pre>
             </div>
             <p class="zzSTDTitle1"/>
           </div>
           <div class="colophon"><p>As with all M<sup>3</sup>AAWG documents that we publish, please check the M<sup>3</sup>AAWG website
       (<a href="http://www.m3aawg.org">www.m3aawg.org</a>) for updates to this paper.</p>
       <p>&#169; copyright by the Messaging, Malware and Mobile Anti-Abuse Working Group (M<sup>3</sup>AAWG)</p>
       </div>
         </body>
    OUTPUT
  end

  it "processes keyword" do
    expect(xmlpp(IsoDoc::M3AAWG::HtmlConvert.new({}).convert("test", <<~"INPUT", true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(<<~"OUTPUT")
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
        #{HTML_HDR}
             <br/>
             <div>
               <h1 class="ForewordTitle">Foreword</h1>
               <span class="keyword">ABC</span>
             </div>
             <p class="zzSTDTitle1"/>
           </div>
           <div class="colophon"><p>As with all M<sup>3</sup>AAWG documents that we publish, please check the M<sup>3</sup>AAWG website
       (<a href="http://www.m3aawg.org">www.m3aawg.org</a>) for updates to this paper.</p>
       <p>&#169; 2001 copyright by the Messaging, Malware and Mobile Anti-Abuse Working Group (M<sup>3</sup>AAWG)</p>
       </div>
         </body>
    OUTPUT
  end

  it "processes section names" do
    expect(xmlpp(IsoDoc::M3AAWG::PresentationXMLConvert.new({}).convert("test", <<~"INPUT", true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(<<~"OUTPUT")
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
    <m3d-standard xmlns='http://riboseinc.com/isoxml' type="presentation">
         <preface>
           <foreword obligation='informative'>
             <title>Foreword</title>
             <p id='A'>This is a preamble</p>
           </foreword>
           <introduction id='B' obligation='informative'>
             <title>Introduction</title>
             <clause id='C' inline-header='false' obligation='informative'>
               <title depth='2'>Introduction Subsection</title>
             </clause>
           </introduction>
         </preface>
         <sections>
           <clause id='D' obligation='normative'>
             <title depth='1'>
               4.
               <tab/>
               Scope
             </title>
             <p id='E'>Text</p>
           </clause>
           <clause id='H' obligation='normative'>
             <title depth='1'>
               2.
               <tab/>
               Terms, definitions, symbols and abbreviated terms
             </title>
             <terms id='I' obligation='normative'>
               <title depth='2'>
                 2.1.
                 <tab/>
                 Normal Terms
               </title>
               <term id='J'>
                 <name>2.1.1.</name>
                 <preferred>Term2</preferred>
               </term>
             </terms>
             <definitions id='K'>
               <title>2.2.</title>
               <dl>
                 <dt>Symbol</dt>
                 <dd>Definition</dd>
               </dl>
             </definitions>
           </clause>
           <definitions id='L'>
             <title>3.</title>
             <dl>
               <dt>Symbol</dt>
               <dd>Definition</dd>
             </dl>
           </definitions>
           <clause id='M' inline-header='false' obligation='normative'>
             <title depth='1'>
               5.
               <tab/>
               Clause 4
             </title>
             <clause id='N' inline-header='false' obligation='normative'>
               <title depth='2'>
                 5.1.
                 <tab/>
                 Introduction
               </title>
             </clause>
             <clause id='O' inline-header='false' obligation='normative'>
               <title depth='2'>
                 5.2.
                 <tab/>
                 Clause 4.2
               </title>
             </clause>
           </clause>
         </sections>
         <annex id='P' inline-header='false' obligation='normative'>
           <title>
             <strong>Appendix A</strong>
             <br/>
             (normative)
             <br/>
             <strong>Annex</strong>
           </title>
           <clause id='Q' inline-header='false' obligation='normative'>
             <title depth='2'>
               A.1.
               <tab/>
               Annex A.1
             </title>
             <clause id='Q1' inline-header='false' obligation='normative'>
               <title depth='3'>
                 A.1.1.
                 <tab/>
                 Annex A.1a
               </title>
             </clause>
           </clause>
         </annex>
         <bibliography>
           <references id='R' obligation='informative' normative='true'>
             <title depth='1'>
               1.
               <tab/>
               Normative References
             </title>
           </references>
           <clause id='S' obligation='informative'>
             <title depth='1'>Bibliography</title>
             <references id='T' obligation='informative' normative='false'>
               <title depth='2'>Bibliography Subsection</title>
             </references>
           </clause>
         </bibliography>
       </m3d-standard>
    OUTPUT
  end

end
