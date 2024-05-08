
# Bulk JAMF Extension Attribute Assignment

With this shell script, JAMF extension attribute assignment can be done by bulk.

## Variables for Extension Attribute and JAMF Token

Add Your JAMF Server URL to the line 33
Add ID number of your extension attribute to the line 34
Add name of your extension attribute to the line 35
Add items, name, ID of your extension atrribute between line 83 and 94 (add new lines if necessary) 

### Example

```bash
  jamfpro_url="https://yourjamfurl.jamfcloud.com"
  eaID="999" 
  eaName="My Lovely Extension Attribute"
```

```bash
:'
EA Name: My Lovely Extension Attribute
EA ID: 999

ITEM1
ITEM2		
ITEM3	
ITEM4	
ITEM5	
ITEM6	
ITEM7	

'
```

You can add new items accordingly. 

## CSV File
* Create a file on your desktop and name as EAassignment.csv
* Column-A must contain serial numbers of the devices
* Column-B must contain item name of extension attribute that will be assigned

### Sample CSV File in code view
```bash
  123ABC456DE;ITEM1
  123ABC457DE;ITEM2
```


## Authors

- [@euydu](https://www.github.com/octokatherine)
- emreuydu@gmail.com 

