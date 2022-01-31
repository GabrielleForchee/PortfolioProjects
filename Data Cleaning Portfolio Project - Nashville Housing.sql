  --Cleaning Data in SQL Queries
Select *
From PortfolioProject.dbo.NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format


Select SaleDate, CONVERT(Date,SaleDate)
From PortfolioProject.dbo.NashvilleHousing


Update PortfolioProject..NashvilleHousing 
SET SaleDate = CONVERT(Date,SaleDate)


--Populate Property Address


Select *
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is NULL
Order By ParcelID 

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL (a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a. UniqueID <> b.UniqueID
Where a.PropertyAddress is null


Update a
Set PropertyAddress = ISNULL (a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a. UniqueID <> b.UniqueID

-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress 
From PortfolioProject.dbo.NashvilleHousing


Select 
SUBSTRING (PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address
,SUBSTRING (PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as Address
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject..NashvilleHousing
ADD PropertySplitAddress Nvarchar(255);

Update PortfolioProject..NashvilleHousing 
Set PropertySplitAddress = SUBSTRING (PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)


ALTER TABLE PortfolioProject..NashvilleHousing 
ADD PropertySplitCity Nvarchar(255);

Update PortfolioProject..NashvilleHousing
Set PropertySplitCity = SUBSTRING (PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) 


Select * 
From PortfolioProject.dbo.NashvilleHousing



Select OwnerAddress 
From PortfolioProject.dbo.NashvilleHousing


Select
PARSENAME(REPLACE(OwnerAddress,',','.'),3) 
,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
,PARSENAME(REPLACE(OwnerAddress,',','.'),1) 
From PortfolioProject.dbo.NashvilleHousing



ALTER TABLE PortfolioProject..NashvilleHousing 
ADD OwnerSplitAddress Nvarchar(255);

Update PortfolioProject..NashvilleHousing 
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)


ALTER TABLE PortfolioProject..[NashvilleHousing ] 
ADD OwnerSplitCity Nvarchar(255);

Update PortfolioProject..NashvilleHousing
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE PortfolioProject..NashvilleHousing
ADD OwnerSplitState Nvarchar(255);

Update PortfolioProject..NashvilleHousing
Set OwnerSplitState= PARSENAME(REPLACE(OwnerAddress,',','.'),1)



--Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant) , COUNT (SoldAsVacant) 
From PortfolioProject.dbo.NashvilleHousing
Group By SoldAsVacant 
Order by 2


Select SoldASVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes' 
		When SoldAsVacant = 'N' THEN 'No' 
		ELSE SoldAsVacant
		END
From PortfolioProject.dbo.NashvilleHousing 

Update PortfolioProject..NashvilleHousing 
Set SoldASVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes' 
		When SoldAsVacant = 'N' THEN 'No' 
		ELSE SoldAsVacant
		END


--Removing Duplicates 

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER () OVER (
	PARTITION BY ParcelID, 
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY UniqueID
				) row_num

From PortfolioProject.dbo.NashvilleHousing 
--ORDER BY ParcelID
)
DELETE
From RowNumCTE
WHERE row_num >1
--Order By PropertyAddress




--Delete Unused Columns

Select *
From PortfolioProject.dbo.NashvilleHousing 

ALTER TABLE PortfolioProject.dbo.NashvilleHousing 
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress 

ALTER TABLE PortfolioProject.dbo.NashvilleHousing 
DROP COLUMN SaleDate

