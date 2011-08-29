#set( $symbol_dollar = '$' )
<%--

    Copyright (C) 2000 - 2011 Silverpeas

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as
    published by the Free Software Foundation, either version 3 of the
    License, or (at your option) any later version.

    As a special exception to the terms and conditions of version 3.0 of
    the GPL, you may redistribute this Program in connection with Free/Libre
    Open Source Software ("FLOSS") applications as described in Silverpeas's
    FLOSS exception.  You should have received a copy of the text describing
    the FLOSS exception, and it is also available here:
    "http://repository.silverpeas.com/legal/licensing"

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

--%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.util.*"%>
<%@ page import="com.silverpeas.util.StringUtil"%>
<%@ page import="com.silverpeas.util.EncodeHelper"%>
<%@ page import="com.stratelia.webactiv.util.*"%>
<%@ page import="com.stratelia.silverpeas.peasCore.URLManager"%>
<%@ page import="${package}.Look${className}Helper"%>
<%@ page import="com.stratelia.webactiv.util.viewGenerator.html.buttons.Button"%>
<%@ page import="com.stratelia.webactiv.util.viewGenerator.html.GraphicElementFactory"%>

<%@ page import="com.stratelia.silverpeas.authentication.*"%>
<%@ page import="com.silverpeas.look.LookHelper" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.silverpeas.com/tld/viewGenerator" prefix="view"%>

<%-- Retrieve user menu display mode --%>
<c:set var="curHelper" value="${symbol_dollar}{sessionScope.Silverpeas_LookHelper}" />
<%-- Set resource bundle --%>
<fmt:setLocale value="${symbol_dollar}{sessionScope['SilverSessionController'].favoriteLanguage}" />
<view:setBundle basename="com.silverpeas.customers.${rootArtifactId}.look.multilang.${className}Bundle"/>

<%
String          m_sContext      = URLManager.getApplicationURL();

GraphicElementFactory   gef         = (GraphicElementFactory) session.getAttribute(GraphicElementFactory.GE_FACTORY_SESSION_ATT);
LookHelper  helper        = (LookHelper) session.getAttribute(LookHelper.SESSION_ATT);

String spaceId    = request.getParameter("privateDomain");
String componentId  = request.getParameter("component_id");

if (!StringUtil.isDefined(spaceId) && StringUtil.isDefined(componentId))
{
  spaceId = helper.getSpaceId(componentId);
}

ResourceLocator resourceSearchEngine = new ResourceLocator("com.stratelia.silverpeas.pdcPeas.settings.pdcPeasSettings", "");
int autocompletionMinChars = resourceSearchEngine.getInteger("autocompletion.minChars", 3);

