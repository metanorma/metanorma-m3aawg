require "spec_helper"
require "metanorma"
require "fileutils"

RSpec.describe Metanorma::M3AAWG::Processor do
  registry = Metanorma::Registry.instance
  registry.register(Metanorma::M3AAWG::Processor)
  processor = registry.find_processor(:m3aawg)

  it "registers against metanorma" do
    expect(processor).not_to be nil
  end

  it "registers output formats against metanorma" do
    expect(processor.output_formats.sort).to eq [[:doc, "doc"], [:html, "html"],
                                                 [:pdf, "pdf"], [:presentation, "presentation.xml"],
                                                 [:rxl, "rxl"], [:xml, "xml"]]
  end

  it "registers version against metanorma" do
    expect(processor.version.to_s).to match(%r{^Metanorma::M3AAWG })
  end

  it "generates IsoDoc XML from a blank document" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}
    INPUT
    output = <<~OUTPUT
<?xml version="1.0" encoding="UTF-8"?>
<metanorma xmlns="https://www.metanorma.org/ns/standoc" type="semantic" version="#{Metanorma::M3AAWG::VERSION}" flavor="m3aawg">
  <bibdata type="standard">
    <title language="en" type="main">Document title</title>
    <docidentifier primary="true" type="M3AAWG">:2026</docidentifier>
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
    <language>en</language>
    <script>Latn</script>
    <status>
      <stage>published</stage>
    </status>
    <copyright>
      <from>2026</from>
      <owner>
        <organization>
          <name>Messaging Malware and Mobile Anti-Abuse Working Group</name>
          <abbreviation>M3AAWG</abbreviation>
        </organization>
      </owner>
    </copyright>
    <ext>
      <doctype>report</doctype>
      <flavor>m3aawg</flavor>
    </ext>
  </bibdata>
  <metanorma-extension>
    <semantic-metadata>
      <stage-published>true</stage-published>
    </semantic-metadata>
    <presentation-metadata>
      <toc-heading-levels>2</toc-heading-levels>
      <html-toc-heading-levels>2</html-toc-heading-levels>
      <doc-toc-heading-levels>2</doc-toc-heading-levels>
      <pdf-toc-heading-levels>2</pdf-toc-heading-levels>
    </presentation-metadata>
  </metanorma-extension>
  <boilerplate>
    <copyright-statement>
      <clause>
        <p id="_">© 2026 Messaging, Malware and Mobile Anti-Abuse Working Group</p>
      </clause>
    </copyright-statement>
    <legal-statement>
      <clause>
        <p id="_">All rights reserved. Unless otherwise specified, no part of this         publication may be reproduced or utilized otherwise in any form or by any         means, electronic or mechanical, including photocopying, or posting on the         internet or an intranet, without prior written permission. Permission can         be requested from the address below.</p>
      </clause>
    </legal-statement>
    <feedback-statement>
      <p id="boilerplate-name">Messaging, Malware and Mobile Anti-Abuse Working Group</p>
      <p class="boilerplate-address" id="_">       781 Beach Street, Suite 302<br/>       San Francisco<br/>       California 94109<br/>       United States of America<br/><br/><link target="https://www.m3aawg.org">www.m3aawg.org</link></p>
    </feedback-statement>
  </boilerplate>
  <sections/>
</metanorma>
    OUTPUT
    expect(xmlpp(strip_guid(processor
      .input_to_isodoc(input, nil))))
      .to be_xml_equivalent_to xmlpp(output)
  end

  it "generates HTML from IsoDoc XML" do
    FileUtils.rm_f "test.xml"
    processor.output(<<~"INPUT", "test.xml", "test.html", :html)
              <m3d-standard xmlns="http://riboseinc.com/isoxml">
      <sections>
      <terms id="H" obligation="normative"><title>1.<tab/>Terms, Definitions, Symbols and Abbreviated Terms</title>
        <term id="J">
        <name>1.1.</name>
        <preferred>Term2</preferred>
      </term>
       </terms>
       </sections>
       </m3d-standard>
    INPUT
    expect(xmlpp(strip_guid(File.read("test.html", encoding: "utf-8")
      .gsub(%r{^.*<main}m, "<main")
      .gsub(%r{</main>.*}m, "</main>"))))
      .to be_xml_equivalent_to xmlpp(strip_guid(<<~"OUTPUT"))
<?xml version="1.0" encoding="UTF-8"?>
<main class="main-section"/>
      OUTPUT
  end
end
