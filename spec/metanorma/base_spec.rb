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
    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_xml_equivalent_to xmlpp(output)
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
  <sections>
    <clause id="_" obligation="normative">
      <title id="_">Clause</title>
    </clause>
  </sections>
</metanorma>
    OUTPUT
    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_xml_equivalent_to xmlpp(output)
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
<metanorma xmlns="https://www.metanorma.org/ns/standoc" type="semantic" version="#{Metanorma::M3AAWG::VERSION}" flavor="m3aawg">
  <bibdata type="standard">
    <title language="en" type="main">Main Title</title>
    <uri>http://www.m3aawg.org/BlocklistHelp</uri>
    <docidentifier primary="true" type="M3AAWG">1000(wd):2001</docidentifier>
    <docnumber>1000</docnumber>
    <date type="updated">
      <on>2000-01-01</on>
    </date>
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
    <version>3.4</version>
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
      <flavor>m3aawg</flavor>
    </ext>
  </bibdata>
  <metanorma-extension>
    <semantic-metadata>
      <stage-published>false</stage-published>
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
        <p id="_">© 2001 Messaging, Malware and Mobile Anti-Abuse Working Group</p>
      </clause>
    </copyright-statement>
    <license-statement>
      <clause>
        <title>Warning for Drafts</title>
        <p id="_">This document is not an M3AAWG Standard. It is distributed for review and         comment, and is subject to change without notice and may not be referred to as         a Standard. Recipients of this draft are invited to submit, with their         comments, notification of any relevant patent rights of which they are aware         and to provide supporting documentation.</p>
      </clause>
    </license-statement>
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
    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_xml_equivalent_to xmlpp(output)
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
<?xml version="1.0" encoding="UTF-8"?>
<metanorma xmlns="https://www.metanorma.org/ns/standoc" type="semantic" version="#{Metanorma::M3AAWG::VERSION}" flavor="m3aawg">
  <bibdata type="standard">
    <title language="en" type="main">Main Title</title>
    <docidentifier primary="true" type="M3AAWG">1000(cd):2026</docidentifier>
    <docnumber>1000</docnumber>
    <date type="updated">
      <on>2000-01-01</on>
    </date>
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
    <version>3.4</version>
    <language>en</language>
    <script>Latn</script>
    <status>
      <stage>committee-draft</stage>
      <iteration>3</iteration>
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
      <stage-published>false</stage-published>
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
    <license-statement>
      <clause>
        <title>Warning for Drafts</title>
        <p id="_">This document is not an M3AAWG Standard. It is distributed for review and         comment, and is subject to change without notice and may not be referred to as         a Standard. Recipients of this draft are invited to submit, with their         comments, notification of any relevant patent rights of which they are aware         and to provide supporting documentation.</p>
      </clause>
    </license-statement>
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
    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_xml_equivalent_to xmlpp(output)
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
<?xml version="1.0" encoding="UTF-8"?>
<metanorma xmlns="https://www.metanorma.org/ns/standoc" type="semantic" version="#{Metanorma::M3AAWG::VERSION}" flavor="m3aawg">
  <bibdata type="standard">
    <title language="en" type="main">Main Title</title>
    <docidentifier primary="true" type="M3AAWG">1000(d):2026</docidentifier>
    <docnumber>1000</docnumber>
    <date type="updated">
      <on>2000-01-01</on>
    </date>
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
    <version>3.4</version>
    <language>en</language>
    <script>Latn</script>
    <status>
      <stage>draft-standard</stage>
      <iteration>3</iteration>
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
      <stage-published>false</stage-published>
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
    <license-statement>
      <clause>
        <title>Warning for Drafts</title>
        <p id="_">This document is not an M3AAWG Standard. It is distributed for review and         comment, and is subject to change without notice and may not be referred to as         a Standard. Recipients of this draft are invited to submit, with their         comments, notification of any relevant patent rights of which they are aware         and to provide supporting documentation.</p>
      </clause>
    </license-statement>
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
    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_xml_equivalent_to xmlpp(output)
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
<?xml version="1.0" encoding="UTF-8"?>
<metanorma xmlns="https://www.metanorma.org/ns/standoc" type="semantic" version="#{Metanorma::M3AAWG::VERSION}" flavor="m3aawg">
  <bibdata type="standard">
    <title language="en" type="main">Main Title</title>
    <docidentifier primary="true" type="M3AAWG">1000:2001</docidentifier>
    <docnumber>1000</docnumber>
    <date type="updated">
      <on>2000-01-01</on>
    </date>
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
    <version>3.4</version>
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
      <flavor>m3aawg</flavor>
    </ext>
  </bibdata>
  <metanorma-extension>
    <semantic-metadata>
      <stage-published>false</stage-published>
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
        <p id="_">© 2001 Messaging, Malware and Mobile Anti-Abuse Working Group</p>
      </clause>
    </copyright-statement>
    <license-statement>
      <clause>
        <title>Warning for Drafts</title>
        <p id="_">This document is not an M3AAWG Standard. It is distributed for review and         comment, and is subject to change without notice and may not be referred to as         a Standard. Recipients of this draft are invited to submit, with their         comments, notification of any relevant patent rights of which they are aware         and to provide supporting documentation.</p>
      </clause>
    </license-statement>
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
    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_xml_equivalent_to xmlpp(output)
  end

  it "strips inline header" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}
      This is a preamble

      == Section 1
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
  <preface>
    <foreword id="_" obligation="informative">
      <title id="_">Foreword</title>
      <p id="_">This is a preamble</p>
    </foreword>
  </preface>
  <sections>
    <clause id="_" obligation="normative">
      <title id="_">Section 1</title>
    </clause>
  </sections>
</metanorma>
    OUTPUT
    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_xml_equivalent_to xmlpp(output)
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
