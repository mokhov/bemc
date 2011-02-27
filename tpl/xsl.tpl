<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:x="http://www.yandex.ru/xscript"
    xmlns:lego="https://lego.yandex-team.ru"
    exclude-result-prefixes=" x lego "
    version="1.0">

<xsl:template match="%block%">
    <div>
        <xsl:apply-templates select="." mode="lego:block-attributes"/>
        <xsl:apply-templates select="." mode="lego:content"/>
    </div>
</xsl:template>

<xsl:template match="%block%" mode="lego:content">
    <div style="color:red">FIXME: или напишите содержимое блока, или удалите этот шаблон</div>
</xsl:template>

</xsl:stylesheet>
