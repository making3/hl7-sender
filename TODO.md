TODO
====

# Main Application
- [x] Save control characters to user's hard drive.
- [ ] Save IP / Port to user's hard drive, on button click (i.e. don't save if they don't want it).
- [ ] Option to accept an ACK from receiving application.
- [x] Notify the user that a message was sent
- [ ] Notify if a message was successful / failed (i.e. rejected by the other system).
- [x] Add a simple About screen. This should use the layout from Settings, except "Settings - ". So create a "default layout" sort of page..
- [x] Add an event-log sort of thing (i.e. "Connected to IP / Port", "Sent message").
- [x] When editing control characters, disable "Save to Disk" unless the settings are updated.
- [x] Reverse the text log output & auto scroll for new messages.
- [ ] Add escape functionality when viewing a "modal" screen.
- [ ] Disable Saved Connections, Host, and Port buttons when the connection is active.
- [ ] Add menu item to view existing connections (opens a new screen and shows a table list of Name | IP | Port).
- [ ] After the above, add an Edit & Delete button to the existing connections (header will be Name | IP | Port | Actions).
- [ ] Create a side-navigation menu. The future menu will include Basic, File, and Analyze. "Basic" is the current home page. File/Analyze are ideas for the future (see the future TODO list).

# JavaScript Ports
- [ ] Add basic eslint for port related code
- [ ] Implement async/await for ports instead of callbacks.

# Future
- [ ] Create an installer / bundler.
- [ ] File page - Read HL7 from a file.
- [ ] Analyze page - Read multiple messages from a file and display them in a table.
- [ ] Basic HL7 validation (separate library).

# Future Ideas
- Broadcast messages to multiple connections / ports.
- Round-robin type messaging where multiple connections/ports are defined but it will send to random connections.
- HL7 building / generating
