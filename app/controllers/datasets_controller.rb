class DatasetsController < ApplicationController
  def new
    @dataset = Dataset.new
    @project = Project.find(params[:project_id])
    @taskflows = @project.taskflows
    @datasets = @project.datasets
  end

  def create
    @dataset = Dataset.new(dataset_params)
    if @dataset.save
      process_image_uploads(params[:dataset][:images], @dataset)
      redirect_to edit_dataset_path(@dataset)
    else
      render 'new'
    end
  end

  def edit
    @dataset = Dataset.find(params[:id])
    @project = @dataset.project
    @taskflows = @project.taskflows
    @datasets = @project.datasets
    @media = @dataset.media
  end

  def update
    @dataset = Dataset.find(params[:id])
    if @dataset.update(dataset_params)
      flash[:notice] = 'Dataset successfully updated.'
      redirect_to edit_dataset_path
    else
      render '/projects'
    end
  end

  def show
    @dataset = Dataset.find(params[:id])
  end

  def destroy
    @dataset = Dataset.find(params[:id])
    @dataset.destroy
    redirect_to edit_project_path @dataset.project
  end

  private
    def dataset_params
      params.require(:dataset).permit(:title, :description, :project_id)
    end

  private
    def process_image_uploads(images, dataset)
      images.each do |image|
        imagehash = { :image => image }
        @medium = Medium.new(imagehash)
        @medium.dataset = dataset
        @medium.save
      end
    end

  private
    def image_params
      params.permit(:dataset, images: [])
    end

end
