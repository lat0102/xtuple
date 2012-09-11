/*jshint indent:2, curly:true eqeqeq:true, immed:true, latedef:true,
newcap:true, noarg:true, regexp:true, undef:true, strict:true, trailing:true
white:true*/
/*global XT:true, XM:true, Backbone:true, _:true, console:true */

(function () {
  "use strict";

  /**
    @class

    @extends XM.Model
  */
  XM.IncidentProject = XM.Model.extend(
    /** @scope XM.IncidentProject.prototype */ {

    recordType: 'XM.IncidentProject',

    isDocumentAssignment: true

  });

}());
