# ================================================================================================
# Composite Visualization of Microsoft Stock Performance (2010-2022) Using R
# ================================================================================================
# Author: Richard Frimpong
# Date: 30th January 2025
# Purpose: To Reveal Microsoft's Stock Performance and Patterns Through Sophisticated Data              
# Visualization Method using R  
# ================================================================================================

# =============================
# Step 1: Loading Required Libraries
# =============================
library(tidyverse)  # For data manipulation and visualization (includes ggplot2, dplyr, etc.)
library(lubridate)  # For handling date and time operations
library(ggplot2)    # For creating visualizations using the grammar of graphics
library(scales)     # For formatting axes, labels, and scaling data in ggplot2
library(grid)       # For fine control over custom plotting
library(gridExtra)  # For arranging multiple plots in a grid layout
library(viridis)    # For color palettes optimized for perceptual uniformity
library(dplyr)      # For data manipulation (filter, select, mutate, etc.)
library(reshape2)   # For reshaping data, especially useful for melting and casting data frames


# =============================
# Step 2: Load and Preprocess the Data
# =============================
# 2.1: Load the dataset
msft_data <- read.csv("msft.csv", stringsAsFactors = FALSE)

# 2.2: Preprocess the Data
# Convert Date from string to Date type assuming format is d-m-y
msft_data$Date <- dmy(msft_data$Date)

# =============================
# Step 3: Handling Missing Values
# =============================
# 3.1: Checking for missing values and removing rows with any missing data
if (any(is.na(msft_data))) {
  msft_data <- na.omit(msft_data)
}

# 3.2: Check the total number of missing values in the dataset
total_missing <- sum(is.na(msft_data))
cat("Total missing values:", total_missing, "\n")

# 3.3: Check the number of missing values per column
missing_per_column <- colSums(is.na(msft_data))
cat("Missing values per column:\n")
print(missing_per_column)

# 3.4: Check the number of rows with missing values
rows_with_missing <- sum(!complete.cases(msft_data))
cat("Number of rows with missing values:", rows_with_missing, "\n")

# 3.5: Display rows with missing values (if any)
if (rows_with_missing > 0) {
  cat("Rows with missing values:\n")
  print(msft_data[!complete.cases(msft_data), ])
} else {
  cat("No rows with missing values detected.\n")
}

# No missing values has been detected in the dataset

# =============================
# Step 4: Filter Data by Date Range
# =============================
# 4.1: Filter data for the years 2010 to 2022
msft_data <- msft_data %>%
  filter(year(Date) >= 2010 & year(Date) <= 2022)


# =============================
# Step 5: Calculate Daily Returns
# =============================
# 5.1: Calculate daily returns as the percentage change in Closing prices
msft_data <- msft_data %>%
  arrange(Date) %>%  # Ensure data is in chronological order
  mutate(Daily_Returns = (Close / lag(Close) - 1) * 100)


# =============================
# Step 6: Create Individual Plots
# =============================
# Plotting Individual Charts


# A. Professional Line Graph of Closing Prices with Greyish Background for Titles and Labels
# Define the individual plots first (your existing plot codes)
# 1. Time Series Plot of Microsoft Closing Prices
line_graph <- ggplot(msft_data, aes(x = Date, y = Close)) +
  geom_line(color = "#1f77b4", size = 1.2) +  # Set the color directly here
  labs(
    title = "Microsoft Stock Closing Prices (2010-2022)",
    subtitle = "Time Series Plot of Microsoft Stock Closing Price",
    caption = "Stock Market Data (NASDAQ, NYSE, S&P500) - MSFT.CSV",
    x = "Date", y = "Closing Price (USD)"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 22, hjust = 0.5, color = "#333333"),
    plot.subtitle = element_text(size = 16, hjust = 0.5, color = "#666666"),
    axis.title = element_text(face = "bold", color = "#333333"),
    axis.text.x = element_text(angle = 0, hjust = 0.5, color = "#444444"),
    axis.text.y = element_text(color = "#444444"),
    panel.grid.major = element_line(color = "grey85"),
    panel.grid.minor = element_blank(),
    plot.caption = element_text(hjust = 0, color = "#888888"),
    plot.background = element_rect(fill = "#f0f0f0", color = NA),
    panel.background = element_rect(fill = "white", colour = "grey50"),
    legend.position = "none"  # Set legend position to none to remove it
  ) +
  geom_ribbon(aes(ymin = Close * 0.95, ymax = Close * 1.05), alpha = 0.1, fill = "#1f77b4")

