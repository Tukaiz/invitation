Invitation
==========

Add invitation functionality to an app

##Current Dependencies
* Implementing site must implement current_site method
* current_site must return an object that responds to name and returns a string
* Implementing site must create an invitation.rb in initializers
* The initializer must be configured with the uri_class_name as a string of the
class in the host application that responds to invitation and returns the uri
endpoint as a string on the auth server for creating and updating an invitation.
* If the host application would like to do actions after a user accepts an
invitation or react to an invitation update request differently,  the class in
this engine should be copied into the host application and altered accordingly.
* Invitation registration type is currently hard coded in bs2.  If this feature
is disabled it will still show as an option however a user won't be able to
access the invitation paths.
* Since invitation registration type is just a string in bs2 registration types,
an interesting situation may arise when a site has selected to use invitation
but then the invitation feature is disabled.  How should the system react when
this happens?  This should be throught through at some point...
