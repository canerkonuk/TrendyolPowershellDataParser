## Trendyol Powershell Data Parser

This PowerShell script exports data for the best seller first 5000 products in a specific category from Trendyol to a CSV file.

### About The Script

The script is set up to fetch product data from the ‘tablet pc’ category on Trendyol by default. If you wish to fetch data from a different category, you’ll need to find the category code from the Trendyol website and replace the $pathModel value in the script. For example, the category code for ‘tablet pc’ is tablet-x-c103665, so the line in the script looks like this:

$pathModel="tablet-x-c103665"

You can find the category code for other categories on the Trendyol's website. (The image below shows an example of how to get the relevant code from the Trendyol's website) :

![](https://raw.githubusercontent.com/canerkonuk/TrendyolPowershellDataParser/refs/heads/master/ExampleProductCategoryCode.png)

The script uses an Trendyol's API endpoint that’s designed for mobile browsers. This endpoint allows to fetch a maximum of 100 items per request with the `pageSize` query parameter. However, once the multiply of `pageSize` and `pageIndex` values exceeds 5000, the endpoint will not return any data. So, for categories with more than 5000 products, the script will make a maximum of 50 requests, each fetching 100 items. (You can use the `offset` query parameter in the URL. But, despite using this query parameter, the retrieval of more than 5000 products data was still not possible.)

### Usage

To use this script, first you have to simply run it in a PowerShell environment. The script will automatically start gathering product data from the Trendyol API and save it to a CSV file in the specified directory. (The default directory is the Documents folder.)

### Output

The output CSV file will contain the following fields for each product:

- Urun Adi: The name of the product.
- Marka: The brand of the product.
- Kategori: The category of the product.
- Fiyat: The original price of the product.
- Indirimli Fiyat: The discounted price of the product.
- Resim: The image of the product.
- Urun Rengi: The color ID of the product.
- Bedava Kargo: Whether the product has free shipping.
- Urun Icerik ID: The content ID of the product.
- Promosyon: The name of the promotion for the product.
- Promosyon Bitis Tarihi: The end date of the promotion for the product.
- Ortalama Begeni Skoru: The average rating score of the product.
- Kupon Kazandirma: Whether the product has a collectable coupon.
- Ayni Gun Kargo: Whether the product has same-day shipping.
- Url: The URL of the product on Trendyol.