class Company::UsersController < Company::BaseController
  def index
  end

  def new
  end

  def download_template
    send_file(
      "#{Rails.root}/public/template_users.csv",
      filename: "template_users.csv",
      type: "application/csv; charset=utf-8"
    )
  end

  def import_users
    begin
      if params[:file].blank?
        flash[:notice] = "Please choice CSV file."
      else
        spreadsheet = open_spreadsheet(params[:file])
        header = spreadsheet.row(1)
        company = current_user.company
        if header == ["name", "surname", "email"]
          (2..spreadsheet.last_row).each do |i|
            row = Hash[[header, spreadsheet.row(i)].transpose]
            attrs = { name: row['name'],
              surname: row['surname'],
              email: row['email'],
            }
            attend_user = company.attend_users.build(attrs)
            attend_user.save!
          end
        else
          flash[:notice] = "Please make sure your CSV file format matches the ‘sample CSV file’. Make sure you remove any links from emails before you upload CSV file."
        end
      end
    rescue Exception => e
      flash[:notice] = "Users imported fail."
    end
    redirect_to new_company_user_path
  end

  def invoices
    respond_to do |format|
      format.html {
        get_invoices
      }

      format.pdf{
        render pdf: "invoice_#{invoice.id}",
               page_size: 'A4',
               layout: 'pdf.html',
               show_as_html: false,
               orientation: 'Landscape',
               margin:  {   top:               0,                     # default 10 (mm)
                            bottom:            0,
                            left:              0,
                            right:             0 },
              outline: {   outline:           false},
              disposition: 'attachment'
      }
    end
  end

  def get_invoices
    @invoices ||= Kaminari.paginate_array(invoice_for_current_user)
      .page(params[:page]).per(5)
  end

  def invoice_for_current_user
    Stripe::Customer.retrieve(current_user.stripe_customer_id).invoices.data rescue []
  end

  def invoice
    @invoice ||= Stripe::Invoice.retrieve(params[:invoice_id])
  end

  def open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".csv" then Roo::CSV.new(file.path,csv_options: {encoding: "iso-8859-1:utf-8"})
    when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
    when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end
end