//Is "forgotten password" feature active ?
ResourceLocator authenticationBundle = new ResourceLocator("com.silverpeas.authentication.multilang.authentication", "");
ResourceLocator general	= new ResourceLocator("com.stratelia.silverpeas.lookAndFeel.generalLook", "");
String pwdResetBehavior = general.getString("forgottenPwdActive", "reinit");
boolean forgottenPwdActive = !pwdResetBehavior.equalsIgnoreCase("false");
String urlToForgottenPwd = m_sContext+"/CredentialsServlet/ForgotPassword";
if ("personalQuestion".equalsIgnoreCase(pwdResetBehavior)) {
  urlToForgottenPwd = m_sContext+"/CredentialsServlet/LoginQuestion";
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
   "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<view:looknfeel/>
<!-- Add JQuery mask plugin css -->
<link href="<c:url value="/util/styleSheets/jquery.loadmask.css" />" rel="stylesheet" type="text/css" />
<link href="<c:url value="/util/styleSheets/jquery.autocomplete.css" />" rel="stylesheet" type="text/css" media="screen"/>

<!-- Add RICO javascript library -->
<script type="text/javascript" src="<c:url value="/util/javaScript/animation.js" />"></script>
<script type="text/javascript" src="<c:url value="/util/ajax/prototype.js" />"></script>
<script type="text/javascript" src="<c:url value="/util/ajax/rico.js" />"></script>
<script type="text/javascript" src="<c:url value="/util/ajax/ricoAjax.js" />"></script>

<!-- Add jQuery javascript library -->
<script type="text/javascript" src="<c:url value="/util/javaScript/jquery/jquery-1.3.2.min.js"/>"></script> <!-- do not remove this line while rico is used -->
<script type="text/javascript" src="<c:url value="/util/javaScript/jquery/jquery.loadmask.js" />"></script>
<script type="text/javascript" src="<c:url value="/util/javaScript/jquery/jquery.ajaxQueue.js" />"></script>
<script type="text/javascript" src="<c:url value="/util/javaScript/jquery/jquery.autocomplete.js" />"></script>
<script type="text/javascript" src="<c:url value="/util/javaScript/jquery/jquery.bgiframe.min.js" />"></script>

<!-- Custom domains bar javascript -->
<script type="text/javascript" src="<c:url value="/util/javaScript/lookV5/navigation.js" />"></script>
<script type="text/javascript" src="<c:url value="/util/javaScript/lookV5/personalSpace.js" />"></script>
<script type="text/javascript" src="<c:url value="/util/javaScript/lookV5/login.js" />"></script>


<script type="text/javascript">

  function reloadTopBar(reload)
  {
    if (reload)
      top.topFrame.location.href='<c:url value="/${rootArtifactId}/jsp/TopBar${className}.jsp" />';
  }

    function checkSubmitToSearch(ev)
  {
    var touche = ev.keyCode;
    if (touche == 13)
      searchEngine();
  }

    function notifyAdministrators(context,compoId,users,groups)
  {
    SP_openWindow('<c:url value="/RnotificationUser/jsp/Main"><c:param name="popupMode">Yes</c:param><c:param name="editTargets">No</c:param><c:param name="theTargetsUsers">Administrators</c:param></c:url>', 'notifyUserPopup', '700', '400', 'menubar=no,scrollbars=no,statusbar=no');
  }

    function openClipboard()
  {
      document.clipboardForm.submit();
  }

  function searchEngine() {
        if (document.searchForm.query.value != "")
        {
          document.searchForm.action = '<c:url value="/RpdcSearch/jsp/AdvancedSearch" />';
          document.searchForm.submit();
        }
  }

  function advancedSearchEngine(){
    document.searchForm.action = '<c:url value="/RpdcSearch/jsp/ChangeSearchTypeToExpert" />';
    document.searchForm.submit();
  }

  var navVisible = true;
  function resizeFrame()
  {
    parent.resizeFrame('10,*');
    if (navVisible)
    {
      document.body.scroll = "no";
      document.images['expandReduce'].src="icons/silverpeasV5/extend.gif";
    }
    else
    {
      document.body.scroll = "auto";
      document.images['expandReduce'].src="icons/silverpeasV5/reduct.gif";
    }
    document.images['expandReduce'].blur();
    navVisible = !navVisible;
  }

  // Callback methods to navigation.js
    function getContext()
    {
      return "<%=m_sContext%>";
    }

    function getHomepage()
    {
      return "<%=gef.getFavoriteLookSettings().getString("defaultHomepage", "/dt")%>";
    }

    function getPersoHomepage()
    {
      return "<%=gef.getFavoriteLookSettings().getString("persoHomepage", "/dt")%>";
    }

    function getSpaceIdToInit()
    {
      return "<%=spaceId%>";
    }

    function getComponentIdToInit()
    {
      return "<%=componentId%>";
    }

    function displayComponentsIcons()
    {
      return <%=helper.getSettings("displayComponentIcons")%>;
    }

    function getPDCLabel()
    {
      return '<fmt:message key="look${className}.pdc" />';
    }

    function getLook()
    {
      return "<%=gef.getCurrentLookName()%>";
    }

    function getWallpaper()
    {
      return "<%=helper.getWallPaper(spaceId)%>";
    }

    function displayPDC()
    {
        return "<%=helper.displayPDCInNavigationFrame()%>";
    }

    function displayContextualPDC() {
        return <%=helper.displayContextualPDC()%>;
    }

    function getTopBarPage()
    {
        return "TopBar${className}.jsp";
    }

    function getFooterPage()
    {
    	return getContext()+"/RpdcSearch/jsp/ChangeSearchTypeToExpert?SearchPage=/admin/jsp/pdcSearchSilverpeasV5.jsp&";
    }

    /**
     * Reload bottom frame
     */
    function reloadSpacesBarFrame(tabId) {
      top.bottomFrame.location.href='<c:url value="/${rootArtifactId}/jsp/frameBottom${className}.jsp" />' + '&UserMenuDisplayMode=' + tabId;
    }

    function getPersonalSpaceLabels()
    {
        var labels = new Array(2);
        labels[0] = "<%=EncodeHelper.javaStringToJsString(helper.getString("look${className}.personalSpace.select"))%>";
        labels[1] = "<%=EncodeHelper.javaStringToJsString(helper.getString("look${className}.personalSpace.remove.confirm"))%>";
        labels[2] = "<%=EncodeHelper.javaStringToJsString(helper.getString("look${className}.personalSpace.add"))%>";
        return labels;
    }

    function toForgottenPassword() {
    	var form = document.getElementById("authForm");
        if (form.elements["Login"].value.length == 0) {
            alert("<%=authenticationBundle.getString("authentication.logon.loginMissing") %>");
        } else {
        	form.action = "<%=urlToForgottenPwd%>";
        	form.target = "MyMain";
        	form.submit();
        }
    }

    
  	//used by keyword autocompletion
    <%  if(resourceSearchEngine.getBoolean("enableAutocompletion", false)){ %>
    	${symbol_dollar}(document).ready(function(){
          ${symbol_dollar}("#query").autocomplete("<c:url value="/AutocompleteServlet"/>", {
                        minChars: <%=autocompletionMinChars%>,
                        max: 50,
                        autoFill: false,
                        mustMatch: false,
                        matchContains: false,
                        scrollHeight: 220
                });
          });
    <%}%>

</script>
</head>
<body class="fondDomainsBar">
<div id="redExp"><a href="javascript:resizeFrame();"><img src="icons/silverpeasV5/reduct.gif" border="0" name="expandReduce" alt="<fmt:message key="look${className}.reductExtend" />" title="<fmt:message key="look${className}.reductExtend" />"/></a></div>
<div id="domainsBar">
  <div id="recherche">
    <div id="submitRecherche">
      <form name="searchForm" action="<%=m_sContext%>/RpdcSearch/jsp/AdvancedSearch" method="post" target="MyMain">
      <input name="query" size="30" id="query"/><input type="hidden" name="mode" value="clear"/>
      <a href="javascript:searchEngine()"><img src="icons/silverpeasV5/px.gif" width="20" height="20" border="0" alt=""/></a>
      </form>
    </div>
        <div id="bodyRecherche">
            <a href="javascript:advancedSearchEngine()"><fmt:message key="look${className}.AdvancedSearch" /></a> | <a href="<%=m_sContext%>/RpdcSearch/jsp/LastResults" target="MyMain"><fmt:message key="look${className}.LastSearchResults" /></a> | <a href="#" onclick="javascript:SP_openWindow('<%=m_sContext%>/RpdcSearch/jsp/help.jsp', 'Aide', '700', '220','scrollbars=yes, resizable, alwaysRaised');"><fmt:message key="look${className}.Help" /></a>
    </div>
    </div>
  <div id="spaceTransverse"></div>
  <div id="basSpaceTransverse">
        <table border="0" cellpadding="0" cellspacing="0" width="100%">
            <tr>
                <td class="basSpacesGauche"><img src="icons/silverpeasV5/px.gif" width="8" height="8" alt=""/></td>
                <td class="basSpacesMilieu"><img src="icons/silverpeasV5/px.gif" width="8" height="8" alt=""/></td>
                <td class="basSpacesDroite"><img src="icons/silverpeasV5/px.gif" width="8" height="8" alt=""/></td>
            </tr>
        </table>
    </div>
    <div id="spaceMenuDivId">
      <c:if test="${symbol_dollar}{curHelper.menuPersonalisationEnabled}">
        <fmt:message key="look${className}.favoriteSpace.tabBookmarks" var="tabBookmarksLabel" />
        <fmt:message key="look${className}.favoriteSpace.tabAll" var="tabAllLabel" />
        <div id="tabDivId" class="tabSpace">
          <form name="spaceDisplayModeForm" action="#" method="get" >
            <input type="hidden" name="userMenuDisplayMode" id="userMenuDisplayModeId" value="<c:out value="${symbol_dollar}{curHelper.displayUserMenu}"></c:out>" />
            <input type="hidden" name="enableAllUFSpaceStates" id="enableAllUFSpaceStatesId" value="<c:out value="${symbol_dollar}{v.enableUFSContainsState}"></c:out>" />
            <input type="hidden" name="loadingMessage" id="loadingMessageId" value="<fmt:message key="look${className}.loadingSpaces" />" />
            <input type="hidden" name="noFavoriteSpaceMsg" id="noFavoriteSpaceMsgId" value="<fmt:message key="look${className}.noFavoriteSpace" />" />
          </form>

          <c:if test="${symbol_dollar}{curHelper.displayUserMenu == 'BOOKMARKS'}">
            <div id="tabsBookMarkSelectedDivId">
             <view:tabs>
               <view:tab label="${symbol_dollar}{tabBookmarksLabel}" action="javascript:openTab('BOOKMARKS');" selected="true"></view:tab>
               <view:tab label="${symbol_dollar}{tabAllLabel}" action="javascript:openTab('ALL');" selected="false"></view:tab>
             </view:tabs>
            </div>
            <div id="tabsAllSelectedDivId" style="display:none">
              <view:tabs>
               <view:tab label="${symbol_dollar}{tabBookmarksLabel}" action="javascript:openTab('BOOKMARKS');" selected="false"></view:tab>
               <view:tab label="${symbol_dollar}{tabAllLabel}" action="javascript:openTab('ALL');" selected="true"></view:tab>
              </view:tabs>
            </div>
          </c:if>
          <c:if test="${symbol_dollar}{curHelper.displayUserMenu == 'ALL'}">
            <div id="tabsBookMarkSelectedDivId" style="display:none">
             <view:tabs>
               <view:tab label="${symbol_dollar}{tabBookmarksLabel}" action="javascript:openTab('BOOKMARKS');" selected="true"></view:tab>
               <view:tab label="${symbol_dollar}{tabAllLabel}" action="javascript:openTab('ALL');" selected="false"></view:tab>
             </view:tabs>
            </div>
            <div id="tabsAllSelectedDivId">
              <view:tabs>
               <view:tab label="${symbol_dollar}{tabBookmarksLabel}" action="javascript:openTab('BOOKMARKS');" selected="false"></view:tab>
               <view:tab label="${symbol_dollar}{tabAllLabel}" action="javascript:openTab('ALL');" selected="true"></view:tab>
              </view:tabs>
            </div>
          </c:if>
        </div>
      </c:if>
      <div id="spaces">
		<center><br/><br/><fmt:message key="look${className}.loadingSpaces" /><br/><br/><img src="icons/silverpeasV5/inProgress.gif" alt="<fmt:message key="look${className}.loadingSpaces" />"/></center>
	  </div>
      <% if (!helper.isAnonymousAccess()) { %>
        <div id="spacePerso" class="spaceLevelPerso"><a class="spaceURL" href="javaScript:openMySpace();"><fmt:message key="look${className}.PersonalSpace" /></a></div>
      <% } %>
    </div>
    <div id="basSpaces">
        <table border="0" cellpadding="0" cellspacing="0" width="100%">
            <tr>
                <td class="basSpacesGauche"><img src="icons/silverpeasV5/px.gif" width="8" height="8" alt=""/></td>
                <td class="basSpacesMilieu"><img src="icons/silverpeasV5/px.gif" width="8" height="8" alt=""/></td>
                <td class="basSpacesDroite"><img src="icons/silverpeasV5/px.gif" width="8" height="8" alt=""/></td>
            </tr>
        </table>
    </div>

    <div id="loginBox">
      <form name="authForm" id="authForm" action="<%=m_sContext%>/AuthenticationServlet" method="post" target="_top">
        <table width="100%">
        <tr>
            <td align="right" valign="top">
                <% if (helper.isAnonymousAccess()) {
                    //------------------------------------------------------------------
                    // domains are used by 'selectDomain.jsp.inc'
                    // Get a LoginPasswordAuthentication object
                    LoginPasswordAuthentication lpAuth = new LoginPasswordAuthentication();
                    Hashtable domains = lpAuth.getAllDomains();
                    //------------------------------------------------------------------
                    Button button = gef.getFormButton(helper.getString("look${className}.login"), "javaScript:login();", false);
                %>
                    <table border="0" cellpadding="0" cellspacing="2">
                        <tr><td><%=helper.getString("look${className}.login")%> : </td><td><%@ include file="../../inputLogin.jsp" %></td></tr>
                        <tr><td nowrap="nowrap"><%=helper.getString("look${className}.password")%> : </td><td><%@ include file="inputPassword${className}.jsp.inc" %></td></tr>
                        <% if (domains.size() == 1) { %>
                            <tr><td colspan="2"><input type="hidden" name="DomainId" value="0"/></td></tr>
                        <% } else { %>
                            <tr><td><fmt:message key="look${className}.domain" /> : </td><td><%@ include file="../../selectDomain.jsp.inc" %></td></tr>
                        <% } %>
                        <tr>
                            <td colspan="2" align="right"><%=button.print()%></td>
                        </tr>
                    </table>
                   	 <% if (forgottenPwdActive) { %>
						<span class="forgottenPwd">
						<% if ("personalQuestion".equalsIgnoreCase(pwdResetBehavior)) { %>
							<a href="javascript:toForgottenPassword()"><%=authenticationBundle.getString("authentication.logon.passwordForgotten") %></a>
						<% } else { %>
						 	<a href="javascript:toForgottenPassword()"><%=authenticationBundle.getString("authentication.logon.passwordReinit") %></a>
						<%} %>
						</span>
					 <% } %>
                <% } else {
                    Button button = gef.getFormButton(helper.getString("look${className}.logout"), "javaScript:logout();", false);
                %>
                    <table border="0" cellpadding="0" cellspacing="2">
                        <tr><td colspan="2" align="right"><%=helper.getUserFullName()%></td></tr>
                        <tr><td colspan="2" align="right"><%=button.print()%></td></tr>
                    </table>
                <% } %>
            </td>
        </tr>
        </table>
        </form>
    </div>
</div>
<form name="clipboardForm" action="<%=m_sContext+URLManager.getURL(URLManager.CMP_CLIPBOARD)%>Idle.jsp" method="post" target="IdleFrame">
<input type="hidden" name="message" value="SHOWCLIPBOARD"/>
</form>
<!-- Form below is used only to refresh this page according to external link (ie search engine, homepage,...) -->
<form name="privateDomainsForm" action="DomainsBar${className}.jsp" method="post">
<input type="hidden" name ="component_id"/>
<input type="hidden" name ="privateDomain"/>
<input type="hidden" name ="privateSubDomain"/>
</form>
</body>
</html>