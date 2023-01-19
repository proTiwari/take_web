import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class AgreementDocument extends StatefulWidget {
  @override
  State<AgreementDocument> createState() => _AgreementDocumentState();
}

const htmlData = r"""
<p><h2>RunForRent Policy Agreement</h2></p>
<br>
<p>This policy agreement (the &quot;Agreement&quot;) outlines the terms and conditions under which RunForRent (&quot;Company&quot;) will provide rental property and seller property services to its clients. Please read this Agreement carefully before accepting it. By accepting this Agreement, you agree to be bound by its terms and conditions.</p>

<p><h4><b>Scope of Services</b></h4> <br>The Company will provide the following services to its clients: Finding and securing suitable rental and seller properties for clients, Assisting with any issue regarding this service.</p>

<p><h4><b>Disclaimer of Warranties</h4></b><br> The Company makes no representations or warranties of any kind, express or implied, regarding the rental properties or the services provided under this Agreement. The Company shall not be liable for any damages or losses of any kind arising from or in connection with the use of the rental properties or the services provided under this Agreement.</p>

<p><h4><b>Indemnification</h4></b><br> You agree to indemnify and hold the Company, its affiliates, and their respective officers, agents, and employees, harmless from any claim or demand, including reasonable attorneys' fees, made by any third party due to or arising out of your use of the rental properties or the services provided under this Agreement.</p>

<p><h4><b>Governing Law This Agreement</h4></b><br> shall be governed by and construed in accordance with the laws of the Indian Constitution.</p>

<p>By accepting this Agreement, you acknowledge that you have read and understood the terms and conditions outlined above and agree to be bound by them.</p>

<p>25 Dec 2022<br> SHUBHAM TIWARI (CEO)</p>
""";

class _AgreementDocumentState extends State<AgreementDocument> {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agreement'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Html(
          data: htmlData,
          tagsList: Html.tags..addAll(["bird", "flutter"]),
        ),
      ),
    );
  }
}
