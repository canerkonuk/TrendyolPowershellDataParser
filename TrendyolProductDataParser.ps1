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