# Display the line graph
print(line_graph)


# B. Histogram of Daily Returns
# High-Quality Professional Histogram of Daily Returns
histogram <- ggplot(msft_data %>% filter(!is.na(Daily_Returns)), aes(x = Daily_Returns)) +
  
  # Improved binning and color scheme for clarity
  geom_histogram(
    bins = 40, aes(fill = factor("Daily Returns")), color = "black", alpha = 0.8
  ) +
  
  # Adding a vertical line for the mean of returns with legend
  geom_vline(
    aes(xintercept = mean(Daily_Returns, na.rm = TRUE), color = "Mean Return"),
    linetype = "dashed", size = 1
  ) +
  
  # Titles and captions for clarity
  labs(
    title = "Histogram of Microsoft Daily Returns",
    subtitle = "Distribution of daily percentage returns (2010-2022)",
    caption =  "Data Source: Stock Market Data (NASDAQ, NYSE, S&P500) - MSFT.CSV",
    x = "Daily Returns (%)",
    y = "Number of Trading Days",  # More precise alternative to 'Frequency'
    fill = "Data",                 # Legend Title for Fill
    color = "Indicator"            # Legend Title for Line
  ) +
  
  # Enhanced professional theme adjustments
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 18, hjust = 0.5, color = "#333333"),
    plot.subtitle = element_text(size = 14, hjust = 0.5, color = "#666666"),
    axis.title = element_text(face = "bold", color = "#333333"),
    axis.text = element_text(color = "#444444"),
    panel.grid.major = element_line(color = "grey80"),
    panel.grid.minor = element_blank(),
    
    # Greyish background for title, subtitle, and axis
    plot.background = element_rect(fill = "#f0f0f0", color = NA),  
    panel.background = element_rect(fill = "white", colour = "grey50"),  
    
    # Adjusting the legend
    legend.position = "right",
    legend.title = element_text(face = "bold", size = 12, color = "#333333"),
    legend.text = element_text(size = 12, color = "#555555")
  ) +
  
  # Customizing colors for the legend (fixed)
  scale_fill_manual(values = c("Daily Returns" = "#FF6347")) +
  scale_color_manual(values = c("Mean Return" = "#1E90FF"))

# Display the improved histogram
print(histogram)



# C. Correlation Heatmap of stock metrics
# Ensure correlation data is in matrix form and melt it properly, excluding 'Price_Change'
correlation_data <- cor(msft_data %>% select(-Date), use = "complete.obs")  # Exclude Date column
melted_corr <- melt(correlation_data)

# High-Quality Professional Correlation Heatmap
heatmap <- ggplot(melted_corr, aes(Var1, Var2, fill = value)) +
  
  # Tile plot with gradient coloring and white borders for contrast
  geom_tile(color = "white") +
  
  # Adding correlation values inside the tiles, formatted for readability
  geom_text(aes(label = sprintf("%.2f", value)), 
            color = "black", size = 4, fontface = "bold") +
  
  # Gradient color scale from blue (negative) to red (positive)
  scale_fill_gradient2(
    low = "#4575B4", mid = "white", high = "#D73027", 
    midpoint = 0, limit = c(-1, 1), space = "Lab", 
    name = "Correlation"
  ) +
  
  # Professional labels and theme adjustments
  labs(
    title = "Microsoft Stock Correlation Heatmap",
    subtitle = "Correlation between different financial metrics (2010-2022)",
    caption = "Data Source: Stock Market Data (NASDAQ, NYSE, S&P500) - MSFT.CSV",
    x = "Financial Metrics", 
    y = "Financial Metrics"
  ) +
  
  # Enhanced theme for professional presentation
  theme_minimal(base_size = 14) +
  
  # Workaround: Adding greyish background by using plot.margin and plot background
  theme(
    # Title and subtitle styling (no direct background support)
    plot.title = element_text(face = "bold", size = 18, hjust = 0.5, color = "#333333"),
    plot.subtitle = element_text(size = 14, hjust = 0.5, color = "#555555"),
    plot.caption = element_text(size = 12, hjust = 0, color = "#666666"),
    
    # Axis labels and text styling
    axis.title = element_text(face = "bold", color = "#333333"),
    axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1, color = "darkgrey", size = 12),
    axis.text.y = element_text(color = "darkgrey", size = 12),
    
    # Greyish background behind the entire plot area, not inside the graph
    plot.background = element_rect(fill = "#f0f0f0"),  
    panel.background = element_rect(fill = "white", colour = "grey60"),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    
    # Adjusting the legend for clarity
    legend.position = "right",
    legend.title = element_text(face = "bold", size = 12, color = "#333333"),
    legend.text = element_text(size = 12, color = "#555555")
  )

