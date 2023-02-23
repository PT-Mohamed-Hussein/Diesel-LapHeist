else if (itemData.name == "lapadminprivelage") {
    $(".item-info-title").html("<p>" + itemData.label + "</p>");
    $(".item-info-description").html("<p>" + itemData.description + "</p><p>Username: " + itemData.info.username + "</p> Password: " + itemData.info.password + " </p><p style=\"font-size:11px\"><b>Weight: </b>" + itemData.weight + " | <b>Amount: </b> " + itemData.amount + " | <b>Quality: </b> " + "<a style=\"font-size:11px;color:green\">" + Math.floor(itemData.info.quality) + "</a>");
}