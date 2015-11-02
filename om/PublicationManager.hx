/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is POM.
 *
 * The Initial Developer of the Original Code is
 * Disruptive Innovations SAS
 * Portions created by the Initial Developer are Copyright (C) 2015
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *   Daniel Glazman <daniel.glazman@disruptive-innovations.com>
 *
 * Alternatively, the contents of this file may be used under the terms of
 * either of the GNU General Public License Version 2 or later (the "GPL"),
 * or the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 *
 * ***** END LICENSE BLOCK ***** */

package om;

class PublicationManager {

  // stores the publication registrations
  private var formatsArray: Array<PublicationRegistration>;

  /*
   * registers an association between a format and a class name
   *   never throws.
   */
  public function registerPublication(format: String, classInfo: String) {
    // unregister first just in case it's already registered
    // this is harmless if the publication was not registered
    this.unregisterPublication(format);

    // create a new registration and push it
    var declaration = new PublicationRegistration(format, classInfo);
    this.formatsArray.push(declaration);
  }

  /*
   * unregisters an already registered format
   *   never throws.
   */
  public function unregisterPublication(format:String) {
    this.formatsArray = this.formatsArray.filter(function(n) {return (n.format != format);});
  }

  /*
   * returns an existing registration for a given format or null
   *   never throws.
   */
  private function getPublicationRegistration(format: String): PublicationRegistration {
    var filtered = this.formatsArray.filter(function(n) {return (n.format == format);});
    return ((0 == filtered.length)
            ? null
            : filtered[0]);
  }

  /*
   * return true if a registration for the given format already exists
   *   never throws.
   */
  public function isPublicationRegistered(format: String): Bool {
    return (null != this.getPublicationRegistration(format));
  }

  /*
   * create a publication for an already registered format
   *   @return an instance of the requested publication
   *   throws UNREGISTERED_PUBLICATION if the format is not yet registered.
   */
  public function createPublication(format: String): Dynamic {
    var filtered = this.getPublicationRegistration(format);
    if (null == filtered)
      throw POMException.UNREGISTERED_PUBLICATION;

    // create the class based on its classname
    return Type.createInstance(Type.resolveClass(filtered.classInfo), []);
  }

  /*
   * CONSTRUCTOR
   */
  public function new() {
    this.formatsArray = [];
  }
}