# Display the heatmap
print(heatmap)



# D. Scatter Plot of Volume vs. Price Change
# Calculate Price Change with NA handling
msft_data <- msft_data %>%
  mutate(Price_Change = Close - lag(Close))

# Remove rows with NA values (such as the first row where lag() generates NA)
msft_data <- na.omit(msft_data)

# High-Quality Professional Scatter Plot of Volume vs. Price Change
scatter_plot <- ggplot(msft_data, aes(x = Volume, y = Price_Change)) +
  
  # Scatter plot points with a refined color gradient from cool to warm colors
  geom_point(aes(color = Price_Change), alpha = 0.7, size = 2) +
  
  # Beautiful color gradient (from soft purple to vibrant orange)
  scale_color_gradient(low = "#1f77b4", high = "#d62728", name = "Price Change") +
  
  # Labels and title customization
  labs(
    title = "Scatter Plot of Trading Volume vs. Price Change",
    subtitle = "Examining the relationship between trading volume and price changes",
    caption = "Data Source: Stock Market Data (NASDAQ, NYSE, S&P500) - MSFT.CSV",
    x = "Trading Volume (Shares)",
    y = "Price Change (USD)"
  ) +
  
  # High-quality minimalistic theme with professional adjustments
  theme_minimal(base_size = 16) +
  theme(
    plot.title = element_text(face = "bold", size = 17, hjust = 0.5, color = "#333333"),
    plot.subtitle = element_text(size = 12, hjust = 0.5, color = "#666666"),
    plot.caption = element_text(size = 10, hjust = 1, color = "#888888"),
    axis.title.x = element_text(size = 14, color = "#333333"),
    axis.title.y = element_text(size = 14, color = "#333333"),
    axis.text.x = element_text(size = 12, color = "#444444"),
    axis.text.y = element_text(size = 12, color = "#444444"),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "#FFFFFF", color = "#D3D3D3"),  # White background for inside of the graph
    plot.background = element_rect(fill = "#F7F7F7", color = NA),  # Greyish background for title, subtitle, and axis labels
    legend.position = "right",  # Legend placed on the right for clarity
    legend.title = element_text(face = "bold", color = "#333333"),
    legend.text = element_text(color = "#555555")
  ) +
  
  # Modify the volume axis to display in millions (M) and thousands (K)
  scale_x_continuous(labels = function(x) {
    ifelse(x >= 1e6, paste0(round(x / 1e6, 1), "M"),
           ifelse(x >= 1e3, paste0(round(x / 1e3, 1), "K"), x))
  })

# Display the scatter plot
print(scatter_plot)


# ==========================================================
# Step 7: Composite Visualization (Multiple Plots)
# ==========================================================
# Composite Visualization of Microsoft Stock Data (2010-2022)

# This layout includes the following visualizations:
# 1. Line Graph: Microsoft Stock Closing Prices over Time
# 2. Histogram: Distribution of Daily Returns
# 3. Correlation Heatmap: Correlation between Financial Metrics
# 4. Scatter Plot: Relationship between Trading Volume and Price Change
# The design emphasizes high-quality professional standards with a refined color palette,
# minimalistic background, and clearly labeled axes and legends

# Define the individual plots first

# 7.1: Line Graph
# Line Graph of Microsoft Closing Prices (2010-2022)
# Adjust base_size for all charts to ensure consistent font size across all elements

line_graph <- ggplot(msft_data, aes(x = Date, y = Close)) +
  geom_line(color = "#1f77b4", size = 1.2) +
  labs(
    title = "Microsoft Stock Closing Prices (2010-2022)",
    subtitle = "Time Series Plot of Microsoft Stock Closing Price",
    x = "Date", y = "Closing Price (USD)",
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(size = 16, face = "bold", hjust = 0.5),  # Fixed here
    plot.subtitle = element_text(size = 12, hjust = 0.5),
    axis.title = element_text(size = 12),
    axis.text = element_text(size = 10),
    panel.background = element_rect(fill = "#f7f7f7"),
    plot.background = element_rect(fill = "#f7f7f7"),
    legend.position = "none"
  ) +
  geom_ribbon(aes(ymin = Close * 0.95, ymax = Close * 1.05), alpha = 0.1, fill = "#1f77b4")




