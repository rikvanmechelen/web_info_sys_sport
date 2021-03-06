class ExercisesController < ApplicationController
	before_filter :login_required, :except => [:index, :show ]
  # GET /exercises
  # GET /exercises.json
  def index
    @exercises = Exercise
			.search_by_name(params[:search_name])
			.search_by_type(params[:search_type])
			.search_by_owner(params[:search_owner])
			.published.paginate(:page => params[:page], :per_page => 10)			
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @exercises }
			format.js
    end
  end

  # GET /exercises/1
  # GET /exercises/1.json
  def show
    @exercise = Exercise.find(params[:id])
		@client = YouTubeIt::Client.new
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @exercise }
    end
  end

  # GET /exercises/new
  # GET /exercises/new.json
  def new
    @exercise = Exercise.new
    @exercise.information = Information.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @exercise }
      format.js
    end
  end

  # GET /exercises/1/edit
  def edit
    @exercise = Exercise.find(params[:id])
  end

  # POST /exercises
  # POST /exercises.json
  def create
		x = {"DistanceExercise"=>DistanceExercise, "RepsExercise"=>RepsExercise, "TimeExercise"=>TimeExercise}
		params[:exercise].delete "distance" if params[:exercise][:type] != "DistanceExercise"
		params[:exercise].delete "unit" if params[:exercise][:type] != "DistanceExercise"
		params[:exercise].delete "reps" if params[:exercise][:type] != "RepsExercise"
		if params[:exercise][:type] != "TimeExercise"
			params[:exercise].delete "hours"
			params[:exercise].delete "minutes"
			params[:exercise].delete "seconds"
		end
    @exercise = x[params[:exercise][:type]].new(params[:exercise])
		@exercise.owner = current_user
    respond_to do |format|
      if @exercise.save
        format.html { redirect_to my_exercises_path, notice: 'Exercise was successfully created.' }
        format.json { render json: @exercise, status: :created, location: @exercise }
        format.js
      else
        format.html { render action: "new" }
        format.json { render json: @exercise.errors, status: :unprocessable_entity }
        format.js { render action: "new"}
      end
    end
  end

  # PUT /exercises/1
  # PUT /exercises/1.json
  def update
    @exercise = Exercise.find(params[:id])

    respond_to do |format|
      if @exercise.update_attributes(params[:exercise])
        format.html { redirect_to @exercise, notice: 'Exercise was successfully updated.' }
        format.json { head :no_content }
        format.js
      else
        format.html { render action: "edit" }
        format.json { render json: @exercise.errors, status: :unprocessable_entity }
        format.js { render action: "edit"}
      end
    end
  end

  # DELETE /exercises/1
  # DELETE /exercises/1.json
  def destroy
    @exercise = Exercise.find(params[:id])
    @exercise.destroy

    respond_to do |format|
      format.html { redirect_to exercises_url }
      format.json { head :no_content }
			format.js
    end
  end

	def publish
		@exercise = Exercise.find_by_id(params[:id])
		logger.debug(@exercise.visibility)
		if @exercise.visibility=="Private"
			@exercise.visibility = "Published"
		else
			@exercise.visibility = "Private"
		end
		@exercise.save
		respond_to do |format|
			format.html
			format.js
		end
	end
end
