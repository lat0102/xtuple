select xt.install_js('XM','Model','xtuple', $$
  /* Copyright (c) 1999-2011 by OpenMFG LLC, d/b/a xTuple. 
     See www.xm.ple.com/CPAL for the full text of the software license. */

  XM.Model = {};
  
  XM.Model.isDispatchable = true;

  /** 
    Deterimine if a specific record can be read. 

    @param {String} Record type
    @param {Number|String} Id
    @returns Boolean
  */
  XM.Model.canRead = function(recordType, id) {
    if (typeof recordType === 'object') {
      id = recordType.id;
      recordType = recordType.recordType;
    }
    var data = new Object(XT.Data),
      record = data.retrieveRecord(recordType, id, null, {silentError: true}),
      prop;
    for (prop in record) { 
      if (record.hasOwnProperty(prop)) {
        return true;
      }
    }
    return false;
  }

  /** 
    Pass in a record type and get the next id for that type 

    @param {String} record type
    @returns Number
  */
  XM.Model.fetchId = function(recordType) { 
    var nameSpace = recordType.beforeDot(),
        type = recordType.afterDot(),
        map = XT.Orm.fetch(nameSpace, type),
        seq = map.idSequenceName,
        sql = 'select nextval($1) as result';

    return seq ? plv8.execute(sql, [seq])[0].result : false;
  }

  /**
    Pass in a record type and get the next id for that type 

    @param {String} record type
    @returns Number
  */
  XM.Model.fetchNumber = function(recordType) {
    var nameSpace = recordType.beforeDot(),
        type = recordType.afterDot(),
        map = XT.Orm.fetch(nameSpace, type),
        seq = map.orderSequence,
        sql = 'select fetchNextNumber($1) as result';

    return seq ? plv8.execute(sql, [seq])[0].result : false;
  }

  /**
    Release a number back into the sequence pool for a given type. 

    @param {String} record type
    @param {Number} number
    @returns Boolean
  */
  XM.Model.releaseNumber = function(recordType, number) {
    var nameSpace = recordType.beforeDot(),
        type = recordType.afterDot(),
        map = XT.Orm.fetch(nameSpace, type),
        seq = map.orderSequence,
        sql = 'select releaseNumber($1, $2) as result';

    return seq ? plv8.execute(sql, [seq, number - 0])[0].result > 0 : false;
  }

  /**
    Return a matching record id for a passed user key and value. If none found returns zero.

    @param {String} record type
    @param {String} user key
    @param {Number} value
    @returns Number
  */
  XM.Model.findExisting = function(recordType, key, value, id) {
    var nameSpace = recordType.beforeDot(),
        type = recordType.afterDot(),
        map = XT.Orm.fetch(nameSpace, type),
        table = recordType.decamelize(),
        pKey = XT.Orm.primaryKey(map),
        sql = 'select {primaryKey} as id from {table} where {userKey}::text=$1::text and {primaryKey} != $2'
              .replace(/{primaryKey}/g, pKey)
              .replace(/{table}/, table)
              .replace(/{userKey}/, key)
              .replace(/{value}/, value)
              .replace(/{id}/, id),
        result = plv8.execute(sql, [value, id])[0];

    return result ? result.id : 0;
  }
  
$$ );

