const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");
const app = express();
const port = 5000;
const axios = require("axios");
const { parseString } = require("xml2js");

app.use(bodyParser.json());
app.use(cors());
app.use(function (req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header(
    "Access-Control-Allow-Headers",
    "Origin,X-Requested-with,Content-Type,Accept"
  );
  next();
});
app.listen(port, () => {
  console.log(`Server listening on port ${port}`);
});

// ################ LOGIN BACKEND #########################################

app.post("/login", async (req, res) => {
  try {
    var username = req.body.user;
    var password = req.body.pass;
    // console.log(req.body);
    const url =
      "http://dxktpipo.kaarcloud.com:50000/XISOAPAdapter/MessageServlet?senderParty=&senderService=BC_SCB_VENDOR_LOGIN&receiverParty=&receiverService=&interface=SI_SCB_VENDOR_LOGIN&interfaceNamespace=http://subas.com/vendor_login";
    var reqData = `<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:sap-com:document:sap:rfc:functions">
   <soapenv:Header/>
   <soapenv:Body>
      <urn:ZFM_VEN_LOGIN>
         <IM_VENDOR_ID>${username}</IM_VENDOR_ID>
         <IM_PASS>${password}</IM_PASS>
      </urn:ZFM_VEN_LOGIN>
   </soapenv:Body>
</soapenv:Envelope>`;
    pipo_res = axios({
      url: url,
      method: "POST",
      mode: "cors",
      cache: "no-cache",
      credentials: "include",
      headers: {
        Authorization: "Basic cG91c2VyQDE6MjAyMkBUZWNo",
        "Content-Type": "application/xml",
      },
      data: reqData,
    }).then((r) => {
      var xmlData = r.data;
      parseString(xmlData, function (err, result) {
        var jsonData = result;

        var status =
          jsonData["SOAP:Envelope"]["SOAP:Body"][0][
            "ns0:ZFM_VEN_LOGIN.Response"
          ][0]["RETURN"][0];
        var name =
          jsonData["SOAP:Envelope"]["SOAP:Body"][0][
            "ns0:ZFM_VEN_LOGIN.Response"
          ][0]["NAME"][0];
        // console.log({ status: status, name: name });
        res.send({ status: status, name: name });
      });
    });
  } catch (error) {
    res.send(error);
  }
});

// ######################## WORK ORDER #################################

app.post("/workorder", async (req, res) => {
  try {
    // console.log(req.body);
    const url =
      "http://dxktpipo.kaarcloud.com:50000/XISOAPAdapter/MessageServlet?senderParty=&senderService=BC_SCB_MAINT_WO&receiverParty=&receiverService=&interface=SI_MAINT_WORD_ORDER&interfaceNamespace=http://subash.com/Maintenance_Portal";
    var reqData = `<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:sap-com:document:sap:rfc:functions">
    <soapenv:Header/>
    <soapenv:Body>
       <urn:ZFM_WO_LIST>
          <PLANT>0001</PLANT>
       </urn:ZFM_WO_LIST>
    </soapenv:Body>
 </soapenv:Envelope>`;
    pipo_res = axios({
      url: url,
      method: "POST",
      mode: "cors",
      cache: "no-cache",
      credentials: "include",
      headers: {
        Authorization: "Basic cG91c2VyQDE6MjAyMkBUZWNo",
        "Content-Type": "application/xml",
      },
      data: reqData,
    }).then((r) => {
      var xmlData = r.data;
      parseString(xmlData, function (err, result) {
        var jsonData = result;
        var _return = 0;
        var _return =
          jsonData["SOAP:Envelope"]["SOAP:Body"][0][
            "ns0:ZFM_WO_LIST.Response"
          ][0]["IT_RESULT"][0]["item"];
        var table = [];
        for (let i = 0; i < _return.length; i++) {
          var ORDERID =
            jsonData["SOAP:Envelope"]["SOAP:Body"][0][
              "ns0:ZFM_WO_LIST.Response"
            ][0]["IT_RESULT"][0]["item"][i]["ORDERID"][0];
          var DESCRIPTION =
            jsonData["SOAP:Envelope"]["SOAP:Body"][0][
              "ns0:ZFM_WO_LIST.Response"
            ][0]["IT_RESULT"][0]["item"][i]["DESCRIPTION"][0];
          var WORK_CNTR =
            jsonData["SOAP:Envelope"]["SOAP:Body"][0][
              "ns0:ZFM_WO_LIST.Response"
            ][0]["IT_RESULT"][0]["item"][i]["WORK_CNTR"][0];
          var CONTROL_KEY =
            jsonData["SOAP:Envelope"]["SOAP:Body"][0][
              "ns0:ZFM_WO_LIST.Response"
            ][0]["IT_RESULT"][0]["item"][i]["CONTROL_KEY"][0];
          var S_STATUS =
            jsonData["SOAP:Envelope"]["SOAP:Body"][0][
              "ns0:ZFM_WO_LIST.Response"
            ][0]["IT_RESULT"][0]["item"][i]["S_STATUS"][0];
          var ORDER_TYPE =
            jsonData["SOAP:Envelope"]["SOAP:Body"][0][
              "ns0:ZFM_WO_LIST.Response"
            ][0]["IT_RESULT"][0]["item"][i]["ORDER_TYPE"][0];

          table.push({
            ORDERID: ORDERID,
            DESCRIPTION: DESCRIPTION,
            WORK_CNTR: WORK_CNTR,
            CONTROL_KEY: CONTROL_KEY,
            S_STATUS: S_STATUS,
            ORDER_TYPE: ORDER_TYPE,
          });
        }

        // console.log(_return);
        res.send({ _return: table });
      });
    });
  } catch (error) {
    res.send(error);
  }
});

