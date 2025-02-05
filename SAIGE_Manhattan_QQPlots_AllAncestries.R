## Manhattan plots - SAIGE - All ancestries
# Function to generate and save Manhattan and QQ plots in a PDF
library(gridExtra)
library(ggmanh)
library(grid) 

# Function to calculate lambda GC
calculate_lambda_gc <- function(pval) {
  chisq <- qchisq(1 - pval, 1)
  lambda <- median(chisq) / qchisq(0.5, 1)
  return(lambda)
}

# Function to generate Manhattan and QQ plots with specified dimensions and save as PNG - ASD Agnostic
generate_plots_to_pdf <- function(filenames, titles, output_pdf) {
  
  for (i in seq_along(filenames)) {
    # Read the data
    data <- read.table(filenames[i], sep = '\t', header = TRUE)
    
    # Extract case and control counts from the data
    ncase <- unique(data$N_case)[1]  # Assuming the N_case is consistent within each file
    nctrl <- unique(data$N_ctrl)[1]  # Assuming the N_ctrl is consistent within each file
    #n <- unique(data$N)[1]
    
    # Generate Manhattan plot with customized title
    plot_title <- paste(titles[i], "(SAIGE w SPA) - All individuals (Ncase =", ncase, ", Nctrl =", nctrl, ")")
    manhattan_plot_spa <- manhattan_plot(x = data, pval.colname = "p.value", chr.colname = "CHR", pos.colname = "POS", 
                                         plot.title = plot_title, 
                                         y.label = "P")
    
    #plot_title <- paste(titles[i], "(SAIGE w SPA) - All individuals (N =", n, ")")
    #manhattan_plot_spa <- manhattan_plot(x = data, pval.colname = "p.value", chr.colname = "CHR", pos.colname = "POS", 
    #                                     plot.title = plot_title, 
    #                                     y.label = "P")
    
    # Save Manhattan plot with specified dimensions
    manhattan_filename <- paste0("manhattan_plot_", i, ".png")
    png(manhattan_filename, width = 1200, height = 450)
    print(manhattan_plot_spa)
    dev.off()
    
    # Generate QQ plot with lambda GC
    lambda <- calculate_lambda_gc(data$p.value)
    qq_plot <- qqunif(data$p.value) +
      ggtitle(paste(titles[i], "- All individuals", "\nLambda GC:", round(lambda, 3)))
    
    # Save QQ plot with specified dimensions
    qq_filename <- paste0("qq_plot_", i, ".png")
    png(qq_filename, width = 600, height = 450)
    print(qq_plot)
    dev.off()
  }
  
  # Combine saved images into a single PDF
  pdf(output_pdf, width = 10, height = 12)
  for (i in seq_along(filenames)) {
    manhattan_filename <- paste0("manhattan_plot_", i, ".png")
    qq_filename <- paste0("qq_plot_", i, ".png")
    grid.arrange(rasterGrob(png::readPNG(manhattan_filename)), rasterGrob(png::readPNG(qq_filename)), nrow = 2)
  }
  dev.off()
  
  # Clean up temporary files
  file.remove(list.files(pattern = "manhattan_plot_\\d+\\.png"))
  file.remove(list.files(pattern = "qq_plot_\\d+\\.png"))
}

# Example usage - DCDQ
filenames <- c('EUR.all.DCDQ_ASD_Agnostic.assoc','AMR.all.DCDQ_ASD_Agnostic.assoc','AFR.all.DCDQ_ASD_Agnostic.assoc','EAS.all.DCDQ_ASD_Agnostic.assoc','SAS.all.DCDQ_ASD_Agnostic.assoc')
titles <- c("SPARK Batch5 EUR ASD-Agnostic DCDQ","SPARK Batch5 AMR ASD-Agnostic DCDQ", "SPARK Batch5 AFR ASD-Agnostic DCDQ", "SPARK Batch15 EAS ASD-Agnostic DCDQ", "SPARK Batch5 SAS ASD-Agnostic DCDQ")
output_pdf <- "SAIGE_GWAS_Plots_ASD_Agnostic_AllIndividuals_DCDQ_RINT_TotalScore_B5.pdf"

generate_plots_to_pdf(filenames, titles, output_pdf)

# Example usage - SCQ - WithinASD
setwd('/Users/admin/SPARK/Batch5/SCQ_GWAS/within_ASD/PC20/all')
filenames <- c('EUR.all.onlyASD.SCQ.assoc','AMR.all.onlyASD.SCQ.assoc','AFR.all.onlyASD.SCQ.assoc','EAS.all.onlyASD.SCQ.assoc','SAS.all.onlyASD.SCQ.assoc')
titles <- c("SPARK Batch5 EUR withinASD SCQ","SPARK Batch5 AMR withinASD SCQ", "SPARK Batch5 AFR withinASD SCQ", "SPARK Batch15 EAS withinASD SCQ", "SPARK Batch5 SAS withinASD SCQ")
output_pdf <- "SAIGE_GWAS_Plots_onlyASD_AllIndividuals_SCQ_B5.pdf"

# Example usage - SCQ - ASD Agnostic
setwd('/Users/admin/SPARK/Batch5/SCQ_GWAS/ASD_agnostic/gwas_results/pc20/all/')
filenames <- c('EUR.all.SCQ_ASD_Agnostic.assoc','AMR.all.SCQ_ASD_Agnostic.assoc','AFR.all.SCQ_ASD_Agnostic.assoc','EAS.all.SCQ_ASD_Agnostic.assoc','SAS.all.SCQ_ASD_Agnostic.assoc')
titles <- c("SPARK Batch5 EUR ASD-Agnostic SCQ","SPARK Batch5 AMR ASD-Agnostic SCQ", "SPARK Batch5 AFR ASD-Agnostic SCQ", "SPARK Batch15 EAS ASD-Agnostic SCQ", "SPARK Batch5 SAS ASD-Agnostic SCQ")
output_pdf <- "SAIGE_GWAS_Plots_ASD_Agnostic_AllIndividuals_SCQ_B5.pdf"