# 7.2: Histogram (Distribution of daily percentage returns (2010-2022))
histogram <- ggplot(msft_data %>% filter(!is.na(Daily_Returns)), aes(x = Daily_Returns)) +
  geom_histogram(aes(fill = "Daily Returns"), bins = 40, color = "black", alpha = 0.8) + # Assign a fill aesthetic for the legend
  geom_vline(aes(xintercept = mean(Daily_Returns, na.rm = TRUE), color = "Mean Return"), linetype = "dashed", size = 1) + # Assign a color aesthetic for the legend
  labs(
    title = "Histogram of Microsoft Daily Returns",
    subtitle = "Distribution of daily percentage returns (2010-2022)",
    x = "Daily Returns (%)", y = "Number of Trading Days"
  ) +
  scale_fill_manual(values = c("Daily Returns" = "#FF6347")) + # Define colors for fill
  scale_color_manual(values = c("Mean Return" = "#1E90FF")) + # Define colors for line
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(size = 16, face = "bold", hjust = 0.5),
    plot.subtitle = element_text(size = 12, hjust = 0.5),
    axis.title = element_text(size = 12),
    axis.text = element_text(size = 10),
    panel.background = element_rect(fill = "#f7f7f7"),
    plot.background = element_rect(fill = "#f7f7f7"),
    legend.position = "right", # Adjust the position of the legend
    legend.title = element_text(face = "bold", size = 12),
    legend.text = element_text(size = 10)
  )


# 7.3: Correlation Heatmap (Correlation between different financial metrics (2010-2022))
correlation_data <- cor(msft_data %>% select(-Date, -Price_Change), use = "complete.obs")
melted_corr <- melt(correlation_data)
heatmap <- ggplot(melted_corr, aes(Var1, Var2, fill = value)) +
  geom_tile(color = "white") +
  geom_text(aes(label = sprintf("%.2f", value)), size = 3.5) +
  scale_fill_gradient2(low = "#4575B4", high = "#D73027", midpoint = 0) +
  labs(
    title = "Microsoft Stock Correlation Heatmap",
    subtitle = "Correlation between different financial metrics (2010-2022)",
    x = "Financial Metrics", y = "Financial Metrics"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(size = 16, face = "bold", hjust = 0.5),
    plot.subtitle = element_text(size = 12, hjust = 0.5),
    axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
    axis.text.y = element_text(size = 10),
    plot.background = element_rect(fill = "#f7f7f7"),
    panel.background = element_rect(fill = "#f7f7f7"),
    legend.position = "right"
  )


# 7.4: Scatter Plot of Trading Volume vs Price Change (2010-2022)
scatter_plot <- ggplot(msft_data, aes(x = Volume, y = Price_Change)) +
  geom_point(aes(color = Price_Change), alpha = 0.7, size = 2) +
  scale_color_gradient(low = "#1f77b4", high = "#d62728") +
  labs(
    title = "Scatter Plot of Trading Volume vs Price Change",
    subtitle = "Examining the relationship between trading volume and price changes",
    x = "Trading Volume (Shares)", y = "Price Change (USD)"
  ) +
  theme_minimal(base_size = 16) +
  theme(
    plot.title = element_text(size = 15, face = "bold", hjust = 0.5),
    plot.subtitle = element_text(size = 12, hjust = 0.5),
    axis.title = element_text(size = 14),
    axis.text = element_text(size = 12),
    panel.background = element_rect(fill = "#f7f7f7"),
    plot.background = element_rect(fill = "#f7f7f7"),
    legend.position = "right"
  ) +
  scale_x_continuous(labels = function(x) {
    ifelse(x >= 1e6, paste0(round(x / 1e6, 1), "M"),
           ifelse(x >= 1e3, paste0(round(x / 1e3, 1), "K"), x))
  })


# 7.5. Combine the four plots into a single layout with a common caption
composite_visualization <- grid.arrange(
  line_graph, histogram, heatmap, scatter_plot,
  ncol = 2, nrow = 2,
  top = textGrob("Composite Visualization of Microsoft's Stock Performance (2010-2022)",
                 gp = gpar(fontsize = 20, fontface = "bold")),
  bottom = textGrob("Data Source: Stock Market Data (NASDAQ, NYSE, S&P500) - MSFT.CSV",
                    gp = gpar(fontsize = 12, fontface = "italic"))
)

