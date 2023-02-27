require "spec_helper"
require "fileutils"

RSpec.describe Metanorma::M3AAWG do
  it "has a version number" do
    expect(Metanorma::M3AAWG::VERSION).not_to be nil
  end

  it "processes a blank document" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}
    INPUT
    output = <<~OUTPUT
          #{BLANK_HDR}
      <sections/>
      </m3d-standard>
    OUTPUT
    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to xmlpp(output)
  end

  it "converts a blank document" do
    FileUtils.rm_f "test.html"
    FileUtils.rm_f "test.doc"
    FileUtils.rm_f "test.pdf"
    input = <<~INPUT
      = Document title
      Author
      :docfile: test.adoc
      :novalid:

      == Clause
    INPUT
    output = <<~OUTPUT
          #{BLANK_HDR}
          <sections>
        <clause id='_' obligation='normative'>
          <title>Clause</title>
        </clause>
      </sections>
      </m3d-standard>
    OUTPUT
    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to xmlpp(output)
    expect(File.exist?("test.html")).to be true
    expect(File.exist?("test.doc")).to be true
    expect(File.exist?("test.pdf")).to be true
  end

  it "processes default metadata" do
    input = <<~INPUT
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :novalid:
      :docnumber: 1000
      :doctype: standard
      :edition: 2
      :revdate: 2000-01-01
      :draft: 3.4
      :technical-committee: TC
      :technical-committee-number: 1
      :technical-committee-type: A
      :technical-committee_2: TC1
      :technical-committee-number_2: 11
      :technical-committee-type_2: A1
      :subcommittee: SC
      :subcommittee-number: 2
      :subcommittee-type: B
      :workgroup: WG
      :workgroup-number: 3
      :workgroup-type: C
      :secretariat: SECRETARIAT
      :copyright-year: 2001
      :status: working-draft
      :iteration: 3
      :language: en
      :title: Main Title
      :uri: http://www.m3aawg.org/BlocklistHelp
    INPUT
    output = <<~OUTPUT
          <?xml version="1.0" encoding="UTF-8"?>
      <m3d-standard xmlns="https://www.metanorma.org/ns/m3d" type="semantic" version="#{Metanorma::M3AAWG::VERSION}">
      <bibdata type="standard">
        <title language="en" format="text/plain">Main Title</title>
        <uri>http://www.m3aawg.org/BlocklistHelp</uri>
      <docidentifier type="M3AAWG">1000(wd):2001</docidentifier>
      <docnumber>1000</docnumber>
        <contributor>
          <role type="author"/>
          <organization>
          <name>Messaging Malware and Mobile Anti-Abuse Working Group</name>
          <abbreviation>M3AAWG</abbreviation>
          </organization>
        </contributor>
        <contributor>
          <role type="publisher"/>
          <organization>
          <name>Messaging Malware and Mobile Anti-Abuse Working Group</name>
          <abbreviation>M3AAWG</abbreviation>
          </organization>
        </contributor>
      <edition>2</edition>
      <version>
        <revision-date>2000-01-01</revision-date>
        <draft>3.4</draft>
      </version>
        <language>en</language>
        <script>Latn</script>
        <status>
          <stage>working-draft</stage>
          <iteration>3</iteration>
        </status>
        <copyright>
          <from>2001</from>
          <owner>
            <organization>
            <name>Messaging Malware and Mobile Anti-Abuse Working Group</name>
          <abbreviation>M3AAWG</abbreviation>
            </organization>
          </owner>
        </copyright>
        <ext>
        <doctype>report</doctype>
        <editorialgroup>
          <committee type="A">TC</committee>
          <committee type="A1">TC1</committee>
        </editorialgroup>
        </ext>
      </bibdata>
               <metanorma-extension>
           <presentation-metadata>
             <name>TOC Heading Levels</name>
             <value>2</value>
           </presentation-metadata>
           <presentation-metadata>
             <name>HTML TOC Heading Levels</name>
             <value>2</value>
           </presentation-metadata>
           <presentation-metadata>
             <name>DOC TOC Heading Levels</name>
             <value>2</value>
           </presentation-metadata>
         </metanorma-extension>
      #{BOILERPLATE.sub(/<legal-statement/, "#{BOILERPLATE_LICENSE}\n<legal-statement").sub(/#{Date.today.year} Messaging, Malware and Mobile Anti-Abuse Working Group/, '2001 Messaging, Malware and Mobile Anti-Abuse Working Group')}
      <sections/>
      </m3d-standard>
    OUTPUT
    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to xmlpp(output)
  end

  it "processes committee-draft" do
    input = <<~INPUT
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :novalid:
      :docnumber: 1000
      :doctype: standard
      :edition: 2
      :revdate: 2000-01-01
      :draft: 3.4
      :status: committee-draft
      :iteration: 3
      :language: en
      :title: Main Title
    INPUT
    output = <<~OUTPUT
              <m3d-standard xmlns="https://www.metanorma.org/ns/m3d" type="semantic" version="#{Metanorma::M3AAWG::VERSION}">
      <bibdata type="standard">
        <title language="en" format="text/plain">Main Title</title>
        <docidentifier type="M3AAWG">1000(cd):#{Time.now.year}</docidentifier>
        <docnumber>1000</docnumber>
        <contributor>
          <role type="author"/>
          <organization>
          <name>Messaging Malware and Mobile Anti-Abuse Working Group</name>
          <abbreviation>M3AAWG</abbreviation>
          </organization>
        </contributor>
        <contributor>
          <role type="publisher"/>
          <organization>
          <name>Messaging Malware and Mobile Anti-Abuse Working Group</name>
          <abbreviation>M3AAWG</abbreviation>
          </organization>
        </contributor>
        <edition>2</edition>
      <version>
        <revision-date>2000-01-01</revision-date>
        <draft>3.4</draft>
      </version>
        <language>en</language>
        <script>Latn</script>
        <status>
          <stage>committee-draft</stage>
          <iteration>3</iteration>
        </status>
        <copyright>
          <from>#{Date.today.year}</from>
          <owner>
            <organization>
            <name>Messaging Malware and Mobile Anti-Abuse Working Group</name>
          <abbreviation>M3AAWG</abbreviation>
            </organization>
          </owner>
        </copyright>
        <ext>
        <doctype>report</doctype>
        </ext>
      </bibdata>
               <metanorma-extension>
           <presentation-metadata>
             <name>TOC Heading Levels</name>
             <value>2</value>
           </presentation-metadata>
           <presentation-metadata>
             <name>HTML TOC Heading Levels</name>
             <value>2</value>
           </presentation-metadata>
           <presentation-metadata>
             <name>DOC TOC Heading Levels</name>
             <value>2</value>
           </presentation-metadata>
         </metanorma-extension>
      #{BOILERPLATE.sub(/<legal-statement/, "#{BOILERPLATE_LICENSE}\n<legal-statement")}
      <sections/>
      </m3d-standard>
    OUTPUT
    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to xmlpp(output)
  end

  it "processes draft-standard" do
    input = <<~INPUT
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :novalid:
      :docnumber: 1000
      :doctype: standard
      :edition: 2
      :revdate: 2000-01-01
      :draft: 3.4
      :status: draft-standard
      :iteration: 3
      :language: en
      :title: Main Title
    INPUT
    output = <<~OUTPUT
              <m3d-standard xmlns="https://www.metanorma.org/ns/m3d" type="semantic" version="#{Metanorma::M3AAWG::VERSION}">
      <bibdata type="standard">
        <title language="en" format="text/plain">Main Title</title>
        <docidentifier type="M3AAWG">1000(d):#{Time.now.year}</docidentifier>
        <docnumber>1000</docnumber>
        <contributor>
          <role type="author"/>
          <organization>
          <name>Messaging Malware and Mobile Anti-Abuse Working Group</name>
          <abbreviation>M3AAWG</abbreviation>
          </organization>
        </contributor>
        <contributor>
          <role type="publisher"/>
          <organization>
          <name>Messaging Malware and Mobile Anti-Abuse Working Group</name>
          <abbreviation>M3AAWG</abbreviation>
          </organization>
        </contributor>
          <edition>2</edition>
      <version>
        <revision-date>2000-01-01</revision-date>
        <draft>3.4</draft>
      </version>
        <language>en</language>
        <script>Latn</script>
        <status>
          <stage>draft-standard</stage>
          <iteration>3</iteration>
        </status>
        <copyright>
          <from>#{Date.today.year}</from>
          <owner>
            <organization>
            <name>Messaging Malware and Mobile Anti-Abuse Working Group</name>
          <abbreviation>M3AAWG</abbreviation>
            </organization>
          </owner>
        </copyright>
        <ext>
        <doctype>report</doctype>
        </ext>
      </bibdata>
               <metanorma-extension>
           <presentation-metadata>
             <name>TOC Heading Levels</name>
             <value>2</value>
           </presentation-metadata>
           <presentation-metadata>
             <name>HTML TOC Heading Levels</name>
             <value>2</value>
           </presentation-metadata>
           <presentation-metadata>
             <name>DOC TOC Heading Levels</name>
             <value>2</value>
           </presentation-metadata>
         </metanorma-extension>
      #{BOILERPLATE.sub(/<legal-statement/, "#{BOILERPLATE_LICENSE}\n<legal-statement")}
      <sections/>
      </m3d-standard>
    OUTPUT
    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to xmlpp(output)
  end

  it "ignores unrecognised status" do
    input = <<~INPUT
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :novalid:
      :docnumber: 1000
      :doctype: standard
      :edition: 2
      :revdate: 2000-01-01
      :draft: 3.4
      :copyright-year: 2001
      :status: standard
      :iteration: 3
      :language: en
      :title: Main Title
    INPUT
    output = <<~OUTPUT
          <m3d-standard xmlns="https://www.metanorma.org/ns/m3d" type="semantic" version="#{Metanorma::M3AAWG::VERSION}">
      <bibdata type="standard">
        <title language="en" format="text/plain">Main Title</title>
        <docidentifier type="M3AAWG">1000:2001</docidentifier>
        <docnumber>1000</docnumber>
        <contributor>
          <role type="author"/>
          <organization>
          <name>Messaging Malware and Mobile Anti-Abuse Working Group</name>
          <abbreviation>M3AAWG</abbreviation>
          </organization>
        </contributor>
        <contributor>
          <role type="publisher"/>
          <organization>
          <name>Messaging Malware and Mobile Anti-Abuse Working Group</name>
          <abbreviation>M3AAWG</abbreviation>
          </organization>
        </contributor>
        <edition>2</edition>
      <version>
        <revision-date>2000-01-01</revision-date>
        <draft>3.4</draft>
      </version>
        <language>en</language>
        <script>Latn</script>
        <status>
          <stage>standard</stage>
          <iteration>3</iteration>
        </status>
        <copyright>
          <from>2001</from>
          <owner>
            <organization>
            <name>Messaging Malware and Mobile Anti-Abuse Working Group</name>
          <abbreviation>M3AAWG</abbreviation>
            </organization>
          </owner>
        </copyright>
        <ext>
        <doctype>report</doctype>
        </ext>
      </bibdata>
               <metanorma-extension>
           <presentation-metadata>
             <name>TOC Heading Levels</name>
             <value>2</value>
           </presentation-metadata>
           <presentation-metadata>
             <name>HTML TOC Heading Levels</name>
             <value>2</value>
           </presentation-metadata>
           <presentation-metadata>
             <name>DOC TOC Heading Levels</name>
             <value>2</value>
           </presentation-metadata>
         </metanorma-extension>
              #{BOILERPLATE.sub(/<legal-statement/, "#{BOILERPLATE_LICENSE}\n<legal-statement").sub(/#{Date.today.year} Messaging, Malware and Mobile Anti-Abuse Working Group/, '2001 Messaging, Malware and Mobile Anti-Abuse Working Group')}
      <sections/>
      </m3d-standard>
    OUTPUT
    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to xmlpp(output)
  end

  it "strips inline header" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}
      This is a preamble

      == Section 1
    INPUT
    output = <<~OUTPUT
      #{BLANK_HDR}
               <preface><foreword id="_" obligation="informative">
           <title>Foreword</title>
           <p id="_">This is a preamble</p>
         </foreword></preface><sections>
         <clause id="_" obligation="normative">
           <title>Section 1</title>
         </clause></sections>
         </m3d-standard>
    OUTPUT
    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to xmlpp(output)
  end

  it "uses default fonts" do
    FileUtils.rm_f "test.html"
    FileUtils.rm_f "test.doc"
    Asciidoctor.convert(<<~"INPUT", *OPTIONS)
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
      :no-pdf:
    INPUT
    html = File.read("test.html", encoding: "utf-8")
    expect(html).to match(%r[\bpre[^{]+\{[^}]+font-family: "Space Mono", monospace;]m)
    expect(html).to match(%r[ div[^{]+\{[^}]+font-family: "Overpass", sans-serif;]m)
    expect(html).to match(%r[h1, h2, h3, h4, h5, h6 \{[^}]+font-family: "Overpass", sans-serif;]m)
    html = File.read("test.doc", encoding: "utf-8")
    expect(html).to match(%r[\bpre[^{]+\{[^}]+font-family: "Courier New", monospace;]m)
    expect(html).to match(%r[ div[^{]+\{[^}]+font-family: "EB Garamond", serif;]m)
    expect(html).to match(%r[h1 \{[^}]+font-family: "EB Garamond", serif;]m)
  end

  it "uses specified fonts" do
    FileUtils.rm_f "test.html"
    Asciidoctor.convert(<<~"INPUT", *OPTIONS)
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
      :script: Hans
      :body-font: Zapf Chancery
      :header-font: Comic Sans
      :monospace-font: Andale Mono
      :no-pdf:
    INPUT
    html = File.read("test.html", encoding: "utf-8")
    expect(html).to match(%r[\bpre[^{]+\{[^{]+font-family: Andale Mono;]m)
    expect(html).to match(%r[ div[^{]+\{[^}]+font-family: Zapf Chancery;]m)
    expect(html).to match(%r[h1, h2, h3, h4, h5, h6 \{[^}]+font-family: Comic Sans;]m)
  end
end
