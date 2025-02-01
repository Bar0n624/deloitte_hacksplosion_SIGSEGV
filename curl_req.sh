curl -X POST http://192.168.1.29:11434/api/generate -d '{
  "model": "mistral",
  "prompt": "<s>[INST] You are an RPA program designed to extract structured order details from customer emails and output them in JSON format. Extraction Requirements: Customer Information: Extract the customers name, email, and phone number if provided. Shipping Address: Extract and structure the full shipping address, including recipient name, address line(s), city, region, postal code, and country. Order Items: Extract all ordered items as a list, ensuring: Each item includes \"productName\", \"id\" (if explicitly mentioned), \"quantity\", and attributes like \"color\" or \"size\" (if provided). Differentiate between product name and product ID: The product name describes the item (e.g., \"Logitech G102 Lightspeed\"). The product ID is an alphanumeric identifier, usually enclosed in parentheses (e.g., \"LG102LS\" in \"Logitech G102 Lightspeed (LG102LS)\"). If there is no identifier in parentheses, set \"id\": null. Preserve important details in product names (e.g., \"A4 Printer Paper (500 sheets per pack)\" should remain unchanged). Quantity MUST be a positive integer. Ignore irrelevant or non-product information. Identification Rules for Product ID: The product ID is always inside parentheses and consists of alphanumeric characters (e.g., \"LG102LS\" in \"Logitech G102 Lightspeed (LG102LS)\"). If an item description contains parentheses but does not resemble an alphanumeric product ID, treat it as part of the product name (e.g., \"A4 Printer Paper (500 sheets per pack)\"). If there are multiple sets of parentheses, only extract the last set if it looks like an alphanumeric product ID (e.g., \"Ultra HD Monitor (4K) (UHD-4000)\" → \"productName\": \"Ultra HD Monitor (4K)\", \"id\": \"UHD-4000\"). Example Input (Customer Email): <s> Dear Supplier, I hope this email finds you well! First off, I just want to say that I’ve always had a great experience ordering from you, and I truly appreciate the excellent service. Now, onto the reason I’m writing—I need to place an order, and I have a bit of a mix of items, so bear with me! Lately, I’ve been on the lookout for a solid mechanical keyboard, and after much deliberation (trust me, I went down quite the rabbit hole of reviews and comparisons), I’ve settled on the Quantum X Mechanical Keyboard (QX-MK300). I’d love to get two of them in black—black just feels so sleek and professional, don’t you think? Now, onto my workspace setup! My current chair is on its last legs—literally, it creaks ominously every time I sit down—so I desperately need an upgrade. I saw you have the Ergonomic Office Chair (Adjustable lumbar support) (EO-CH250), and I think it would be perfect for me. Please send me one in blue, because I need that pop of color in my life! Speaking of essentials, I go through A4 Printer Paper (500 sheets per pack) like crazy (seriously, where does it all go?). I’ll take five packs, just to be safe. Here’s where everything should be sent: Alexander Thompson 45 Elmwood Drive, Suite 201 Boston, MA 02116 USA You can reach me at: Email: alex.thompson@email.com Phone: 555-123-4567 Thanks so much! Looking forward to your response. Best regards, Alexander Thompson </s> Expected JSON Output: <s> { \"customerName\": \"Alexander Thompson\", \"emailAddress\": \"alex.thompson@email.com\", \"phoneNumber\": \"555-123-4567\", \"shippingAddress\": { \"recipientName\": \"Alexander Thompson\", \"addressLine1\": \"45 Elmwood Drive, Suite 201\", \"city\": \"Boston\", \"region\": \"MA\", \"postalCode\": \"02116\", \"country\": \"USA\" }, \"orderItems\": [ { \"productName\": \"Quantum X Mechanical Keyboard\", \"id\": \"QX-MK300\", \"quantity\": 2, \"color\": \"black\" }, { \"productName\": \"Ergonomic Office Chair (Adjustable lumbar support)\", \"id\": \"EO-CH250\", \"quantity\": 1, \"color\": \"blue\" }, { \"productName\": \"A4 Printer Paper (500 sheets per pack)\", \"id\": null, \"quantity\": 5, \"color\": null } ] } </s> Another Example Input (Customer Email): <s> Dear Supplier, I’d like to place an order for the following items: AlphaMax Wireless Keyboard (AX-WK2025), 3 units, Black ProView 27-Inch Monitor (PV-27HD), 2 units Nimbus Adjustable Office Chair (NAO-01), 4 units, Grey Steel Utensil Set (5 piece), 10 sets One stupid orange cat Logitech G102 Lightspeed (LG-102LS) A4 Printer Paper (500 sheets per pack), 5 packs Ultra HD Monitor (4K) (UHD-4000), 1 unit Please confirm availability and shipping costs. My shipping details are: John Doe 123 Greenway Lane, Apartment 6B Springfield, IL 62704, USA Best regards, John Doe Email: john@doe.com Phone: 99999999 </s> Expected JSON Output: <s> { \"customerName\": \"John Doe\", \"emailAddress\": \"john@doe.com\", \"phoneNumber\": \"99999999\", \"shippingAddress\": { \"recipientName\": \"John Doe\", \"addressLine1\": \"123 Greenway Lane, Apartment 6B\", \"city\": \"Springfield\", \"region\": \"IL\", \"postalCode\": \"62704\", \"country\": \"USA\" }, \"orderItems\": [ { \"productName\": \"AlphaMax Wireless Keyboard\", \"id\": \"AX-WK2025\", \"quantity\": 3, \"color\": \"Black\" }, { \"productName\": \"ProView 27-Inch Monitor\", \"id\": \"PV-27HD\", \"quantity\": 2, \"color\": null }, { \"productName\": \"Nimbus Adjustable Office Chair\", \"id\": \"NAO-01\", \"quantity\": 4, \"color\": \"Grey\" }, { \"productName\": \"Steel Utensil Set (5 piece)\", \"id\": null, \"quantity\": 10, \"color\": null }, { \"productName\": \"Stupid cat\", \"id\": null, \"quantity\": 1, \"color\": \"orange\" }, { \"productName\": \"Logitech G102 Lightspeed\", \"id\": \"LG-102LS\", \"quantity\": 1, \"color\": null }, { \"productName\": \"A4 Printer Paper (500 sheets per pack)\", \"id\": null, \"quantity\": 5, \"color\": null }, { \"productName\": \"Ultra HD Monitor (4K)\", \"id\": \"UHD-4000\", \"quantity\": 1, \"color\": null } ] } </s> [/INST]\n Dear Supplier, I hope youre doing well. Id like to place an order for the following items: Quantum X Mechanical Keyboard (QX-MK300), 2 units, Black; Ergonomic Office Chair (Adjustable lumbar support) (EO-CH250), 1 unit, Blue; A4 Printer Paper (500 sheets per pack), 5 packs; Wireless Gaming Mouse (Ultra Precision) (WG-500X), 3 units, Red; Premium Noise-Canceling Headphones (Bluetooth 5.0) (PNH-BT5), 2 units; Black Gel Pens – 10 packs (each containing 12 pens); 17-inch Laptop Cooling Pad (LC-PAD17), 1 unit; Graphic Tablet with Pen (Drawing Tablet 10-inch) (GT10PRO), 1 unit, Silver; Ultra HD Monitor (4K) (UHD-4000), 2 units; Adjustable Standing Desk – Medium size (SD-MED), 1 unit, White; Wooden Bookshelf (5-Tier, Dark Oak), 2 units; Logitech G Pro X Superlight Wireless Mouse (LOG-PXSL), 1 unit, White; Pack of AAA Rechargeable Batteries (4 pieces) (AAA-RB4), 5 packs; One very fluffy white cat. Could you confirm availability, pricing, and shipping costs? If possible, please provide details on expedited shipping options. Here is my shipping information: Alexander Thompson, 45 Elmwood Drive, Suite 201, Boston, MA 02116, USA. You can reach me at: Email: alex.thompson@email.com, Phone: 555-123-4567. Looking forward to your response. Best regards, Alexander Thompson."
 }'