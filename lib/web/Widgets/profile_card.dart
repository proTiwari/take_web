import 'package:flutter/material.dart';
import '../pages/ownersprofile/owners_profile_page.dart';

class OwnerProfileCard extends StatelessWidget {
  var detail;
  var profileimage;
  var valuedata;
  OwnerProfileCard(this.detail, this.profileimage, this.valuedata, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OwnersProfilePage(valuedata)));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
                color: Colors.grey,
                offset: Offset(10, 15),
                blurRadius: 15,
                spreadRadius: 1)
          ],
          color: Colors.white,
          // color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(50),
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).primaryColor,
                    backgroundImage: profileimage == null
                        ? const NetworkImage("")
                        : NetworkImage(profileimage),
                    child: Text(
                      detail["ownername"].substring(0, 1).toUpperCase(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),
                  title: Text(
                    detail["ownername"],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: detail['wantto'] == "Rent property"
                      ? const Text(
                          "( Property On Rent )",
                          style: TextStyle(fontSize: 13),
                        )
                      : const Text(
                          "( Property On Sale )",
                          style: TextStyle(fontSize: 13),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(38, 20, 18, 18),
                  child: Row(
                    children: [
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          text: "Address",
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 3,
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                            text: "${detail["streetaddress"]}",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                detail["description"] == "null"
                    ? detail["wantto"] == "Rent property"
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(38, 20, 18, 18),
                            child: Row(
                              children: [
                                RichText(
                                  text: const TextSpan(
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    text: "Description",
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  flex: 3,
                                  child: RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                      text:
                                          "If you need any help regarding this property please contact us on ${detail["mobilenumber"]}",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.fromLTRB(38, 20, 18, 18),
                            child: Row(
                              children: [
                                RichText(
                                  text: const TextSpan(
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    text: "Description",
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  flex: 3,
                                  child: RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                      text:
                                          "You can need more information please contact us on ${detail["mobilenumber"]}",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(38, 20, 18, 18),
                        child: Row(
                          children: [
                            RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                text: "Description",
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 3,
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                  text: "${detail["description"]}",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
