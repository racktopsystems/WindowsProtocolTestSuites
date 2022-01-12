<xsl:stylesheet version="1.0"  
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:t="http://microsoft.com/schemas/VisualStudio/TeamTest/2010"
                >

<xsl:template match="/">
<xsl:comment>
  use like this:
  xsltproc -o ~/Temp/wpts-results.html ~/Temp/wpts.xsl ~/Downloads/_smbtest_2021-12-08_17_28_23.trx
</xsl:comment>

  <html>
  <head>
        <style type="text/css">
            h2 {color: sienna}
            .resultsHdrRow { font-face: arial; padding: 5px }
            .resultsRow { font-face: arial; padding: 5px }
            </style>
    </head>
  <body>
    <h2>Test Results</h2>
    <h3>Summary</h3>
        <ul>
            <li>Tests found:    <xsl:value-of select="t:TestRun/t:ResultSummary/t:Counters/@total"/></li>
            <li>Tests executed: <xsl:value-of select="t:TestRun/t:ResultSummary/t:Counters/@executed"/></li>
            <li>Tests passed:   <xsl:value-of select="t:TestRun/t:ResultSummary/t:Counters/@passed"/></li>
            <li>Tests Failed:   <xsl:value-of select="t:TestRun/t:ResultSummary/t:Counters/@failed"/></li>

        </ul>
    <table border="1" width="80%" >
        <tr  class="resultsHdrRow">
          <th align="left">Test</th>
          <th align="left">Outcome</th>
        </tr>
        <xsl:for-each select="/t:TestRun/t:Results/t:UnitTestResult" >
	<xsl:sort select="@testName"/>
        <tr valign="top" class="resultsRow">
            <td><xsl:value-of select="@testName"/></td>
	    <td><xsl:value-of select="@outcome"/></td> 
        </tr>
        </xsl:for-each>
    </table>
  </body>
  </html>
</xsl:template>

</xsl:stylesheet>
