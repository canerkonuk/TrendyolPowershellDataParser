# This script exports data for the best seller first 5000 products in a category from Trendyol to a CSV file.

# Get the current datetime and format the current datetime into a string that can be used in a filename:
$currentTime = Get-Date
$currentTimeFormatted=$currentTime.ToString("ddMMyyyy_HHmm")

# Construct the filename for the CSV file using the formatted datetime and define the full path for the new CSV file
$csvFileName="TrendyolProductsData_$($currentTimeFormatted).csv"
$csvFilePath="C:\Users\User\Documents\"+$csvFileName;

# Create an empty array to store products data from responses:
$products = @()

# Initialize pageIndex for query:
$pi = 1

# Add product category from url:
$pathModel="tablet-x-c103665"

do {
    # Parse json content
    $url = "https://public.trendyol.com/discovery-mweb-searchgw-service/api/search-v2/products/?storeId=&pathModel=%2F$($pathModel)&pi=$($pi)&pageSize=100&sst=BEST_SELLER&language=tr"
    $response = (Invoke-WebRequest -Uri $url -Method Get).Content | ConvertFrom-Json
    $products+=$response.products

    # Increment pi
    $pi++
    Write-Host($products.Count)

    } while ($response.appliedSearchStrategy -ne "NO_RESULT" -and $products.Count -ne 5000)


# Initialize an empty array for storing product csv data:
$csvProducts=@()
foreach ($product in $products) {

    # Construct the product model
    $productModel = [ordered]@{
        'Urun Adi'  = $product.name
        'Marka' = $product.brand
        'Kategori' = $product.category.name
        'Fiyat' = "`t"+$product.price.originalPrice
        'Indirimli Fiyat' = "`t"+$product.price.discountedPrice
        'Resim' = $product.image
        'Urun Rengi' = $product.colorId
        'Bedava Kargo' = if ($product.isFreeCargo) { "Evet" } else { "Hayir" }
        'Urun Icerik ID' = "`t"+$product.contentId
        'Promosyon' = $product.promotion.name
        'Promosyon Bitis Tarihi' = if ($product.promotion.promotionEndDate -ne $null) { $date = [DateTime]::ParseExact($product.promotion.promotionEndDate, "yyyy-MM-ddTHH:mm:ss", $null); $date.ToString("dd/MM/yyyy HH:mm") } else { $null }
        'Ortalama Begeni Skoru' = [math]::Round($product.ratingScore.averageRating, 2)
        'Kupon Kazandirma' = if ($product.hasCollectableCoupon) { "Evet" } else { "Hayir" }
        'Ayni Gun Kargo' = if ($product.sameDayShipping) { "Evet" } else { "Hayir" }
        'Url' = "https://www.trendyol.com"+$product.url
    }

    # Transform the product model into a custom object and add it to the array:
    $productItem = New-Object PSObject -Property $productModel
    $csvProducts+=$productItem
}

# Convert the array of product data into CSV format and save it to a file:
$csvProducts | ConvertTo-Csv -NoTypeInformation | Set-Content $csvFilePath
