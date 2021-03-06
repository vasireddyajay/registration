 <%--
 *  Copyright 2009 Society for Health Information Systems Programmes, India (HISP India)
 *
 *  This file is part of Registration module.
 *
 *  Registration module is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.

 *  Registration module is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with Registration module.  If not, see <http://www.gnu.org/licenses/>.
 *
--%> 
<%@ include file="/WEB-INF/template/include.jsp" %>
<%@ page import="java.util.Map" %>
<%@ page import="org.openmrs.Patient" %>
<%@ page import="org.openmrs.module.hospitalcore.util.PatientUtils"%>

<script type="text/javascript">
	
	PATIENTSEARCHRESULT = {
		oldBackgroundColor: "",
		
		/** Click to view patient info */
		visit: function(patientId){			
			window.location.href = openmrsContextPath + "/module/registration/showPatientInfo.form?patientId=" + patientId;
		},
		
		/** Edit a patient */
		editPatient: function(patientId){
			window.location.href = openmrsContextPath + "/module/registration/editPatient.form?patientId=" + patientId;
		},
		
		reprint: function(patientId){
			window.location.href = openmrsContextPath + "/module/registration/showPatientInfo.form?patientId=" + patientId + "&reprint=true";
		}
	};
	
	jQuery(document).ready(function(){
	
		// hover rows
		jQuery(".patientSearchRow").hover(
			function(event){					
				obj = event.target;
				while(obj.tagName!="TR"){
					obj = obj.parentNode;
				}
				PATIENTSEARCHRESULT.oldBackgroundColor = jQuery(obj).css("background-color");
				jQuery(obj).css("background-color", "#00FF99");									
			}, 
			function(event){
				obj = event.target;
				while(obj.tagName!="TR"){
					obj = obj.parentNode;
				}
				jQuery(obj).css("background-color", PATIENTSEARCHRESULT.oldBackgroundColor);				
			}
		);
		
		// insert images
		jQuery(".editImage").each(function(index, value){
			jQuery(this).attr("src", openmrsContextPath + "/images/edit.gif");
		});		
	});
</script>

<c:choose>
	<c:when test="${not empty patients}" >		
	<table style="width:100%">
		<tr>
			<openmrs:hasPrivilege privilege="Edit Patients">
				<td style="text-align:center;"><b>Edit</b></td>
			</openmrs:hasPrivilege>		
			<td style="text-align:center;"><b>Identifier</b></td>
			<td style="text-align:center;"><b>Name</b></td>
			<td style="text-align:center;"><b>Age</b></td>
			<td style="text-align:center;"><b>Gender</b></td>			
			<td style="text-align:center;"><b>Birthdate</b></td>
			<td style="text-align:center;"><b>Relative Name</b></td>
			<td style="text-align:center;"><b>Reprint</b></td>
		</tr>
		<c:forEach items="${patients}" var="patient" varStatus="varStatus">
			<tr class='${varStatus.index % 2 == 0 ? "oddRow" : "evenRow" } patientSearchRow'>
				<openmrs:hasPrivilege privilege="Edit Patients">
					<td onclick="PATIENTSEARCHRESULT.editPatient(${patient.patientId});">
						<center>
							<img class="editImage" title="Edit patient information"/>
						</center>
					</td>
				</openmrs:hasPrivilege>		
				<td onclick="PATIENTSEARCHRESULT.visit(${patient.patientId});">
					${patient.patientIdentifier.identifier}
				</td>
				<td onclick="PATIENTSEARCHRESULT.visit(${patient.patientId});">${patient.givenName} ${patient.middleName} ${patient.familyName}</td>
				<td style="text-align:center;" onclick="PATIENTSEARCHRESULT.visit(${patient.patientId});"> 
                	<%
						Patient patient = (Patient) pageContext.getAttribute("patient");
						out.print(PatientUtils.estimateAge(patient));
					%>
                </td>
				<td style="text-align:center;" onclick="PATIENTSEARCHRESULT.visit(${patient.patientId});">
					<c:choose>
                		<c:when test="${patient.gender eq 'M'}">
							<img src="${pageContext.request.contextPath}/images/male.gif"/>
						</c:when>
                		<c:otherwise><img src="${pageContext.request.contextPath}/images/female.gif"/></c:otherwise>
                	</c:choose>
				</td>                
				<td style="text-align:center;" onclick="PATIENTSEARCHRESULT.visit(${patient.patientId});"> 
                	<openmrs:formatDate date="${patient.birthdate}"/>
                </td>
				<td onclick="PATIENTSEARCHRESULT.visit(${patient.patientId});"> 
                	<%
						// Patient patient = (Patient) pageContext.getAttribute("patient");
						Map<Integer, Map<Integer, String>> attributes = (Map<Integer, Map<Integer, String>>) pageContext.findAttribute("attributeMap");						
						Map<Integer, String> patientAttributes = (Map<Integer, String>) attributes.get(patient.getPatientId());						
						String relativeName = patientAttributes.get(8); 
						if(relativeName!=null)
							out.print(relativeName);
					%>
                </td>
				<td onclick="PATIENTSEARCHRESULT.reprint(${patient.patientId});"> 
					<center>
						<img src="${pageContext.request.contextPath}/moduleResources/registration/print.png"/>
					</center>                	
                </td>
			</tr>
		</c:forEach>
	</table>
	</c:when>
	<c:otherwise>
	No Patient found.
	</c:otherwise>
</c:choose>