// ############################### NOTIFICATIONS #############################

app.post("/notification", async (req, res) => {
  try {
    // console.log(req.body);
    const url =
      "http://dxktpipo.kaarcloud.com:50000/XISOAPAdapter/MessageServlet?senderParty=&senderService=BC_SCB_NOTIFICATION&receiverParty=&receiverService=&interface=SI_SCB_NOTIFICATION&interfaceNamespace=http://subash.com/Maint_notification";
    var reqData = `<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:sap-com:document:sap:rfc:functions">
    <soapenv:Header/>
    <soapenv:Body>
       <urn:ZFM_MAINT_NOTIF_LIST>
          <DATE>2023-03-12</DATE>
          <GROUP>010</GROUP>
          <PLANT>0001</PLANT>
       </urn:ZFM_MAINT_NOTIF_LIST>
    </soapenv:Body>
 </soapenv:Envelope>`;
    pipo_res = axios({
      url: url,
      method: "POST",
      mode: "cors",
      cache: "no-cache",
      credentials: "include",
      headers: {
        Authorization: "Basic cG91c2VyQDE6MjAyMkBUZWNo",
        "Content-Type": "application/xml",
      },
      data: reqData,
    }).then((r) => {
      var xmlData = r.data;
      parseString(xmlData, function (err, result) {
        var jsonData = result;
        var _return = 0;
        var _return =
          jsonData["SOAP:Envelope"]["SOAP:Body"][0][
            "ns0:ZFM_MAINT_NOTIF_LIST.Response"
          ][0]["RESULT"][0]["item"];
        var table = [];
        for (let i = 0; i < _return.length; i++) {
          var NOTIFICAT =
            jsonData["SOAP:Envelope"]["SOAP:Body"][0][
              "ns0:ZFM_MAINT_NOTIF_LIST.Response"
            ][0]["RESULT"][0]["item"][i]["NOTIFICAT"][0];
          var NOTIF_TYPE =
            jsonData["SOAP:Envelope"]["SOAP:Body"][0][
              "ns0:ZFM_MAINT_NOTIF_LIST.Response"
            ][0]["RESULT"][0]["item"][i]["NOTIF_TYPE"][0];
          var DESCRIPT =
            jsonData["SOAP:Envelope"]["SOAP:Body"][0][
              "ns0:ZFM_MAINT_NOTIF_LIST.Response"
            ][0]["RESULT"][0]["item"][i]["DESCRIPT"][0];
          var S_STATUS =
            jsonData["SOAP:Envelope"]["SOAP:Body"][0][
              "ns0:ZFM_MAINT_NOTIF_LIST.Response"
            ][0]["RESULT"][0]["item"][i]["S_STATUS"][0];
          var FUNCLDESCR =
            jsonData["SOAP:Envelope"]["SOAP:Body"][0][
              "ns0:ZFM_MAINT_NOTIF_LIST.Response"
            ][0]["RESULT"][0]["item"][i]["FUNCLDESCR"][0];
          var NOTIFDATE =
            jsonData["SOAP:Envelope"]["SOAP:Body"][0][
              "ns0:ZFM_MAINT_NOTIF_LIST.Response"
            ][0]["RESULT"][0]["item"][i]["NOTIFDATE"][0];
          var NOTIFTIME =
            jsonData["SOAP:Envelope"]["SOAP:Body"][0][
              "ns0:ZFM_MAINT_NOTIF_LIST.Response"
            ][0]["RESULT"][0]["item"][i]["NOTIFTIME"][0];
          var STARTDATE =
            jsonData["SOAP:Envelope"]["SOAP:Body"][0][
              "ns0:ZFM_MAINT_NOTIF_LIST.Response"
            ][0]["RESULT"][0]["item"][i]["STARTDATE"][0];

          table.push({
            NOTIFICAT: NOTIFICAT,
            NOTIF_TYPE: NOTIF_TYPE,
            DESCRIPT: DESCRIPT,
            S_STATUS: S_STATUS,
            FUNCLDESCR: FUNCLDESCR,
            NOTIFDATE: NOTIFDATE,
            NOTIFTIME: NOTIFTIME,
            STARTDATE: STARTDATE,
          });
        }

        // console.log(_return);
        res.send({ _return: table });
      });
    });
  } catch (error) {
    res.send(error);
  }
});
