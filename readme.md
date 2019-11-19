# Designer

Build designs for [invites](https://e.rathnas.com)

## Get started

### Create new design

Design name should start with an alphabet followed by 5 numbers. eg: b00001

```sh
git clone https://github.com/nesign/designer.git
./designer/xdesign/new.sh b00001
# b00001 Created successfully.

```

### Start designing

Modify the following files:

- b00001/src/teamplate/main.html
- b00001/src/styles/main.scss
- b00001/src/scripts/main.js

### Ensure local ssl certs are available for webpack. Recommended to automat setup, using [mkcert](https://github.com/nesign/mkcert)

- Install local dev certs

```sh
brew install mkcert
mkcert -install
mkcert localhost

```

### Test your design locally

```sh
cd b00001
./start.sh
```

## Sanbox Options

Test sandbox is hosted on [gh-pages](https://nesign.github.io/designer)

### Invite Id (iid)

This is mandatory. Example `https://nesign.github.io/designer?iid=demo`

### Port

Default port is 8080. Example `https://nesign.github.io/designer?iid=demo&port=8080`

## Design guidelines

### Custom designs

The following files can be used to fit your design needs.

WARNING: These files should be used ONLY to design the invite. All resources must be included, no external assets, no external cdn, no external content, and definitely no XSS. To include a referral link, please write to us.

#### main.scss

The css will apply to the whole invite, ensure the sites look and feel is not disturbed.

#### main.js

The scripts for designing the invite.

#### main.html

The [handlebars](https://github.com/wycats/handlebars.js/) template to define the DOM structure of the invite. The basic data available for rendering are:

| Tag | Description |
| --- | ----------- |
| {{guest.name}} | The name of the user who is logged in |
| {{invite.title}} | The title of the invite |
| {{invite.shortMsg}} | The show welcome message, eg: Join Us |
| {{{invite.longMsg}}} | The standard welcome message, notice the 3 {'s and }'s to render html as is |
| {{invite.addrText}} | The venue details for the invite |
| {{invite.timeFrom}} | The start time in epoch, eg: `1608951600000` |
| {{invite.timeTo}} | The end time in epoch, eg: `1608966000000` |
| {{invite.timeFromString}} | The start time, eg: `Friday, December 25, 2020 7:00 PM` |
| {{invite.timeToString}} | The name of the user who is logged in |
| {{bgPhoto.url}} | The url of bgPhoto |
| {{mainPhoto.url}} | The url of mainPhoto |
| {{#each slidePhotos}}{{/each}} | For each photo, these will be available: {{url}}, {{title}}, {{description}} |

Some helper functions:

| Tag | Description |
| --- | ----------- |
| {{endsat invite}} | The end time, eg: `11:00 PM`, if its the same day, if not returns a full date, eg: `Friday, December 25, 2020 11:00 PM`. Takes the invite as input |
| {{json invite}} | Returns the json string |
| {{#each (eachch invite.shortMsg)}} {{/each}} | Loops through each character of the string input. Use {{this}} to render the character |
| {{#ifEven @index}} {{/ifEven}} | Use inside a loop to check if its the even item or odd. to access the content the parent loop, you will have to use {{../title}}, {{../description}}, {{../url}}|

#### External libraries

```sh
cd b00001
npm i bootstrap
```

### Before you submit a Pull Request

- Ensure you raise a PR for a new repo or 
- Ensure the minified version is not too heavy.
- Test the design in all different screen sizes.
- Once PR is approved, design will be live at [invite](https://e.rathnas.com)
